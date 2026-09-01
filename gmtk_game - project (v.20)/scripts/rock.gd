extends RigidBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2


var max_speed = 500
var sound_delta = 0 
var pitch_delta = 0
var previous_contact = 0 
var rng = RandomNumberGenerator.new()

# MORE INFORMATION ON THE PHYSICS SYSTEM OF THE BOULDER:
	# why not use Godot's rolling system for the boulder's mouvement? 
	# --> it is very buggy! Especially for my king of game in which players can move the boulder by running on it
	# Other methods to make the boulder "roll" doesn't work 
	# Solution I found: make the boulder as slippery as ice and add bouciness to it. It acts exactly like a real rolling boulder :) !
	# Therefore, to make it LOOK like it rolls, we need to rotate the sprite through code when moving

func _physics_process(delta):
	
	if max_speed > 500: 
		max_speed -= 1
	
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
	
	var boulder_sprite_rotation =  linear_velocity.x/2000
	if delta != 0:
		sprite_2d.rotation += boulder_sprite_rotation
		# we rotate the sprite of the bolder to simulate its "rolling" motion
	
	
	## Sound emissions:
	if abs(boulder_sprite_rotation) >= 0.04 and sound_delta >= 0.68 :
		audio_stream_player_2d.pitch_scale = rng.randf_range(0.85, 1.15)
		audio_stream_player_2d.play()
		sound_delta = 0 
	
	elif sound_delta >= 0.68:
		audio_stream_player_2d.stop()
	
	if len(get_colliding_bodies()) != previous_contact and previous_contact == 0 and pitch_delta >= 0.6:
		audio_stream_player_2d_2.pitch_scale = rng.randf_range(0.35, 0.4)
		audio_stream_player_2d_2.play()
		pitch_delta = 0 
	
	previous_contact = len(get_colliding_bodies())
	
	
	sound_delta  += delta 	
	pitch_delta += delta 
