extends Camera2D
var act_cum_pos_buildings : Vector2
var act_cum_pos_poly : Vector2
var act_cum_pos : Vector2
var UwUy = 0
var speedofbuildings = 0.25
var PolySpeed = 0.1
var target_pos = Vector2.ZERO
#Это, типа, та же херь но теперь с... чем?... Да хз.
func _process(delta: float) -> void:
	var gg_pos = $"../P".global_position
	target_pos = Vector2(gg_pos.x, gg_pos.y + UwUy)
	RenderMain(delta)
func RenderBuildings(delta):
	var bgbuildingsviewport = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer3")
	var buldings_cum = bgbuildingsviewport.get_node("SubViewport/layer 2/Camera2D")
	act_cum_pos_buildings = act_cum_pos_buildings.lerp(target_pos * speedofbuildings, delta * 3)
	var cum_subP_buildings = act_cum_pos_buildings.round() - act_cum_pos_buildings
	bgbuildingsviewport.material.set_shader_parameter("cam_offset", Vector2(cum_subP_buildings.x, 0))
	var buildingsCHETOTAM = act_cum_pos_buildings.round()
	buldings_cum.global_position.x = buildingsCHETOTAM.x
func RenderPoly(delta):
	var bgpolyviewport = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer4")
	var poly_cum = bgpolyviewport.get_node("SubViewport/layer 1/Camera2D")
	act_cum_pos_poly = act_cum_pos_poly.lerp(target_pos * PolySpeed, delta * 3)
	var cum_subP_poly = act_cum_pos_poly.round() - act_cum_pos_poly
	bgpolyviewport.material.set_shader_parameter("cam_offset", Vector2(cum_subP_poly.x, 0))
	var polyCHETOTAM = act_cum_pos_poly.round()
	poly_cum.global_position.x = polyCHETOTAM.x
func RenderMain(delta):
	act_cum_pos = act_cum_pos.lerp(target_pos, delta * 3)
	var cum_subP = act_cum_pos.round() - act_cum_pos
	get_parent().get_parent().get_parent().get_parent().material.set_shader_parameter("cam_offset", cum_subP)
	global_position = act_cum_pos.round()
