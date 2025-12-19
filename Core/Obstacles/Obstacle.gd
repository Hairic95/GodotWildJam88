extends Area2D
class_name Obstacle

@export var damage : int = 1
@export var random_scale  : Vector2

enum Materials {Wood, Stone, Metal}
@export var material_type : Materials


func _ready() -> void:
	if random_scale:
		var random = randf_range(random_scale.x, random_scale.y)
		scale = Vector2(random, random)
