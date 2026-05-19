extends Area2D

const FILE_PATH= "res://scenes/level"



func _on_body_entered(_body: Node2D) -> void:
	if len(get_overlapping_bodies()) == 2:
		call_deferred("switch_scene")
		
func switch_scene():
	var current_scene = get_tree().current_scene.scene_file_path
	var next_scene = current_scene.to_int() + 1
	get_tree().change_scene_to_file(FILE_PATH + str(next_scene) + ".tscn")
