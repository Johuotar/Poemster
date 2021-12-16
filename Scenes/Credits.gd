extends Control

export (NodePath) onready var carousel = get_node(carousel) as Control
var cards = []
var active_card
var card_index = 0
export (Curve) var cardSpeedCurve
var moveAmount
var viewportX = OS.window_size.x
var cardStartX = null

func _ready():
	for card in carousel.get_children():
		cards.append(card)
		cardStartX = card.rect_position.x
	active_card = cards[card_index]

func _process(delta):
		moveAmount = abs(viewportX/2 - active_card.rect_position.x - active_card.rect_size.x*active_card.rect_scale.x/2)
		moveAmount = moveAmount / 20
		if moveAmount < 5:
			moveAmount = 0.5
		if active_card.rect_position.x > viewportX + 1:
			active_card.rect_position.x = cardStartX
			 # TODO: FIX: cards dont stay in sync and will begin overlapping
			if !card_index + 1 == cards.size():
				card_index += 1
			else:
				card_index = 0
			active_card = cards[card_index]
		active_card.rect_position.x += moveAmount
		


func _on_ExitBtn_pressed():#TODO Exit credits into main menu or straight into gameplay
	print("Exiting credits not implemented. Enjoy watching them!")
