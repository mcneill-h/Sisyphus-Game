extends RigidBody2D

var max_speed = 500
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

var already_rolling = false
var memory_rotation = 0
var deltadelta = 0 
var deltadelta_2 = 0
var previous_contact = 0 
var rng = RandomNumberGenerator.new()

func _physics_process(delta):
	
	if max_speed > 500: 
		max_speed -= 1
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed

	var memory =  linear_velocity.x/2000
	
	if delta != 0:
		sprite_2d.rotation += memory
	
	if abs(memory) >= 0.04 and deltadelta >= 0.68 :
		audio_stream_player_2d.pitch_scale = rng.randf_range(0.85, 1.15)
		audio_stream_player_2d.play()
		deltadelta = 0 
	elif deltadelta >= 0.68:
		audio_stream_player_2d.stop()
		
	deltadelta  += delta 	
	
	
	
	
	#if -linear_velocity.length() + previous_velocity >= 10 and deltadelta_2 >= 0.4:
	#	audio_stream_player_2d_2.play()
	#	deltadelta_2 = 0 
	#print(linear_velocity.length() - previous_velocity)
	#previous_velocity = linear_velocity.length()
	#deltadelta_2 += _delta 
	
	
	if len(get_colliding_bodies()) != previous_contact and previous_contact == 0 and deltadelta_2 >= 0.6:
		audio_stream_player_2d_2.pitch_scale = rng.randf_range(0.35, 0.4)
		audio_stream_player_2d_2.play()
		deltadelta_2 = 0 
	previous_contact = len(get_colliding_bodies())
	deltadelta_2 += delta 
