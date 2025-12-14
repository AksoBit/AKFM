extends Node2D
var EnCounter = 0
var DontLetMeCook = 0
#Поняли? Типа Enemy Counter, EnCounter... Ха... Ха... Да, я понял, это не смешно. В этом даже почти шутки нет.
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.MusicPack = 4
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	while Global.BodyCountForLib != DontLetMeCook:
			DontLetMeCook += 1
			enemy_dies()
	DontLetMeCook =Global.BodyCountForLib
func new_enemy():
	EnCounter += 1
	if EnCounter >= 0:
		$UwUGG.get_node("UwUGG/MusicPlayer").EPICER_MUSIK()
func enemy_dies():
	EnCounter -= 1
	if EnCounter <= 0:
		EnCounter = 0
		$UwUGG.get_node("UwUGG/MusicPlayer").calm_down()


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Motorslice/Motorender.tscn")
