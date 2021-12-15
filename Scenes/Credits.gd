extends Control

export (NodePath) onready var carousel = get_node(carousel) as Control
export (NodePath) onready var cardTimer = get_node(cardTimer) as Timer
var cards = []
export (Curve) var cardSpeedCurve
var moveAmount
var viewportX = OS.window_size.x

func _ready():
	for card in carousel.get_children():
		cards.append(card)

func _process(delta):
	moveAmount = cardSpeedCurve.interpolate(cardTimer.time_left/10)
	for card in cards:
		if card.rect_position.x > viewportX + 1:
			card.rect_position.x = card.startXPos # TODO: FIX: cards dont stay in sync and will begin overlapping
		else:
			card.rect_position.x += moveAmount
		
