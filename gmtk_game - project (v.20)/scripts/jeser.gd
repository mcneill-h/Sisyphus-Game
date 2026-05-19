extends Node2D

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D
@onready var area_player: Area2D = $"Area Player"
@onready var area_rock: Area2D = $Area_rock
@onready var rock: RigidBody2D = $"../game_all/Rock"

@onready var timer_2: Timer = $Timer2

var player_in = false
var rock_in = false
var try_fly = false 


func _on_timer_timeout() -> void:
	if cpu_particles_2d.emitting == true:
		cpu_particles_2d.emitting = false
		try_fly = false 
	else:
		cpu_particles_2d.emitting = true
		if player_in == true: 
			timer_2.start()
		elif rock_in == true:
			try_fly = true 
			fly()
			
	
	

func _on_timer_2_timeout() -> void:
	call_deferred("killing")

func killing():
	get_tree().reload_current_scene()

	
	
func fly():
	if name == "jeser_special":
		rock.linear_velocity.y = rock.linear_velocity.y - 940
		rock.linear_velocity.x = rock.linear_velocity.x - 340
	elif name == "jeser_faible":
		rock.linear_velocity.y = rock.linear_velocity.y - 100
	else:
		rock.linear_velocity.y = rock.linear_velocity.y -1000
	rock.max_speed = 1000

func _physics_process(_delta: float) ->void:
	if try_fly == true:
		if name !="jeser_strange" and name != "jeser_strange_2":
			fly()
	

func _on_area_player_body_entered(_body: Node2D) -> void:
	player_in = true
	if  cpu_particles_2d.emitting == true:
		timer_2.start()


func _on_area_player_body_exited(_body: Node2D) -> void:
	player_in = false 


func _on_area_rock_body_entered(_body: Node2D) -> void:
	rock_in = true 
	if  cpu_particles_2d.emitting == true:
		try_fly = true 
		fly()
	

func _on_area_rock_body_exited(_body: Node2D) -> void:
	rock_in = false 
	try_fly = false 
	
