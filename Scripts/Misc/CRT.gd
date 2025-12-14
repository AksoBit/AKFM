extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred('update_shader')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_shader():
	visible = Global.CRT
	material.set_shader_parameter("curva", Global.Curvature)
	material.set_shader_parameter("vin_mult", Global.Vingette)
	material.set_shader_parameter("blur", Global.Blur)
	material.set_shader_parameter("scanlines_mult", Global.Scanlines)
