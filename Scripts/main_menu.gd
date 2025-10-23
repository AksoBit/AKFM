extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	Global.music = load("res://Music/1xx/100 Continue.ogg")
	Global.footstep = load("res://Sounds/untitled.wav")
	Global.speed = 500
	Global.admin = false
	$AnimationPlayer.play("drive")
	$AnimationPlayer2.play("RESET")
	$AnimationPlayer3.play("Y")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Scenes/UwUPIXEL.tscn")

func _on_exit_button_down() -> void:
	$AnimationPlayer/CollisionShape2D/Car/OpenedTheCarDoor.play()
	await get_tree().create_timer(1).timeout
	get_tree().quit()


func _on_infinity_button_down() -> void:
	print('Ща будет куча ошибок, это норма')
	get_tree().change_scene_to_file("res://Scenes/∞/MainRender.tscn")
