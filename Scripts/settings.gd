# ░░░░                                                                  ▒░░▒░    
# ░░░░░░                                                               ▒░░░░░░   
#░░░░▒░░░░        ░                                                     ▒░▒░░▒░  
# ▒░▒░░░░▒░     ▒░░░▒                                                    ▒░░░░░░ 
#  ▒▒░░░▒▒░░▒░ ▒░░░░░░                █    █                     ▒▒░   ░ ▒▒░░░░▒ 
#   ▒░░░░░░░░░▒░░░░▒                ░█░▒▒▒▒▒▓█░░░              ░░░░░▒░   ░▒▒▒▒░▒ 
#   ▒░▒░░░░░░▒░░░░▒              ░▒█▓░░░░░░░░░░▒▒░▒▒░          ░▒░░░░░  ▒▒░░░░░▒ 
#   ░░░░░░▒░░░░░░▒            ░▒▒░░░░░░░░░░░░░░░░░░░░░▒          ▒░░░▒░▒░░░░░░░░ 
#    ▒░░░▒░░░░░░░▒ ░         ▒░░░▓▒░░▒░░░░░░░▒░░▒▓░░░░░░▒       ░░▒░░░░░░░░░░░░░░
#     ▒░░░░░░░░░░▒         ░░░░█░░░░▒░░░░░░░░░░▒░░░▓░░░░░▒░      ░░░░░░░░░▒░░░░▒ 
#     ░░░░░░░▒░░░▒        ▒░░▒░░░░░░░░▒▓▓▓▓▓▓▓░░░░░░░░░░░░▒░     ░░░▒░░░░░░░░░▒░ 
#      ▒░░░░░░░▒░░       ▒░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░    ░▒▒░░░░░░░░░▓   
#       ░░░░░░░▒░      ░░░░░░░░░░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░▒      ▒▒░░░░░░▓░ ░  
#        ░░▒▒▒▒         ▒░░░░░░░▒▓▓▓████▓▓▓███▓▓▓▓▓▓░░░░░░░░░▒      ░▒▒▒▒░░      
#                      ▒░░░░░░░▒▓▓▓██████▓█████▓▓▓▓▓▓░░░░░░░░▒░                  
#                      ▒░░░░░░▒▓▓▓▓█████████████▓▓▓▓▓▓░░░░░░░░░                  
#                      ▒░░░░░░▓▓▓▓███████████████▓▓▓▓▓▒░░░░░░░░                  
#                      ▒░░░░░▓▓▓▓▓███████████████▓▓▓▓▓█░░░░░░░░                  
#                      ▒░░░░░█▓▓▓▓████▓░░░░░░▓███▓▓▓▓▓▓▒░░░░░▒░                  
#                      ░░░░░▓▓▓▓▓▓██▒░░░░░░░░░░▒█▓▓▓▓▓▓▓░░░░░▒                   
#                      ░▒░░░▓▓▓▓▓▓▓░░░░░░░░░░░░░░▓▓▓▓▓▓▓▒░░░░░                   
#                       ░▒░▒▓▓▓▓▓▒░░░░░░░░░░░░░░░░▒▓▓▓▓▓▓░░░▒                    
#                        ▒░▒▓▓▓▓░░░░░░░░░░░░░░░░░░░░▓▓▓▓▓░░▒                     
#                        ▒░░▒▒░░░░░░░░░░░░░░░░░░░░░░░▒▓▓░░░░                     
#                         ▒░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                     
#                          ▒▒░▒░░░░░░░░░░░░░░░░░░░░░░░▒▒░░▒                      
#                              ░▒▒░░░░░░░░░░░░░░░░░▒▒░                           
#                                ░░░▒▒░░░░░░░░░▒▒░░
#Очень страшный код                               
extends Node

