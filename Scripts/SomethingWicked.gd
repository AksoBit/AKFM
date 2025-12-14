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
var dashesleft = 2 #Количество рывков, которые можно совершить без отката.
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
var AlreadyDied = false #Для счетчика смертей
var IsInLib = false #Нужна для того, чтобы там работала книжка

#Движения всякие
var speed = Global.speed
var DashSpeed = 2000
var base_gravity = 1200
var jump_force = 600
var fast_fall_gravity_multiplier = 1.5
var isknockbacking = false

#Эм, это... Это.
var ShiftClick = false
var HitstoppingNow = false
var hitstopdur = 0
var DPM = 0
var death_reason = "Я вообще хз лол"
#Овердрайв!
var BladePoint1 = Vector2.ZERO #Используется для следов от рывков 
var BladePoint2 = Vector2.ZERO #Как и эта
var OVERDRIVEN = false #Сам факт овердрайва
var OVERDRIVE_TYPE = 1 #Тип оружия
var energy := 128 #Мне некуда было запихнуть саму энергию, пускай туточке будет
var GOD_MODE = false
var OVERLOAD := 0

#Музыка!
var NotRegen = true
var EnReg = true
var NotCoreRegening = true
var CoreReg = true
var NotRegening = true
var MusicPack = Global.MusicPack
var CoreCounter := 0
var rng = RandomNumberGenerator.new()
var Whooshes


#А туточке всякие загрузки и пути
var Whoosh1 = preload("res://Sounds/MC/Whoosh1.wav") #Звук взмаха мечом 
var Whoosh2 = preload("res://Sounds/MC/Whoosh2.wav") #Звук взмаха мечом 
var Whoosh3 = preload("res://Sounds/MC/Whoosh3.wav") #Звук взмаха мечом 
var Book = preload("res://Scenes/∞/BOOK.tscn") #Книга в библиотеке
var CORE = preload("res://Scenes/CORE.tscn") #Ядро
var Rodger = preload("res://Scenes/ReRodger.tscn") #Роджер для спавна
var Hack = preload("res://Scenes/Hack.tscn") #Хэк для спавна
var TechnoZen = preload("res://Scenes/TechnoZen.tscn") #Техно для спавна
var NeonThingy = preload("res://Scenes/MC/NeonThingy.tscn") 
var TEST_THINGY = preload("res://Scenes/RemIS/RemIS.tscn")
var overdriver = preload("res://Scenes/Polygon/overdriver.tscn")
var Newoverdriver
@onready var music = $MusicPlayer
#НУ ПРОСТИТЕ ЗА ЭТО, Я НЕ УМЕЮ ПО-ДРУГОМУ
@onready var Scene = get_parent().get_parent().get_parent().get_parent().get_parent()
@onready var EnergyIcon = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI")
@onready var DeathMessage = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/Death")
@onready var EnergyLable = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI/RichTextLabel")
@onready var TextPanel = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/Panel")
@onready var OverloadBar = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/OverloadBar")
@onready var AttackArea = $Area2D
func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://Sprites/Misc/CURSOR.png"))
	update_overload()
	await get_tree().process_frame
	if OS.get_unique_id() == "{5fffa4c0-29de-11eb-9669-806e6f6e6963}":
		admin = true
		transfer_to_text_panel("ПРИВЕТ, ХОЗЯИН~", false, Color.from_rgba8(0, 68, 255, 255), Color.from_rgba8(148, 175, 255, 255))
	update_energy()
	DPMstuff()
	music.play_from_pos()
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
	if velocity.x < 0:
		$Animations.flip_h = true
		$Animations.texture.normal_texture = preload("res://Sprites/MC/NormalSiriFliped.png")
		AttackArea.set_scale(Vector2(1, 1))
		$Area2D/HitArea.set_scale(Vector2(1, 1))
	elif velocity.x > 0:
		$Animations.flip_h = false
		$Animations.texture.normal_texture = preload("res://Sprites/MC/SiriNormal.png")
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
	if velocity == Vector2.ZERO and not AttackArea.attacking and not isdashing:
		$AnimationPlayer.play("Idle")
	elif velocity.x < 0 and is_on_floor() and not AttackArea.attacking:
		$AnimationPlayer.play("Run")
	elif velocity.x > 0 and is_on_floor() and not AttackArea.attacking:
		$AnimationPlayer.play("Run")
	elif not AttackArea.attacking:
		$AnimationPlayer.play("Idle")
