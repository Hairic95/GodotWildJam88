extends Area2D

@onready var health_manager: HealthManager = $"../HealthManager"

signal increase_speed(amount : int)

func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)

func on_body_entered(_body):
	print("bam")
func on_area_entered(area):
	if area is Obstacle:
		health_manager.hurt(area.damage)
	if area is PowerUps:
		match(area.power_type):
			PowerUps.PowerUpTypes.Speed:
				increase_speed.emit(area.amount)
				area.queue_free()
