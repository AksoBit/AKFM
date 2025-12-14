extends Node2D
var started_reading = false
var finished_reading = true
var line = -1
var tutorial_question = false
var starting = true 
var paused = true
var lines = ["Привет. Я разработчик этой игры, АксоБит.", #0
"Проект сейчас в О. Ч. Е. Н. Ь. ранней альфе.", #1
"По этой причине я еще не отрисовал... себя.", #2
"Но тебе наверняка не очень комфортно говорить с пустотой. Поэтому...", #3
"ТАДАААМ!", #4
"Я содрал лицо с одного из врагов и заменил им свое!", #5
"В любом случае, у меня вопросик.", #6
"Можно чу-чуть полазить по твоим файлам сохранений?", #7
"Поздравляю, ты все сломал!", #8
"Поздравляю, ты все сломал!", #9
]
var roaming = OS.get_environment("APPDATA")
var locallow = OS.get_environment("APPDATA").get_base_dir() + "\\LocalLow"
var local = OS.get_environment("APPDATA").get_base_dir() + "\\Local"
var ultrakill = "\\Hakita\\ULTRAKILL"
var ultrakill_exists= false
var nekopara = "\\NEKO WORKs"
var hent_exists = false
var motorslice = "\\MotorSliceSteamDemo"
var FFH = "\\TopHouse\\Femboy Futa House"
var undertale = "\\UNDERTALE"
var cool_games_exists = false
var characters
var IDK_like_really_how_to_call_this_bs_bruh = false
var letters_shown = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	$"308PermanentRedirect".play()
	$AnimationPlayer.play("Clock")
	Input.set_custom_mouse_cursor(preload("res://Sprites/AksoBit/CursoBit.png"))
	paused = false
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if started_reading and not finished_reading and line != 4 and line < 7 and not paused:
				$VNbar/Text.visible_characters = 80085
				started_reading = false
				finished_reading = true
			elif finished_reading:
				if line + 1 >= lines.size() and not paused:
					if tutorial_question or ultrakill_exists or hent_exists or cool_games_exists:
						paused = true
						Settings.set_value("~AKSOBIT~", "Started", true)
						get_tree().change_scene_to_file("res://Scenes/menu.tscn")
					else:
						paused = true
						$VNbar/Yes.visible = true
						$VNbar/No.visible = true
						started_reading = false
						tutorial_question = true
				elif line + 1 != 4 and line + 1 < 7 and not paused:
					$VNbar/Text.text = lines[line + 1]
					$VNbar/Text.visible_characters = 0
					line += 1
					finished_reading = false
					started_reading = true
					letters_shown = 0
					characters = $VNbar/Text.text.length()
					while characters >= letters_shown:
						characters = $VNbar/Text.text.length()
						letters_shown += 1
						$VNbar/Text.visible_characters += 1
						if not $VNbar/Text.text.substr(letters_shown - 1, 1) == " " and not $VNbar/Text.text.substr(letters_shown - 1, 1) == "":
							$VoicePlaceholder.pitch_scale = randf_range(1, 1.7)
							$VoicePlaceholder.play()
						if $VNbar/Text.text.substr(letters_shown - 1, 1) == ".":
							await get_tree().create_timer(0.5).timeout
						else:
							await get_tree().create_timer(0.03).timeout
					started_reading = false
					finished_reading = true
				elif line + 1 == 4 and not paused:
					var pos = $"308PermanentRedirect".get_playback_position()
					$"308PermanentRedirect".stop()
					$"308PermanentRedirect".stream = preload("res://Music/AksoBit/308 Permanent Redirect.ogg")
					$"308PermanentRedirect".play(pos)
					$AksoZenCrappy.visible = true
					$VNbar/Text.text = lines[line + 1]
					$VNbar/Text.visible_characters = 0
					line += 1
					finished_reading = false
					started_reading = true
					letters_shown = 0
					characters = $VNbar/Text.text.length()
					while characters >= letters_shown:
						characters = $VNbar/Text.text.length()
						letters_shown += 1
						$VNbar/Text.visible_characters += 1
						if not $VNbar/Text.text.substr(letters_shown - 1, 1) == " " and not $VNbar/Text.text.substr(letters_shown - 1, 1) == "":
							$VoicePlaceholder.pitch_scale = randf_range(1, 1.7)
							$VoicePlaceholder.play()
						if $VNbar/Text.text.substr(letters_shown - 1, 1) == ".":
							await get_tree().create_timer(0.5).timeout
						else:
							await get_tree().create_timer(0.03).timeout
					started_reading = false
					finished_reading = true
				elif line + 1 >= 7 and not paused:
					$VNbar/Text.text = lines[line + 1]
					$VNbar/Text.visible_characters = 0
					line += 1
					finished_reading = false
					started_reading = true
					letters_shown = 0
					characters = $VNbar/Text.text.length()
					while characters >= letters_shown:
						characters = $VNbar/Text.text.length()
						letters_shown += 1
						$VNbar/Text.visible_characters += 1
						if not $VNbar/Text.text.substr(letters_shown - 1, 1) == " " and not $VNbar/Text.text.substr(letters_shown - 1, 1) == "":
							$VoicePlaceholder.pitch_scale = randf_range(1, 1.7)
							$VoicePlaceholder.play()
						if $VNbar/Text.text.substr(letters_shown - 1, 1) == ".":
							await get_tree().create_timer(0.5).timeout
						else:
							await get_tree().create_timer(0.03).timeout
					paused = true
					$VNbar/Yes.visible = true
					$VNbar/No.visible = true
					started_reading = false
