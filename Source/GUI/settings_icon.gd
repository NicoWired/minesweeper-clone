extends TextureRect

signal settings_clicked # emitted when the settings icon is clicked

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _gui_input(_event: InputEvent) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		settings_clicked.emit()

func _on_mouse_entered() -> void:
	material.set_shader_parameter("glow_intensity", 0.6)
	
func _on_mouse_exited() -> void:
	material.set_shader_parameter("glow_intensity", 0)
