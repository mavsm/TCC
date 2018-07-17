extends Node

var Player = load("res://Scenes/Entities/Player.tscn") 

var maze = [[0, -1, -1],
			[-1, 0, -1],
			[-1, -1, -1]]

func _ready():
	var pl = Player.instance()
	add_child(pl)
	pl.connect("shoot", self, "_on_shoot")
	
	$tiles.scale = Vector2(1.5, 1.5)
	
	for i in range(3):
		for j in range(3):
			if maze[i][j] == 0:
				$tiles.set_cell(i, j, 0)
			else:
				$tiles.set_cell(i, j, 1)


func _on_shoot(bullet, pos, dir):
	var b = bullet.instance()
	add_child(b)
	b.start(pos, dir)