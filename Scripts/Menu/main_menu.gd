extends Node2D
var OffsetPolyY = 150
var Speed = 2.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Settings.get_value("~AKSOBIT~", "Started"):
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	Engine.time_scale = 1
	Input.set_custom_mouse_cursor(preload("res://Sprites/Misc/CURSOR.png"))
	Global.music = load("res://Music/1xx/100 Continue.ogg")
	Global.footstep = load("res://Sounds/untitled.wav")
	Global.speed = 500
	Global.admin = false
	$Synth/Control/MenuPolygon.play("default")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse = get_global_mouse_position()
	$Car.global_position.x = lerp($Car.global_position.x, ((mouse.x) /12.8) * -2 + 50, Speed * delta)
	$Synth.global_position.x = lerp($Car.global_position.x, ((mouse.x) /12.8) * -2 + 50, Speed * delta) / 1.8 + 320
	if mouse.y >= 221:
		$Car.global_position.y = lerp($Car.global_position.y, ((mouse.y) /7.2) * -2 + 50, Speed * delta)
		$Synth.global_position.y = lerp($Car.global_position.y, ((mouse.y) /7.2) * -2 + 50, Speed * delta) / 1.8 + $Car.global_position.y + OffsetPolyY
	else:
		$Car.global_position.y = lerp($Car.global_position.y, 50.0, Speed * delta)
		$Synth.global_position.y = lerp($Car.global_position.y, 50.0, Speed * delta) /1.8 + $Car.global_position.y + OffsetPolyY
func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/UwUPIXEL.tscn")
func _on_exit_button_down() -> void:
	$Car/Car/OpenedTheCarDoor.play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()


func _on_infinity_button_down() -> void:
	print('Ща будет куча ошибок, это норма')
	get_tree().change_scene_to_file("res://Scenes/∞/MainRender.tscn")
