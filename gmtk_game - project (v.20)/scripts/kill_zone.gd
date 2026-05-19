extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	print(name)
	call_deferred("reloads_scene")
	


func reloads_scene():
	get_tree().reload_current_scene()