func _input(event):
	if AlreadyDied and not event is InputEventMouse and event.pressed:
		restart()
	if event is InputEventKey and event.keycode == KEY_F and IsInLib:
		if event.pressed:
			pass
		else:
			var NewBook = Book.instantiate()
			EnergyIcon.get_parent().get_parent().get_parent().get_parent().add_child(NewBook)
			NewBook.global_position = Vector2(320, 180)
	if event is InputEventKey and event.keycode == KEY_E and not OVERDRIVEN:
		if event.pressed:
			pass
		else:
			var NEWCORE = CORE.instantiate()
			get_parent().get_parent().add_child(NEWCORE)
			NEWCORE.global_position = global_position
			NEWCORE.get_node("Core").MC = self
			NEWCORE.get_node("Core").linear_velocity += velocity / 2
			CoreReg = false
			CoreCounter += 1 
			if CoreCounter >= 3:
				if CoreCounter >= 5:
					if CoreCounter >= 7:
						transfer_to_text_panel("overcore", true, Color.from_rgba8(51, 0, 2, 255))
					else:
						transfer_to_text_panel("overcore", true, Color.from_rgba8(103, 0, 2, 255))
				else:
					transfer_to_text_panel("overcore", true, Color.from_rgba8(152, 0, 2, 255))
			if CoreCounter < 2 and not GOD_MODE:
				energy -= 5
			if energy <= 0:
				death_reason = "Передоз ядрами"
			elif not GOD_MODE:
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
			if get_parent().get_parent().has_method("new_enemy"):
				get_parent().get_parent().new_enemy()
			var NewHack = Hack.instantiate()
			get_parent().get_parent().add_child(NewHack)
			NewHack.global_position = get_global_mouse_position()
			NewHack.get_node("ManHack").activate()
	if event is InputEventKey and event.keycode == KEY_7 and admin:
		if not event.pressed:
			var NewTest = TEST_THINGY.instantiate()
			get_parent().get_parent().add_child(NewTest)
			if get_parent().get_parent().has_method("new_enemy"):
				get_parent().get_parent().new_enemy()
			NewTest.get_node("RemIS").global_position = get_global_mouse_position()
	if event is InputEventKey and event.keycode == KEY_4 and admin:
		if not event.pressed:
			if get_parent().get_parent().has_method("new_enemy"):
				get_parent().get_parent().new_enemy()
			var NewTechnoZen = TechnoZen.instantiate()
			get_parent().get_parent().add_child(NewTechnoZen)
			NewTechnoZen.global_position = get_global_mouse_position()
			NewTechnoZen.get_node("TechnoZen").activate()
	if event is InputEventKey and event.keycode == KEY_O and admin:
		if event.is_pressed() and Newoverdriver == null:
			Newoverdriver = overdriver.instantiate()
			get_parent().get_parent().add_child(Newoverdriver)
			Newoverdriver.global_position = get_global_mouse_position()
		elif event.is_released():
			Newoverdriver.queue_free()
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
			if get_parent().get_parent().has_method("new_enemy"):
				get_parent().get_parent().new_enemy()
			var NewRodger = Rodger.instantiate()
			get_parent().get_parent().add_child(NewRodger)
			NewRodger.global_position = get_global_mouse_position()
			NewRodger.get_node("Roach").activate()
	if event is InputEventKey and event.keycode == KEY_ENTER:
		if not AlreadyDied:
			get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	if event is InputEventKey and event.keycode == KEY_8 and admin:
		Engine.time_scale = 0.3
	if event is InputEventKey and event.keycode == KEY_SHIFT and candash:
		if event.pressed:
			pass
		else:
			dash()
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not AttackArea.attacking:
			hit()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed and not AttackArea.attacking:
			if OVERDRIVEN and OVERDRIVE_TYPE == 1:
				THIS_PLACE_ABOUT_TO_BLOW()
			else:
				parryMC()
	if event is InputEventKey and event.keycode == KEY_C:
		if event.pressed:
			Engine.time_scale = 0.0000000001
		else:
			Engine.time_scale = 1
