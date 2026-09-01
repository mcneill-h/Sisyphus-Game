extends Area2D


## When player falls in lava/dies:
func _on_body_entered(_body: Node2D) -> void:
	call_deferred("reloads_scene")


func reloads_scene():
	get_tree().reload_current_scene()
