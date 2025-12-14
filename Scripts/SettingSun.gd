extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_back_button_down() -> void:
	$".".visible = false
	$"../MainMenu".visible = true
	$"../MainMenu/Synth".visible = true
	$"../MainMenu/Synth/Control".visible = true

func _on_settings_sound_button_down() -> void:
	$".".visible = false
	$"../ФонСинт".visible = true


func _on_settings_control_button_down() -> void:
	$".".visible = false
	$"../Panel".visible = true
	
