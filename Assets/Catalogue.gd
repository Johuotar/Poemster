extends Control


signal item_chosen
onready var item_list = get_node("ObjectCatalog")

# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": preload("res://gfx/res/chair.tres"),
		"cost": 100,
		"energy": 2,
		"profit": 0,
		"special": [],
		"limit": 8
	},
	{
		"name": "Flower Pot",
		"icon": preload("res://gfx/res/flowerpot.tres"),
		"cost": 50,
		"energy": 1,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Incense Burner",
		"icon": preload("res://gfx/res/incense.tres"),
		"cost": 150,
		"energy": 5,
		"profit": 0,
		"special": [],
		"limit": 4
	},
	{
		"name": "Bed",
		"icon": preload("res://gfx/res/bed.tres"),
		"cost": 1000,
		"energy": 4,
		"profit": 0,
		"special": [],
		"limit": 4
	},
	{
		"name": "BONZAJ",
		"icon": preload("res://gfx/res/bonsai.tres"),
		"cost": 100,
		"energy": 5,
		"profit": 0,
		"special": ["HAJKU"],
		"limit": 1
	},
	{
		"name": "Telly",
		"icon": preload("res://gfx/res/telly.tres"),
		"cost": 1000,
		"profit": 0,
		"energy": 4,
		"special": ["Modern"],
		"limit": 1
	},
	{
		"name": "Cabinet",
		"icon": preload("res://gfx/res/cabinet.tres"),
		"cost": 500,
		"profit": 0,
		"energy": 2,
		"special": [],
		"limit": 8
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in data:
		item_list.add_item("%s: %s cr + %s ENG %s" % [item["name"], str(item["cost"]), str(item["energy"]), item["special"]], item["icon"])


func _on_ObjectCatalog_item_selected(index):
	emit_signal("item_chosen", data[index])
	visible = false