func dash():
	var to_mouse = 0
	if not isdashing and dashesleft > 0:
		collision_mask = (1 << 0) | (1 << 1) | (1 << 3)
		collision_layer = (1 << 9) 
		BladePoint1 = global_position
		var mouse_pos = get_global_mouse_position()
		to_mouse = (mouse_pos - global_position).normalized()
		if not OVERDRIVEN:
			velocity = to_mouse * DashSpeed
		else:
			velocity = to_mouse * DashSpeed * 1.5
		base_gravity = 0
		isdashing = true
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
			energy -= 5
			OVERLOAD -= 1
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(152,0,2,255))
		2:
			OVERLOAD -= 2
			energy -= 10
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(103,0,2, 255))
		3:
			OVERLOAD -= 3
			energy -= 20
			EnReg = false
			update_energy()
			transfer_to_text_panel("overdash", true, Color.from_rgba8(51,0,2, 255))
	EnReg = false
	update_energy()
func OverdriveRift():
	#Рот болит 
	#И попе больно
	#Разрабом быть 
	#Вполне прикольно
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
	collision_layer = (1 << 0) | (1 << 14)
	collision_mask = (1 << 0) | (1 << 1) | (1 << 2)
	dashesleft -= 1
	if OVERDRIVEN and OVERDRIVE_TYPE == 1:
		OverdriveRift()
		base_gravity = 1200
		velocity = Vector2.ZERO
		isdashing = false
	else:
		base_gravity = 1200
		velocity = Vector2.ZERO
		isdashing = false
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
		EnergyIcon.get_node("NUM1").play("E")
		EnergyIcon.get_node("NUM2").play("r")
		EnergyIcon.get_node("NUM3").play("r")
		EnergyIcon.play("OVERDRIVE")
	else:
		EnergyLable.text = str(energy).pad_zeros(3)
		if energy <= 0:
			EnergyIcon.play("0")
		elif energy > 224:
			EnergyIcon.play("256")
		elif energy > 192:
			EnergyIcon.play("224")
		elif energy > 160:
			EnergyIcon.play("192")
		elif energy > 128:
			EnergyIcon.play("160")
		elif energy > 96:
			EnergyIcon.play("128")
		elif energy > 64:
			EnergyIcon.play("96")
		elif energy > 32:
			EnergyIcon.play("64")
		elif energy > 0:
			EnergyIcon.play("32")
		energy = clamp(energy, 0, 256)
	var EnergyButWithZeros = str(energy).pad_zeros(3)
	var FirstNumUwU = EnergyButWithZeros.substr(0, 1)
	var SecondNumUwU = EnergyButWithZeros.substr(1, 1)
	var ThirdNumUwU = EnergyButWithZeros.substr(2, 1)
	EnergyIcon.get_node("NUM1").play(FirstNumUwU)
	EnergyIcon.get_node("NUM2").play(SecondNumUwU)
	EnergyIcon.get_node("NUM3").play(ThirdNumUwU)
func _on_dash_regen_timeout() -> void:
	#Уменьшает счетчик рывков
	if DashRegen == DashesUsed:
		DashesUsed -= 1
	NotRegen = true
