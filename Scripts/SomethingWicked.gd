##██       █████  ███████  ██████ ██  █████  ████████ ███████
##██      ██   ██ ██      ██      ██ ██   ██    ██    ██     
##██      ███████ ███████ ██      ██ ███████    ██    █████  
##██      ██   ██      ██ ██      ██ ██   ██    ██    ██      
##███████ ██   ██ ███████  ██████ ██ ██   ██    ██    ███████ 

## ██████   ██████  ███    ██ ██ 
##██    ██ ██       ████   ██ ██ 
##██    ██ ██   ███ ██ ██  ██ ██ 
##██    ██ ██    ██ ██  ██ ██ ██ 
## ██████   ██████  ██   ████ ██
  
##██    ██  ██████  ██ 
##██    ██ ██    ██ ██ 
##██    ██ ██    ██ ██ 
## ██  ██  ██    ██ ██ 
##  ████    ██████  ██ 
  
## ██████ ██   ██ ▄█ ███████ ███    ██ ████████ ██████   █████  ████████ ███████ 
##██      ██   ██    ██      ████   ██    ██    ██   ██ ██   ██    ██    ██      
##██      ███████    █████   ██ ██  ██    ██    ██████  ███████    ██    █████   
##██      ██   ██    ██      ██  ██ ██    ██    ██   ██ ██   ██    ██    ██      
## ██████ ██   ██    ███████ ██   ████    ██    ██   ██ ██   ██    ██    ███████ 

# Такие слова были написаны над вратами в ад.
# Я буду молиться за вас. Хотя даже Бог вам не поможет. Удачи.

extends CharacterBody2D

#Рывки:
var DashOverdose = 0 #Уровень Передоза 
var DashesUsed = 0 #Количество рывков, необходимо для Передоза
@export var dashesleft = 2 #Количество рывков, которые можно совершить без отката.
var DashRegen = 0 #Я хз чстнслв
var candash = true #При false отключает рывки

#Переменные для дебага 
var CoyoteStarted = false
var Coyote = false
var isdashing = false
var isjumping = false
var iswalkin = false

var admin = false #Дает читы как в полигоне
var IsInBackrooms = false #Для закулисья
var IsAlreadyDied = false #Для счетчика смертей
var IsInLib = false #Нужна для того, чтобы там работала книжка
#Движения всякие
var speed = Global.speed
var DashSpeed = 2000
var base_gravity = 1200
var jump_force = 600
var fast_fall_gravity_multiplier = 1.5
var isknockbacking = false
#Эм, это... Это.
var shift_pressed := false
var shift_pressed_time := 0.0
var tap_threshold := 0.2
var IsActuallyDrawin = 0
var ShiftClick = false
var HitstoppingNow = false
var hitstopdur = 0

