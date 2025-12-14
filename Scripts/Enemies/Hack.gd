#Наконец я почистил этот код, перевел на змеинный и все подписал. Красиво, правда?
#Я очень старался!~
#Можете меня поблагодарить потом. Если бы я все это не почистил, вы бы СТРАДАЛИ. 

extends CharacterBody2D

#Скорости:
var max_speed = 1000 #Максимальная скорость
var acceleration = 800 #Скорость ускорения
var friction = 200000 #Сила трения для крутых заносов
var speed: int = 0 #Эта херь как-бы спидометр для динамичного урона

#Паррирование и отбрасывание:
var parriable = true #Можно ли паррировать
var parried = false #Паррирован ли
var direction = Vector2.ZERO

#Другое:
var is_attacking = false #Флажок для того, чтобы когда ты встаешь на пилу она тебя, ну, пилила 
var energy = 50 #Мгм, это энергия.
var max_energy = 50 #Эт для РемИС
var activated = false #Пока не получит activate() не будет ничего делать
var OVERDRIVEN

#Загрузки и пути
var offset = Vector2.ZERO #Я честно не знаю как работает этот баг, но... Я просто добавил отступ! Да! Вот это я понимаю фикс!
var parts = preload("res://Scenes/Debris/HackBody.tscn").instantiate() #Его части на которые он рассыпается 
@onready var siri = get_parent().get_parent().get_node("UwUGG/UwUGG") #Сириус, Сири, UwUGG, MC, gg, GG, ActualMC... Как ее только не называли.

func _ready() -> void:
	offset = global_position
	$RichTextLabel.text = str(energy)
	var material = ShaderMaterial.new()
	var shader = preload("res://Shaders/Flashing.gdshader")
	material.shader = shader
	$Sprite2D2/ContactPos/sparks.material = material
	$Sprite2D.material = material
	$Sprite2D2.material = material
	var WHHH = load("res://Sounds/Enemies/Hack/hitHurt (2).wav")
	$AudioStreamPlayer2D.stream = WHHH
	if Global.Debug:
		while 1 == 1:
			$RichTextLabel.text = "Pos: " + str(global_position) + "\n" + \
			"En:: " + str(energy) + "\n" + \
			"Vel: " + str(velocity) + "\n" + \
			"speed: " + str(speed) + "\n"
			await get_tree().create_timer(0.03).timeout 
func _physics_process(delta: float) -> void:
	if activated: 
		var target_pos = siri.get_global_position()
		var direction = Vector2.ZERO
		var length = target_pos - global_position
		direction = (target_pos - global_position).normalized()
		if direction.length() > 0:
			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		var current_speed = velocity.x + velocity.y 
		speed = abs(velocity.x + velocity.y) * 0.05
		$Sprite2D.rotate((velocity.x + velocity.y) * 0.001) 
		global_position = global_position.round()
		move_and_slide()
func deflect(): 
	velocity = direction * -1000
	velocity.y -= 300
	print("Пое**нь отлетела от ГГшки")
func hit():
		velocity += direction * -300
		velocity.y -= 50
		print("Пое**нь отлетела от ГГшки")
func _on_attack_area_body_entered(body: Node2D) -> void:
	parriable = true
	if body.name == "UwUGG" and activated and not parried:
		is_attacking = true
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer2D.play()
		print("Получил от летающей пое**ни")
		$Sprite2D2/ContactPos/sparks.emitting = true
		parried = false
		while is_attacking:
			if speed >= 20:
				print("Получил от летающей пое**ни с хитстопом, скорость ", speed)
				body.take_damage(int(speed / 2), float(speed) / 1000, int(speed / 8), "Hack")
			else:	
				print("Получил от летающей пое**ни без хитстопа, скорость ", speed)
				body.take_damage(int(speed / 2), 0, int(speed / 8), "Hack")
			if body != null:
				deflect()
			is_attacking = false
			await get_tree().create_timer(0.1).timeout 
		stop_attack()
	elif body.has_method('DESTROY') and activated:
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer2D.play()
		$Sprite2D2/ContactPos/sparks.emitting = true
		body.DESTROY()
		await get_tree().create_timer(0.03).timeout 
		stop_attack()
	elif not body == $"." and activated:
		print("Пое**нь ударила что-то")
		if body.has_method("take_damage"):
			if parried:
				body.take_damage(int(speed / 2), 0, 0, "Hack")
				await get_tree().create_timer(0.01).timeout 
				if body == null:
					siri.transfer_to_text_panel("BUZZKILL", false, Color.from_rgba8(220, 213, 47, 255), Color.from_rgba8(0, 0, 0, 255))
					siri.take_overheat(5)
				elif speed >= 10 and body.name != "UwUGG":
					siri.transfer_to_text_panel("BUZZ-OFF", false, Color.from_rgba8(171, 229, 165, 255), Color.from_rgba8(9, 89, 0, 255))
					siri.take_overheat(int(speed / 8))
				parried = false
				parriable = true
			else:
				body.take_damage(speed / 4, 0, 0, "Hack")
				await get_tree().create_timer(0.01).timeout
		velocity * -1000
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer2D.play()
		$Sprite2D2/ContactPos/sparks.emitting = true
		await get_tree().create_timer(0.03).timeout 
		stop_attack()
func stop_attack() -> void:
	is_attacking = false
	$AudioStreamPlayer2D.stop()
	$Sprite2D2/ContactPos/sparks.emitting = false
func take_damage(damage, hitstopdur = 0, OverHeatDamage = 0, reason = null):
	var damage_to_return = damage
	print("Удар по хэку")
	if reason == "the_bite_of_87":
		pass
	elif reason == "Core":
		int(damage * 1.5)
		int(damage_to_return * 1.5)
		hit()
	else:
		hit()
	energy -= damage
	if energy <= 0:
		if reason == "LaserCore":
			siri.transfer_to_text_panel("NAH, I'D WIN.", false, Color.from_rgba8(220, 213, 47, 255), Color.from_rgba8(0, 0, 0, 255))
			siri.take_overheat(5)
		die() 
	$RichTextLabel.text = str(energy)
	return damage_to_return
func die() -> void:
	stop_attack()
	get_parent().get_parent().call_deferred("add_child", parts)
	parts.global_rotation = $Sprite2D.global_rotation
	parts.global_position = global_position - offset
	print("Nah, i'd win")
	Global.HackDeath()
	queue_free()
func parry(Dir):
		parriable = false
		print(velocity)
		velocity = velocity.length() * 2 * Dir.normalized()
		print(velocity)
		parried = true
		print('+parry')
func activate():
		print(name,' активирован')
		activated = true   
func Impact(BW, Finish):
	if Finish:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("Flashing", false)
		$Sprite2D.material.set_shader_parameter("Flashing", false)
		$Sprite2D2.material.set_shader_parameter("Flashing", false)
	else:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("Flashing", true)
		$Sprite2D.material.set_shader_parameter("Flashing", true)
		$Sprite2D2.material.set_shader_parameter("Flashing", true)
	if BW == true:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("White", true)
		$Sprite2D.material.set_shader_parameter("White", true)
		$Sprite2D2.material.set_shader_parameter("White", true)
	else:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("White", false)
		$Sprite2D.material.set_shader_parameter("White", false)
		$Sprite2D2.material.set_shader_parameter("White", false)
func _on_attack_area_body_exited(body: Node2D) -> void:
	stop_attack()
func heal_target(show_mark):
	if show_mark == true:
		$HealMark.visible = true
	else:
		$HealMark.visible = false
func OVERDRIVE():
	OVERDRIVEN = true 
