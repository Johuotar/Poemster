extends Control


# Poem Writing Class Object
signal poem_complete
signal typed


onready var instructions = get_node("Instructions")
onready var text_edit = get_node("TextEdit")
onready var warnings = get_node("Warnings")
onready var success_display = get_node("Success")
# Rules for passing poem
var lines_rule = 5
var words_per_line = [5, 5, 5, 5, 5]
var expression_rule = null  # Special regexp rule (if regexp possible)
var letters_rule = {'y': 15}  # amount of specific letter to find in text

# Special rules
var available_special_rules = []
var used_special_rule = null
var modern_length = 0

# Other params
var energy = 10  # Can type as long as there is energy
var poem_profit = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# Demo rules generation
	_generate_rules()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if energy > 0:
		text_edit.readonly = false
		warnings.text = ""
	else:
		text_edit.readonly = true
		warnings.text = "Out of energy!"
		
func _generate_rules():
	# Generate random rules for poem, and generate instructions for them
	# TODO: Scaling with difficulty
	# TODO: Special rules overwriting all generation!
	randomize()
	lines_rule = randi() % 10
	if lines_rule < 3:
		lines_rule = 3
		
	# Determine if we have available special rule, and if so, check if one is needed
	if randi() % 100 > 50:
		# Use Special rule
		if len(available_special_rules) > 0:
			var random_rule = 0
			if len(available_special_rules) > 1:
				random_rule = rand_range(0, len(available_special_rules) - 1)
			if available_special_rules[random_rule] == "HAJKU":
				# Haiku generation
				used_special_rule = "HAJKU"
				words_per_line = ["3", "4", "3"]
				lines_rule = 3
				instructions.text = "Write a HAJKU!\nThat is, write 3 words on first line,\n4 words on second,\nand 3 words on last one."
			elif available_special_rules[random_rule] == "modern":
				# Just ask for poem length, 50-500 characters
				used_special_rule = "Modern"
				modern_length = 50 + randi() % 450
				instructions.text = "Write a MödéRN PÖEm:\nThe poem must be atleast %s characters in length.\nThere are no other rules!" % str(modern_length)
	else:
	
		# TODO: Word end rhyming.
		# TODO: Differing amounts of words per line
		var line_words_num = randi() % 10
		if line_words_num < 3:
			line_words_num = 3
		words_per_line = []
		for i in range(0, lines_rule):
			words_per_line.append(line_words_num)
			
		var available_letters = [
			"a", "b", "c", "d", "e", "f",
			"g", "h", "i", "j", "k", "l",
			"m", "n", "o", "p", "q", "r",
			"s", "t", "u", "v", "w", "x", "y", "z"
		]
		var use_letters = randi() % 3
		letters_rule = {}
		for i in range(0, use_letters):
			letters_rule[available_letters[rand_range(1, len(available_letters))]] = randi() % 5
			
		# Simple income generation algorithm!
		poem_profit = floor((1 + line_words_num + len(letters_rule) + lines_rule) / 2)
			
		# TODO: It's possible that the rules generation generates unsolvable poems right now. Solved by ripping paper of course!
		instructions.text = "Write a %s line poem,\nwith %s words on each line,\nhaving %s letters in minimum.\nExpect profit to be %s credits once on the market!" % [str(lines_rule), str(line_words_num), str(letters_rule), str(poem_profit)]
		used_special_rule = null
		
func _check_completion():
	# Check that Poem is complete as necessary
	var success = true
	# There has to be some text!
	if len(text_edit.text) > 0:
		# Lines Amount Rule
		if used_special_rule in [null, "HAJKU"]:
			# REMEMBER: HAJKU uses same structure rules as normal poems
			if lines_rule > 0 and text_edit.get_line_count() < lines_rule:
				success = false
				
			# Words Per Line Rule
			if len(words_per_line) > 0:
				for i in range(0, len(words_per_line)):
					var line_text = text_edit.get_line(i)
					var line_text_words = line_text.split(" ")
					if len(line_text_words) != words_per_line[i]:
						success = false
						
			# Found Letters Rule
			if len(letters_rule) > 0:
				var found_keys = {}
				for key in letters_rule.keys():
					found_keys[key] = 0
					for character in text_edit.text:
						if character.to_lower() == key:
							found_keys[key] += 1
				# Check that we have enough letters of each type
				for key in letters_rule.keys():
					if found_keys[key] < letters_rule[key]:
						success = false
		elif used_special_rule == "Modern":
			if len(text_edit.text) < modern_length:
				success = false
	else:
		success = false
	if success:
		success_display.text = "Success!"
		success_display.modulate = Color(0, 1, 0)
	else:
		success_display.text = "Failure!"
		success_display.modulate = Color(1, 0, 0)
	if success:
		# Empty canvas!
		text_edit.text = ""
		_generate_rules()
		emit_signal("poem_complete", poem_profit)


func _on_TextEdit_text_changed():
	emit_signal("typed")


func _on_Submit_pressed():
	_check_completion()


func _on_Rip_pressed():
	# RIP! Text is emptied and new rules will be generated
	text_edit.text = ""
	_generate_rules()
