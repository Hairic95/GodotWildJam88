extends CharacterBody2D

@export var dog : CharacterBody2D


func _physics_process(_delta: float) -> void:
	velocity = dog.velocity
	move_and_slide()

func change_frame(frame: int) -> void:
	$Sprite2D.frame = frame
	match(frame):
		0:
			$Arms.position = Vector2(-391.0, 28.0)
			$Arms.rotation_degrees = -22.9
			$Line2D.points[0] = Vector2(-112.0, -22.0)
			
		1:
			$Arms.position = Vector2(-275.0, -11.0)
			$Arms.rotation_degrees = 0
			$Line2D.points[0] = Vector2(0, 0)
		2:
			$Arms.position = Vector2(-144.0, -130.0)
			$Arms.rotation_degrees = 16.3
			$Line2D.points[0] = Vector2(14.0, -26)
