extends Area2D
class_name PowerUps

enum PowerUpTypes {None, Speed, Shield, Alcohol, WarmClothes}
@export var power_type : PowerUpTypes
@export var amount : int
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(kill)

func kill():
	call_deferred("queue_free")
