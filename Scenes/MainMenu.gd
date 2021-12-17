extends Control
onready var game = get_parent()

func _on_StartBtn_pressed():
	game.set_scene("home")

func _on_Credits_pressed():
	game.set_scene("credits")
