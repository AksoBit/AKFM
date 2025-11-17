extends Sprite2D
@onready var Speed = $Speed
@onready var Music = $Volume
@onready var SFX = $SFX
@onready var Voice = $Voicelines
@onready var Main = $MAIN
func _ready():
	Global.Debug = Settings.get_value("~GAMEPLAY~", "Debug")
	if Global.Debug == true:
		get_tree().debug_collisions_hint = true
		Settings.set_value("~GAMEPLAY~", "Debug", true)
	Global.CRT = Settings.get_value("~GRAPHICS~", "CRT",)
	if Global.CRT == true:
		$CRT.update_shader()
	$DeBugtton.button_pressed = Settings.get_value("~GAMEPLAY~", "Debug")
	Music.value = Settings.get_value("~SOUND~", "Music")
	SFX.value = Settings.get_value("~SOUND~", "SFX")
	Main.value = Settings.get_value("~SOUND~", "Global")
	Speed.value = Settings.get_value("~SOUND~", "Speed")
	Voice.value = Settings.get_value("~SOUND~", "Voice")
	$Curva.value = 15 -  Settings.get_value("~GRAPHICS~", "Curvature")
	$Vin.value = Settings.get_value("~GRAPHICS~", "Vingette multiplyer",)
	$Scan.value = Settings.get_value("~GRAPHICS~", "Scanlines")
	$Blur.value = Settings.get_value("~GRAPHICS~", "Blur")
	$CheckButton2.button_pressed = Settings.get_value("~GRAPHICS~", "CRT",)
	_on_volume_value_changed(Music.value)
	_on_sfx_value_changed(SFX.value)
	_on_speed_value_changed(Speed.value)
	_on_voicelines_value_changed(Voice.value)
	_on_main_value_changed(Main.value)
	_on_scan_value_changed($Scan.value)
	_on_vin_value_changed($Vin.value)
	_on_curva_value_changed($Curva.value)
	_on_blur_value_changed($Blur.value)
	$"100Continue".play()
	$"Road".play()
func _on_back_to_main_button_down() -> void:
	visible = false
	$"../ФонСинтNoSun".visible = true

func _on_vsync_button_toggled(button_pressed) -> void:
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_sfx_value_changed(value: float) -> void:
	var linear_volume_SFX = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(linear_volume_SFX))
	$Line2D.set_point_position(2, Vector2(120, -2 * value + 180))
	$Polygon2D.upd_polygon()
	Settings.set_value("~SOUND~", "SFX", value)


func _on_speed_value_changed(value: float) -> void:
	if Speed.value == 0:
		Global.MusicPitch = 0.001
		$"100Continue".pitch_scale = Global.MusicPitch
	else:
		Global.MusicPitch = Speed.value * 0.01
		$"100Continue".pitch_scale = Global.MusicPitch
	$Line2D.set_point_position(5, Vector2(-240.0, -2 * value/2 + 180))
	$Polygon2D.upd_polygon()
	Settings.set_value("~SOUND~", "Speed", value)

func _on_volume_value_changed(value: float) -> void:
	var linear_volumeMusic = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(linear_volumeMusic))
	$Line2D.set_point_position(4, Vector2(-120, -2 * value + 180))
	$Polygon2D.upd_polygon()
	Settings.set_value("~SOUND~", "Music", value)
	

func _on_voicelines_value_changed(value: float) -> void:
	$Line2D.set_point_position(1, Vector2(240.0, -2 * value + 180))
	$Polygon2D.upd_polygon()
	Settings.set_value("~SOUND~", "Voice", value)

func _on_main_value_changed(value: float) -> void:
	var linear_volume = value / 100
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(linear_volume))
	$Line2D.set_point_position(3, Vector2(-1, -2 * value + 180))
	$Polygon2D.upd_polygon()
	Settings.set_value("~SOUND~", "Global", value)

func _on_check_button_button_down(button_pressed) -> void:
	if button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)


func _on_de_bugtton_pressed() -> void:
	if not Global.Debug:
		Global.Debug = true
		get_tree().debug_collisions_hint = true
		Settings.set_value("~GAMEPLAY~", "Debug", true)
	else:
		Global.Debug = false
		get_tree().debug_collisions_hint = false
		Settings.set_value("~GAMEPLAY~", "Debug", false)


func _on_de_bugtton_2_toggled(button_pressed) -> void:
	if button_pressed:
		Settings.set_value("~SOUND~", "Overdrum", true)
		Global.OVERDRUM = true
	else:
		Settings.set_value("~SOUND~", "Overdrum", false)
		Global.OVERDRUM = false


func _on_check_button_2_toggled(button_pressed) -> void:
	if button_pressed:
		Settings.set_value("~GRAPHICS~", "CRT", true)
		Global.CRT = true
		$CRT.update_shader()
	else:
		Settings.set_value("~GRAPHICS~", "CRT", false)
		Global.CRT = false
		$CRT.update_shader()


func _on_blur_value_changed(value: float) -> void:
	Global.Blur = value
	Settings.set_value("~GRAPHICS~", "Blur", value)
	$CRT.update_shader()


func _on_scan_value_changed(value: float) -> void:
	Global.Scanlines = value
	Settings.set_value("~GRAPHICS~", "Scanlines", value)
	$CRT.update_shader()


func _on_vin_value_changed(value: float) -> void:
	Global.Vingette = value
	Settings.set_value("~GRAPHICS~", "Vingetta", value)
	$CRT.update_shader()


func _on_curva_value_changed(value: float) -> void:
	value = 15 - value
	Global.Curvature = value 
	Settings.set_value("~GRAPHICS~", "Curvature", value)
	$CRT.update_shader()
