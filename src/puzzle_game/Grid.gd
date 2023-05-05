extends Node2D

const width = 6
const height = 12
var x_start:int 
var y_start:int
var offset = 24
var PieceScene = preload("res://src/puzzle_game/piece.tscn")

enum TYPE {RE,BL,GR,YE,EM}
var colour_count := TYPE.values().size() -1
# STORES IN Y,X FORMAT
var grid_array := [] # grid in array form
@export_range(0,height) var starting_row_count:int  
var destroyTimer:Timer #timers for animation delays
var collapseTimer:Timer
var sidedrop_delay = .1 #animation delays
var cleardrop_delay = .3


func _ready() -> void:
	x_start = get_viewport_rect().size.x/2 - (offset * width/2)
	y_start = offset * (height + 2) 
	seed(4)
	#randomize()
	destroyTimer = get_parent().get_node("DestoryTimer")
	collapseTimer = get_parent().get_node("CollapseTimer")

	grid_array = make_grid_array()
	start_grid()
	add_rows(starting_row_count)
	destroyTimer.timeout.connect(destroy_matches)
	collapseTimer.timeout.connect(collapse_colums)

func make_grid_array():
	var grid_array = []
	for i in width:
		grid_array.append([])
		for j in height:
			grid_array[i].append(null)
	return grid_array

func start_grid():
	call_every_pos(change_to_empty)


func make_piece(type_int:int) -> Piece:
	var new_piece :Piece = PieceScene.instantiate()
	new_piece.type = type_int
	new_piece.empty = false
	return new_piece

func make_empty_piece() -> Piece:
	var new_piece :Piece = PieceScene.instantiate()
	new_piece.type = TYPE.EM
	new_piece.empty = true
	return new_piece

func grid_to_pixel(column,row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x,new_y)

func rng_piece(i,j):
	var tries := 0
	var rng = randi_range(0,colour_count -1)
	var newPiece = make_piece(rng)
	while(match_at(i,j,rng) and tries < 100):
		rng = randi_range(0,colour_count -1)
		tries += 1
		newPiece = make_piece(rng)
	add_child(newPiece)
	grid_array[i][j] = newPiece
	newPiece.position = grid_to_pixel(i,j)

func fill_grid():
	call_every_pos(rng_piece)

func add_rows(new_rows:int):
	#repeat for number of rows added
	for x in range(new_rows):
	#check that there is space on that row (keep a 1d array with the higest not empty piece on each column)
		for col in width:
			var currRow = 0
			while !grid_array[col][currRow].empty:
				currRow += 1
				#if currRow == height:  # if you topped out leave function
					#topout()
					#return
			#if currRow < height:
			#move every other piece on row up by one
			for i in range(currRow,0,-1):
				drop_piece(col,i,i-1)
			rng_piece(col,0)
			destroy_matches()
				


	#add new piece at bottom
	pass


func change_to_empty(col:int,row:int):
	#change a piece at a positions to an empty piece
	var new_empty := make_empty_piece()
	if grid_array[col][row] != null: grid_array[col][row].queue_free()
	grid_array[col][row] = new_empty
	add_child(new_empty)
	new_empty.position = grid_to_pixel(col,row)

func match_at(i,j,type_checking):
	if i >1:
		if !grid_array[i-1][j].empty and !grid_array[i-2][j].empty:
			if grid_array[i-1][j].type == type_checking and grid_array[i-2][j].type == type_checking:
				return true
	if j >1:
		if !grid_array[i][j-1].empty and !grid_array[i][j-2].empty:
			if grid_array[i][j-1].type == type_checking and grid_array[i][j-2].type == type_checking:
				return true

func swap_pieces(cursor_pos):
	var valueL :Piece= grid_array[cursor_pos.x][cursor_pos.y] 
	var valueR :Piece= grid_array[cursor_pos.x + 1][cursor_pos.y] 
	#check if both pieces can be swapped
	# swap both pieces
	if valueL.can_swap and valueR.can_swap:
		var temp = grid_array[cursor_pos.x][cursor_pos.y] 
		grid_array[cursor_pos.x][cursor_pos.y] = grid_array[cursor_pos.x+1][cursor_pos.y] 
		grid_array[cursor_pos.x+1][cursor_pos.y]=temp


		valueL.move(grid_to_pixel(cursor_pos.x+1,cursor_pos.y))
		valueR.move(grid_to_pixel(cursor_pos.x,cursor_pos.y))
		collapseTimer.start(sidedrop_delay)

