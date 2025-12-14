extends Sprite2D


# Эм... Это работает без Vsync. 
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position()
