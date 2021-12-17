extends TileMap


signal poem_complete

# Declare member variables here. Examples:
var money = 50
var energy = 50
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
	0: "\nThis new cabin is thrilling.\nI can write so many poems here!\nTo write, I should press 'Begin Writing'.\nI will know what to write next!\nAlso, I need to take care of my energy.\nI can buy new stuff for that\nfrom the 'View Catalogue' button. :)",
	1: "What a cozy morning.\nLet's make the most of it!\nI should remember that special items\nlike the 'BONZAJ' and 'Telly'\nallow new poem types for me!"
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
var object_limits = {}


func _ready():
	ui_story_text.text = story_texts[story_progression]
	# Load object limits from Catalogue
	for item in catalog.data:
		object_limits[item["name"]] = item["limit"]

func _update_ui():
	ui_money.text = "Money: %s" % str(money)
	ui_energy.text = "Energy: %s" % str(energy)
	ui_energy_inc.text = "Regen: %s" % str(energy_increase)
	ui_profit.text = "Profit: %s" % str(profit)
	var special_rules_text = ""
	if len(special_rules) > 0:
		for i in range(0, len(special_rules)):
			special_rules_text += "\n%s" % special_rules[i]
	ui_specials.text = "Specials: %s" % special_rules_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
			poem.visible = false
			ui_story_text.text = story_texts[story_progression]

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
			if object_limits[chosen_item["name"]] == null or object_limits[chosen_item["name"]] > 0:
				if money >= chosen_item["cost"]:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					money -= chosen_item["cost"]
					var new_home_object = buyable.instance()
					new_home_object.texture = chosen_item["icon"]
					# Update profit margins and energy incomes if item such provides
					profit += chosen_item["profit"]
					energy_increase += chosen_item["energy"]
					if len(chosen_item["special"]) > 0:
						for spec in chosen_item["special"]:
							if not spec in special_rules:
								special_rules.append(spec)
					new_home_object.transform.origin = get_global_mouse_position()
					furniture.add_child(new_home_object)
					ghost.visible = false
					if object_limits[chosen_item["name"]] != null:
						object_limits[chosen_item["name"]] -= 1
					chosen_item = null
				else:
					ghost.modulate.g = 0.0
					ghost.modulate.b = 0.0
			else:
				ghost.modulate.g = 0.0
				ghost.modulate.b = 0.0
