extends Node2D
var step = 24
var width = 6
var height = 12
var grid_position :Vector2i= Vector2i.ZERO
var max_position:Vector2i = Vector2i(4,11)
var x_start:int
var y_start:int
var input_dir:Vector2
var grid_array
var grid

@onready var sprite := $sprite
func _ready():
	x_start = get_viewport_rect().size.x/2 - (step * width/2)
	y_start = step * (height + 2) 
	position.x = x_start
	position.y = y_start
	grid = get_parent().get_node("Grid")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		input_dir = Vector2i.DOWN
		move(input_dir)
	elif event.is_action_pressed("down"):
		input_dir = Vector2i.UP
		move(input_dir)
	elif event.is_action_pressed("left"):
		input_dir = Vector2i.LEFT
		move(input_dir)
	elif event.is_action_pressed("right"):
		input_dir = Vector2i.RIGHT
		move(input_dir)

	if event.is_action_pressed("accept"):
		grid.swap_pieces(grid_position)


	
func move(input_dir:Vector2i):
	var new_position := grid_position + input_dir
	#if within the grid
	if new_position.x >= 0 and new_position.y >= 0 and new_position <= max_position:
		grid_position += input_dir
		position.x += input_dir.x * step
		position.y += -input_dir.y * step



