extends CharacterBody2D

var max_speed = 1000
var acceleration = 800
var friction = 2000   

@onready var gg = get_parent().get_parent().get_node("UwUGG/UwUGG")
var Parriable = true
var FuckingVar = false
var health = 50
var is_attacking = false
var can_attack = false 
var AnotherBoringVar = true
var speedRN: int = 0
var Parried = false
var HIT = false
var Velocity_before = Vector2.ZERO
var SomeDEVar = false
var Offset = Vector2.ZERO
var Parts = preload("res://Scenes/HackBody.tscn").instantiate()
func _ready() -> void:
	Offset = global_position
	$RichTextLabel.text = str(health)
	var material = ShaderMaterial.new()
	var shader = preload("res://Shaders/Flashing.gdshader")
	material.shader = shader
	$Sprite2D2/ContactPos/sparks.material = material
	$Sprite2D.material = material
	$Sprite2D2/GPUParticles2D.material = material
	$Sprite2D2.material = material
	var WHHH = load("res://Sounds/Enemies/Hack/hitHurt (2).wav")
	$AudioStreamPlayer2D.stream = WHHH
	if Global.Debug:
		while 1 == 1:
			$RichTextLabel.text = "Pos: " + str(global_position) + "\n" + \
			"En:: " + str(health) + "\n" + \
			"Vel: " + str(velocity) + "\n" + \
			"SpeedRN: " + str(speedRN) + "\n"
			await get_tree().create_timer(0.03).timeout 
func _physics_process(delta: float) -> void:
	if can_attack: 
		var target_pos: Vector2 = gg.get_global_position()
		var direction = Vector2.ZERO
		var length = target_pos - global_position
		if length.length() < 1:
			direction  = Vector2.ZERO
		else:
			direction = (target_pos - global_position).normalized()
		if FuckingVar == true:
			velocity = direction * -1000
			velocity.y -= 300
			print("Пое**нь отлетела от ГГшки")
			FuckingVar = false
		if HIT:
			velocity += direction * -300
			velocity.y -= 50
			print("Пое**нь отлетела от ГГшки")
			HIT = false
		if direction.length() > 0:
			velocity = velocity.move_toward(direction * max_speed, acceleration * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		var current_speed = velocity.x + velocity.y 
		if current_speed < 0:
			speedRN = current_speed * -0.05
		else:
			speedRN = current_speed * 0.05
		var rot = current_speed * 0.001
		$Sprite2D.rotate(rot)
		if velocity != Vector2.ZERO:
			move_and_slide()
		global_position = global_position.round()
		SomeDEVar = true
func _on_attack_area_body_entered(body: Node2D) -> void:
	Velocity_before = velocity
	Parried = false
	Parriable = true
	if body.name == "UwUGG" and can_attack and not Parried:
		is_attacking = true
		$AudioStreamPlayer2D.pitch_scale = randf_range(0.9, 1.1)
		$AudioStreamPlayer2D.play()
		print("Получил от летающей пое**ни")
		$Sprite2D2/ContactPos/sparks.emitting = true
		while is_attacking:
			body.take_damage(int(speedRN / 2))
			FuckingVar = true
			await get_tree().create_timer(0.1).timeout 
		stop_attack()
	elif not body == $"." and can_attack:
		print("Пое**нь ударила что-то")
		if body.has_method("take_damage"):
			if Parried:
				body.take_damage(int(speedRN / 2))
				Parried = false
				Parriable = true
			else:
				body.take_damage(speedRN / 4)
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
func take_damage(damage) -> void:
	health -= damage
	print("Удар по хэку")
	HIT = true
	if health <= 0:
		die() 
	$RichTextLabel.text = str(health)
	
func die() -> void:
	stop_attack()
	SomeDEVar = false
	get_parent().get_parent().call_deferred("add_child", Parts)
	Parts.global_rotation = $Sprite2D.global_rotation
	Parts.global_position = global_position - Offset
	print("Nah, i'd win")
	Global.HackDeath()
	queue_free()
func parry(Dir):
		Parriable = false
		print(velocity)
		velocity = velocity.length() * 2 * Dir.normalized()
		print(velocity)
		Parried = true
		print('+parry')
func activate():
		print(name,' активирован')
		can_attack = true   
func Impact(BW, Finish):
	if Finish:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("Flashing", false)
		$Sprite2D.material.set_shader_parameter("Flashing", false)
		$Sprite2D2/GPUParticles2D.material.set_shader_parameter("Flashing", false)
		$Sprite2D2.material.set_shader_parameter("Flashing", false)
	else:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("Flashing", true)
		$Sprite2D.material.set_shader_parameter("Flashing", true)
		$Sprite2D2/GPUParticles2D.material.set_shader_parameter("Flashing", true)
		$Sprite2D2.material.set_shader_parameter("Flashing", true)
	if BW == true:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("White", true)
		$Sprite2D.material.set_shader_parameter("White", true)
		$Sprite2D2/GPUParticles2D.material.set_shader_parameter("White", true)
		$Sprite2D2.material.set_shader_parameter("White", true)
	else:
		$Sprite2D2/ContactPos/sparks.material.set_shader_parameter("White", false)
		$Sprite2D.material.set_shader_parameter("White", false)
		$Sprite2D2/GPUParticles2D.material.set_shader_parameter("White", false)
		$Sprite2D2.material.set_shader_parameter("White", false)


func _on_attack_area_body_exited(body: Node2D) -> void:
	stop_attack()
