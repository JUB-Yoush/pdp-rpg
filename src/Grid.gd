extends Node2D

var width = 6
var height = 12
var x_start = 300
var y_start = 32 * 14
var offset = 32
var PieceScene = preload("res://src/piece.tscn")

enum TYPE {RE,BL,GR,YE,PU}
var colour_count := 5
var grid_array = []

func _ready() -> void:
	randomize()
	grid_array = make_2d_array()
	fill_grid()

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
	return new_piece

func grid_to_pixel(column,row):
	var new_x = x_start + offset * column
	var new_y = y_start + -offset * row
	return Vector2(new_x,new_y)

func fill_grid():
	for i in width:
		for j in height:
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
		if grid_array[i-1][j] != null and grid_array[i-2][j] != null:
			if grid_array[i-1][j].type == type_checking and grid_array[i-2][j].type == type_checking:
				return true
	if j >1:
		if grid_array[i][j-1] != null and grid_array[i][j-2] != null:
			if grid_array[i][j-1].type == type_checking and grid_array[i][j-2].type == type_checking:
				return true
	pass;
