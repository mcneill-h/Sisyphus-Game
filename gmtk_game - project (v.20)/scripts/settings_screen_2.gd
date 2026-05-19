extends Control

@onready var settings_screen: Control = $"."
@onready var sfx_button: AudioStreamPlayer2D = $sfx_button


func _on_back_button_pressed() -> void:
	settings_screen.visible = false
	sfx_button.play()
	Engine.time_scale = 1
	
