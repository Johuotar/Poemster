extends Node2D


signal set_scene

# Main Game Controller
onready var home_scene = preload("res://Assets/Home.tscn")


func set_scene(new_scene: String):
	for child in get_children():
		child.queue_free()
	if new_scene == "home":
		add_child(home_scene.instance())

# Called when the node enters the scene tree for the first time.
func _ready():
	set_scene("home")


func _on_Game_set_scene(new_scene):
	set_scene(new_scene)
