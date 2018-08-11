extends CanvasLayer

func _update_hp_bar(percentage):
	$MarginContainer/HBoxContainer/HP_bar.value = percentage
