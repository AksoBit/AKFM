extends Area2D
var IsInTheBeam

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body == null:
		return
	if body.has_method('take_damage') and not body.has_method("IDC"):
		IsInTheBeam = true
		while IsInTheBeam == true:
			if body == null:
				return
			if body.name == "UwUGG":
				body.take_damage(15)
			else:
				body.take_damage(1)
			await get_tree().create_timer(0.2).timeout
	elif body.has_method("IDC"):
		body.IsChillin = true
		body.IDC()
func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	IsInTheBeam = false
	if body == null:
		return
	if body.has_method("IDC"):
		body.IsChillin = false
