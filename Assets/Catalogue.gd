extends Control


signal item_chosen
onready var item_list = get_node("ObjectCatalog")

# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": preload("res://gfx/res/chair.tres"),
		"cost": 100,
		"energy": 1,
		"profit": 0,
		"special": [],
		"limit": 8,
		"energy_cap": 25,
		"tooltip": "Chairs are good for sitting, helping you conserve your energy."
	},
	{
		"name": "Flower Pot",
		"icon": preload("res://gfx/res/flowerpot.tres"),
		"cost": 50,
		"energy": 1,
		"profit": 0,
		"special": [],
		"limit": null,
		"energy_cap": 0,
		"tooltip": "Flowers are relaxing! Nature is the true medicine."
	},
	{
		"name": "Incense Burner",
		"icon": preload("res://gfx/res/incense.tres"),
		"cost": 150,
		"energy": 2,
		"profit": 0,
		"special": [],
		"limit": 4,
		"energy_cap": 0,
		"tooltip": "I can burn mixtures here for increased rejuvenation!"
	},
	{
		"name": "Bed",
		"icon": preload("res://gfx/res/bed.tres"),
		"cost": 1000,
		"energy": 4,
		"profit": 0,
		"special": [],
		"limit": 4,
		"energy_cap": 100,
		"tooltip": "A bed is really a necessity. Huge increase in energy!"
	},
	{
		"name": "BONZAJ",
		"icon": preload("res://gfx/res/bonsai.tres"),
		"cost": 100,
		"energy": 2,
		"profit": 0,
		"special": ["HAJKU"],
		"limit": 1,
		"energy_cap": 0,
		"tooltip": "Pruning BONZAJ is extremely relaxing,\nand also inspires me to write HAJKUS!"
	},
	{
		"name": "Telly",
		"icon": preload("res://gfx/res/telly.tres"),
		"cost": 1000,
		"profit": 0,
		"energy": 1,
		"special": ["Modern"],
		"limit": 1,
		"energy_cap": 10,
		"tooltip": "The Telly brings modernity to my cabin!\nModern lyricists also inspire me to write in a modern fashion."
	},
	{
		"name": "Cabinet",
		"icon": preload("res://gfx/res/cabinet.tres"),
		"cost": 500,
		"profit": 0,
		"energy": 0,
		"special": [],
		"limit": 8,
		"energy_cap": 250,
		"tooltip": "Cabinets help me store stuff, helping me conserve energy."
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for item in data:
		item_list.add_item("%s: %s cr" % [item["name"], str(item["cost"])], item["icon"])
		var tooltip_str =  "%s\nENG+ %s - CAP+ %s - Specials: %s" % [item["tooltip"], str(item["energy"]), str(item["energy_cap"]), item["special"]]
		if item["limit"] != null:
			tooltip_str += "| LIMIT %s" % str(item["limit"])
		item_list.set_item_tooltip(i, tooltip_str)
		i += 1


func _on_ObjectCatalog_item_selected(index):
	emit_signal("item_chosen", data[index])
	visible = false
