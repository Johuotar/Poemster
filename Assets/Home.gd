extends TileMap


signal poem_complete

# Declare member variables here. Examples:
var money = 0
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

# Poem Editor
onready var poem = get_node("Poem")


func _update_ui():
	ui_money.text = "Money: %s" % str(money)
	ui_energy.text = "Energy: %s" % str(energy)
	ui_energy_inc.text = "Regen: %s" % str(energy_increase)
	ui_profit.text = "Profit: %s" % str(profit)
	ui_specials.text = "Specials: -"  # TODO:
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	second_timer += 1 * delta
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


func _on_Poem_typed():
	energy -= 1
	poem.energy = energy
	_update_ui()
