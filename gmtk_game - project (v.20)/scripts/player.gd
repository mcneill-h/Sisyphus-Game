extends CharacterBody2D

@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED = 300.0 
const JUMP_VELOCITY = -1200.0
const GRAVITY_SCALE = 10
const PUSH_SCALE = 18 # player's boulder push constant

## Jumping input delays:
# helps players' input delays (when falling off the edge of a platform)
# search "coyotee time" on internet for details
const COYOTE_TIME = 0.2 
var coyote_timer = 0.0

# helps players' input delays (when pressing jump before landing)
const JUMP_BUFFER_TIME = 0.1 
var jump_buffer_timer = 0.0


func switch_scene(): 
	get_tree().reload_current_scene()


func _physics_process(delta: float) -> void:
	
	if Input.is_action_pressed("reset"):
		call_deferred("switch_scene")
	
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction:
		velocity.x = direction * SPEED
	
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if delta != 0: 
		
		if direction > 0: 
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run")
		
		elif direction < 0:
			animated_sprite_2d.flip_h = true 
			animated_sprite_2d.play("run")
		
		else: 
			animated_sprite_2d.play("idle")
	
	## Jumping inputs delays (Coyotee time + jump buffer time):
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SCALE/2
		
		if coyote_timer>0:
			coyote_timer -= delta
		
		animated_sprite_2d.play("jump")
	
	else: 
		velocity += get_gravity() * delta * GRAVITY_SCALE * 2
		coyote_timer = COYOTE_TIME
		
		if jump_buffer_timer > 0:
			jump_buffer_timer = 0.0
			velocity.y = JUMP_VELOCITY
	
	if coyote_timer > 0 and  jump_buffer_timer > 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0
			jump_buffer_timer = 0.0
	
	if  Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		
	# Jumps of different heights:
	if not is_on_floor() and Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY/2: 
		velocity.y *= 0.5
	
	
	## Computes when and how strong the player moves the boulder:
	# there are 3 ways the player can moves/affect the boulder: 
	# 1. the player pushes the boulder from one side 
	# 2. the player runs on the top of the boulder (making the boulder roll)
	# 3. friction between player and boulder (especially when the boulder rolls in the player)
	var is_on_ground = false
	
	if ray_cast_right.get_collider() is StaticBody2D or ray_cast_left.get_collider() is StaticBody2D:
		# is_on_ground != is_on_floor(), as is_on_ground is not true when the player is on the boulder. 
		is_on_ground = true 
	
	for i in get_slide_collision_count():
		var occured_collision = get_slide_collision(i)
		
		# if there is a collision between the player and boulder
		if  occured_collision.get_collider() is RigidBody2D:
			
			if direction != 0 : # if we are at least pressing on the left or right key
				
				# 1. the player pushes the boulder from one side:
				if is_on_ground == true: 
					occured_collision.get_collider().apply_central_impulse(-occured_collision.get_normal() * PUSH_SCALE )
				
				# 2. the player runs on the top of the boulder (making the boulder roll):
				elif ray_cast_right.get_collider() is RigidBody2D or ray_cast_left.get_collider() is RigidBody2D:
					velocity.x *= 0.4
					
					var direction_marche = 1
					
					if Input.is_action_pressed("move_left"): 
						direction_marche = -1
				
					occured_collision.get_collider().apply_central_impulse( Vector2(direction_marche * occured_collision.get_normal().y , 0) * PUSH_SCALE/2.5) #qd on marche sur le rock, il se dirige de l'autre sens 
			
			# 3. friction between player and boulder (especially when the boulder rolls in the player):
			elif abs (occured_collision.get_collider_velocity() * Vector2(1, 0)) >= Vector2(1, 0) and is_on_ground == true:
				occured_collision.get_collider().apply_central_impulse(-occured_collision.get_normal() * abs(occured_collision.get_collider_velocity()/20 ) * Vector2(1, 0))
				
			elif ray_cast_right.get_collider() is RigidBody2D or ray_cast_left.get_collider() is RigidBody2D:
				
				if abs(occured_collision.get_normal().y) <= 0.95:
					occured_collision.get_collider().apply_central_impulse(Vector2(sign(occured_collision.get_normal().x) , 0) * PUSH_SCALE/7.5)
	
	
	move_and_slide()
