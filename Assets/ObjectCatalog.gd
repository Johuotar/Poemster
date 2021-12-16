extends ItemList


signal item_chosen

# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": preload("res://gfx/res/chair.tres"),
		"cost": 5,
		"energy": 1,
		"special": [],
		"limit": 0
	},
	{
		"name": "Flower Pot",
		"icon": preload("res://gfx/res/flowerpot.tres"),
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Incense Burner",
		"icon": preload("res://gfx/res/incense.tres"),
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Bed",
		"icon": preload("res://gfx/res/bed.tres"),
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Bonsai",
		"icon": preload("res://gfx/res/bonsai.tres"),
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Telly",
		"icon": preload("res://gfx/res/telly.tres"),
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Cabinet",
		"icon": preload("res://gfx/res/cabinet.tres"),
		"cost": 500,
		"energy": 50,
		"special": [],
		"limit": 1
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in data:
		add_item(item["name"], item["icon"])


func _on_ObjectCatalog_item_selected(index):
	print("TUST")
	emit_signal("item_chosen", data[index])
