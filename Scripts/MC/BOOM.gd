extends Area2D
var damage = 0
var MC
var IsInTheBeam
var Charge 
#НАПОМИНАНИЕ ДЛЯ СЕБЯ:
#Если пьешь чай, делай последний глоток АККУРАТНО. Там может быть заварка.
func _ready() -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
		if Charge.size() > 0:
			if Charge[0] == "Laser":
				if body == null:
					return
				if body.has_method('take_damage') and not body.has_method("IDC"):
					IsInTheBeam = true
					while IsInTheBeam == true:
						if body == null:
							return
						if body.name == "UwUGG":
							body.take_damage(int(damage/2), 0, 0, "LaserCore")
						else:
							body.take_damage(int(damage), 0, 0, "LaserCore")
						await get_tree().create_timer(0.2).timeout
				elif body.has_method("IDC"):
					body.IsChillin = true
					body.IDC()
		else:
			if body.has_method("take_damage") and not body.name == "UwUGG":
				body.take_damage(damage, 0, 0, "Core")
				MC.DPM += damage
			elif body.name == "UwUGG":
				body.take_damage(int(damage/2), 0, 0, "Core")
			elif body.has_method('DESTROY'):
				body.DESTROY()
	
func DESTROY():
	Charge = $"../Core".Charge
	if Charge.size() > 0:
		if Charge[0] == "Laser":
			MC = $"../Core".MC
			visible = true
			monitoring = true
			global_position = $"../Core".global_position
			$CorExplosion.pitch_scale = randf_range(0.7, 1.3)
			$CorExplosion.play()
			$CollisionShape2D2/LaserCoreExplosion.visible = true
			damage = $"../Core".Damage
			await get_tree().create_timer(2).timeout
			get_parent().queue_free()
	else:
		MC = $"../Core".MC
		visible = true
		monitoring = true
		global_position = $"../Core".global_position
		$CollisionShape2D2/AnimatedSprite2D.visible = true
		$CorExplosion.pitch_scale = randf_range(0.7, 1.3)
		$CorExplosion.play()
		$CollisionShape2D2/AnimatedSprite2D.play("default")
		damage = $"../Core".Damage
func _on_animated_sprite_2d_animation_finished() -> void:
	get_parent().queue_free()


func _on_body_exited(body: Node2D) -> void:
	IsInTheBeam = false
	if body == null:
		return
	if body.has_method("IDC"):
		body.IsChillin = false