#Овердрайв!
var BladePoint1 = Vector2.ZERO #Используется для следов от рывков 
var BladePoint2 = Vector2.ZERO
var OVERDRIVEN = false #Сам факт овердрайва
var OVERDRIVE_TYPE = 1 #Тип оружия
var energy := 100 #Мне некуда было запихнуть саму энергию, пускай туточке будет
var GOD_MODE = false
var OVERLOAD := 0
#Музыка!
var music = Global.music
var AlreadyPlaying2 = false
var AlreadyPlaying = false
var AlreadyOver200 = false
var NotRegen = true
var EnReg = true
var NotCoreRegening = true
var CoreReg = true
var NotRegening = true
var MusicPack = Global.MusicPack
var CoreCounter := 0
#А туточке всякие загрузки и пути
var Book = preload("res://Scenes/∞/BOOK.tscn")
var CORE = preload("res://Scenes/CORE.tscn")
var Rodger = preload("res://Scenes/ReRodger.tscn")
var Hack = preload("res://Scenes/Hack.tscn")
var TechnoZen = preload("res://Scenes/TechnoZen.tscn")
var NeonThingy = preload("res://Scenes/MC/NeonThingy.tscn")
var TEST_THINGY = preload("res://Scenes/NeonGG.tscn")
@onready var EnergyIcon = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI")
@onready var EnergyLable = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI/RichTextLabel")
@onready var TextPanel = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/Panel")
@onready var OverloadBar = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/OverloadBar/Label")
@onready var AttackArea = $Area2D
func _ready() -> void:
	update_overload()
	await get_tree().process_frame
	if OS.get_unique_id() == "{5fffa4c0-29de-11eb-9669-806e6f6e6963}":
		admin = true
		transfer_to_text_panel("ПРИВЕТ, ХОЗЯИН~", false, Color.from_rgba8(0, 68, 255, 255), Color.from_rgba8(148, 175, 255, 255))
	MusicPack = Global.MusicPack
	if MusicPack == 1:
		music = load("res://Music/1xx/100 Continue.ogg")
	elif MusicPack == 2:
		music = load("res://Music/5xx/508 Loop Detected.wav")
	elif MusicPack == 3:
		music = load("res://Sounds/w9u2jbrxo7scu2gicg67bltaf1cy7nycy2ior.mp3")
	update_energy()
	MusicPlayer()
func _process(delta):
	if energy > 256:
		energy = 256
	if energy == 256 and not OVERDRIVEN:
		OVERDRIVE()
	if energy < 100 and NotRegening == true:
		EnReg = true	
		NotRegening = false
		$DashRegen2.start()
	if CoreCounter > 0 and NotCoreRegening == true:
		NotCoreRegening = false
		CoreReg = true
		$CoreRegen.start()
	if energy < 200:
		AlreadyOver200 = false
	if energy >= 200 and not OVERDRIVEN and AlreadyPlaying and not AlreadyOver200:
		MusicPack = Global.MusicPack
		if MusicPack == 1 and not Global.OVERDRUM:
			music = load('res://Music/1xx/103 Early Hints (OVER 200).ogg')
		elif MusicPack == 2 and not Global.OVERDRUM:
			music = load("res://Music/4xx/416 Range Not Satisfiable (OVER 200).wav")
		elif MusicPack == 1 and Global.OVERDRUM:
			music = load('res://Music/1xx/103 Early Hints (OVER 200).ogg')
		elif MusicPack == 2 and Global.OVERDRUM:
			music = load("res://Music/BREAKCORE/4xx/[BREAK] 416 Range Not Satisfiable (OVER 200).ogg")
		AlreadyOver200 = true
		AlreadyPlaying2 = false
		MusicPlayer()
	elif not OVERDRIVEN and AlreadyPlaying and not AlreadyPlaying2 and not AlreadyOver200:
		if MusicPack == 1 and not Global.OVERDRUM:
			music = load("res://Music/1xx/103 Early Hints.ogg")
		elif MusicPack == 2 and not Global.OVERDRUM:
			music = load("res://Music/4xx/416 Range Not Satisfiable.wav")
		elif MusicPack == 1 and Global.OVERDRUM:
			music = load("res://Music/1xx/103 Early Hints.ogg")
		elif MusicPack == 2 and Global.OVERDRUM:
			music = load("res://Music/BREAKCORE/4xx/[BREAK] 416 Range Not Satisfiable.ogg")
		AlreadyPlaying2 = true
		MusicPlayer()
	if IsActuallyDrawin >= 0:
		queue_redraw()
	
	if energy <= 0:
		die()
		
	if DashesUsed >= 2:
		DashOverdose = 1
		if DashesUsed >= 5:
			DashOverdose = 2
			if DashesUsed >= 8:
				DashOverdose = 3
	if DashesUsed <= 2:
		DashOverdose = 0	

	if DashesUsed > 0 and NotRegen:
		NotRegen = false 
		DashRegen = DashesUsed
		$DashRegen.start()
	if shift_pressed and not OVERDRIVEN and candash:
		var hold_time = (Time.get_ticks_msec() / 1000.0) - shift_pressed_time
		if hold_time >= tap_threshold:
			IsActuallyDrawin = 1
	elif HitstoppingNow == false:
		IsActuallyDrawin = 0

