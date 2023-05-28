extends Action
class_name ModifierAction

# We must override the constructor to use it.
# Notice how _init() uses a unique notation to call the parent's constructor.
func _init(data: ModifierActionData, actor:Battler, targets: Array):
	super(data, actor, targets)


### when we implement status effects.
#func calculate_potential_modifier_for(target:Battler) -> int:
	#return Formulas.calculate_modifier(_data, _actor, target)


func apply_async() -> bool:
	# We apply the action to each target so attacks work both for single and multiple targets.
	for target in _targets:
		#var modifier:float= _data.value 
		# We're going to define a new function on the battler so it takes hits.
		#make some cast class or somthing that you can use for 
		target.stats.add_modifier(_data.stat_name,_data.value,_data.length)
	# Our method is supposed to be a coroutine, that is to say, it pauses
	# execution and ends after some time.
	# in Godot 3.2, we do so using the `yield` keyword.
	# Here, we wait for the next frame by listening to the SceneTree's
	# `idle_frame` signal.
	await Engine.get_main_loop().process_frame
	return true
