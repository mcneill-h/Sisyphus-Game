extends Node2D

@onready var rock: RigidBody2D = $game_all/Rock


## Used for the dramatic fall of the boulder down the mountain:
func _ready() -> void:
	rock.physics_material_override.bounce = 0.0
