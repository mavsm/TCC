extends CanvasLayer

var exploracao_mud = 3

var dific_mud = 3

func _ready():
	Generator.print_params()

func _on_Dif_HSlider_changed(value):
	dific_mud = value

func _on_Exp_HSlider_changed(value):
	exploracao_mud = value

func _on_Apply_pressed():
	print("Exploracao: ", exploracao_mud)
	print("Dificuldade: ", dific_mud)
	Generator.change_params(exploracao_mud, dific_mud)
	Transition.goto_scene("res://Testing.tscn")
	$Simples.hide()
