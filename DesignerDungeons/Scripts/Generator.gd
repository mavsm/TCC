
"""
VALORES DENTRO DA MATRIZ E SIGNIFICADOS
*
*  0 - ESPAÇO LIVRE
*
*  1 - PAREDE
*
*  2 - ESPAÇO INICIAL
*
"""

#Valores pertinentes a todos níveis
const HEIGHT = 50
const WIDTH = 50

var maze = []

#Valores de geração da topologia
var rounds = 6
var chance_either = .4
var chance_small = .5
var more_door_limit = 20


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
	maze[1][1] = 2

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
		return
	if decide_cut(xs, xe, ys, ye) == 'x': #Vou cortar no axis x
		if ye - ys < 5:
			#O quarto é pequeno demais pra cortar mais
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




