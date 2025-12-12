extends CharacterBody2D

@export var path_follow : PathFollow2D
var speed = 20
func _process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		print
		
		path_follow.progress+= (speed * direction)
		#print((path_follow.progress))
		##print(ratio)
		#path_follow.progress += clamp(ratio ,0.0, 2300.0) 


	
		
	
