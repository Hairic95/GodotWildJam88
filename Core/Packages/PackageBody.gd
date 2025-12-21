extends CharacterBody2D
class_name PackageBody

@onready var timer: Timer = $Timer
@export var debug: bool = false

var direction = GameState.tile_size.normalized()
var children_entities = 1


func _ready() -> void:
	timer.timeout.connect(kill)

func _physics_process(_delta: float) -> void:
	velocity = direction * GameState.speed 
	move_and_slide()

func kill():
	call_deferred("queue_free")
