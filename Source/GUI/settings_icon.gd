extends TextureRect

signal settings_clicked # emitted when the settings icon is clicked

func _gui_input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		settings_clicked.emit()
