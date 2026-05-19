extends Node2D

@onready var rock: RigidBody2D = $game_all/Rock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rock.add_constant_central_force(Vector2(-300,0))


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level12.tscn")
