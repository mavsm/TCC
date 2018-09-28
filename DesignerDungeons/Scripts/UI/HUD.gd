extends CanvasLayer

func _update_hp_bar(percentage):
	$MarginContainer/VBoxContainer/HBoxContainer/HP_bar.value = percentage

func _update_floor_depth():
	$MarginContainer/VBoxContainer/FloorDepth.text = str(Global.Floor_depth)