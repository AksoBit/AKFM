extends Node
var Debug = false
var MusicPitch = 1
var music = load("res://Music/1xx/100 Continue.ogg")
var footstep = load("res://Sounds/untitled.wav")
var speed = 600
var admin = false
var BodyCountForLib = 0
var BodyCountForCoolness = 0
var MusicPack = 1
var OVERDRUM = false
var lib_score = 0
var CRT = false
var Curvature = 7.0
var Vingette = 0.25
var Blur = 0.3
var Scanlines = 2
func _ready() -> void:
	print('Короча, это логи. Да, те самые сложные буковоки которые ты отправляешь разрабу, и он делает вид что понял в чем баг. Но мои логи чутка попроще... Сам понимяу.')
func HackDeath():
	BodyCountForLib += 1
	BodyCountForCoolness += 1
	var Kills = Save.get_value("~NUMBERS~", "HacksKilled", ) + 1
	Save.set_value("~NUMBERS~", "HacksKilled", Kills )
func RemDeath():
	BodyCountForLib += 1
	BodyCountForCoolness += 1
	var Kills = Save.get_value("~NUMBERS~", "RemISKilled", ) + 1
	Save.set_value("~NUMBERS~", "RemISKilled", Kills )
func RoDeath():
	BodyCountForLib += 1
	BodyCountForCoolness += 1
	var Kills = Save.get_value("~NUMBERS~", "RodgersKilled", ) + 1
	Save.set_value("~NUMBERS~", "RodgersKilled", Kills )
func TechnoDeath():
	BodyCountForLib += 1
	BodyCountForCoolness += 1
	var Kills = Save.get_value("~NUMBERS~", "TechnoZensKilled", ) + 1
	Save.set_value("~NUMBERS~", "TechnoZensKilled", Kills )
