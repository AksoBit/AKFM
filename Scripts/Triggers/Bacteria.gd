extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	move_and_slide()

func activated():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("default")
	$Area2D.monitoring = true
	velocity.x = 700
	$"Backrooms-bacteria-sound-made-with-voicemod".play()


func _on_area_2d_body_entered(body: Node2D) -> void:
		get_tree().quit()
