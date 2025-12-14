extends Node2D
@onready var ShapeCast = $ShapeCast2D
var DESTROY
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.5 ).timeout 
func BLOW():
	$TearStart.visible = true
	$TearEnd.visible = true
	$AnimatedSprite2D.play("default")
	ShapeCast.force_shapecast_update()
	if ShapeCast.is_colliding():
		for i in range(ShapeCast.get_collision_count()):
			var body = ShapeCast.get_collider(i)
			if body.has_method("take_damage"):
				body.take_damage(15)
	await get_tree().create_timer(0.1).timeout 
	queue_free()
