extends Node

var maze = [[0, -1, -1],
			[-1, 0, -1],
			[-1, -1, -1]]

func _ready():

	$tiles.scale = Vector2(1.5, 1.5)
	
	for i in range(3):
		for j in range(3):
			if maze[i][j] == 0:
				$tiles.set_cell(i, j, 0)
			else:
				$tiles.set_cell(i, j, 1)