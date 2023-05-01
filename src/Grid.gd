extends Node2D

var width = 6
var height = 12
var x_start = 300
var y_start = 32 * 14
var offset = 32
var PieceScene = preload("res://src/piece.tscn")

enum TYPE {RE,BL,GR,YE,PU,EM}
var colour_count := 5
# STORES IN Y,X FORMAT
var grid_array := []
var destroyTimer:Timer

func _ready() -> void:
	#randomize()
	destroyTimer = get_parent().get_node("DestoryTimer")
	grid_array = make_2d_array()
	fill_grid()
	destroyTimer.timeout.connect(destroy_matches)

func make_2d_array():
	var grid_array = []
	for i in width:
		grid_array.append([])
		for j in height:
			grid_array[i].append(null)
	return grid_array

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

func fill_grid():
	call_every_pos(rng_piece)

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

func match_at(i,j,type_checking):
	if i >1:
		if !grid_array[i-1][j].empty and !grid_array[i-2][j].empty:
			if grid_array[i-1][j].type == type_checking and grid_array[i-2][j].type == type_checking:
				return true
	if j >1:
		if !grid_array[i][j-1].empty and !grid_array[i][j-2].empty:
			if grid_array[i][j-1].type == type_checking and grid_array[i][j-2].type == type_checking:
				return true
	pass;

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
		find_matches()

func find_matches():
	call_every_pos(find_match)
	destroyTimer.start()



func call_every_pos(passed_func:Callable):
	for i in width:
		for j in height:
			passed_func.call(i,j)

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

func destroy_matches():
	call_every_pos(destroy_match)

func destroy_match(i,j):
	if !grid_array[i][j].empty && grid_array[i][j].matched:
			print(grid_array[i][j].type)
			var new_empty = make_empty_piece()
			new_empty.position = grid_array[i][j].position
			#grid_array[i][j].queue_free()
			grid_array[i][j] = new_empty
			print(grid_array[i][j].type)
	
