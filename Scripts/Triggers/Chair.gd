extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == ("UwUGG"):
		$"../Chair".play()
		$"../RigidBody2D".linear_velocity = Vector2(-1000, -700)
		queue_free()
