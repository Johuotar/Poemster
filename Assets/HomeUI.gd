extends Control


signal dismissed



func _on_Dismiss_pressed():
	emit_signal("dismissed")
