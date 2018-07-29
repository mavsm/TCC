extends Node

var Generator = load("res://Scripts/Generator.gd")
var G = Generator.new()

var Player = load("res://Scenes/Entities/Player.tscn")
var Enemy = load("res://Scenes/Entities/Enemy.tscn")


func offset(num):
	return (num+.5)*$tiles.cell_size.x*1.5

func _ready():
	var pl = Player.instance()
	add_child(pl)
	pl.connect("shoot", self, "_on_shoot")
	
	G.setup_maze()
	
	$tiles.scale = Vector2(1.5, 1.5)
	
	for j in range(len(G.maze)):
		for i in range(len(G.maze[j])):
			if G.maze[j][i] == 1:
				$tiles.set_cell(i, j, 0)
			else:
				if randf() > 0.3:
					$tiles.set_cell(i, j, 1)
				else:
					$tiles.set_cell(i, j, 2)
				if G.maze[j][i] == 2:
					$tiles.set_cell(i, j, 3) #Entrada
					pl.set_global_position(Vector2(offset(i), offset(j)))
				elif G.maze[j][i] == 3:
					new_enemy(Vector2(offset(i), offset(j)))
				elif G.maze[i][j] == 4:
					$Exit.global_position = Vector2(offset(i), offset(j))
					$tiles.set_cell(i, j, 4)
	var limits = $tiles.get_used_rect().end
	var cell_size = $tiles.cell_size
	pl.set_limits(cell_size.x*limits.x*1.5, cell_size.y*limits.y*1.5)

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		print(randf_gaussian())


func new_enemy(pos):
	var en = Enemy.instance()
	add_child(en)
	en.connect("shoot", self, "_on_shoot")
	en.set_global_position(pos)

func _on_shoot(bullet, pos, dir):
	var b = bullet.instance()
	add_child(b)
	b.start(pos, dir)


func _on_Area2D_body_entered(body):
	print("Fim!")
