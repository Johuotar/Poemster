extends Node2D


signal set_scene

# Main Game Controller
onready var home_scene = preload("res://Assets/Home.tscn")
onready var main_menu_scene = preload("res://Scenes/MainMenu.tscn")
onready var credits_scene = preload("res://Scenes/Credits.tscn")

func set_scene(new_scene: String):
	for child in get_children():
		child.queue_free()
	if new_scene == "home":
		add_child(home_scene.instance())
	if new_scene == "credits":
		add_child(credits_scene.instance())
	if new_scene == "main_menu":
		add_child(main_menu_scene.instance())

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scene("main_menu")


func _on_Game_set_scene(new_scene):
	set_scene(new_scene)
