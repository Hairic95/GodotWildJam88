extends Node2D


@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(kill)

func kill():
	call_deferred("queue_free")
