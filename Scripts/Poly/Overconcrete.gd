extends Node2D

# Потом допилю
func _process(delta: float) -> void:
	$UwUGG.get_node("Camera2D").UwUy = $UwUGG.get_node("UwUGG").global_position.y
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), 0)
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("SFX"), 0, true)
