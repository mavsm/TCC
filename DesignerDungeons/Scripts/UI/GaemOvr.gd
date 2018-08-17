extends CanvasLayer

var buttonBounds

func _ready():
	buttonBounds = $VBoxContainer/Button.get_rect()

func _on_Button_pressed():
	print("Hi")
	Transition.go_to("res://Testing.tscn")
