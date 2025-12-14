extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../RigidBody2D2".linear_velocity += Vector2(randf_range(-100, 100), randf_range(-100, 100))#Применяет случайное ускорение от -1000 до 1000
	$"../RigidBody2D2".apply_torque(randf_range(-10, 10)) #Применяет случайное вращение от -100 до 100
	$"../RigidBody2D".linear_velocity += Vector2(randf_range(-100, 100), randf_range(-100, 100))
	$"../RigidBody2D".apply_torque(randf_range(-10, 10))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