func _physics_process(delta):
	var current_gravity = base_gravity
	if velocity.y > 0 and not is_on_floor():
		current_gravity *= fast_fall_gravity_multiplier
	if not is_on_floor() and not CoyoteStarted:
		CoyoteStarted = true
		Coyote = true
		$Coyote.start()
	if not isdashing:
		velocity.y += current_gravity * delta
		if not isknockbacking:
			var direction = Input.get_axis("ui_left", "ui_right")
			velocity.x = direction * speed
			if direction == 0 or not is_on_floor(): 
				$Step.stop()
			else:
				if not $Step.playing:
					$Step.play()
	if velocity.x < 0:
		$AnimatedSprite2D.flip_h = true
		AttackArea.set_scale(Vector2(1, 1))
		$Area2D/HitArea.set_scale(Vector2(1, 1))
	elif velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		AttackArea.set_scale(Vector2(-1, 1))
		$Area2D/HitArea.set_scale(Vector2(-1, 1))
	if is_on_floor():
		CoyoteStarted = false
		dashesleft = 2
		isjumping = false 
	if Input.is_action_just_pressed("UwU_SPACE") and (is_on_floor() or Coyote):
		Coyote = false
		velocity.y = -jump_force
		isjumping = true
	move_and_slide()
	position = position.round()
	
	if velocity == Vector2.ZERO and not AttackArea.attacking and not isdashing:
		$AnimatedSprite2D.play("default")
		$footstepart.emitting = false
	elif velocity.x < 0 and is_on_floor() and not AttackArea.attacking:
		$AnimatedSprite2D.play("run")
		$footstepart.emitting = true
	elif velocity.x > 0 and is_on_floor() and not AttackArea.attacking:
		$AnimatedSprite2D.play("run")
		$footstepart.emitting = true
	elif not AttackArea.attacking:
		$AnimatedSprite2D.play("default")
		$footstepart.emitting = false