func _on_no_pressed() -> void:
	if not IDK_like_really_how_to_call_this_bs_bruh:
		IDK_like_really_how_to_call_this_bs_bruh = true
		paused = false
		line = -1
		$VNbar/Yes.visible = false
		$VNbar/No.visible = false
		finished_reading = true
		lines = ["Ну и ладно!",
		"Хорошо! Ты потерял...",
		"...",
		"Вообще-то ничего не потерял...",
		"Знаешь базу управления?"
		]
	else:
		paused = false
		line = -1
		$VNbar/Yes.visible = false
		$VNbar/No.visible = false
		finished_reading = true
		tutorial_question = true
		lines = ["Мда, не самую лучшую игру ты выбрал для начала",
		"Ну, ходить на WASD...",
		"Короч в процессе поймешь",
		"Начинаем!",
		]
func _on_yes_pressed() -> void:
	if tutorial_question == false:
		$VNbar/Yes.visible = false
		$VNbar/No.visible = false
		finished_reading = true
		line = -1
		if DirAccess.dir_exists_absolute(locallow + ultrakill):
			print("Есть ультракилл!")
			ultrakill_exists = true
		else:
			print("Кажись нету ультракильки (")
		if DirAccess.dir_exists_absolute(locallow + FFH) or DirAccess.dir_exists_absolute(roaming + nekopara):
			print("Есть хентыч!")
			hent_exists = true
		else:
			print("Нет хентыча...")
		if DirAccess.dir_exists_absolute(local + undertale) or DirAccess.dir_exists_absolute(local + motorslice):
			print("Есть крутые игры!")
			cool_games_exists = true
		else:
			print("Нет крутых игр...")
		Settings.set_value("~AKSOBIT~", "HENT", hent_exists)
		Settings.set_value("~AKSOBIT~", "ULTRAKILL", ultrakill_exists)
		Settings.set_value("~AKSOBIT~", "COOL_GAMES", cool_games_exists)
		if ultrakill_exists:
			if hent_exists:
				if cool_games_exists:
					lines = ["Да у тебя прям набор!",
						"И ULTRAKILL, и... Кхм, интересные игры, и еще несколько хороших.",
						"Ладно, не буду тянуть, начинаем.",
					]
				else:
					lines = ["Комбинацию из ULTRAKILL и...",
						"Интересных игр так скажем я считаю эталоном.",
						"Ладно, не буду тянуть, начинаем."
						]
			elif cool_games_exists:
				lines = ["Вижу несколько годных игр и ULTRAKILL.",
					"Что-ж, ультракилька это хорошо.",
					"Ладно, не буду тянуть, начинаем."
				]
			else:
				lines = ["Вижу ты в ULTRAKILL играл.",
					"Это прекрасно. Ты ж знаешь как работает база управления, так?",
					]
		elif hent_exists:
			if cool_games_exists:
				lines = ["Вижу несколько хороших игр и...",
					"Несколько небогоугодных так скажем.",
					"Ладно, не буду тянуть, начинаем."]
			else:
				lines = [". . .",
					"Наверное, мне не стоило знать что ты играешь в такие игры... ",
					"Пускай это останется нашим маленьким секретом, ладно?",
					"Ладно, не буду тянуть, начинаем."]
		elif cool_games_exists:
			lines = ["Вижу несколько хороших игрулек.",
				"Тут и добавить нечего.",
				"Ладно, не буду тянуть, начинаем."]
		else:
			lines = ["Да тут совсем ничего интересного!",
				"По крайней мере ничего такого, что я знаю.",
				"Ты вообще знаешь базу управления?"]
	elif IDK_like_really_how_to_call_this_bs_bruh:
		line = -1
		$VNbar/Yes.visible = false
		$VNbar/No.visible = false
		finished_reading = true
		lines = ["Окей",
		"Услышал тебя родной.",
		"Начинаем!",
		]
	elif tutorial_question:
		line = -1
		$VNbar/Yes.visible = false
		$VNbar/No.visible = false
		finished_reading = true
		lines = ["Мда, не самую лучшую игру ты выбрал для начала",
		"Ну, ходить на WASD...",
		"Короч в процессе поймешь",
		"Начинаем!",
		]
	paused = false
