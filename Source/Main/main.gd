extends Node

const MARGIN_SIZE: int = 32
const MENU_BAR_HEIGHT: int = 48

var elapsed_time: Timer = Timer.new()
var elapsed_seconds: int
var tile_size: int = 32
var tile_grid: TileGrid

@onready var settings_window: Window = $SettingsWindow
@onready var bgm: AudioStreamPlayer = $BGM
@onready var gui: Control = $GUI


func _ready() -> void:
	get_viewport().size_changed.connect(on_viewport_size_changed)
	SettingsLoader.music_changed.connect(on_music_changed)
	SettingsLoader.difficulty_changed.connect(func(_x): on_start_pressed())
	
	## Settings window setup
	settings_window.visible = false
	settings_window.close_requested.connect(on_settings_close)
	settings_window.visibility_changed.connect(on_settings_visibility_changed)
	on_start_pressed()
	
	## Start button setup
	gui.connect_start_button(on_start_pressed)
	gui.settings_clicked.connect(on_settings_clicked)
	
	## Time elapsed setup
	elapsed_time.one_shot = false
	elapsed_time.wait_time = 1
	elapsed_time.timeout.connect(on_elapsed_time)
	add_child(elapsed_time)
	
	## BGM player setup
	bgm.stream = ExternalResourceLoader.bgm
	bgm.stream.loop = true
	bgm.volume_db = linear_to_db(SettingsLoader.music_volume)
	bgm.play()

## Clears the current game (if any) and starts a new one
func on_start_pressed() -> void:
	GameState.current_state = GameState.states.RUNNING
	if tile_grid:
		tile_grid.queue_free()
		await tile_grid.tree_exited
	create_tile_grid()
	gui.add_tile_grid(tile_grid)
	gui.update_mines_left(str(tile_grid.total_mines))
	elapsed_time.stop()
	gui.update_time_elapsed("0")
	gui.victory_text.visible = false
	setup_viewport_size()

func create_tile_grid() -> void:
	tile_grid = ExternalResourceLoader.scenes["tile_grid"].instantiate()
	tile_grid.initialize(
		SettingsLoader.chosen_difficulty_settings["grid_size"]
		,SettingsLoader.chosen_difficulty_settings["mine_amt"]
		,tile_size
	)
	tile_grid.mine_hit.connect(on_mine_hit)
	tile_grid.tile_pressed.connect(on_tile_pressed)
	tile_grid.tile_flagged.connect(on_tile_flagged)
	tile_grid.game_won.connect(on_game_won)

func on_mine_hit() -> void:
	GameState.current_state = GameState.states.OVER
	elapsed_time.stop()
	for tile in tile_grid.get_children():
		if tile.has_method("tile_pressed"):
			if not tile.flagged:
				tile.set_sprite_texture(tile.tile_sprite, tile.revealed_sprite)

func on_tile_pressed() -> void:
	if elapsed_time.is_stopped():
		elapsed_seconds = 0
		elapsed_time.start()
		
func on_elapsed_time() -> void:
	elapsed_seconds += 1
	gui.update_time_elapsed(str(elapsed_seconds))

func on_tile_flagged(mines_left: int) -> void:
	gui.update_mines_left(str(mines_left))

func on_game_won() -> void:
	elapsed_time.stop()
	GameState.current_state = GameState.states.OVER
	gui.update_victory_screen(SettingsLoader.chosen_difficulty_settings["text"])

func setup_viewport_size() -> void:
	var min_x: int = tile_size * int(tile_grid.grid_size.x)
	var min_y: int = tile_size * int(tile_grid.grid_size.y)
	min_x += MARGIN_SIZE
	min_y += MARGIN_SIZE + MENU_BAR_HEIGHT
	gui.visible = false
	get_viewport().size = Vector2(min_x, min_y)
	gui.visible = true

func on_settings_close() -> void:
	SettingsLoader.save_settings()
	SettingsLoader.refresh_settings()
	settings_window.visible = false
	
func on_settings_visibility_changed() -> void:
	$GUI/PauseScreen.visible = settings_window.visible
	gui.get_tree().paused = settings_window.visible

func on_settings_clicked() -> void:
	settings_window.visible = true

func on_music_changed(new_volume: float) -> void:
	bgm.volume_db = linear_to_db(new_volume)

func on_viewport_size_changed():
	settings_window.move_to_center()
