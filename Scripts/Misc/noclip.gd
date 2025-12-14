extends Area2D
func _on_body_entered(body: Node2D) -> void:
	if body.name == ("UwUGG"):
		Global.music = load('res://Sounds/w9u2jbrxo7scu2gicg67bltaf1cy7nycy2ior.mp3')
		Global.speed = 200
		Global.footstep = load("res://Sounds/hard-carpet-footwork-shoes-footsteps-walking-ntg3 (mp3cut.net).mp3")
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://Scenes/PIXELSrooms.tscn")
		
	elif body.hac_method("die"):
		body.die()
	
