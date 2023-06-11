extends TextureButton
class_name UIBattlerBox

#bad code but
var battler:Battler

const focused_color := 'ffffeb'
const unfocused_color := 'c2c2d1'
const disabled_color := '43434f'

const focused_border := 'res://assets/ui/battlebox/battlebox-focused.png'
const unfocused_border := 'res://assets/ui/battlebox/battlebox-unfocused.png'
const disabled_border := 'res://assets/ui/battlebox/battlebox-disabled.png'


@onready var nameLabel := $VBoxContainer/NameLabel
@onready var portrait := $VBoxContainer/Portrait
@onready var hpLabel := $VBoxContainer/HPLabel

# setget this mf
var max_hp:int

func setup(battlerNode:Battler):
	battler = battlerNode
	battler.stats.health_depleted.connect(battler_hp_depleted)
	if not is_inside_tree():
		await self.ready
	nameLabel.text = battler.stats.name
	portrait.texture = battler.stats.portrait
	max_hp = battler.stats.max_health
	battler.stats.health_changed.connect(update_hp_label)
	focus_entered.connect(display_focus)
	update_hp_label(max_hp)
	pass


func update_hp_label(new_hp):
	hpLabel.text = str(new_hp)+ "/"+str(max_hp)

func display_focus():
	if disabled == false:
		nameLabel.modulate = focused_color
		hpLabel.modulate = focused_color
		


func display_unfocus():
	if disabled == false:
		nameLabel.modulate = unfocused_color
		hpLabel.modulate = unfocused_color

func battler_hp_depleted():
	disabled = true
	hpLabel.modulate = disabled_color
	#portrait.modulate = disabled_color
	nameLabel.modulate = disabled_color
