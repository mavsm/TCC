extends Node

#Valores de geração em sí
const HEIGHT = 50
const WIDTH = 50

var maze = []



func setup_maze():
	randomize()
	reset_maze()

func reset_maze():
	maze = []
	# Monta o nível como um quadrado com paredes nas bordas
	# com espaço livre dentro
	for i in range(HEIGHT):
		maze.append([1])
		for j in range(1, WIDTH-1):
			if i == 0 or i == HEIGHT-1:
				maze[i].append(1)
			else:
				maze[i].append(0)
		maze[i].append(1)