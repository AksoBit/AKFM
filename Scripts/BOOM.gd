extends Area2D
var damage = 0
var MC
#НАПОМИНАНИЕ ДЛЯ СЕБЯ:
#Если пьешь чай, делай последний глоток АККУРАТНО. Там может быть заварка.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
		if body.has_method("take_damage") and not body.name == "UwUGG":
			body.take_damage(damage, 0, 0, "Core")
			MC.DPM += damage
		elif body.name == "UwUGG":
			body.take_damage(int(damage/2), 0, 0, "Core")
		elif body.has_method('DESTROY'):
			body.DESTROY()
	
func DESTROY():
	MC = $"../RigidBody2D".MC
	$CorExplosion.pitch_scale = randf_range(0.7, 1.3)
	$CorExplosion.play()
	$CollisionShape2D2/AnimatedSprite2D.play("default")
	damage = $"../RigidBody2D".Damage
func _on_animated_sprite_2d_animation_finished() -> void:
	get_parent().queue_free()
