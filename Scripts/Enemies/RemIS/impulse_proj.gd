extends CharacterBody2D
var target 
var remis 
var parriable = true
var speed = 1000
var damage = 10
var damage_to_enemies = 2
@onready var siri = get_parent().get_parent().get_node("UwUGG/UwUGG")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	velocity = -target.normalized() * speed
func _physics_process(delta: float) -> void:
	move_and_slide()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		if body.is_in_group("enemy"):
			if parriable == true:
				body.take_damage(damage_to_enemies)
				if remis != null:
					remis.energy += damage_to_enemies
			else:
				body.take_damage(damage)
				siri.energy += damage
		else:
			body.take_damage(damage)
			if parriable == true:
				if remis != null:
					remis.energy += damage
			else:
				siri.energy += damage
	queue_free()
func parry(dir):
	velocity = dir.normalized() * speed
	$CollisionShape2D.look_at(velocity)
	parriable = false
