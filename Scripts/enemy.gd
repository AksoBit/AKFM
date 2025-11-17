extends CharacterBody2D

var health = 200



func take_damage(damage):
	health -= damage
	print("Ударил маникен")
	if health <= 0:
		die()
		print("Убил маникен")

func die():
	queue_free()


func _on_attack_area_body_entered(body):
	if body.name == "UwUGG":
		print("Ударился мизинцем о маникен")
		body.take_damage(1)
