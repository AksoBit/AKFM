extends GPUParticles2D
@onready var gg =  get_node("res://Scenes/sparks.tscn")
func _process(delta: float) -> void:
	var ggpos = gg.get_global_position()
	look_at(ggpos)
