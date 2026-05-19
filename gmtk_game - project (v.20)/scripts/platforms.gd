extends StaticBody2D

@onready var line_2d: Line2D = $platforms_textures/Line2D



@onready var platforms_collisions: CollisionPolygon2D = $platforms_collisions
@onready var platforms_textures: Polygon2D = $platforms_textures

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var shape =  platforms_collisions.polygon
	platforms_textures.polygon = shape.duplicate()
	
	shape.append(shape[0])
	for i in range(len(shape)):
		shape[i] += Vector2(5,5)
	
	line_2d.clear_points()
	for i in range(len(shape)):
		line_2d.add_point(Vector2(shape[i]))  
	
	line_2d.width= 13
	
	
	
