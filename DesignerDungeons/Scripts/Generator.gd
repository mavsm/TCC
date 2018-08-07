extends Node
"""
VALORES DENTRO DA MATRIZ E SIGNIFICADOS
*
*  0 - ESPAÇO LIVRE
*
*  1 - PAREDE
*
*  2 - INIMIGO
*
"""

#Valores pertinentes a todos níveis
const HEIGHT = 50
const WIDTH = 50
const MAX_ENEMIES = [0, 1, 3, 4, 7, 10, 15, 16, 17, 19, 22, 30]

const NEIGHBORS = [Vector2(1, 1), Vector2(1, 0), Vector2(1, -1),
				   Vector2(0, 1),                Vector2(0, -1),
				   Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]

var maze = []
var START = Vector2()
var END = Vector2()


#Valores de geração da topologia
var rounds = 6
var chance_either = .4
var chance_small = .5
var more_door_limit = 20

#Valores de geração da dificuldade
var diff_base = 1
var diff_var = 1

func rand_rangei(a, b):
	return int(rand_range(a, b))

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
	generate()

func generate():
	partition(1, WIDTH-1, 1, HEIGHT-1, 0)
	var start = Vector2(rand_rangei(1, WIDTH/3), rand_rangei(1, HEIGHT/3))
	var end = Vector2(rand_rangei(2*WIDTH/3, WIDTH-1), rand_rangei(2*HEIGHT/3, HEIGHT-1))
	var temp = start
	var i=0
	while(maze[temp.x][temp.y] == 1):
		temp = start + NEIGHBORS[i]
		i+=1
	START = temp
	maze[START.x][START.y] = 0
	temp = end
	i=0
	while(maze[temp.x][temp.y] == 1):
		temp = end + NEIGHBORS[i]
		i+=1
	END = temp


func decide_cut(xs, xe, ys, ye):
	var difx = xe - xs
	var dify = ye - ys
	var path = randf()
	
	#Escolhe qualquer um
	if path < chance_either:
		if randf() > .5:
			return 'y'
		return 'x'
	#Escolhe o menor axis
	elif path < chance_either + chance_small:
		if difx > dify:
			return 'y'
		return 'x'
	#Escolhe o maior axis
	else:
		if difx < dify:
			return 'y'
		return 'x'


func partition(xs, xe, ys, ye, depth):
	if rounds < depth:
		populate_room(Vector2(xs, ys), Vector2(xe, ye))
		return
	if decide_cut(xs, xe, ys, ye) == 'x': #Vou cortar no axis x
		if ye - ys < 5:
			#O quarto é pequeno demais pra cortar mais
			populate_room(Vector2(xs, ys), Vector2(xe, ye))
			return
		
		#Particiona
		var cut = int(rand_range(ys+1, ye-1))
		for i in range(xs, xe):
			maze[i][cut] = 1
		
		#insere passagems
		var num_doors = 1
		var size = xe-xs
		while size > more_door_limit:
			num_doors += 1
			size /= 2
		
		for i in range(num_doors):
			var door = int(rand_range(xs, xe))
			maze[door][cut] = 0
		
		if xs != 1 and maze[xs-1][cut] == 0:
			maze[xs][cut] = 0; #passagem em t
		if xe != WIDTH-1 and maze[xe][cut] == 0:
			maze[xe-1][cut] = 0; #passagem em t
		
		#Chama as próximas camadas de partição
		partition(xs, xe, cut+1, ye, depth+1)
		partition(xs, xe, ys, cut, depth+1)
		
	else: #Vou cortar no axis y
		if xe - xs < 5:
			#O quarto é pequeno demais para cortar mais
			populate_room(Vector2(xs, ys), Vector2(xe, ye))
			return
		
		#Particiona
		var cut = int(rand_range(xs+1, xe-1))
		for i in range(ys, ye):
			maze[cut][i] = 1
		
		#insere passagems
		var num_doors = 1
		var size = ye-ys
		while size > more_door_limit:
			num_doors += 1
			size /= 2
		
		for i in range(num_doors):
			var door = int(rand_range(ys, ye))
			maze[cut][door] = 0
		
		if ys != 1 and maze[cut][ys-1] == 0:
			maze[cut][ys] = 0; #passagem em t
		if ye != HEIGHT-1 and maze[cut][ye] == 0:
			maze[cut][ye-1] = 0; #passagem em t
		
		#Chama as próximas camadas de partição
		partition(cut+1, xe, ys, ye, depth+1)
		partition(xs, cut, ys, ye, depth+1)

func populate_room(start, end):
	var diff = int(randf_gaussian()*diff_var + diff_base) +1
	var area = (end.x - start.x)*(end.y - start.y)
	if diff > 11:
		diff = 11
	elif diff < 0:
		diff = 0
		
	var num_enemies = area/10*(1 - diff/12)
	if num_enemies > MAX_ENEMIES[diff]:
		num_enemies = MAX_ENEMIES[diff]
	
	for i in range(num_enemies):
		maze[rand_range(start.x, end.x)][rand_range(start.y, end.y)] = 2

func randf_gaussian():
	return sqrt(-2 * log(randf())) * cos(2 * PI * randf())
