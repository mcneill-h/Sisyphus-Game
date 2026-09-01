extends Node2D

@onready var naming_text: Label = $naming_text

## Used for the dramatic fall of the boulder down the mountain:
func _ready() -> void:
	naming_text.text = "Will there be any end to this curse?"


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
