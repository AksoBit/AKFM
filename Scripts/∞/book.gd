extends Sprite2D
var page = [] #Эта хрень называется массив.
#Это я из будущего. Нахрена ты сказал это? Все И ТАК ЗНАЮТ что это называется массив.
var PageNow = 0
func _ready() -> void:
	for i in range(411): 
		var page_text = BookGen() 
		page.append(page_text) #Добавляет в массив страницу
	PageNow = 1
	$LeftPage.text = str(page[PageNow])
	$RightPage.text = str(page[PageNow+1])
func BookGen(): #Эта функция генерирует страницу
	var result = ""
	var characters = "абвгдеёжзийклмнопрстуфхцчшщъыьэюя .,"
	for y in range(1323):
		var random_index = randi() % characters.length()
		result += characters[random_index]
	return result

#Дальше ничего такого, перелистывание и крестик
func _on_button_3_button_down() -> void:
	if PageNow - 2 <= 0:
		return
	PageNow -= 2
	$LeftCounter.text = str(PageNow)
	$RightCounter.text = str(PageNow+1)
	$LeftPage.text = str(page[PageNow])
	$RightPage.text = str(page[PageNow+1])
func _on_button_2_button_down() -> void:
	if PageNow + 2 >= 410:
		return
	PageNow += 2
	$LeftCounter.text = str(PageNow)
	$RightCounter.text = str(PageNow+1)
	$LeftPage.text = str(page[PageNow])
	$RightPage.text = str(page[PageNow+1])


func _on_button_button_down() -> void:
	queue_free()
