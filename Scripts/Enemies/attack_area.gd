extends Area2D
var SomethingChanged = false
var DirRN = false
var DirWas = false
@onready var MC = $"."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if $"../Sprite2D".flip_h == false:
			set_scale(Vector2(1, 1))
			$"../CollisionShape2D".set_scale(Vector2(1, 1))
		else:
			set_scale(Vector2(-1, 1))
			$"../CollisionShape2D".set_scale(Vector2(-1, 1))
