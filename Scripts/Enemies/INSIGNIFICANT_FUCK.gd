extends Line2D
@onready var MC = get_parent().get_parent().get_node("UwUGG/UwUGG")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		global_position.y = MC.global_position.y
		global_position.x = MC.global_position.x - 500
		$"LaserShoot(2)2".pitch_scale = randf_range(0.9, 1.1)
		$"LaserShoot(2)2".play()
		global_rotation_degrees = 90
		await get_tree().create_timer(1).timeout
		$"LaserShoot(2)".pitch_scale = randf_range(0.9, 1.1)
		$"LaserShoot(2)".play()
		$AnimatedSprite2D.visible = true
		$Area2D.monitoring = true
		$AnimatedSprite2D.play('default')
		await get_tree().create_timer(1).timeout
		$"..".queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
