# 2025 GMTK Game Jam Submission - Ascent from the Depths (Sisyphus Video Game)
# Copyright (c) 2025-2026 henrymcneill
# Licensed under the MIT License - See the LICENSE document, 
# more details on GitHub at https://github.com/mcneill-h/Sisyphus-Game

extends Node2D

@onready var settings_screen: Control = $CanvasLayer/Settings_screen


func _ready() -> void:
	settings_screen.visible = false


func _physics_process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("settings"):
		
		if settings_screen.visible == false:
			settings_screen.visible = true
			
		else: 
			settings_screen.visible = false
			
	elif Input.is_action_pressed("escape"):
		get_tree().quit()
