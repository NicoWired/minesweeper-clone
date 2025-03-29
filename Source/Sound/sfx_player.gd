extends AudioStreamPlayer
## This scrippt is used to control the volume of the sfx players


func _ready() -> void:
	SettingsLoader.sfx_changed.connect(on_sfx_changed)
	volume_db = linear_to_db(SettingsLoader.sfx_volume)

func on_sfx_changed(new_volume: float) -> void:
	volume_db = linear_to_db(new_volume)
