extends Node2D
var BLANK = preload("res://Scenes/∞/BlankRoom.tscn")
var ReadingRoom = preload("res://Scenes/∞/ReadingRoom.tscn")
var RoomPos = 1312
var RoomInd = 1
var rng = RandomNumberGenerator.new()
var Rooms = [BLANK, ReadingRoom]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.MusicPack = 2
	Global.lib_score = 0
	Global.BodyCountForCoolness = 0
	newone()
	newone()
	$UwUGG/UwUGG.IsInLib = true
	$UwUGG/Camera2D.speedofbuildings = 0.9
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func newone():
	rng.randomize()
	var NEWROOM = Rooms[rng.randi() % Rooms.size()].instantiate()
	add_child(NEWROOM)
	NEWROOM.RoomInd = RoomInd
	NEWROOM.RoomPos = RoomPos
	NEWROOM.global_position.x += RoomPos
	RoomInd += 1
	RoomPos += 1312