func _input(event):
	if event is InputEventKey and event.keycode == KEY_F and IsInLib:
		if event.pressed:
			pass
		else:
			var NewBook = Book.instantiate()
			EnergyIcon.get_parent().get_parent().get_parent().get_parent().add_child(NewBook)
			NewBook.global_position = Vector2(320, 180)
	if event is InputEventKey and event.keycode == KEY_E:
		if event.pressed:
			pass
		else:
			var NEWCORE = CORE.instantiate()
			get_parent().get_parent().add_child(NEWCORE)
			NEWCORE.global_position = global_position
			NEWCORE.get_node("RigidBody2D").MC = self
			NEWCORE.get_node("RigidBody2D").linear_velocity += velocity / 2
			CoreReg = false
			if not GOD_MODE:
				CoreCounter += 1 
				if CoreCounter >= 2:
					if CoreCounter >= 4:
						if CoreCounter >= 6:
							transfer_to_text_panel("overcore", true, Color.from_rgba8(51, 0, 2, 255))
						else:
							transfer_to_text_panel("overcore", true, Color.from_rgba8(103, 0, 2, 255))
					else:
						transfer_to_text_panel("overcore", true, Color.from_rgba8(152, 0, 2, 255))
				energy -= CoreCounter * 5
			update_energy()
	if event is InputEventKey and event.keycode == KEY_1 and admin:
		if event.pressed:
			global_position = get_global_mouse_position()
			velocity.y = 0
			collision_layer = 0
		else:
			collision_layer = 1
	if event is InputEventKey and event.keycode == KEY_2 and admin:
		if not event.pressed:
			var NewHack = Hack.instantiate()
			get_parent().get_parent().add_child(NewHack)	
			NewHack.global_position = get_global_mouse_position()
			NewHack.get_node("ManHack").activate()
	if event is InputEventKey and event.keycode == KEY_7 and admin:
		if not event.pressed:
			var NewTest = TEST_THINGY.instantiate()
			get_parent().get_parent().add_child(NewTest)
			NewTest.global_position = get_global_mouse_position()
	if event is InputEventKey and event.keycode == KEY_4 and admin:
		if not event.pressed:
			var NewTechnoZen = TechnoZen.instantiate()
			get_parent().get_parent().add_child(NewTechnoZen)
			NewTechnoZen.global_position = get_global_mouse_position()
			NewTechnoZen.get_node("TechnoZen").activate()
	if event is InputEventKey and event.keycode == KEY_5 and admin:
		if not event.pressed:
			OVERDRIVE()
	if event is InputEventKey and event.keycode == KEY_6 and admin:
		if not event.pressed:
			if GOD_MODE:
				GOD_MODE = false
			else:
				GOD_MODE = true
	if event is InputEventKey and event.keycode == KEY_3 and admin:
		if not event.pressed:
			var NewRodger = Rodger.instantiate()
			get_parent().get_parent().add_child(NewRodger)
			NewRodger.global_position = get_global_mouse_position()
			NewRodger.get_node("Roach").activate()
	if event is InputEventKey and event.keycode == KEY_ENTER:
		if not IsInBackrooms:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
		else:
			$"../Camera2D/Panel".visible = true
			await get_tree().create_timer(2).timeout
			$"../Camera2D/Panel".visible = false
	if event is InputEventKey and event.keycode == KEY_SHIFT and candash:
		if event.pressed:
			shift_pressed = true
			shift_pressed_time = Time.get_ticks_msec() / 1000.0
		elif ShiftClick == true:
			shift_pressed = false
			ShiftClick = false
			var hold_time = (Time.get_ticks_msec() / 1000.0) - shift_pressed_time
			if hold_time < tap_threshold:
				print('pong')
				dash(false)
				hit()
			else:
				print('ping')
				dash(true)
				hit()
		else:
			shift_pressed = false
			var hold_time = (Time.get_ticks_msec() / 1000.0) - shift_pressed_time
			if hold_time < tap_threshold:
				dash(false)
			else:
				dash(true)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and shift_pressed:
			ShiftClick = true
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not AttackArea.attacking:
			hit()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and not AttackArea.attacking:
			if OVERDRIVEN and OVERDRIVE_TYPE == 1:
				THIS_PLACE_ABOUT_TO_BLOW()
			else:
				parryMC()
	if event is InputEventKey and event.keycode == KEY_C:
		if event.pressed:
			Engine.time_scale = 0
		else:
			Engine.time_scale = 1
func dash(IsWicked): #Параметр IsWicked отвечает за то, будет рывок направленным или нет
	var to_mouse = 0
	if not isdashing and dashesleft > 0:
		collision_mask = (1 << 0) | (1 << 1) | (1 << 3)
		collision_layer = (1 << 9)
		BladePoint1 = global_position
		if IsWicked:
			var mouse_pos = get_global_mouse_position()
			to_mouse = (mouse_pos - global_position).normalized()
			if not OVERDRIVEN:
				velocity = to_mouse * DashSpeed
			else:
				velocity = to_mouse * DashSpeed * 1.5
		else:
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction == 0:
				direction = -1 if $AnimatedSprite2D.flip_h else 1
			velocity.y = 0
			if not OVERDRIVEN:
				velocity.x = direction * DashSpeed
			else:
				velocity.x = direction * DashSpeed + 1.5
		base_gravity = 0
		isdashing = true
		dashesleft -= 1
		overdose()
		$SoundPlayerMC.pitch_scale = randf_range(0.9, 1.1)
		$SoundPlayerMC.play()
		$DASHTIME.start()
