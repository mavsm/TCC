extends CanvasLayer

var exploracao_mud = 3

var dific_mud = 3

func _ready():
	pass

func _on_Dif_HSlider_changed(value):
	dific_mud = value

func _on_Exp_HSlider_changed(value):
	exploracao_mud = value

func _on_Apply_pressed():
	Generator.change_params(exploracao_mud, dific_mud)
	Transition.goto_scene("res://Testing.tscn")
	$Simples.hide()
