extends CharacterBody2D
class_name PackageBody

@onready var timer: Timer = $Timer

var direction = GameState.tile_size.normalized()
var children_entities = 1

func _ready() -> void:
	timer.timeout.connect(kill)

func _physics_process(_delta: float) -> void:
	velocity = direction * 4000 
	move_and_slide()

func kill():
	call_deferred("queue_free")