func die():
	DeathMessage.visible = true
	if IsInLib:
		DeathMessage.get_node("Label").text = str("
		Счет — ", Global.lib_score,"
		Лучший счет — ", Save.get_value("~NUMBERS~", "BestLibScore"),"
		Убийств — ", Global.BodyCountForCoolness,"
		Причина смерти — ", death_reason, "
		")
	#Просто смерть. Хреново сделанная.
	global_rotation_degrees = 90
	speed = 0
	velocity. x = 0
	velocity.y = 0
	jump_force = 0
	music.pitch_scale = lerp(music.pitch_scale, 0.0, 0.02)
	await get_tree().create_timer(1).timeout
	if AlreadyDied == false:
		AlreadyDied = true
		var Deaths = Save.get_value("~NUMBERS~", "YourselfKilled", ) + 1
		Save.set_value("~NUMBERS~", "YourselfKilled", Deaths )
func _on_dash_regen_2_timeout():
	return
	#ЗАРЕЗЕРВИРОВАННО
	while energy < 100 and EnReg == true:
		energy += 1
		update_energy()
		await get_tree().create_timer(0.05).timeout
	NotRegening = true
	EnReg = true
func take_damage(damage = 1, hitstopdur = 0, OverHeatDamage = 1, reason = null):
	#Функция отвечает за получаемый урон.
	#Я попытался ее унифицировать. Первый параметр это урон. Второй - длительность хитстопа. Третий - количество потерь перегрева. И последнее: причина смерти.
	if not isdashing and not OVERDRIVEN and not GOD_MODE:
		if OVERLOAD > 0:
			OVERLOAD -= OverHeatDamage
		if hitstopdur > 0:
			music.PitchShiftDamage(hitstopdur)
		if hitstopdur > 0 and not HitstoppingNow:
			hitstop(hitstopdur)
		elif HitstoppingNow:
			print("хитстоп на ", hitstopdur, " не удался из-за наложения")
		var OverDamage = calc_overdamage()
		energy -= int(damage * OverDamage)
		if energy <= 0:
			death_reason = reason
		update_energy()
		update_overload()
		EnReg = false
	knockback()
func calc_overdamage():
		var OverDamage = 1
		if OVERLOAD < 10:
			OverDamage = 1
		elif OVERLOAD < 20:
			OverDamage = 1.1
		elif OVERLOAD < 30:
			OverDamage = 1.2
		elif OVERLOAD < 40:
			OverDamage = 1.3
		elif OVERLOAD < 50:
			OverDamage = 1.4
		elif OVERLOAD < 60:
			OverDamage = 1.5
		elif OVERLOAD < 70:
			OverDamage = 1.6
		elif OVERLOAD < 80:
			OverDamage = 1.7
		elif OVERLOAD < 90:
			OverDamage = 1.8
		elif OVERLOAD < 100:
			OverDamage = 1.9
		else:
			OverDamage = 2
		return OverDamage
func hitstop(hitstopdur):
	print("хитстоп на ", hitstopdur)
	HitstoppingNow = true
	get_tree().paused = true
	await(get_tree().create_timer(hitstopdur, true, false, true).timeout)
	get_tree().paused = false
	HitstoppingNow = false
func hit():
	$Area2D.monitoring = true
	$Area2D.attacking = true
	print('Произошол тролленг')
	$AnimationPlayer.play("Attack")
	rng.randomize()
	Whooshes = [Whoosh1, Whoosh2, Whoosh3]
	var Sound = Whooshes[rng.randi() % Whooshes.size()]
	$Whoosh.stream = Sound
	$Whoosh.pitch_scale = randf_range(0.7, 1.3)
	$Whoosh.play()
func OVERDRIVE():
	energy = 256
	music.DoSomething(4)
	OVERDRIVEN = true
	speed = 800
	jump_force = 600
	await get_tree().create_timer(5.33).timeout
	while OVERLOAD > 0:
		take_overheat(-1)
		await get_tree().create_timer(0.2).timeout
	OVERDRIVEN = false
	THIS_PLACE_ABOUT_TO_BLOW()
	speed = Global.speed
	jump_force = 600
	OVERLOAD = 0
	energy = 128
	print('Конец овердрайва')
	update_energy()
	music.DoSomething(2)
func take_energy_overdrive():
	await get_tree().create_timer(5.33 / Global.MusicPitch).timeout
	update_energy()
func knockback():
	#Отбрасывание, теперь вообще отключил. Доработаю потом когда-нить
	pass
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
	var OverloadButWithZeros = str(OVERLOAD).pad_zeros(3)
	var FirstNum = OverloadButWithZeros.substr(0, 1)
	var SecondNum = OverloadButWithZeros.substr(1, 1)
	var ThirdNum = OverloadButWithZeros.substr(2, 1)
	if FirstNum == "0":
		FirstNum = "O"
	if SecondNum == "0":
		SecondNum = "O"
	if ThirdNum == "0":
		ThirdNum = "O"
	OverloadBar.get_node("Label").text = str(FirstNum)
	EnergyIcon.get_node("OverheatThingy").scale.x = float(OVERLOAD) / 2
	EnergyIcon.get_node("OverheatThingy").global_position.x = 11.5 + float(OVERLOAD) / 2
	OverloadBar.get_node("Label2").text = str(SecondNum)
	OverloadBar.get_node("Label3").text = str(ThirdNum)
func transfer_to_text_panel(text, is_minus, color = Color.from_rgba8(255, 255, 255, 255), outline = Color.from_rgba8(0, 0, 0, 255)):
	TextPanel.update_text_panel(text, is_minus, color, outline)
func _on_core_regen_timeout() -> void:
	NotCoreRegening = true
	if CoreReg:
		CoreCounter -= 1


func _on_coyote_timeout() -> void:
	Coyote = false

func take_overheat(overheat):
	OVERLOAD += overheat
	update_overload()
func DPMstuff():
	while Global.Debug == true:
		DPM = 0
		while DPM == 0:
			await get_tree().create_timer(0.1).timeout
		await get_tree().create_timer(5).timeout
func update_DPM(Damage):
	DPM += Damage
func restart():
	print(Scene.scene_file_path)
	get_tree().change_scene_to_file(Scene.scene_file_path)
