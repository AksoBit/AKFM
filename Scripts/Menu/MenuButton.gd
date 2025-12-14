extends Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and monitoring and not $"../../Car/Car/Area2D".monitoring:
		monitoring = false
		$"../Control".monitoring = false
		$"../Control".visible = false
		$"../..".visible = false
		$"../../../ФонСинтNoSun".visible = true


func _on_mouse_entered() -> void:
	monitoring = true
func _on_mouse_exited() -> void:
	monitoring = false
