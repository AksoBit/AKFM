extends Panel
@onready var volume_slider = $HSlider

func _ready():
	volume_slider.value_changed.connect(_on_volume_changed)
	_apply_volume(500)

func _on_volume_changed(value: float):
	_apply_volume(value)


func _apply_volume(volume_percent: float):
	var linear_volume = volume_percent / 1000
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(linear_volume))


func _on_back_to_main_button_down() -> void:
	$".".visible = false
	$"../MainMenu".visible = true
	$"../MainMenu/AnimationPlayer/CollisionShape2D".visible = true

func _on_de_bugtton_toggled(toggled_on: bool) -> void:
	if Global.Debug == false:
		Global.debug()
	else:
		Global.undebug()



func _on_v_slider_value_changed(value: float) -> void:
	if $VSlider.value == 0:
		Global.MusicPitch = 0.001
		$"../100Continue".pitch_scale = Global.MusicPitch
	else:
		Global.MusicPitch = $VSlider.value * 0.01
		$"../100Continue".pitch_scale = Global.MusicPitch


func _on_vsync_button_toggled(button_pressed) -> void:
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_controls_button_down() -> void:
	$".".visible = false
	$"../Panel".visible = true
