extends Area2D
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and monitoring and not $"../../Car/Car/Area2D".monitoring:
		monitoring = false
		get_tree().change_scene_to_file("res://Scenes/POLY.tscn")


func _on_mouse_entered() -> void:
	monitoring = true
func _on_mouse_exited() -> void:
	monitoring = false
