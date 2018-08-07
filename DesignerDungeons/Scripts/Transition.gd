extends CanvasLayer

var path = ""
var current_scene = null

func goto_scene(path):
	self.path = path
	$Animation.play("Fade")

func change_scene():
	if path != "":
		get_tree().change_scene(path)
	get_tree().paused = false