var config = ConfigFile.new()
var path = "user://settings.cfg"
var Version = "1.3.5"
func _ready():
	if config.load(path) != OK:
		set_value("~SOUND~", "Global", 50 )
		set_value("~SOUND~", "SFX", 50 )
		set_value("~SOUND~", "Voice", 50 )
		set_value("~SOUND~", "Music", 50 )
		set_value("~SOUND~", "Speed", 100 )
		set_value("~SOUND~", "Overdrum", false)
		set_value("~GRAPHICS~", "VSYNC", true)
		set_value("~GRAPHICS~", "CRT", false)
		set_value("~GRAPHICS~", "Curvature", 7.0)
		set_value("~GRAPHICS~", "Vingette multiplyer", 0.25)
		set_value("~GRAPHICS~", "Blur", 0.3)
		set_value("~GRAPHICS~", "Scanlines", 0.1)
		set_value("~GAMEPLAY~", "Debug", false)
		set_value("~SYSTEM~", "Version", Version)
		set_value("~AKSOBIT~", "ULTRAKILL", false)
		set_value("~AKSOBIT~", "HENT", false)
		set_value("~AKSOBIT~", "COOL_GAMES", false)
		set_value("~AKSOBIT~", "Started", false)
		config.save(path)
	if config.get_value("~SYSTEM~", "Version") != Version:
		Save.hey_ive_got_an_update()
		print("Оп оп, обнова")
		if get_value("~SOUND~", "Global") != null:
			set_value("~SOUND~", "Global", get_value("~SOUND~", "Global"))
		else:
			set_value("~SOUND~", "Global", 50 )
		if get_value("~SOUND~", "SFX") != null:
			set_value("~SOUND~", "SFX", get_value("~SOUND~", "SFX"))
		else:
			set_value("~SOUND~", "SFX", 50 )
		if get_value("~SOUND~", "Voice") != null:
			set_value("~SOUND~", "Voice", get_value("~SOUND~", "Voice"))
		else:
			set_value("~SOUND~", "Voice", 50 )
		if get_value("~SOUND~", "Music") != null:
			set_value("~SOUND~", "Music", get_value("~SOUND~", "Music"))
		else:
			set_value("~SOUND~", "Music", 50 )
		if get_value("~SOUND~", "Speed") != null:
			set_value("~SOUND~", "Speed", get_value("~SOUND~", "Speed"))
		else:
			set_value("~SOUND~", "Speed", 100 )
		if get_value("~SOUND~", "Overdrum") != null:
			set_value("~SOUND~", "Overdrum", get_value("~SOUND~", "Overdrum"))
		else:
			set_value("~SOUND~", "Overdrum", false)
		if get_value("~GRAPHICS~", "VSYNC") != null:
			set_value("~GRAPHICS~", "VSYNC", get_value("~GRAPHICS~", "VSYNC"))
		else:
			set_value("~GRAPHICS~", "VSYNC", true)
		if get_value("~GRAPHICS~", "CRT") != null:
			set_value("~GRAPHICS~", "CRT", get_value("~GRAPHICS~", "CRT"))
		else:
			set_value("~GRAPHICS~", "CRT", false)
		if get_value("~GRAPHICS~", "Curvature") != null:
			set_value("~GRAPHICS~", "Curvature", get_value("~GRAPHICS~", "Curvature"))
		else:
			set_value("~GRAPHICS~", "Curvature", 7.0)
		if get_value("~GRAPHICS~", "Vingette multiplyer") != null:
			set_value("~GRAPHICS~", "Vingette multiplyer", get_value("~GRAPHICS~", "Vingette multiplyer"))
		else:
			set_value("~GRAPHICS~", "Vingette multiplyer", 0.25)
		if get_value("~GRAPHICS~", "Blur") != null:
			set_value("~GRAPHICS~", "Blur", get_value("~GRAPHICS~", "Blur"))
		else:
			set_value("~GRAPHICS~", "Blur", 0.3)
		if get_value("~GRAPHICS~", "Scanlines") != null:
			set_value("~GRAPHICS~", "Scanlines", get_value("~GRAPHICS~", "Scanlines"))
		else:
			set_value("~GRAPHICS~", "Scanlines", 0.1)
		if get_value("~GAMEPLAY~", "Debug") != null:
			set_value("~GAMEPLAY~", "Debug", get_value("~GAMEPLAY~", "Debug"))
		else:
			set_value("~GAMEPLAY~", "Debug", false)
		if get_value("~AKSOBIT~", "ULTRAKILL") != null:
			set_value("~AKSOBIT~", "ULTRAKILL", get_value("~AKSOBIT~", "ULTRAKILL"))
		else:
			set_value("~AKSOBIT~", "ULTRAKILL", false)
		if get_value("~AKSOBIT~", "HENT") != null:
			set_value("~AKSOBIT~", "HENT", get_value("~AKSOBIT~", "HENT"))
		else:
			set_value("~AKSOBIT~", "HENT", false)
		if get_value("~AKSOBIT~", "COOL_GAMES") != null:
			set_value("~AKSOBIT~", "COOL_GAMES", get_value("~AKSOBIT~", "COOL_GAMES"))
		else:
			set_value("~AKSOBIT~", "COOL_GAMES", false)
		if get_value("~AKSOBIT~", "Started") != null:
			set_value("~AKSOBIT~", "Started", get_value("~AKSOBIT~", "Started"))
		else:
			set_value("~AKSOBIT~", "Started", false)
	set_value("~SYSTEM~", "Version", Version)

func get_value(section, key):
	return config.get_value(section, key)

func set_value(section, key, value):
	config.set_value(section, key, value)
	config.save(path)
