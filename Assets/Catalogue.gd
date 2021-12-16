extends Control


signal item_chosen
onready var item_list = get_node("ObjectCatalog")

# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": preload("res://gfx/res/chair.tres"),
		"cost": 5,
		"energy": 1,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Flower Pot",
		"icon": preload("res://gfx/res/flowerpot.tres"),
		"cost": 100,
		"energy": 5,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Incense Burner",
		"icon": preload("res://gfx/res/incense.tres"),
		"cost": 100,
		"energy": 5,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Bed",
		"icon": preload("res://gfx/res/bed.tres"),
		"cost": 100,
		"energy": 5,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Bonsai",
		"icon": preload("res://gfx/res/bonsai.tres"),
		"cost": 100,
		"energy": 5,
		"profit": 0,
		"special": [],
		"limit": 0
	},
	{
		"name": "Telly",
		"icon": preload("res://gfx/res/telly.tres"),
		"cost": 100,
		"profit": 0,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Cabinet",
		"icon": preload("res://gfx/res/cabinet.tres"),
		"cost": 500,
		"profit": 0,
		"energy": 50,
		"special": [],
		"limit": 1
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in data:
		item_list.add_item("%s: %s cr + %s ENG" % [item["name"], str(item["cost"]), str(item["energy"])], item["icon"])


func _on_ObjectCatalog_item_selected(index):
	emit_signal("item_chosen", data[index])
	visible = false
