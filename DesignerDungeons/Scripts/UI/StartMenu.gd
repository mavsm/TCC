extends CanvasLayer



func _on_Button_pressed():
	Transition.goto_scene("res://Testing.tscn")
	$VBoxContainer.hide()