func overdose():
	#Отнимает энергию при Передозе
	if OVERDRIVEN or GOD_MODE:
		return
	DashesUsed += 1
	match DashOverdose:
		1:
			energy -= 10
			OVERLOAD -= 1
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(152,0,2,255))
		2:
			OVERLOAD -= 2
			energy -= 20
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(103,0,2, 255))
		3:
			OVERLOAD -= 3
			energy -= 30
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(51,0,2, 255))
	EnReg = false
	update_energy()
func OverdriveRift():
	var NewNeonThingy = NeonThingy.instantiate()
	get_parent().get_parent().add_child(NewNeonThingy)
	var NeonShapeCast = NewNeonThingy.get_node("ShapeCast2D")
	var NeonMain = NewNeonThingy.get_node("AnimatedSprite2D")
	var NeonTearStart = NewNeonThingy.get_node("TearStart")
	var NeonTearEnd = NewNeonThingy.get_node("TearEnd")
	BladePoint2 = global_position
	NeonShapeCast.global_position = BladePoint1
	var Bladirection = (BladePoint2 - BladePoint1)
	var BladderStone = (BladePoint2 + BladePoint1) / 2
	var Bladistance = Bladirection.length()
	Bladirection = Bladirection.normalized()
	NeonMain.global_position =  BladderStone
	NeonTearStart.global_rotation = Bladirection.angle()
	NeonTearEnd.global_rotation = Bladirection.angle() 
	NeonTearStart.global_rotation_degrees += 90
	NeonTearEnd.global_rotation_degrees += 270
	NeonTearStart.global_position = BladePoint1
	NeonTearEnd.global_position = BladePoint2
	NeonShapeCast.target_position = Vector2.RIGHT * Bladistance
	NeonShapeCast.global_rotation = Bladirection.angle()
	NeonMain.global_rotation = Bladirection.angle()
	NeonMain.scale = Vector2(1, Bladistance)
	NeonMain.global_rotation_degrees += 90
func _on_dashtime_timeout():
	collision_layer = (1 << 0)
	collision_mask = (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3)
	if OVERDRIVEN and OVERDRIVE_TYPE == 1:
		OverdriveRift()
		base_gravity = 1200
		velocity = Vector2.ZERO
		isdashing = false
	else:
		base_gravity = 1200
		velocity = Vector2.ZERO
		isdashing = false
func _draw():
	#Рисует линию для рывка
	var mouse_pos = get_global_mouse_position()
	draw_line(Vector2.ZERO, mouse_pos - global_position, Color.WHITE, IsActuallyDrawin)

func update_energy():
	#I, EvaX, humbly submit a toast
	#To Nicholas Alexander
	#For successfully managing to pirate Warcraft III
	#So that he may play Defense of The Ancients.
	#Congratulations, Nick. 
	#Enjoy
	#Your
	#DOTA.
	#PVZTZZZ TZ
	#Ahhhh
	if OVERDRIVEN == true:
		EnergyLable.text = str("OVERDRIVE")
		if energy <= 0:
			EnergyIcon.play("0")
		elif energy <= 36:
			EnergyIcon.play("36")
		elif energy <= 72:
			EnergyIcon.play("72")
		elif energy <= 108:
			EnergyIcon.play("108")
		elif energy <= 144:
			EnergyIcon.play("OVERDRIVE 144")
		elif energy <= 180:
			EnergyIcon.play("OVERDRIVE 180")
		elif energy <= 216:
			EnergyIcon.play("OVERDRIVE 216")
		elif energy >= 216:
			EnergyIcon.play("OVERDRIVE FULL")
	else:
		EnergyLable.text = str(energy)
		if energy <= 0:
			EnergyIcon.play("0")
			EnergyLable.text = str('')
		elif energy <= 36:
			EnergyIcon.play("36")
		elif energy <= 72:
			EnergyIcon.play("72")
		elif energy <= 108:
			EnergyIcon.play("108")
		elif energy <= 144:
			EnergyIcon.play("144")
		elif energy <= 180:
			EnergyIcon.play("180")
		elif energy <= 216:
			EnergyIcon.play("216")
		elif energy >= 216:
			EnergyIcon.play("over 216")
