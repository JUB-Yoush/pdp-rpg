extends TextureButton
class_name UIBattlerBox

#bad code but
var battler:Battler

const focused_color := 'ffffeb'
const unfocued_color := 'c2c2d1'
const disabled_color := '43434f'

@onready var nameLabel := find_child("NameLabel")
@onready var portrait := $VBoxContainer/Portrait
@onready var hpLabel := $VBoxContainer/HPLabel

# setget this mf
var max_hp:int

func setup(battlerNode:Battler):
	battler = battlerNode
	if not is_inside_tree():
		await self.ready
	nameLabel.text = battler.stats.name
	portrait.texture = battler.stats.portrait
	max_hp = battler.stats.max_health
	update_hp_label(max_hp)
	pass


func update_hp_label(new_hp):
	hpLabel.text = str(new_hp)+ "/"+str(max_hp)
