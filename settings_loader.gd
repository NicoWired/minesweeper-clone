extends Node
## This script is used to load and save the game settings
## It also emits signals when the settings are changed

const SAVE_FILE: String = "user://settings.ini"
var config: ConfigFile = ConfigFile.new()

enum difficulty {
	EASY,
	MEDIUM,
	HARD
}

## Dictionary containing the settings for each difficulty
## If a new difficulty is added, it should be added here
var difficulty_settings: Dictionary = {
	difficulty.EASY: {
		"grid_size": Vector2(9,8),
		"mine_amt": 10
	},
	difficulty.MEDIUM: {
		"grid_size": Vector2(16,16),
		"mine_amt": 40
	},
	difficulty.HARD: {
		"grid_size": Vector2(30,16),
		"mine_amt": 100
	}
}

var chosen_difficulty: int	## ID of the chosen difficulty, should match the keys in difficulty_settings
var chosen_difficulty_settings: Dictionary ## Contains a dictionary with the settings for the chosen difficulty
var music_volume: float
var sfx_volume: float

signal music_changed(new_volume: float)	## Signal emitted when the music volume changes in the settings screen
signal sfx_changed(new_volume: float)	## Signal emitted when the sfx volume changes in the settings screen
signal difficulty_changed(new_difficulty: int)	## Signal emitted when the difficulty changes in the settings screen


func _ready() -> void:
	load_settings()
	refresh_settings()

## Should be called every time the settings are changed
func refresh_settings() -> void:
	chosen_difficulty = config.get_value("Settings", "difficulty", difficulty.EASY)
	chosen_difficulty_settings = difficulty_settings[chosen_difficulty]
	music_volume = config.get_value("Sound", "music", 0.5)
	sfx_volume = config.get_value("Sound", "sfx", 0.5)

func save_settings() -> void:
	config.set_value("Settings", "difficulty", chosen_difficulty)
	config.set_value("Sound", "music", music_volume)
	config.set_value("Sound", "sfx", sfx_volume)
	var error := config.save(SAVE_FILE)
	assert(error == OK, "An error ocurred saving the game settings")
	
func load_settings() -> void:
	var error := config.load(SAVE_FILE)
	assert(error == OK, "An error ocurred loading the game settings")

func on_music_changed(new_volume: float) -> void:
	music_volume = new_volume
	music_changed.emit(new_volume)

func on_sfx_changed(new_volume: float) -> void:
	sfx_volume = new_volume
	sfx_changed.emit(new_volume)
	
func on_difficulty_changed(new_difficulty: int) -> void:
	chosen_difficulty = new_difficulty
	chosen_difficulty_settings = difficulty_settings[chosen_difficulty]
	difficulty_changed.emit(new_difficulty)
