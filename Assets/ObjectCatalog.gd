extends ItemList


signal item_chosen

# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": preload("res://gfx/res/chair.tres"),
		"cost": 100,
		"energy": 2,
		"special": [],
		"limit": 8
	},
	{
		"name": "Flower Pot",
		"icon": preload("res://gfx/res/flowerpot.tres"),
		"cost": 60,
		"energy": 1,
		"special": [],
		"limit": 0
	},
	{
		"name": "Incense Burner",
		"icon": preload("res://gfx/res/incense.tres"),
		"cost": 200,
		"energy": 2,
		"special": [],
		"limit": 0
	},
	{
		"name": "Bed",
		"icon": preload("res://gfx/res/bed.tres"),
		"cost": 1000,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "BONZAJ",
		"icon": preload("res://gfx/res/bonsai.tres"),
		"cost": 150,
		"energy": 2,
		"special": ["haiku"],  # Bonsai tree enables haikus
		"limit": 1
	},
	{
		"name": "Telly",
		"icon": preload("res://gfx/res/telly.tres"),
		"cost": 1000,
		"energy": 2,
		"special": ["modern"],  # Telly enables postmodern poetry
		"limit": 1
	},
	{
		"name": "Cabinet",
		"icon": preload("res://gfx/res/cabinet.tres"),
		"cost": 500,
		"energy": 4,
		"special": [],
		"limit": 1
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in data:
		add_item(item["name"], item["icon"])


func _on_ObjectCatalog_item_selected(index):
	emit_signal("item_chosen", data[index])
