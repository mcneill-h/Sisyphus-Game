extends Area2D


@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var naming_text: Label = $naming_text
@onready var rock: RigidBody2D = $"../Rock"

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level11.tscn")


func _on_body_entered(body: Node2D) -> void:
	print("fdsdsf")
	timer.start()
	rock.add_constant_central_force(Vector2(0,-1000))
	animation_player.play("bouldering")
	naming_text.text = "THE BOLDER IS CURSED BY THE GODS"
