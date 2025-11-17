extends Area2D
var attacking = false
var parrying = false
var Dir = Vector2.ZERO
var OverDamage
@onready var BG = $"../../../../../../ColorRect"
@onready var UI = $"../../../../../../SubViewportContainer2"
func _on_body_entered(body):
	if parrying:
		if body.has_method('parry') and body.Parriable:	
			if body.has_method('Impact') and 42 == 80085: #Зарезервированно 
				body.Impact(true, false)
				BG.visible = true
				UI.visible = false
				$"../AnimatedSprite2D".material.set_shader_parameter("Flashing", true)
				$"../AnimatedSprite2D".material.set_shader_parameter("White", true)
				BG.material.set_shader_parameter("White", false)
				$"../../../TileMap".material.set_shader_parameter("Flashing", true)
				$"../../../TileMap".material.set_shader_parameter("White", true)
				await(get_tree().create_timer(0.05, true, false, true).timeout)
				$"../AnimatedSprite2D".material.set_shader_parameter("White", false)
				body.Impact(false, false)
				BG.material.set_shader_parameter("White", true)
				$"../../../TileMap".material.set_shader_parameter(	"White", false)
				await(get_tree().create_timer(0.05, true, false, true).timeout)
				body.Impact(true, true)
				$"../../../TileMap".material.set_shader_parameter("Flashing", false)
				$"../AnimatedSprite2D".material.set_shader_parameter("Flashing", false)
				BG.visible = false
				UI.visible = true
			$"../Parry".pitch_scale = randf_range(0.7, 1.3)
			$"../Parry".play()
			var ThingyPos = get_global_mouse_position()
			Dir = (ThingyPos - global_position).normalized()
			parrying = false
			$"..".transfer_to_text_panel("PARRY", false, Color.from_rgba8(171, 229, 165, 255), Color.from_rgba8(9, 89, 0, 255))
			body.parry(Dir * 1000)
			$"..".OVERLOAD += 2
			$"..".update_overload()
	if body.has_method('take_damage') and not body.name == 'UwUGG' and attacking:
		if $"..".OVERLOAD < 10:
			OverDamage = 1
		elif $"..".OVERLOAD < 20:
			OverDamage = 1.2
		elif $"..".OVERLOAD < 30:
			OverDamage = 1.4
		elif $"..".OVERLOAD < 40:
			OverDamage = 1.6
		elif $"..".OVERLOAD < 50:
			OverDamage = 1.8
		elif $"..".OVERLOAD < 60:
			OverDamage = 2
		elif $"..".OVERLOAD < 70:
			OverDamage = 2.2
		elif $"..".OVERLOAD < 80:
			OverDamage = 2.4
		elif $"..".OVERLOAD < 90:
			OverDamage = 2.6
		elif $"..".OVERLOAD < 100:
			OverDamage = 2.8
		else:
			OverDamage = 3
		$"../Hit".pitch_scale = randf_range(0.7, 1.3)
		$"../Hit".play()
		if not $"..".OVERDRIVEN:
			body.take_damage(int(5 * OverDamage), 0, 0, "Siri")
			$"..".update_DPM(int(5 * OverDamage))
			$"..".OVERLOAD += 1
			$"..".update_overload()
			$"..".energy += int(5 * OverDamage)
			$"..".update_energy()
		elif $"..".OVERDRIVEN:
			body.take_damage(15, 0, 0, "Siri")
			$"..".update_DPM(10)
	elif body.has_method('DESTROY') and attacking:
		$"../Hit".pitch_scale = randf_range(0.7, 1.3)
		$"../Hit".play()
		body.DESTROY()
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if attacking == true:
		attacking = false
		monitoring = false
