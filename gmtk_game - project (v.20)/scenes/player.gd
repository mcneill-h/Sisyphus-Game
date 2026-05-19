extends CharacterBody2D

@onready var ray_cast_right: RayCast2D = $RayCast_right
@onready var ray_cast_left: RayCast2D = $RayCast_left
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0 
const JUMP_VELOCITY = -1200.0
const gravity_scale = 10
const COYOTE_TIME = 0.2   # make so that we can jump near edges
const JUMP_BUFFER_TIME = 0.1 #make so that we can jump even just before landing

var coyote_timer = 0.0
var jump_buffer_timer = 0.0
var push = 18 #so that the player is able to push the rock


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
		if direction >0: 
			animated_sprite_2d.flip_h = false
			animated_sprite_2d.play("run")
		elif direction < 0:
			animated_sprite_2d.flip_h = true 
			animated_sprite_2d.play("run")
		else: 
			animated_sprite_2d.play("idle")
	
	
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
		
	if not is_on_floor():
		velocity += get_gravity() * delta * gravity_scale/2
		if coyote_timer>0:
			coyote_timer -= delta
		animated_sprite_2d.play("jump")
	
	else: 
		velocity += get_gravity() * delta * gravity_scale * 2
		coyote_timer = COYOTE_TIME
		if jump_buffer_timer > 0:
			jump_buffer_timer = 0.0
			velocity.y = JUMP_VELOCITY
			
			
	
	
	
	#determines if on floor 
	var FLOOR = false
	if ray_cast_right.get_collider() is StaticBody2D or ray_cast_left.get_collider() is StaticBody2D:
		FLOOR = true 
			
	if FLOOR == false:
		floor_stop_on_slope = false #so that when the player is on the rock, it will slip 
	else: 
		floor_stop_on_slope = true 
	
		
	for i in get_slide_collision_count():
		var n = get_slide_collision(i)
		if  n.get_collider() is RigidBody2D:
			
			if direction != 0 :  #meaning that we are precing the left or right key
				if FLOOR == true: 
					n.get_collider().apply_central_impulse(-n.get_normal() * push )
					animated_sprite_2d.play("push")
				elif ray_cast_right.get_collider() is RigidBody2D or ray_cast_left.get_collider() is RigidBody2D: #different que FLOOR car cela inclue le rock 
					
					velocity.x *= 0.4
					
					var direction_marche = 1
					if Input.is_action_pressed("move_left"): 
						direction_marche = -1
				
					n.get_collider().apply_central_impulse( Vector2(direction_marche * n.get_normal().y , 0) * push/2.5) #qd on marche sur le rock, il se dirige de l'autre sens 
					
					
					
			elif abs (n.get_collider_velocity()*Vector2(1, 0)) >= Vector2(1, 0) and FLOOR == true:
				n.get_collider().apply_central_impulse(-n.get_normal() * abs(n.get_collider_velocity()/20 ) * Vector2(1, 0))
					
			elif ray_cast_right.get_collider() is RigidBody2D or ray_cast_left.get_collider() is RigidBody2D:
				if abs(n.get_normal().y) <= 0.95:
					n.get_collider().apply_central_impulse( Vector2(sign(n.get_normal().x),0) * push/7.5)
				
				
				
	
	if coyote_timer > 0 and  jump_buffer_timer > 0:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0
			jump_buffer_timer = 0.0
	
	if  Input.is_action_just_pressed("jump"):
		jump_buffer_timer = JUMP_BUFFER_TIME
		
	#permet a avoir des sauts de differnetes longueurs selon le temps d'appui du bouton "jump"
	if not is_on_floor() and Input.is_action_just_released("jump") and velocity.y < JUMP_VELOCITY/2: 
		velocity.y *= 0.5
	
	move_and_slide()
	
	
		
		
		
		
