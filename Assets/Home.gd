extends TileMap


signal poem_complete

# Declare member variables here. Examples:
var money = 1000
var energy = 10
var profit = 0
var energy_increase = 1
var special_rules = []
var second_timer = 0.0

# UI Elements
onready var ui_money = get_node("HomeUI/Money")
onready var ui_energy = get_node("HomeUI/Energy")
onready var ui_energy_inc = get_node("HomeUI/EnergyInc")
onready var ui_profit = get_node("HomeUI/Profit")
onready var ui_specials = get_node("HomeUI/Special")
onready var ui_story = get_node("HomeUI/StoryBG")
onready var ui_story_text = get_node("HomeUI/StoryBG/StoryText")
onready var ui_dismiss = get_node("HomeUI/StoryBG/Dismiss")

# Story things
var story_progression = 0
var story_texts = {
	0: "What a cozy morning.\nLet's make the most of it!",  # TODO: Add tutorial texts
	5: "How riveting! I am enchanted."
}
var story_dismissed = false
var chosen_item = null
var chosen_item_sprite = null

# Poem Editor
onready var poem = get_node("Poem")

# Catalogue
onready var ghost = get_node("Ghost")
onready var catalog = get_node("Catalogue")
onready var buyable = preload("res://Assets/HomeObject.tscn")
onready var furniture = get_node("Furniture")


func _ready():
	ui_story_text.text = story_texts[story_progression]


func _update_ui():
	ui_money.text = "Money: %s" % str(money)
	ui_energy.text = "Energy: %s" % str(energy)
	ui_energy_inc.text = "Regen: %s" % str(energy_increase)
	ui_profit.text = "Profit: %s" % str(profit)
	ui_specials.text = "Specials: -"  # TODO:


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_esc"):
		get_parent().set_scene("main_menu")
	ghost.transform.origin = get_global_mouse_position()
	if ghost.modulate.g < 1.0:
		ghost.modulate.g += 1 * delta
	if ghost.modulate.b < 1.0:
		ghost.modulate.b += 1 * delta
	second_timer += 1 * delta
	if chosen_item:
		# Draw "ghost" of selected item if possible
		if chosen_item.get("icon"):
			if not chosen_item_sprite:
				
				chosen_item_sprite = chosen_item["icon"]
				ghost.texture = chosen_item_sprite
				ghost.visible = true
	# Increase resources each second
	if second_timer > 1.0:
		second_timer = 0.0
		energy += energy_increase
		money += profit
		_update_ui()
		poem.energy = energy


func _on_Poem_poem_complete(poem_profit):
	# Increase profit
	profit += poem_profit
	
	# Update story progression
	story_progression += 1
	if story_texts.get(story_progression):
		if story_dismissed:
			story_dismissed = false
			ui_story.visible = true
			ui_story_text.text = story_texts[story_progression]


func buy_home_object(object):
	# Adds a new home object, if one stored from catalogue and updates stats based on that
	pass


func _on_Poem_typed():
	energy -= 1
	poem.energy = energy
	_update_ui()


func _on_HomeUI_dismissed():
	story_dismissed = true
	ui_story.visible = false


func _on_Button_pressed():
	if poem.visible:
		poem.visible = false
	else:
		poem.visible = true


func _on_Catalogue_item_chosen(item_data):
	chosen_item = item_data
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	ghost.texture = item_data["icon"]
	ghost.visible = true


func _on_Button2_pressed():
	# Toggle Catalogue visible
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	chosen_item = false
	ghost.visible = false
	if catalog.visible:
		catalog.visible = false
	else:
		catalog.visible = true


func _on_BuildArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("buy_item"):
		# BUy an item from catalogue
		if chosen_item:
			if money >= chosen_item["cost"]:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				money -= chosen_item["cost"]
				var new_home_object = buyable.instance()
				new_home_object.texture = chosen_item["icon"]
				profit += chosen_item["profit"]
				energy_increase += chosen_item["energy"]
				# TODO: Handle specials
				new_home_object.transform.origin = get_global_mouse_position()
				furniture.add_child(new_home_object)
				ghost.visible = false
				chosen_item = null
			else:
				ghost.modulate.g = 0.0
				ghost.modulate.b = 0.0
