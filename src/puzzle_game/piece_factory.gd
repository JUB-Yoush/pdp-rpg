extends Node2D
class_name PieceFactory
#you makea all da pieces and give them to the grid

var PieceScene = preload("res://src/puzzle_game/piece.tscn")
var ActionPieceScene = preload("res://src/puzzle_game/action_piece.tscn")
enum TYPE {RE,BL,GR,YE,PR,EM}
var colour_count := TYPE.values().size() -1

func make_empty_piece() -> Piece:
	var new_piece :Piece = PieceScene.instantiate()
	new_piece.type = TYPE.EM
	new_piece.empty = true
	return new_piece

func make_piece(type_int:int) -> Piece:
	var new_piece :Piece = PieceScene.instantiate()
	new_piece.type = type_int
	new_piece.empty = false
	return new_piece

func make_action_piece(action:Action) -> ActionPiece:
	var new_action_piece :ActionPiece = ActionPieceScene.instantiate()
	new_action_piece.type = TYPE.PR
	new_action_piece.action = action
	new_action_piece.countdown_time = action._data.countdown_time
	new_action_piece.empty = false
	return new_action_piece
