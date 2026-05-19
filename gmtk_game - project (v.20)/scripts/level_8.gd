extends Node2D

@onready var rock: RigidBody2D = $game_all/Rock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock.physics_material_override.bounce = 0.0


	
