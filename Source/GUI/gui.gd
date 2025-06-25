extends Control

signal settings_clicked # emitted when the settings icon is clicked

@onready var victory_text: Label = $VictoryText
@onready var settings_icon: TextureRect = %SettingsIcon
@onready var start_button: TextureButton = %StartButton
@onready var time_elapsed: Label = %TimeElapsed
@onready var tile_grid_spawner: PanelContainer = %TileGridSpawner
@onready var mines_left: Label = %MinesLeft


func _ready() -> void:
	# propagates the signal from the settings icon to the main scene
	settings_icon.settings_clicked.connect(func(): settings_clicked.emit())
	
	# align the "start" label with the texture button
	%StartButton/StartLabel.global_position = start_button.global_position
	%StartButton/StartLabel.custom_minimum_size = start_button.size

func update_mines_left(new_value: String) -> void:
	mines_left.text = new_value

func update_time_elapsed(new_value: String) -> void:
	time_elapsed.text = new_value

func add_tile_grid(tile_grid: TileGrid) -> void:
	tile_grid_spawner.add_child(tile_grid)

func connect_start_button(start_button_action: Callable) -> void:
	start_button.pressed.connect(start_button_action)
	
func update_victory_screen(difficulty: String) -> void:
	victory_text.visible = true
	victory_text.text = "You won!!

	Difficulty: %s
	
	Time elapsed: %s" % [difficulty, time_elapsed.text]
