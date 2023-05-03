extends Node2D
class_name Battler

@export var stats:Resource
@export var ai_scene :PackedScene
@export var skills:Array[Skill]
@export var is_party_member:= true
var acted:bool = false