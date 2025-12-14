extends Line2D
@onready var MC = get_parent().get_parent().get_node("UwUGG/UwUGG")
@onready var Ray = $"../Ray"
@export var V = 2 #Дмитрий сказал V. Я не в праве спорить со своим Господином. >w<
var X = false #Дмитрий сказал X. Я не в праве спорить со своим Господином. >w<
var M = 0 #Дмитрий сказал M. Я не в праве спорить со своим Господином. >w<
func _ready() -> void:
	global_position.x = MC.global_position.x 
	await get_tree().create_timer(0.5).timeout
	X = true
	$"LaserShoot(2)".pitch_scale = randf_range(0.9, 1.1)
	$"LaserShoot(2)".play()
	$AnimatedSprite2D.visible = true
	$Area2D.monitoring = true
	$AnimatedSprite2D.play('default')
	await get_tree().create_timer(5).timeout
	$"..".queue_free()

func _process(delta: float) -> void:
		Ray.force_raycast_update()
		if Ray.is_colliding():
			var floor_position = Ray.get_collision_point()
			global_position.y = floor_position.y 
		if X:
			if MC.global_position.x - global_position.x < 0:
				M = -1
			elif MC.global_position.x - global_position.x > 0:
				M = 1
			else:
				M = 0
			global_position.x += V * M * ((MC.global_position.x - global_position.x)/200 * M + 1)
