extends CharacterBody2D

@export var dog : CharacterBody2D

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity = dog.velocity
	move_and_slide()
