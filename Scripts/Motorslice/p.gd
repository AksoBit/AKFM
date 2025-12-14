extends CharacterBody2D

#Все по классике, тут движения
var speed = 400
var base_gravity = 980
var jump_force = 250
var fast_fall_gravity_multiplier = 1.5
var isknockbacking = false
var shifted = false
#Переменные для дебага 
var CoyoteStarted = false
var is_trying_to_MOTORSLICE = false
var Coyote = false
var state = "idle"
var isjumping = false
var iswalkin = false
var HitstoppingNow = false
var admin = false #Дает читы как в полигоне
var IsInBackrooms = false #Для закулисья
var IsAlreadyDied = false #Для счетчика смертей
var GOD_MODE = false
var direction
var MotorDir = 0
var wallrunable = true
#Музыка!
var MusicPack = Global.MusicPack
var CoreCounter := 0
var rng = RandomNumberGenerator.new()
var Whooshes
var is_free_falling = false
var is_climbing = false
var jumped_off
var facing_right = true
var is_on_bg_wall = false
var is_on_motorslicable = false
var current_gravity
@onready var BlackThingy = get_parent().get_parent().get_parent().get_node("Node2D")
#А туточке всякие загрузки и пути
var MotorLine = preload("res://Scenes/Motorslice/MotorLine.tscn")
var Whoosh1 = preload("res://Sounds/MC/Whoosh1.wav") #Звук взмаха мечом 
var Whoosh2 = preload("res://Sounds/MC/Whoosh2.wav") #Звук взмаха мечом 
var Whoosh3 = preload("res://Sounds/MC/Whoosh3.wav") #Звук взмаха мечом 
var NeonThingy = preload("res://Scenes/MC/NeonThingy.tscn") 
var TEST_THINGY = preload("res://Scenes/NeonGG.tscn")
@onready var music = $MusicPlayer
@onready var AttackArea = $Area2D

#Так забавно смотреть на свои старые костыли
#Когда знаешь как было бы правильнее 
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Sprites/Motorslice/P/orbie_cursor.png"))
	await get_tree().process_frame
	if OS.get_unique_id() == "{5fffa4c0-29de-11eb-9669-806e6f6e6963}":
		admin = true
func _physics_process(delta):
	current_gravity = base_gravity
	if velocity.y > 0 and not is_on_floor():
		current_gravity *= fast_fall_gravity_multiplier
	if not is_on_floor() and not CoyoteStarted:
		CoyoteStarted = true
		Coyote = true
		$Coyote.start()
	if not is_on_floor() and not is_on_wall() and not state == "MOTORSLICE":
		velocity.y += current_gravity * delta
	direction = Input.get_axis("ui_left", "ui_right")
	if state == "MOTORSLICE":
		MotorDir += direction / 40
	if is_on_floor() and not state == "Fall" and not state == "Slide" and not state == "Run" and not state == "MOTORSLICE":
		state = "Idle"
	if is_on_floor() and not state == "Slide" and not state == "MOTORSLICE":
		velocity.x = direction * speed
		if velocity.x < 0:
			state = "Run"
			$Animations.flip_h = true
			AttackArea.set_scale(Vector2(1, 1))
			$RayCast2D.target_position.x = -32
		elif velocity.x > 0:
			state = "Run"
			$Animations.flip_h = false
			AttackArea.set_scale(Vector2(-1, 1))
			$Area2D/HitArea.set_scale(Vector2(-1, 1))
			$RayCast2D.target_position.x = 32
	if velocity.x < 0:
		$Animations.flip_h = true
		AttackArea.set_scale(Vector2(1, 1))
		$RayCast2D.target_position.x = -32
	elif velocity.x > 0:
		$Animations.flip_h = false
		AttackArea.set_scale(Vector2(-1, 1))
		$Area2D/HitArea.set_scale(Vector2(-1, 1))
		$RayCast2D.target_position.x = 32
	if is_on_floor():
		CoyoteStarted = false
		isjumping = false 
		is_free_falling = false
		is_climbing = false
		jumped_off = false
		wallrunable = true
	if is_on_wall_only() and not is_free_falling and not is_climbing:
		is_climbing = true
		velocity = Vector2.ZERO
		await get_tree().create_timer(0.1).timeout
		velocity.y = -150
		climb()
		await get_tree().create_timer(0.5).timeout
		if is_climbing and not jumped_off and not is_free_falling:
			velocity = Vector2.ZERO
		await get_tree().create_timer(0.2).timeout
		if is_climbing and not jumped_off and not is_free_falling:
			velocity.y = 0
			is_climbing = false
			is_free_falling = true
			if $Animations.flip_h == false:
				velocity.x = 10 * -1
			else:
				velocity.x = 10 * 1
		else:
			return
	if Input.is_action_just_pressed("UwU_SPACE"):
		if state == "Wallrun":
			velocity.y = -jump_force / 1.5
			state = "Jump"
		elif state == "MOTORSLICE":
			velocity.y = -jump_force / 1.5
			state = "Jump"
		elif is_on_bg_wall and shifted and is_on_floor():
			velocity.y = -jump_force / 1.5
			wall_run()
		elif is_on_wall_only():
			print("UwU")
			is_climbing = false
			jumped_off = true
			velocity.y = -jump_force / 2
			if $Animations.flip_h == false:
				velocity.x = jump_force * -1
			else:
				velocity.x = jump_force
		elif (is_on_floor() or Coyote):
			Coyote = false
			velocity.y = -jump_force
			isjumping = true
			state = "Jump"
	move_and_slide()
	if state == "Run" and velocity == Vector2.ZERO:
		state == "Idle"
		$AnimationPlayer.play("Idle")
	elif abs(velocity.x) > 0 and is_on_floor() and state == "Run" or state == "Wallrun":
		$AnimationPlayer.play("Run")
	elif state == "Jump" or state == "Fall" or state == "MOTORSLICE":
		$AnimationPlayer.play("Idle")
	
