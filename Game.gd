extends Node2D


signal set_scene

# Main Game Controller
onready var home_scene = preload("res://Assets/Home.tscn")
onready var main_menu_scene = preload("res://Scenes/MainMenu.tscn")
onready var credits_scene = preload("res://Scenes/Credits.tscn")
onready var audio_scene = preload("res://Scenes/AudioPlayer.tscn")
var audioplayer


func play_music(song):
	for song in audioplayer.get_children():
		song.stop()
	audioplayer.get_node(song).play()

func set_scene(new_scene: String):
	for child in get_children():
		if child.get_name() != "AudioPlayer":
			child.queue_free()
	add_child(audio_scene.instance())
	if new_scene == "home":
		add_child(home_scene.instance())
		play_music("GentleWinds")
	if new_scene == "credits":
		add_child(credits_scene.instance())
		play_music("Credits")
	if new_scene == "main_menu":
		add_child(main_menu_scene.instance())


func _ready():
	audioplayer = get_node("AudioPlayer")
	set_scene("main_menu")


func _on_Game_set_scene(new_scene):
	set_scene(new_scene)
