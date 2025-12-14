extends Area2D
var attacking = false
var parrying = false
var Dir = Vector2.ZERO
var OverDamage
var Cooked = preload("res://Sprites/Poly/PikatCooked.png")
@onready var BG = $"../../../../../../ColorRect"
@onready var UI = $"../../../../../../SubViewportContainer2"
#Мне очень нравится читать свои комментарии из прошлого. Привет, Бит из будущего! 
func _on_body_entered(body):
	if parrying:
		if body.has_method('parry') and body.parriable:	
			$"../Parry".pitch_scale = randf_range(0.7, 1.3)
			$"../Parry".play()
			$"..".hitstop(0.03)
			var ThingyPos = get_global_mouse_position()
			Dir = (ThingyPos - body.global_position).normalized()
			parrying = false
			$"..".transfer_to_text_panel("PARRY", false, Color.from_rgba8(171, 229, 165, 255), Color.from_rgba8(9, 89, 0, 255))
			body.parry(Dir * 1000)
			$"..".OVERLOAD += 2
			$"..".update_overload()
	if body.has_method('take_damage') and not body.name == 'UwUGG' and attacking:
		OverDamage = $"..".calc_overdamage()
		$"../Hit".play()
		if not $"..".OVERDRIVEN:
			$"..".energy += int(body.take_damage(int(5 * OverDamage), 0, 0, "Siri"))
			$"..".update_DPM(int(5 * OverDamage))
			$"..".OVERLOAD += 1
			$"..".update_overload()
			$"..".update_energy()
		elif $"..".OVERDRIVEN:
			body.take_damage(15, 0, 0, "Siri")
			$"..".update_DPM(10)
	elif body.has_method('DESTROY') and attacking:
		$"../Hit".pitch_scale = randf_range(0.7, 1.3)
		$"../Hit".play()
		body.DESTROY()
	if body.name == "Core" and attacking:
		var pos = $"../MusicPlayer".get_playback_position()
		$"../MusicPlayer".stop()
		$"..".hitstop(0.01 * body.Damage)
		$"../MusicPlayer".play(pos)
	if body.name == "Core" and 42 == 80085:
		if body != null:
			body.Impact(true, false)
		BG.visible = true
		UI.visible = false
		$"../Animations".material.set_shader_parameter("Flashing", true)
		$"../Animations".material.set_shader_parameter("White", true)
		BG.material.set_shader_parameter("White", false)
		$"../../../TileMap".material.set_shader_parameter("Flashing", true)
		$"../../../TileMap".material.set_shader_parameter("White", true)
		await(get_tree().create_timer(0.05, true, false, true).timeout)
		$"../Animations".material.set_shader_parameter("White", false)
		if body != null:
			body.Impact(false, false)
		BG.material.set_shader_parameter("White", true)
		$"../../../TileMap".material.set_shader_parameter(	"White", false)
		await(get_tree().create_timer(0.05, true, false, true).timeout)
		if body != null:
			body.Impact(true, true)
		$"../../../TileMap".material.set_shader_parameter("Flashing", false)
		$"../Animations".material.set_shader_parameter("Flashing", false)
		BG.visible = false
		UI.visible = true
	elif body.name == "Pikat" and $"..".OVERLOAD >= 100 and not body.get_node("Pikat").animation == "default":
		print("Fuck")
		body.get_node("Pikat").play("default")
		body.global_position.y += 1
		body.get_node("Cooking").play()
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if attacking == true:
		attacking = false
		monitoring = false
