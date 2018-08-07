extends Node

var G = Generator

var Player = load("res://Scenes/Entities/Player.tscn")
var Enemy = load("res://Scenes/Entities/Enemy.tscn")



func offset(num):
	return (num+.5)*$tiles.cell_size.x*1.5

func _ready():
	var pl = Player.instance()
	add_child(pl)
	pl.connect("shoot", self, "_on_shoot")
	pl.connect("died", self, "_on_Area2D_body_entered")
	
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
					new_enemy(Vector2(offset(i), offset(j)))
	#Define a entrada
	$tiles.set_cell(G.START.y, G.START.x, 3)
	pl.set_global_position(Vector2(offset(G.START.y), offset(G.START.x)))
	
	#Define a saída
	$tiles.set_cell(G.END.y, G.END.x, 4)
	$Exit.set_global_position(Vector2(offset(G.END.y), offset(G.END.x)))
	
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
	get_tree().paused = true
	Transition.goto_scene("res://Testing.tscn")
