extends Panel
#Хааай~
#Это мой (почти) первый опыт с массивами
#Получился не самый красивый код, отчасти нерабочий
#Зато свой ^^
var Rows = []
var Multiplyers = []
var Colors = []
var OutlineColors = []
var IsArranging = false
var DidAnythingHappen = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Rows.resize(9)
	OutlineColors.resize(9)
	Colors.resize(9)
	Multiplyers.resize(9)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ClrTimer(Mult, RowText):
	await get_tree().create_timer(5).timeout
	for i in range(9):
		if Mult == Multiplyers[i] and RowText == Rows[i]:
			Rows[i] = null
			Colors[i] = null
			OutlineColors[i] = null
			Multiplyers[i] = null
			get_node("Row " + str(i + 1)).visible = false
			Aranged()
func update_text_panel(text, is_minus, text_color = Color.from_hsv(0.0, 0.0, 1.0, 1.0), outline = Color.from_rgba8(255, 255, 255, 255)):
	while IsArranging:
		await get_tree().process_frame
	text = str("-", text) if is_minus else str("+", text)
	var FreeRow = FindARow()
	for i in range(9):
		if Rows[i] == text:
			if Multiplyers[i] == null:
				Multiplyers[i] = str(" x", 2)
				get_node("Row " + str(i + 1)).visible = true
				get_node("Row " + str(i + 1)).label_settings.font_color = text_color
				get_node("Row " + str(i + 1)).label_settings.outline_color = outline
				get_node("Row " + str(i + 1)).text = str(Rows[i], Multiplyers[i])
				ClrTimer(Multiplyers[i], Rows[i])
				return
			else:
				var Multi = int(Multiplyers[i].substr(Multiplyers[i].length() - 1, 1))
				var MaybeMulty = (Multiplyers[i].substr(Multiplyers[i].length() - 2, 2)).is_valid_int()
				print(MaybeMulty)
				if MaybeMulty == true:
					Multi = int(Multiplyers[i].substr(Multiplyers[i].length() - 2, 2))
					MaybeMulty = (Multiplyers[i].substr(Multiplyers[i].length() - 3, 3)).is_valid_int()
					print(Multi)
					if MaybeMulty:
						Multiplyers[i] = str(" OVERFILL")
					else:
						Multiplyers[i] = str(" x", Multi +1)
				else:
					Multiplyers[i] = str(" x", Multi +1)
				get_node("Row " + str(i + 1)).label_settings.outline_color = outline
				get_node("Row " + str(i + 1)).visible = true
				get_node("Row " + str(i + 1)).label_settings.font_color = text_color
				get_node("Row " + str(i + 1)).text = str(Rows[i], Multiplyers[i])
				ClrTimer(Multiplyers[i], Rows[i])
				return
	size.y = 12 * (FreeRow + 1) + 5
	if FreeRow == -1:
		pass
	else:
		Colors[FreeRow] = text_color
		OutlineColors[FreeRow] = outline
		Rows[FreeRow] = text
		get_node("Row " + str(FreeRow + 1)).visible = true
		get_node("Row " + str(FreeRow + 1)).label_settings.font_color = text_color
		get_node("Row " + str(FreeRow + 1)).label_settings.outline_color = outline
		get_node("Row " + str(FreeRow + 1)).text = str(text)
		ClrTimer(Multiplyers[FreeRow], Rows[FreeRow])
func FindARow():
	for i in range(9):
		if Rows[i] == null:
			return i
	return -1

func Aranged():
	var Sorted = []
	var SortedM = []
	var SortedC = []
	var SortedOC = []
	IsArranging = true
	for i in range(9):
		if Rows[i] != null:
			Sorted.append(Rows[i])
			SortedM.append(Multiplyers[i])
			SortedC.append(Colors[i])
			SortedOC.append(OutlineColors[i])
	SortedOC.resize(9)
	SortedC.resize(9)
	Sorted.resize(9)
	SortedM.resize(9)
	Rows = Sorted
	Multiplyers = SortedM
	OutlineColors = SortedOC
	Colors = SortedC
	for i in range(9):
		if Rows[i] != null:
			get_node("Row " + str(i + 1)).visible = true
			if Multiplyers[i] != null:
				get_node("Row " + str(i + 1)).text = str(Rows[i], Multiplyers[i])
				
			else:
				get_node("Row " + str(i + 1)).text = str(Rows[i])
			get_node("Row " + str(i + 1)).label_settings.font_color = Colors[i]
			get_node("Row " + str(i + 1)).label_settings.outline_color = OutlineColors[i]
		else:
			get_node("Row " + str(i + 1)).visible = false
	if Rows[0] == null:
		size.y = 0
	else:
		size.y = 12 * (FindARow()) + 5
	IsArranging = false
