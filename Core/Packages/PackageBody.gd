extends CharacterBody2D
class_name PackageBody

var direction = GameState.tile_size.normalized()
var children_entities = 1

func _physics_process(_delta: float) -> void:
	velocity = direction * 10000 
	print("vel ", velocity)
	move_and_slide()
