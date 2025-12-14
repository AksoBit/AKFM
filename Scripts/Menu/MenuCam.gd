extends Camera2D
var act_cum_pos : Vector2
var UwUy = false
#Хаюшки~ Это AksoBit. Я честно не совсем понимаю как это все работает. Шейдеры такие сложные >w<
#Этот код я взял из видео Barry's Dev Hell, как и, впрочем, код для паралакса. 
#www.youtube.com/@BarrysDevHell
func _process(delta: float) -> void:
	
	var gg_pos = global_position
	var target_pos = Vector2(gg_pos)
	act_cum_pos = act_cum_pos.lerp(target_pos, delta * 3)
	var cum_subP = act_cum_pos.round() - act_cum_pos
	get_parent().get_parent().get_parent().material.set_shader_parameter("cam_offset", cum_subP)
	global_position = act_cum_pos.round()
