extends Node
"""
VALORES DENTRO DA MATRIZ E SIGNIFICADOS
*
*  0 - ESPAÇO LIVRE
*
*  1 - PAREDE
*
*  2 - INIMIGO BASICO
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
var rooms = []
var START = Vector2()
var END = Vector2()

var bounds = Rect2(Vector2(0, 0), Vector2(WIDTH, HEIGHT))

#Valores de geração da topologia
var rounds = 6
var chance_either = .4
var chance_small = .5
var more_door_limit = 6

#Valores de geração da dificuldade
var diff_base = 5
var diff_var = 1

func _ready():
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

func rand_rangei(a, b):
	return int(rand_range(a, b))

#CRIA O MAZE
func setup_maze():
	randomize()
	reset_maze()

#RESETA O MAZE
func reset_maze():
	# Monta o nível como um quadrado com paredes nas bordas
	# com espaço livre dentro
	for i in range(HEIGHT):
		for j in range(1, WIDTH-1):
			if i == 0 or i == HEIGHT-1:
				maze[i][j] = 1
			else:
				maze[i][j] = 0
		maze[i][WIDTH-1] = 1
	generate()

#GERA O MAZE DE FATO
func generate():
	partition(1, WIDTH-1, 1, HEIGHT-1, 0)
	var start = Vector2(rand_rangei(2, WIDTH/3), rand_rangei(2, HEIGHT/3))
	var end = Vector2(rand_rangei(2, WIDTH-1), rand_rangei(2*HEIGHT/3, HEIGHT-1))
	var temp = start
	var i=0
	while(maze[temp.x][temp.y] == 1):
		temp = start + NEIGHBORS[i]
		i+=1
	START = temp
	maze[START.x][START.y] = 0
	clean(START, 3)
	temp = end
	i=0
	while(maze[temp.x][temp.y] == 1):
		temp = end + NEIGHBORS[i]
		i+=1
	END = temp
	
	if !bounds.has_point(START):
		print("PROBLEMA COM START")
		print(START)
	if !bounds.has_point(END):
		print("PROBLEMA COM END")
		print(END)
	if START == END:
		print("ELES TAO DANDO IGUAIS")
		
#DECIDE ONDE CORTAR PARA A PARTIÇÃO BINÁRIA
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

#RECURSIVA QUE DECIDE ONDE CORTAR, ASSIM FAZENDO A GERAÇÃO VIA
#PARTIÇÃO BINÁRIA
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

#INSERE INIMIGOS NO QUARTO DELIMITADO POR start E end
func populate_room(start, end):
	var bound = Vector2(end.x - start.x, end.y - start.y)
	rooms.append(Rect2(start, bound))
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

#ESTA FUNÇÃO RETIRA OS INIMIGOS DE place E TODOS OS ESPAÇOS NUM
#RAIO dist
func clean(place, dist):
	var lowX = -place.x
	var highX = WIDTH-place.x
	var lowY = -place.y
	var highY = HEIGHT-place.y
	
	if place.x > dist:
		lowX = -dist
	if place.y > dist:
		lowY = -dist
	if place.x + dist < WIDTH:
		highX = dist
	if place.y + dist < HEIGHT:
		highY = dist
		
	for i in range(lowX, highX+1):
		for j in range(lowY, highY+1):
			if maze[place.x+i][place.y+j] == 2:
				maze[place.x+i][place.y+j] = 0
	

func randf_gaussian():
	return sqrt(-2 * log(randf())) * cos(2 * PI * randf())

func print_params():
	print("EXPLORAÇÃO:")
	print(rounds, " ", chance_either, " ", chance_small, " ", more_door_limit)
	print("DIFICULDADE:")
	print(diff_base, " ", diff_var)

func change_params(e, d):
	rounds = (rounds*e + rand_rangei(3, 7)*(4-e))/4
	chance_either = (chance_either*e + rand_range(0, 1)*(4-e))/4
	chance_small = (chance_small*e + rand_range(0, 1)*(4-e))/4
	more_door_limit = (more_door_limit*e + rand_rangei(0, WIDTH)*(4-e))/4
	
	diff_base = (diff_base*d + rand_rangei(1, 10)*(4-d))/4
	diff_var = (diff_var*d + rand_range(0, 2)*(4-d))/4
	if d > 3 and diff_base < 9.5:
		diff_base += .5