func wall_run():
	wallrunable = false
	base_gravity = 30
	velocity.y = 0
	current_gravity = base_gravity
	velocity.x == 500 if $Animations.flip_h == false else - 500
	is_climbing = false
	await get_tree().process_frame
	$WallRun.start()
	state = "Wallrun"
	while is_on_bg_wall and shifted and state == "Wallrun":
		await get_tree().process_frame
	base_gravity = 980
func MOTORSLICE():
	var PosArray = []
	var NewMotorLine = MotorLine.instantiate()
	get_parent().get_parent().add_child(NewMotorLine)
	MotorDir = rad_to_deg(get_angle_to(velocity.normalized()))
	state = "MOTORSLICE"
	while is_on_motorslicable and is_trying_to_MOTORSLICE and state == "MOTORSLICE":
		PosArray.append(global_position)
		NewMotorLine.get_node("Line2D").points = PosArray
		velocity = -300 * Vector2(cos(MotorDir), sin(MotorDir)).normalized()
		await get_tree().process_frame
	state = "Fall"
func climb():
	state = "Climb"
	while is_climbing:
		$RayCast2D.force_raycast_update()
		if $RayCast2D.is_colliding():
			pass
		else:
			is_climbing = false
			is_free_falling = true
			state = "Idle"
			global_position.y -= 54
			if $Animations.flip_h == false:
				global_position.x += 18
			else:
				global_position.x -= 18
		await get_tree().process_frame
func slide():
	state = "Slide"
	$Slide.start()
	$AnimationPlayer.play("Slide")
	$SlidePart.emitting = true
	$CollisionShape2D.shape.size.y = 23
	$CollisionShape2D.global_position.y += 16
	while state == "Slide" and is_on_floor():
		await get_tree().process_frame
	$SlidePart.emitting = false
	$CollisionShape2D.shape.size.y = 55
	$CollisionShape2D.global_position.y -= 16
func _input(event):
	if event is InputEventKey and event.keycode == KEY_CTRL:
		if event.pressed:
			if is_on_floor() and abs(velocity.x) >= 1 and state == "Run":
				slide()
			elif not state == "Slide":
				state = "Fall"
		else:
			if is_on_floor() and state == "Slide":
				state = "Idle"
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.pressed:
			shifted = true
			if is_on_bg_wall and not is_on_floor() and wallrunable == true:
				wall_run()
		else:
			shifted = false
	if event is InputEventKey and event.keycode == KEY_F:
			pass
	if event is InputEventKey and event.keycode == KEY_2 and admin:
		if not event.pressed:
			var NewTest = TEST_THINGY.instantiate()
			get_parent().get_parent().add_child(NewTest)
			NewTest.global_position = get_global_mouse_position()
	if event is InputEventKey and event.keycode == KEY_1 and admin:
		if not event.pressed:
			if GOD_MODE:
				GOD_MODE = false
			else:
				GOD_MODE = true
	if event is InputEventKey and event.keycode == KEY_ENTER:
		if not IsInBackrooms:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		else:
			$"../Camera2D/Panel".visible = true
			await get_tree().create_timer(2).timeout
			$"../Camera2D/Panel".visible = false
	if event is InputEventKey and event.keycode == KEY_8 and admin:
		Engine.time_scale = 0.2
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				is_trying_to_MOTORSLICE = true
				if is_on_motorslicable:
					MOTORSLICE()

			else:
				is_trying_to_MOTORSLICE = false
func die():
	global_rotation_degrees = 90
	speed = 0
	velocity. x = 0
	velocity.y = 0
	jump_force = 0
	music.pitch_scale = lerp(music.pitch_scale, 0.0, 0.02)
	Engine.time_scale = lerp(music.pitch_scale, 0.0, 0.02)
	if IsAlreadyDied == false:
		IsAlreadyDied = true
		var Deaths = Save.get_value("~NUMBERS~", "YourselfKilled", ) + 1
		Save.set_value("~NUMBERS~", "YourselfKilled", Deaths )
	Engine.time_scale = 0
func hitstop(hitstopdur):
	print("хитстоп на ", hitstopdur)
	HitstoppingNow = true
	Engine.time_scale = 0
	await(get_tree().create_timer(hitstopdur, true, false, true).timeout)
	Engine.time_scale = 1
	HitstoppingNow = false
func hit():
	$Area2D.monitoring = true
	$Area2D.attacking = true
	$AnimationPlayer.play("Attack")
	rng.randomize()
	Whooshes = [Whoosh1, Whoosh2, Whoosh3]
	var Sound = Whooshes[rng.randi() % Whooshes.size()]
	$Whoosh.stream = Sound
	$Whoosh.pitch_scale = randf_range(0.7, 1.3)
	$Whoosh.play()
func _on_coyote_timeout() -> void:
	Coyote = false
func _on_shift_detector_body_entered(body: Node2D) -> void:
	is_on_bg_wall = true
	if shifted and wallrunable and not state == "Wallrun" or state == "Slide" and not is_on_floor():
		wall_run()

func _on_shift_detector_body_exited(body: Node2D) -> void:
	is_on_bg_wall = false
	
func _on_wall_run_timeout() -> void:
	if state == "Wallrun":
		state = "Fall"
func _on_slide_timeout() -> void:
	if state == "Slide":
		state = "Idle"
func _on_kmp_body_entered(body: Node2D) -> void:
	is_on_motorslicable = true
func _on_kmp_body_exited(body: Node2D) -> void:
	is_on_motorslicable = false
