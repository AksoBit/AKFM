extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(load("res://Sprites/AksoBit/Pen.png"), Input.CURSOR_ARROW, Vector2(0, 332))
	var date = "{day}/{month}/{year}".format(Time.get_datetime_dict_from_system())
	$"../Label".text = str("
Данная игра может содержать жестокие сцены, несмешные шутки, баги, кошек и отсылки на... А нет, абсолютно все персонажи являются вымышленными, все совпадения случайны. Еще игра не несет цели оскорбить или обидеть, вызвать хаос и разрушение. А сейчас к серьезным вещам:

Данная игра содержит МИГАЮЩИЕ ОГОНЬКИ, если у вас была или есть эпилепсия... Лучше не играть. Поверьте мне, эта игра точно не стоит того.

Данная игра еще не закончена и содержит баги. Почти, если не все, будет переработано и перекроено.

Если у вас есть предложения, если вы нашли баг или если вам просто скучно, напишите мне в ТГ @NekoAxolotl или на почту aksozonfm@gmail.com
К слову, для меня нет непрошенных советов, буду рад любой критике или помощи, будь то спрайты, музыка или код.


ㅤㅤ                                Подпись ", OS.get_environment("USERNAME"), ":")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
