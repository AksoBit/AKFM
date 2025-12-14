extends Area2D
var pos: = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pos = get_global_mouse_position()
	global_position = lerp(global_position, pos, 10 * delta)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("OVERDRIVE") and not body.OVERDRIVEN:
		body.OVERDRIVE()
