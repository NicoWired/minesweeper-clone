extends Window


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	transparent = true
	match SettingsLoader.chosen_difficulty:
		SettingsLoader.difficulty.EASY:
			%EasyRadioButton.button_pressed = true
		SettingsLoader.difficulty.MEDIUM:
			%MediumRadioButton.button_pressed = true
		SettingsLoader.difficulty.HARD:
			%HardRadioButton.button_pressed = true

	%EasyRadioButton.pressed.connect(func(): on_difficulty_changed(SettingsLoader.difficulty.EASY))
	%MediumRadioButton.pressed.connect(func(): on_difficulty_changed(SettingsLoader.difficulty.MEDIUM))
	%HardRadioButton.pressed.connect(func(): on_difficulty_changed(SettingsLoader.difficulty.HARD))
		
	%MusicHSlider.value_changed.connect(func(new_volume): SettingsLoader.on_music_changed(new_volume))
	%MusicHSlider.value = SettingsLoader.music_volume
	%SFXHSlider.value_changed.connect(func(new_volume): SettingsLoader.on_sfx_changed(new_volume))
	%SFXHSlider.value = SettingsLoader.sfx_volume
	
	size_changed.connect(on_window_size_changed)
	on_window_size_changed()

func on_difficulty_changed(new_difficulty):
	SettingsLoader.on_difficulty_changed(new_difficulty)
	
func on_window_size_changed():
	$Background.size = get_viewport().size
	$Background.position = Vector2(0,0)