func _on_dash_regen_timeout() -> void:
	#Уменьшает счетчик рывков
	if DashRegen == DashesUsed:
		DashesUsed -= 1
	NotRegen = true
func die():
	#Просто смерть. Хреново сделанная.
	global_rotation_degrees = 90
	speed = 0
	velocity. x = 0
	velocity.y = 0
	jump_force = 0
	$"ПервыйПлеер".pitch_scale = 0.2
	if IsAlreadyDied == false:
		IsAlreadyDied = true
		var Deaths = Save.get_value("~NUMBERS~", "YourselfKilled", ) + 1
		Save.set_value("~NUMBERS~", "YourselfKilled", Deaths )
	Engine.time_scale = 0
func _on_dash_regen_2_timeout():
	return
	#ЗАРЕЗЕРВИРОВАННО
	while energy < 100 and EnReg == true:
		energy += 1
		update_energy()
		await get_tree().create_timer(0.05).timeout
	NotRegening = true
	EnReg = true
func take_damage(damage = 1, hitstopdur = 0, knockback = 1000):
	#Функция отвечает за получаемый урон.
	if not isdashing and not OVERDRIVEN and not GOD_MODE:
		if OVERLOAD > 0:
			OVERLOAD -= 1
		update_overload()
		if hitstopdur > 0 and not HitstoppingNow:
			hitstop(hitstopdur)
		elif HitstoppingNow:
			print("хитстоп на ", hitstopdur, " не удался из-за наложения")
		var OverDamage = 1
		if OVERLOAD < 10:
			OverDamage = 1
		elif OVERLOAD < 20:
			OverDamage = 1.2
		elif OVERLOAD < 30:
			OverDamage = 1.4
		elif OVERLOAD < 40:
			OverDamage = 1.6
		elif OVERLOAD < 50:
			OverDamage = 1.8
		elif OVERLOAD < 60:
			OverDamage = 2
		elif OVERLOAD < 70:
			OverDamage = 2.2
		elif OVERLOAD < 80:
			OverDamage = 2.4
		elif OVERLOAD < 90:
			OverDamage = 2.6
		elif OVERLOAD < 100:
			OverDamage = 2.8
		else:
			OverDamage = 3
		energy -= int(damage * OverDamage)
		update_energy()
		EnReg = false
	knockback()
func EPICER_MUSIK():
	if not OVERDRIVEN and not AlreadyPlaying:
		if MusicPack == 1 and not Global.OVERDRUM:
			music = load('res://Music/1xx/103 Early Hints.ogg')
		elif MusicPack == 2 and not Global.OVERDRUM:
			music = load("res://Music/4xx/416 Range Not Satisfiable.wav")
		elif MusicPack == 1 and Global.OVERDRUM:
			music = load('res://Music/1xx/103 Early Hints.ogg')
		elif MusicPack == 2 and Global.OVERDRUM:
			music = load("res://Music/BREAKCORE/4xx/[BREAK] 416 Range Not Satisfiable.ogg")
		MusicPlayer()
		AlreadyPlaying = true
func calm_down():
	if not OVERDRIVEN:
		if MusicPack == 1:
			music = load('res://Music/1xx/100 Continue.ogg')
		elif MusicPack == 2:
			music = load("res://Music/5xx/508 Loop Detected.wav")
		MusicPlayer()
		AlreadyPlaying = false
		var AlreadyPlaying2 = false
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
	print('Произошол тролленг')
	$AnimatedSprite2D.play("attack")
	$Whoosh.pitch_scale = randf_range(0.7, 1.3)
	$Whoosh.play()
