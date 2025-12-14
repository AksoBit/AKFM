extends CharacterBody2D

#Чистый код от меня, удивительно!
#Даже с функциями и без магических чисел~
#Разрешаю себя хвалить!

var upper_gun = true
var rotation_speed = 5
var overdriven_rotation_speed = 10
var energy_needed = 40
var energy = 30
var max_energy = 30
var friction = 3
var is_healing = false
var ready_to_heal = false
var angle: float
var OVERDRIVEN = false
var speed = 200
@onready var ray_scan = $CollisionShape2D/RayCast2D
var proj = preload("res://Scenes/RemIS/Impulse_proj.tscn")
var new_proj
var melee_multiplyer = 1.5
var proj_ammount = 8
var heal_target_body
var regen_ammount = 0
var ok_cooldown = 0.1
var overdriven_cooldown = 0.025
var offset
@onready var siri = get_parent().get_parent().get_node("UwUGG/UwUGG")
func _ready() -> void:
	offset = $"../Line2D".global_position
	$"../Line2D".global_position = offset
	fly()
	while true:
		while energy <= energy_needed and not OVERDRIVEN or calc_heal(false) == 375:
			shoot_proj(proj_ammount, ok_cooldown)
			await get_tree().create_timer(3).timeout
		if calc_heal(false) != 375 and not is_healing and not OVERDRIVEN:
			calc_heal(true)
			is_healing = true
			regen_ammount = energy - energy_needed
			if heal_target_body.has_method("heal_target"):
				heal_target_body.heal_target(true)
			$CollisionShape2D/Middle/Charge.play()
			await get_tree().create_timer(0.5).timeout
			ready_to_heal = true
			while is_healing == true:
				await get_tree().create_timer(0.1).timeout
			await get_tree().create_timer(3).timeout
		else:
			await get_tree().create_timer(0.1).timeout
func fly():
	while true:
		var angle = randi() % 360
		velocity += Vector2(cos(angle), sin(angle)).normalized() * speed
		await get_tree().create_timer(3).timeout
func fly_away():
	velocity = (global_position - siri.global_position).normalized()  * speed
func _physics_process(delta: float) -> void:
	energy = clampi(energy, 0, 80)
	velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	if not is_healing:
		angle = get_angle_to(siri.global_position)
		if OVERDRIVEN:
			$CollisionShape2D.global_rotation = lerp_angle($CollisionShape2D.global_rotation, angle, overdriven_rotation_speed * delta)
		else:
			$CollisionShape2D.global_rotation = lerp_angle($CollisionShape2D.global_rotation, angle, rotation_speed * delta)
	elif heal_target_body != null and not OVERDRIVEN and is_healing:
		print("ХИЛЛИТЬ!!!!!!")
		angle = get_angle_to(heal_target_body.global_position)
		$CollisionShape2D.global_rotation = lerp_angle($CollisionShape2D.global_rotation, angle, rotation_speed * delta)
		ray_scan.force_raycast_update()
		if ray_scan.is_colliding() and int(rad_to_deg(angle)) == int($CollisionShape2D.global_rotation_degrees) and ready_to_heal:
			ray_scan.force_raycast_update()
			var body = ray_scan.get_collider()
			if body.has_method("take_damage"):
				body.take_damage(-regen_ammount, 0, -5, "Healaser")
			$"../Line2D".visible = true
			$"../Line2D".points = [$CollisionShape2D/Middle.global_position - offset, ray_scan.get_collision_point() - offset]
			if heal_target_body.has_method("heal_target"):
				heal_target_body.heal_target(false)
			is_healing = false
			energy -= energy - energy_needed
			$Heal.pitch_scale = randf_range(0.7, 1.3)
			$Heal.play()
			$ClearLine.start()
			ready_to_heal = false
			if body.name == "UwUGG":
				OVERDRIVE()
		recoil(10)
	elif heal_target_body != null and OVERDRIVEN and is_healing:
		print("ОВЕРДРИВИТЬ!!!!!!")
		angle = get_angle_to(heal_target_body.global_position)
		$CollisionShape2D.global_rotation = lerp_angle($CollisionShape2D.global_rotation, angle, overdriven_rotation_speed * delta)
		ray_scan.force_raycast_update()
		if ray_scan.is_colliding() and int(rad_to_deg(angle)) == int($CollisionShape2D.global_rotation_degrees) and ready_to_heal:
			ray_scan.force_raycast_update()
			var body = ray_scan.get_collider()
			if body.has_method("OVERDRIVE"):
				body.OVERDRIVE()
			$"../Line2D2".visible = true
			$"../Line2D2".points = [$CollisionShape2D/Middle.global_position - offset, ray_scan.get_collision_point() - offset]
			is_healing = false
			$Overdriver.play()
			recoil(100)
			$ClearLine.start()
			ready_to_heal = false
			$CollisionShape2D/RemIs.frame = 0
			OVERDRIVEN = false
	elif heal_target_body == null:
		is_healing = false
	move_and_slide()
