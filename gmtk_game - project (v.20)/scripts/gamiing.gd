extends Node2D


@onready var settings_screen: Control = $CanvasLayer/Settings_screen


# Called when the node enters the scene tree for the first time.
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
