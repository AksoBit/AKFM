#В этом коде есть корни, синусы и косинусы. При этом это просто глупенький Роджер.
#✋😐🤚 абсолютный кинотеатр
extends CharacterBody2D

@onready var GG = get_parent().get_parent().get_node("UwUGG/UwUGG")
var is_attaking = false
var base_gravity = 1200
var direction = Vector2.ZERO
var fast_fall_gravity_multiplier = 1.5
var acceleration = 400 
var max_speed = 300
var jumped = false
var can_jump = false
var is_rotating = false
var max_energy = 25
var energy = 25
var fell = false
var AlreadyFellTimerStarted = false
var Activated = false
var parriable = false
var is_falling = false
var IsOnSomeone = false
var Someone 
var BREAK = false
var Offset = Vector2.ZERO
var OnCoolDown = false
var BeliveHeCanFLy
var StopFuckingRotating = false
func _ready() -> void:
	$AttackArea/AnimatedSprite2D.play("default")
func _physics_process(delta: float) -> void:
	if Activated == true:
		if Someone != null:
			while IsOnSomeone and not BREAK and Someone.name == "ManHack":
				#Ну... Простите?
				#Как работает мой код? На одном крыле и молитве.
				if Someone == null:
					break
				global_rotation = Someone.get_node("Sprite2D").global_rotation
				global_position = Someone.global_position + Vector2(cos(Someone.get_node("Sprite2D").global_rotation), sin(Someone.get_node("Sprite2D").global_rotation)) * 38
				await get_tree().create_timer(0.01).timeout 
				StopFuckingRotating = true
				if Someone == null:
					break
			while IsOnSomeone and not BREAK:
				if Someone == null:
					break
				global_position =  Someone.global_position + Offset
				await get_tree().create_timer(0.01).timeout 
		IsOnSomeone = false
		if StopFuckingRotating:
			StopFuckingRotating = false
			global_rotation = 0
		if fell and AlreadyFellTimerStarted == false :
			is_attaking = false
			is_falling = false
			is_rotating = false
			parriable = false
			AlreadyFellTimerStarted = true
			for i in 100:
				if !is_on_floor():
					break
				await get_tree().create_timer(0.01).timeout
			$Sprite2D.rotation = 0
			fell = false
			AlreadyFellTimerStarted = false
		if jumped and not fell and not is_falling:
			if direction.x >= 0:
				jumped = false
				while direction.x >= 0:
					await get_tree().create_timer(0.1).timeout 
				is_rotating = true
			else:
				jumped = false
				while direction.x < 0:
					await get_tree().create_timer(0.1).timeout 
				is_rotating = true
		var target_pos: Vector2 = GG.get_global_position()
		direction = (target_pos - global_position).normalized()
		if direction.x != 0:
			velocity.x = move_toward(velocity.x, direction.x * max_speed, acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, acceleration * delta)
		if is_on_floor() and not fell and is_rotating:
			print($"..".name, ' падает')
			fell = true
		if can_jump and is_on_floor() and not fell and not OnCoolDown:
			jump()
		if not fell:
			if velocity.x < 0 and not BeliveHeCanFLy and not IsOnSomeone:
				if is_on_floor():
					$Sprite2D.flip_h = false 
					$AnimationPlayer.play("run")
				else:
					$Sprite2D.flip_h = false 
					$AnimationPlayer.play("flyyyyyyy")
			elif velocity.x > 0 and not BeliveHeCanFLy and not IsOnSomeone:
				if is_on_floor():
					$Sprite2D.flip_h = true
					$AnimationPlayer.play("run")
				else:
					$Sprite2D.flip_h = true
					$AnimationPlayer.play("flyyyyyyy")
			elif velocity.x < 0 and BeliveHeCanFLy and not IsOnSomeone:
				$Sprite2D.look_at(velocity.normalized() * -1) 
				$Sprite2D.flip_h = false
			elif velocity.x > 0 and BeliveHeCanFLy and not IsOnSomeone:
				$Sprite2D.flip_h = true
				$Sprite2D.look_at(velocity.normalized()) 
		var current_gravity = base_gravity
		if is_on_floor():
			BeliveHeCanFLy = false
		if velocity.y > 0 and not is_on_floor():
			current_gravity *= fast_fall_gravity_multiplier
			if is_rotating == true:
				$Sprite2D.rotation += 0.3
				await get_tree().create_timer(0.01).timeout 
		if not is_on_floor() and not IsOnSomeone:
			velocity.y += current_gravity * delta
		if not fell and not IsOnSomeone:
			move_and_slide()
