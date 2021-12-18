extends TileMap


signal poem_complete

# Declare member variables here. Examples:
var money = 50
var energy = 50
var energy_cap = 100
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
	1: "What a cozy morning.\nLet's make the most of it!\nI feel like 'I can progress my story\nby writing more poems'!\nI don't know exactly what it means\nbut ket's do it!",
	2: "It's nice being able to write this much!\nI should remember that special items\nlike the 'BONZAJ' and 'Telly'\nallow new poem types for me!\nAnyway, I should keep writing.\nIt will progress my personal story!",
	3: "I started writing as a way to relax.\nBut people like accessing the mental spaces of others;\nMaybe that's why people like reading my writings!\nIt's not a matter of skill but sincerity.\nI should write more.",
	5: "The town just a short hike away is pretty nice.\nSmall, idyllic, somewhat agrarian - but the people are super nice.\nThe local librarian expressed interest in my writings, so I should keep writing!",
	7: "I met a local lord and his daughter riding\nfrom their mansion (that is probably\neven more secluded than my cabin). The Lord told me about problems in his\nhunting grounds - someone or something keeps hunting his game.\nHis daughter was enchanting.\nI should write.",
	10: "I saw a dove outside - I feel it is\na symbol of continued peace and quiet in these lands!\nI wish I can make it work here.\nI am inspired to write more.",
	15: "I received a letter from The Publisher's Association -\nThey want to print more of my poem collections!\nMy career is taking off really well.\nI think I can make it here!\nI should keep writing then.",
	18: "I met the lord's daughter today while out hiking -\nShe is pretty and kind and charming and whatmore.\nWe walked and talked for a distance, then parted with smiles.\nA fascination within me has awoked!\nI should write.",
	23: "I feel a bit depressed today.\nI went to the village early morning and I saw a killed deer\n - probably game from the local lord's grounds.\nIt wasn't a pretty sight and I contacted the local\nsheriff to clean up the mess.\nI might need to write. Thoughts are with death...",
	30: "This letter is amazing! I received\na letter from the local lord's daughter\nsaying she's read my poetry and enjoys it greatly.\nIs this the start of a great friendship?\nI want to write more!",
	33: "The local lord is spooked by something.\nI talked with him today in the local inn and he says\nthat what is killing his game is not natural.\nI am not inclined to believe, but have to say\nthat I like this particular local urban legend.\nI will tell you more about it later, for now, let's write!",
	37: "So the local legend is one of a\nthe 'grizzly man' - a grizzly bear that talks and walks and stalks on two feet.\nIt is noted for it's tendency to be messy;\nIt gores animals but doesn't eat them entirely\nand is apparently exceptionally clumsy in spite of it's speed (breaking stuff accidentally).\nScary, but urban legends inspire me to write!",
	42: "They finally found the culprit for the disappearing game.\nIt was a grizzly bear and particularly big one at that.\nSomehow, it eluded the lord's gamekeepers for weeks.\nNo one knows where it came from.\nThe lord's daughter sent me another letter,\nwanting to meet me. Delightful!\nI shall write in the meantime.",
	45: "I met the lord's daughter - Julia is her name, by the way.\nWe went to the forest and just kind of sat there\nand talked for a LOOONG while.\nI am infatuated with her! I must ask her out properly at some point.\nFor now, there is still more stuff to write.",
	50: "My poems are global stuff now - great!\nI am in love with Julia, and I think we have a great future.\nThe local people are great, and everything is actually roses and chocolate.\nI think I might have to retire to a 'boring' family life now! (STORY END)",
	250: "Okay I have written so much.\nI think I have more length in my poem bibliography\nthan there is length in Tolstoy's War And Peace.\nThat's great, really. Maybe I should retire?\n(STORY PROGRESS IS REALLY NOT CONTINUING ANYMORE)"
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
	poem.available_special_rules = special_rules

func _update_ui():
	ui_money.text = "Money: %s" % str(money)
	ui_energy.text = "Energy: %s/%s" % [str(energy), str(energy_cap)]
	ui_energy_inc.text = "Regen: %s" % str(energy_increase)
	ui_profit.text = "Profit: %s" % str(profit)
	var special_rules_text = ""
	if len(special_rules) > 0:
		for i in range(0, len(special_rules)):
			special_rules_text += "\n%s" % special_rules[i]
	ui_specials.text = "Specials: %s" % special_rules_text


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
		if energy > energy_cap:
			energy = energy_cap
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
					energy_cap += chosen_item["energy_cap"]
					if len(chosen_item["special"]) > 0:
						for spec in chosen_item["special"]:
							if not spec in special_rules:
								special_rules.append(spec)
					poem.available_special_rules = special_rules
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
