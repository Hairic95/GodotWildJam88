extends CharacterBody2D

@export var dog : CharacterBody2D

func _physics_process(_delta: float) -> void:
	velocity = dog.velocity
	move_and_slide()

func change_frame(frame: int) -> void:
	$Sprite2D.frame = frame
