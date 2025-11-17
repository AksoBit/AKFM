extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1
	Global.MusicPack = 3
	get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI").visible = false
	get_parent().get_node("UwUGG/UwUGG").jump_force = 300
	get_parent().get_node("UwUGG/UwUGG").candash = false
	get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer2/SubViewport/UI/UI/RichTextLabel").visible = false
	get_parent().get_node("UwUGG/Camera2D").speedofbuildings = 1.1
	get_parent().get_node("UwUGG/UwUGG").IsInBackrooms = true
	get_parent().get_node("UwUGG/UwUGG/footstepart").texture = load("res://Sprites/Dust.png")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == ("UwUGG"):
		$"../54857Ada726a34b".play()
		queue_free()
