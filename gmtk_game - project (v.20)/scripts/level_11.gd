extends Node2D

@onready var rock: RigidBody2D = $game_all/Rock


## Used for the dramatic fall of the boulder down the mountain:
func _ready() -> void:
	rock.add_constant_central_force(Vector2(-300,0))


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level12.tscn")
