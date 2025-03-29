extends Control

signal settings_clicked # emitted when the settings icon is clicked

func _ready() -> void:
	# propagates the signal from the settings icon to the main scene
	%SettingsIcon.settings_clicked.connect(func(): settings_clicked.emit())

func update_mines_left(new_value: String) -> void:
	%MinesLeft.text = new_value

func update_time_elapsed(new_value: String) -> void:
	%TimeElapsed.text = new_value

func add_tile_grid(tile_grid: TileGrid) -> void:
	%TileGridSpawner.add_child(tile_grid)

func connect_start_button(start_button_action: Callable) -> void:
	%StartButton.pressed.connect(start_button_action)
	
func update_victory_screen(difficulty: String) -> void:
	$VictoryText.visible = true
	$VictoryText.text = "You won!!

	Difficulty: %s
	
	Time elapsed: %s" % [difficulty, %TimeElapsed.text]