func _on_jump_range_body_entered(body: Node2D):
		if body.name == "UwUGG":
			can_jump = true
func _on_attack_area_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage") and not body == $".":
		is_attaking = true
		$AttackArea/sparks.emitting = true
	if body.has_method("take_damage") and not IsOnSomeone and (parriable or BeliveHeCanFLy) and not body == $".":
		if body.name == "UwUGG" or BeliveHeCanFLy:
			$AttackArea/sparks.emitting = true
			print($"..".name, " прицепился к ", body.name)
			Someone = body
			velocity = Vector2.ZERO
			IsOnSomeone = true
			collision_layer = (1 << 11)
			var Bites = 0
			Offset = global_position - body.global_position
			if Someone.name == "UwUGG":
				for i in 50:
					if not IsOnSomeone and not BREAK:
						break
					parriable = true
					print($"..".name, ' кускус')
					if Someone == null:
						break
					Someone.take_damage(1, 0, 0)
					Bites += 1
					if Bites >= 5:
						Someone.take_damage(0, 0, 1)
						Bites = 0
					await get_tree().create_timer(0.05).timeout 
			else:
				GG.transfer_to_text_panel("NOPE.", false, Color.from_rgba8(220, 213, 47, 255), Color.from_rgba8(0, 0, 0, 255))
				GG.take_overheat(5)
				for i in 30:
					if not IsOnSomeone and not BREAK:
						break
					parriable = true
					print($"..".name, ' кускус')
					if Someone == null:
						break
					Someone.take_damage(1, 0, 0, "the_bite_of_87")
					await get_tree().create_timer(0.05).timeout 
			IsOnSomeone = false
			BREAK = false
			$AttackArea/sparks.emitting = false
			collision_layer = (1 << 2)
	elif body.has_method("take_damage") and is_attaking and not body == $"." and body.name == "UwUGG":
		$AttackArea/sparks.emitting = true
		while is_attaking:
			if body == null:
				break
			body.take_damage(1)
			await get_tree().create_timer(0.1).timeout 
		$AttackArea/sparks.emitting = false
func _on_attack_area_body_exited(body: Node2D) -> void:
	$AttackArea/sparks.emitting = false
	if body.name == "UwUGG": 
		is_attaking = false
		print($"..".name, ' не делает кусь')
func take_damage(damage, hitstopdur = 0, OverHeatDamage = 0, reason = null):
	energy -= damage
	print($"..".name, ' прилетело')
	if energy <= 0:
		if reason == "LaserCore":
			GG.transfer_to_text_panel("NAH, I'D WIN.", false, Color.from_rgba8(220, 213, 47, 255), Color.from_rgba8(0, 0, 0, 255))
			GG.take_overheat(5)
		die() 
	return damage
func die():
	print('Роджер того')
	is_attaking = false
	Global.RoDeath()
	queue_free()
func parry(Dir):
	$AnimationPlayer.play("flyyyyyyy")
	if parriable:
		global_rotation = 0
		rotation = 0
		collision_layer = (1 << 2)
		await get_tree().create_timer(0.01).timeout 
		BeliveHeCanFLy = true
		print('+parry')
		parriable = false
		is_attaking = false
		IsOnSomeone = false
		velocity = Dir
		while BeliveHeCanFLy:
			await get_tree().create_timer(0.01).timeout 
		$Sprite2D.flip_v = false
		$Sprite2D.rotation_degrees = 0
	if IsOnSomeone:
		IsOnSomeone = false
		BREAK = true
func activate():
		print($"..".name, " активирован")
		Activated = true
func jump():
		$AnimationPlayer.play("flyyyyyyy")
		print($"..".name, ' прыгает')
		parriable = true
		var target_height = GG.global_position.y
		var current_height = global_position.y
		if target_height >= current_height:
			return
		var required_height = current_height - target_height 
		velocity.y += -sqrt(2 * base_gravity * required_height) 
		if $Sprite2D.flip_h == false:
			velocity.x -= 600
		else:
			velocity.x += 600
		jumped = true
		OnCoolDown = true
		$BiTimer.start()
func _on_jump_range_body_exited(body: Node2D) -> void:
	if body.name == "UwUGG": 
		can_jump = false
func _on_bi_timer_timeout() -> void:
	OnCoolDown = false
func heal_target(show_mark):
	if show_mark == true:
		$HealMark.visible = true
	else:
		$HealMark.visible = false