func OVERDRIVE():
	energy = 256
	update_energy()
	OVERDRIVEN = true
	if MusicPack == 1:
		music = load("res://Sounds/All the stuff.wav")
	elif MusicPack == 2:
		music = load("res://Music/4xx/414 URI Too Long (pre).wav")
	$"ПервыйПлеер".stop()
	$"ПервыйПлеер".stream = music
	$"ПервыйПлеер".play()
	var OneTimeTestWarUwUNyaLol = 5.33 / Global.MusicPitch
	await get_tree().create_timer(OneTimeTestWarUwUNyaLol).timeout
	speed = 800
	jump_force = 600
	if MusicPack == 1 and not Global.OVERDRUM:
		music = load("res://Music/1xx/101 Switching Protocols.ogg")
	elif MusicPack == 2 and not Global.OVERDRUM:
		music = load("res://Music/4xx/414 URI Too Long.wav")
	elif MusicPack == 1 and Global.OVERDRUM:
		music = load("res://Music/1xx/101 Switching Protocols.ogg")
	elif MusicPack == 2 and Global.OVERDRUM:
		music = load("res://Music/BREAKCORE/4xx/414 URI Too Long.ogg")
	$"ПервыйПлеер".stop()
	$"ПервыйПлеер".stream = music
	$"ПервыйПлеер".play()
	while energy > 100:
		energy -= 1
		update_energy()
		await get_tree().create_timer(0.1).timeout
	OVERDRIVEN = false
	THIS_PLACE_ABOUT_TO_BLOW()
	speed = Global.speed
	jump_force = 600
	OVERLOAD = 0
	print('Конец овердрайва')
	if MusicPack == 1 and not Global.OVERDRUM:
		music = load("res://Music/1xx/103 Early Hints.ogg")
	elif MusicPack == 2 and not Global.OVERDRUM:
		music = load("res://Music/4xx/416 Range Not Satisfiable.wav")
	elif MusicPack == 1 and Global.OVERDRUM:
		music = load("res://Music/1xx/103 Early Hints.ogg")
	elif MusicPack == 2 and Global.OVERDRUM:
		music = load("res://Music/BREAKCORE/4xx/[BREAK] 416 Range Not Satisfiable.ogg")
	MusicPlayer()
	update_energy()
func knockback():
	#Отбрасывание, теперь вообще отключил. Доработаю потом когда-нить
	pass
func MusicPlayer():
	#Это плеер музыки. Он просто переключает музыку, лол
	#Ничего такого
	var pos = $"ПервыйПлеер".get_playback_position()
	$"ПервыйПлеер".stop()
	$"ПервыйПлеер".stream = music
	$"ПервыйПлеер".play(pos)
func parryMC():
	#Паррирование! Оно включается на 0.1 секунду и обратно. Пока что почти бесполезно. 
	#Разве что роджеров попинать да из ЯДРА сделать миниган.
	$Area2D.monitoring = true
	$Area2D.parrying = true
	await get_tree().create_timer(0.1).timeout
	$Area2D.parrying = false
	$Area2D.monitoring = false
func THIS_PLACE_ABOUT_TO_BLOW():
	var Rifts = get_tree().get_nodes_in_group("NeonRifts")
	for node in Rifts:
		node.BLOW()
func update_overload():
	OVERLOAD = clamp(OVERLOAD, 0, 100)
	OverloadBar.text = str(OVERLOAD, "%")
func transfer_to_text_panel(text, is_minus, color = Color.from_rgba8(255, 255, 255, 255), outline = Color.from_rgba8(0, 0, 0, 255)):
	TextPanel.update_text_panel(text, is_minus, color, outline)


func _on_core_regen_timeout() -> void:
	NotCoreRegening = true
	if CoreReg:
		CoreCounter -= 1


func _on_coyote_timeout() -> void:
	Coyote = false
