extends Node2D

"""
the loop:
start by playing pdp for like 10 seconds
clear lines and collect points
after that, display the points at the top of the screen or somthing
display all potential actions in a list
when an action is selected, go to selection the target
when turn is ended (button to press or somthing): go back to pdp

need a state system to manage if we're playing the puzzle game or not
party members are stored in an array and thier turns are called

"""
enum STATES {PUZZLE,TURN}
var _state = STATES.TURN

var _party_members := []
var _opponents := []
@onready var puzzleGame = get_parent().get_node("PuzzleGame")
@onready var battlers := get_children()


func _ready() -> void:
	for battler in battlers:
		if battler.is_party_member:
			_party_members.append(battler)
		else:
			_opponents.append(battler)
	
	print(_party_members[0])
	_play_turn(_party_members[0])

func _play_turn(battler:Battler):
	# this is where the battler would pick thier action and target
	# hard coding interaction for now
	var targets = [_opponents[0]]
	var basicAttack :AttackActionData = load("res://src/resources/attack_actions/basic_attack.tres")
	var action := AttackAction.new(basicAttack,battler,targets)
	battler.act(action)
	await battler.action_finished
	targets = [_opponents[0]]
	action = AttackAction.new(basicAttack,battler,targets)
	battler.act(action)
	await battler.action_finished
	pass


	
func end_turn():
	_state = STATES.PUZZLE
	start_puzzle()


func start_puzzle():
	pass

func end_puzzle():
	# tick all purple boxes and check if any reached -1
	# if they did then put those enemies in an array
	_state = STATES.TURN
	start_enemy_turn()

func start_enemy_turn():
	pass

func start_turn():
	#loop thru enemies and put in speed-sorted array
	# play turn for each purple counted down

	# loop through all our party members
	# sort them by speed stat
	# play_turn for each of them
	# at end of loop go back to puzzle ig

	pass
