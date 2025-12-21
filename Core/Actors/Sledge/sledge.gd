extends CharacterBody2D

#@export var dog : CharacterBody2D


#func _physics_process(_delta: float) -> void:
	#velocity = dog.velocity
	#move_and_slide()

func change_frame(frame: int) -> void:
	$Sprite2D.frame = frame
	match(frame):
		0:
			$Arms.position = Vector2(-211.0, -143.0)
			$Arms.rotation_degrees = -22.9
			$Line2D.points[0] = Vector2(-17.143, -1.286)
			
		1:
			$Arms.position = Vector2(-126.0, -171.0)
			$Arms.rotation_degrees = 0
			$Line2D.points[0] = Vector2(-0.571, 4.429)
		2:
			$Arms.position = Vector2(3.0, -278.0)
			$Arms.rotation_degrees = 16.3
			$Line2D.points[0] = Vector2(27.714, -15.857)