func drop_piece(col:int,dropRow:int,emptyRow:int):
	#swap filled piece with empty piece
	var valueU :Piece= grid_array[col][dropRow]
	var valueD :Piece= grid_array[col][emptyRow]

	var temp:Piece = grid_array[col][emptyRow]
	grid_array[col][emptyRow] = grid_array[col][dropRow]
	grid_array[col][dropRow] = temp

	valueD.move(grid_to_pixel(col,dropRow))
	valueU.move(grid_to_pixel(col,emptyRow))


func topout():
	print("you should be dead! now!")


func find_matches():
	call_every_pos(
		func find_match(i,j):

		var current_type = grid_array[i][j].type
		# check on left and right for matches
		if i > 0 && i < width - 1:
			if !grid_array[i-1][j].empty && !grid_array[i+1][j].empty:
				if grid_array[i-1][j].type == current_type && grid_array[i+1][j].type == current_type:
					grid_array[i-1][j].matched = true
					grid_array[i-1][j].dim()
					grid_array[i][j].matched = true
					grid_array[i][j].dim()
					grid_array[i+1][j].matched = true
					grid_array[i+1][j].dim()

		if j > 0 && j < height - 1:
			if !grid_array[i][j-1].empty && !grid_array[i][j+1].empty:
				if grid_array[i][j-1].type == current_type && grid_array[i][j+1].type == current_type:
					grid_array[i][j-1].matched = true
					grid_array[i][j-1].dim()
					grid_array[i][j].matched = true
					grid_array[i][j].dim()
					grid_array[i][j+1].matched = true
					grid_array[i][j+1].dim()
					)
	destroyTimer.start()



func call_every_pos(passed_func:Callable):
	for i in width:
		for j in height:
			passed_func.call(i,j)


func destroy_matches():
	call_every_pos(
		func destroy_match(i,j):
			if !grid_array[i][j].empty && grid_array[i][j].matched:
					change_to_empty(i,j))

	collapseTimer.start(cleardrop_delay)


func collapse_colums():
	call_every_pos(
		func collapse_colum(i,j):
			# check if current piece is empty and if any above it are NOT empty
			# if so then swap the non-empty and empty
			if grid_array[i][j].empty:
				for k in range(j+1,height):
					if !grid_array[i][k].empty:
						drop_piece(i,k,j)
						break

	)
	find_matches()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("row_add"):
		add_rows(1)

#func collapse_colum(i,j):
	## check if current piece is empty and if any above it are NOT empty
	## if so then swap the non-empty and empty
	#if grid_array[i][j].empty:
		#for k in range(j+1,height):
			#if !grid_array[i][k].empty:
				#drop_piece(i,k,j)
				#break


#func destroy_match(i,j):
	#if !grid_array[i][j].empty && grid_array[i][j].matched:
			#change_to_empty(i,j)



#func find_match(i,j):
	#var current_type = grid_array[i][j].type
	## check on left and right for matches
	#if i > 0 && i < width - 1:
		#if !grid_array[i-1][j].empty && !grid_array[i+1][j].empty:
			#if grid_array[i-1][j].type == current_type && grid_array[i+1][j].type == current_type:
				#grid_array[i-1][j].matched = true
				#grid_array[i-1][j].dim()
				#grid_array[i][j].matched = true
				#grid_array[i][j].dim()
				#grid_array[i+1][j].matched = true
				#grid_array[i+1][j].dim()

	#if j > 0 && j < height - 1:
		#if !grid_array[i][j-1].empty && !grid_array[i][j+1].empty:
			#if grid_array[i][j-1].type == current_type && grid_array[i][j+1].type == current_type:
				#grid_array[i][j-1].matched = true
				#grid_array[i][j-1].dim()
				#grid_array[i][j].matched = true
				#grid_array[i][j].dim()
				#grid_array[i][j+1].matched = true
				#grid_array[i][j+1].dim()
