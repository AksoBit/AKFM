@tool
extends Sprite2D

var previsible = false
var byebye = preload("res://Sounds/MC/bye.mp3")
var hi = preload("res://Sprites/MC/hi.png")
#Это все не имеет смысла.
#Серьезно.
func _ready():
	if Engine.is_editor_hint():
		visible = false
		previsible = visible
		set_process(true)
	else:
		if visible == true:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(0))
			var jeffrey = AudioStreamPlayer.new()
			add_child(jeffrey)
			jeffrey.stream = preload("res://Sounds/MC/jeffrey.wav")
			jeffrey.call_deferred("play")
func _process(delta):
	if Engine.is_editor_hint():
		if visible != previsible:
			previsible = visible
			await get_tree().create_timer(5).timeout
			var bye = AudioStreamPlayer.new()
			add_child(bye)
			bye.stream = byebye
			bye.play()
			await get_tree().create_timer(0.5).timeout
			texture = hi
			await get_tree().create_timer(1.5).timeout
			previsible = false
			visible = false
			texture = load("res://Sprites/MC/jeffrey.png")
