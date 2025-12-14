extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	$"../MAIN".value = 50
	$"../SFX".value = 50
	$"../Volume".value = 50
	$"../Speed".value = 100
	$"../Voicelines".value = 50
	Global.OVERDRUM = false 
	Settings.set_value("~SOUND~", "Overdrum", false)
