extends CharacterBody2D

@export var path : Path2D
@export var path_follow : PathFollow2D
var speed = 20


func _process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_down", "ui_up")
	if direction:
		if direction.x != 0:
			path_follow.progress += (speed * direction.x)
		if direction.y != 0:

			path.global_position = path.global_position - Vector2(direction.y,direction.y) * speed

	


	
		
	
