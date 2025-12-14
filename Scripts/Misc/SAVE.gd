extends Node

var config = ConfigFile.new()
var path = "user://save.cfg"
var saved_data        = ["HacksKilled", "RodgersKilled", "TechnoZensKilled", "RemISKilled", "YourselfKilled", "BestLibScore"]
var saved_data_section= ["~NUMBERS~", "~NUMBERS~", "~NUMBERS~", "~NUMBERS~", "~NUMBERS~", "~NUMBERS~"]
var saved_data_value  = [0, 0, 0, 0, 0, 0]
func _ready():
	if config.load(path) != OK:
		set_value("~NUMBERS~", "HacksKilled", 0 )
		set_value("~NUMBERS~", "RodgersKilled", 0 )
		set_value("~NUMBERS~", "TechnoZensKilled", 0 )
		set_value("~NUMBERS~", "RemISKilled", 0 )
		set_value("~NUMBERS~", "YourselfKilled", 0 )
		set_value("~NUMBERS~", "BestLibScore", 0 )
		config.save(path)
func get_value(section, key):
	return config.get_value(section, key)
func set_value(section, key, value):
	config.set_value(section, key, value)
	config.save(path)
func hey_ive_got_an_update():
	await get_tree().process_frame
	for i in saved_data.size():
		if get_value(saved_data_section[i], saved_data[i]) != null:
			set_value(saved_data_section[i], saved_data[i], get_value(saved_data_section[i], saved_data[i]))
		else:
			set_value(saved_data_section[i], saved_data[i], saved_data_value[i])
	config.save(path)
