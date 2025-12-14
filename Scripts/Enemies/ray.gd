extends RayCast2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.y += 2000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x = $"../Line2D".global_position.x
