extends AudioStreamPlayer
var music
var music_pack = Global.MusicPack
var playing_something = false
var over_192 = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	music_pack = Global.MusicPack
	pitch_scale = Global.MusicPitch
	if music_pack == 1:
		music = load("res://Music/1xx/100 Continue.ogg")
	elif music_pack == 2:
		music = load("res://Music/5xx/508 Loop Detected.wav")
	elif music_pack == 3:
		music = load("res://Sounds/w9u2jbrxo7scu2gicg67bltaf1cy7nycy2ior.mp3")
	elif music_pack == 4:
		music = load("res://Music/Polygon/207 Multi-Status (INTRO).ogg")
func _process(delta: float) -> void:
	if playing_something:
		if $"..".energy >= 192 and not over_192:
			over_192 = true
			DoSomething(3)
		elif $"..".energy < 192 and over_192:
			over_192 = false
			DoSomething(2)
func DoSomething(type_of_music): # 1 - фоновая 2 - бой 3 - бой больше 192 4 - Овердрайв
	if type_of_music == 1:
		if music_pack == 1:
			music = load("res://Music/1xx/100 Continue.ogg")
		elif music_pack == 2:
			music = load("res://Music/5xx/508 Loop Detected.wav")
		elif music_pack == 3:
			music = load("res://Sounds/w9u2jbrxo7scu2gicg67bltaf1cy7nycy2ior.mp3")
		elif music_pack == 4:
			music = load("res://Music/Polygon/207 Multi-Status (INTRO).ogg")
		play_from_pos()
	elif type_of_music == 2:
		if music_pack == 1:
			music = load('res://Music/1xx/103 Early Hints.ogg')
		elif music_pack == 2:
			music = load("res://Music/4xx/416 Range Not Satisfiable.wav")
		elif music_pack == 4:
			music = load("res://Music/Polygon/207 Multi-Status (MAIN).ogg")
		play_from_pos()
	elif type_of_music == 3:
		if music_pack == 1:
			music = load('res://Music/1xx/103 Early Hints (OVER 200).ogg')
		elif music_pack == 2:
			music = load("res://Music/4xx/416 Range Not Satisfiable (OVER 200).wav")
		elif music_pack == 4:
			music = load("res://Music/Polygon/207 Multi-Status (MAIN OVER 192).ogg")
		play_from_pos()
	elif type_of_music == 4:
		if music_pack == 1:
			music = load("res://Sounds/All the stuff.wav")
		elif music_pack == 2:
			music = load("res://Music/4xx/414 URI Too Long (pre).wav")
		elif music_pack == 4:
			music = load("res://Music/Polygon/207 Multi-Status (OVERDRIVING).ogg")
		stop()
		stream = music
		play()
		await get_tree().create_timer(5.33 / Global.MusicPitch).timeout
		if music_pack == 1:
			music = load("res://Music/1xx/101 Switching Protocols.ogg")
		elif music_pack == 2:
			music = load("res://Music/4xx/414 URI Too Long.wav")
		elif music_pack == 4:
			music = load("res://Music/Polygon/207 Multi-Status (OVERDRIVEN).ogg")
		stop()
		stream = music
		play()
func PitchShiftDamage(hitstopdur):
	pitch_scale = lerp(pitch_scale, 0.2, 0.2)
	await get_tree().create_timer(0.2).timeout
	pitch_scale = lerp(pitch_scale, Global.MusicPitch, 1)
	
func play_from_pos():
	var pos = get_playback_position()
	stop()
	stream = music
	play(pos)
func EPICER_MUSIK():
	if not playing_something:
		while $"..".OVERDRIVEN:
			await get_tree().process_frame
		DoSomething(2) if not over_192 else DoSomething(3)
		playing_something = true
func calm_down():
	if playing_something:
		while $"..".OVERDRIVEN:
			await get_tree().process_frame
		DoSomething(1)
		playing_something = false
