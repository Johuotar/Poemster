extends ItemList


# Buyable object catalogue
onready var data = [
	{
		"name": "Chair",
		"icon": null,
		"cost": 5,
		"energy": 1,
		"special": [],
		"limit": 0
	},
	{
		"name": "Flower Pot",
		"icon": null,
		"cost": 100,
		"energy": 5,
		"special": [],
		"limit": 0
	},
	{
		"name": "Glass Statue",
		"icon": null,
		"cost": 500,
		"energy": 50,
		"special": [],
		"limit": 1
	},
]


# Called when the node enters the scene tree for the first time.
func _ready():
	for item in data:
		add_item(item["name"])


func _on_ObjectCatalog_item_selected(index):
	print(data[index])
	emit_signal("item_chosen", data[index])
