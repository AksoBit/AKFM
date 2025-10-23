extends Label
@onready var GG = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("SubViewportContainer/SubViewport/Main/UwUGG/UwUGG")
var pos
var isd
var isj
var vel
var en
var fps
var mpos
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.Debug == false:
		queue_free()
func _process(delta: float) -> void:
	pos = GG.global_position
	vel = GG.velocity
	isd = GG.isdashing
	isj = GG.isjumping
	en = GG.energy
	mpos = get_global_mouse_position().round()
	fps = Performance.get_monitor(0)
	text = "Pos: " + str(pos) + "\n" + \
	"MPos: " + str(mpos) + "\n" + \
	"Vel: " + str(vel) + "\n" + \
	"Isd: " + str(isd) + "\n" + \
	"Isj: " + str(isj) + "\n" + \
	"En: " + str(en) + "\n" + \
	"Fps: " + str(fps)
	