func recoil(recoil):
	velocity -= Vector2.RIGHT.rotated($CollisionShape2D/Middle.global_rotation) * recoil
func shoot_proj(ammount, cooldown):
	for i in range(ammount):
		if OVERDRIVEN and cooldown != overdriven_cooldown:
			return
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.7, 1.3)
		$AudioStreamPlayer2D.play()
		new_proj = proj.instantiate()
		get_parent().get_parent().add_child(new_proj)
		if upper_gun == true:
			upper_gun = false
			new_proj.global_position = $CollisionShape2D/Upper.global_position
		else:
			upper_gun = true
			new_proj.global_position = $"CollisionShape2D/Bottomer(?)".global_position
		new_proj.get_node("proj").target = -Vector2(cos($CollisionShape2D.global_rotation), sin($CollisionShape2D.global_rotation)).normalized()
		new_proj.get_node("proj").remis = self
		recoil(10)
		await get_tree().create_timer(cooldown).timeout
		
func calc_overdrive(): #Считает врага с самой высокой энергией
	var bodies = get_tree().get_nodes_in_group("enemy")
	var healthyness = 0.0
	for body in bodies:
		if (body.energy / body.max_energy) > healthyness and not body.name == "RemIS":
			healthyness = (body.energy / body.max_energy)
			heal_target_body = body
	print("Лучше всего сейчас ", heal_target_body)
	if heal_target_body == null or heal_target_body == self:
		return 375 
	else:
		return 007
		
func calc_heal(change_target): #Считает врага с самой низкой энергией
	var target 
	var bodies = get_tree().get_nodes_in_group("enemy")
	var healthyness = 1.0
	for body in bodies:
		if (body.energy / body.max_energy) < healthyness and not body.name == "RemIS":
			healthyness = (body.energy / body.max_energy)
			target = body
			if change_target == true:
				heal_target_body = body
		if change_target == true:
			print("Херовее всего сейчас ", target)
	if target == null or target == self or healthyness == 1.0:
		return 375 
	else:
		return 007

func take_damage(damage, hitstopdur = 0, OverHeatDamage = 0, reason = null):
	var damage_to_return = damage
	if reason == "Siri":
		energy -= int(damage * melee_multiplyer)
		int(damage_to_return * melee_multiplyer)
	else:
		energy -= damage
	if energy <= 0:
		die()
	return damage_to_return
func die():
	Global.RemDeath()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	fly_away()

func _on_area_2d_body_exited(body: Node2D) -> void:
	velocity = Vector2.ZERO


func _on_clear_line_timeout() -> void:
	$"../Line2D".visible = false
	$"../Line2D2".visible = false
func heal_target(show_mark):
	if show_mark == true:
		$HealMark.visible = true
	else:
		$HealMark.visible = false

func OVERDRIVE():
	$Overdrive.play()
	OVERDRIVEN = true
	$CollisionShape2D/RemIs.frame += 1
	await get_tree().create_timer(1).timeout
	$CollisionShape2D/RemIs.frame += 1
	await get_tree().create_timer(1).timeout
	$CollisionShape2D/RemIs.frame += 1
	shoot_proj(32, overdriven_cooldown)
	await get_tree().create_timer(32 * overdriven_cooldown).timeout
	if calc_overdrive() == 375:
		OVERDRIVEN = false
		print('Редиска никого не нашла')
		$CollisionShape2D/RemIs.frame = 0
		return
	is_healing = true
	ready_to_heal = true
