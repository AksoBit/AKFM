extends RigidBody2D
var Parriable = true
var Damage = 10
var FirstDot
var SeconDot
var Distance
var Direction
var MC 
var Startimer
var Endtimer
var Correction = Vector2.ZERO
var CoreParts = preload("res://Scenes/MC/CoreParts.tscn").instantiate()
@onready var CoolRay = $"../RayCast2D"
func _ready() -> void:
	Startimer = Time.get_ticks_msec()
	set_process(false)
	Correction = global_position #Эм... Простите?... Я не смог найти баг, так что будем делать ЭТО.
	await get_tree().process_frame
	FirstDot = global_position
	CoolRay.global_position = FirstDot
	apply_torque(10000)
	var mouse_pos = get_global_mouse_position()
	var req = global_position.y - mouse_pos.y
	if req < 0:
		linear_velocity.y += -sqrt(2 * 980) 
	else:
		linear_velocity.y += -sqrt(2 * 980 * req) 
	var reqx = global_position.x - mouse_pos.x
	linear_velocity.x += -reqx
	set_process(true)
func _process(delta: float) -> void:
	CoolRay.global_position = FirstDot
	SeconDot = global_position
	Direction = (SeconDot - FirstDot)
	Distance = Direction.length()
	CoolRay.target_position = Vector2.RIGHT * Distance
	CoolRay.global_rotation = Direction.angle()
	CoolRay.force_raycast_update()
	if CoolRay.is_colliding():
		var body = CoolRay.get_collider()
		if body.has_method("take_damage") and not body.name == "UwUGG":
			body.take_damage(Damage)
			if Parriable == false:
				MC.OVERLOAD += 5
				MC.transfer_to_text_panel("CANON", false, Color.from_rgba8(254, 244, 55, 255), Color.from_rgba8(0, 0, 0, 255))
		elif body.name == "UwUGG":
			body.take_damage(Damage/4)
		print("Поезд сделал БУМ")
		var Thingy = CoolRay.get_collision_point()
		$"../Area2D".visible = true
		$"../Area2D".monitoring = true
		$"../Area2D".global_position = Thingy
		$"../Area2D".DESTROY()
		get_parent().get_parent().call_deferred("add_child", CoreParts)
		CoreParts.global_position = Thingy - Correction
		queue_free()
	FirstDot = global_position
func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if $"../Area2D" == null:
		return
	else:
		if body.has_method("take_damage") and not body.name == "UwUGG":
			body.take_damage(Damage)
		elif body.name == "UwUGG":
			body.take_damage(Damage/4)
		$"../Area2D".visible = true
		$"../Area2D".monitoring = true
		$"../Area2D".global_position = global_position
		$"../Area2D".DESTROY()
		get_parent().get_parent().call_deferred("add_child", CoreParts)
		CoreParts.global_position = global_position - Correction
		queue_free()
func parry(Dir):
	if Parriable == true:
		Endtimer = int(Time.get_ticks_msec())
		$"../Area2D/CoreParry".pitch_scale = randf_range(0.9, 1.1)
		$"../Area2D/CoreParry".play()
		var TiMulti = Endtimer - Startimer
		linear_velocity = Dir * 3
		print(TiMulti / 100)
		Damage = Damage + (TiMulti / 100)
		print('+parry')
		Parriable = false
