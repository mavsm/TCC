extends Node

var Player = load("res://Scenes/Entities/Player.tscn")
var Enemy = load("res://Scenes/Entities/Enemy.tscn")

var maze = [[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
			[1, 2, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
			[1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1],
			[1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 3, 1],
			[1, 0, 0, 0, 0, 0, 0, 3, 1, 0, 0, 1],
			[1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1]]


func offset(num):
	return (num*64+32)*1.5

func _ready():
	var pl = Player.instance()
	add_child(pl)
	pl.connect("shoot", self, "_on_shoot")
	
	$tiles.scale = Vector2(1.5, 1.5)
	
	for j in range(len(maze)):
		for i in range(len(maze[j])):
			if maze[j][i] == 1:
				$tiles.set_cell(i, j, 1)
			else:
				$tiles.set_cell(i, j, 0)
				if maze[j][i] == 2:
					pl.set_global_position(Vector2(offset(i), offset(j)))
				elif maze[j][i] == 3:
					new_enemy(Vector2(offset(i), offset(j)))


func new_enemy(pos):
	var en = Enemy.instance()
	add_child(en)
	en.connect("shoot", self, "_on_shoot")
	en.set_global_position(pos)

func _on_shoot(bullet, pos, dir):
	var b = bullet.instance()
	add_child(b)
	b.start(pos, dir)