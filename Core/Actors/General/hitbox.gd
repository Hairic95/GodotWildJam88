extends Area2D

@onready var health_manager: HealthManager = $"../HealthManager"

signal increase_speed(amount : int)

@onready var iframe_timer: Timer = $IframeTimer
var invicibilty_frame = false

func _ready() -> void:
	area_entered.connect(on_area_entered)
	body_entered.connect(on_body_entered)
	health_manager.took_damage.connect(on_take_dmg)
	iframe_timer.timeout.connect(disable_i_frame)
	
func on_take_dmg(amount):
	invicibilty_frame = true
	iframe_timer.start()
	
func disable_i_frame():
	invicibilty_frame = false

func on_body_entered(_body):
	print("bam")
func on_area_entered(area):
	
	if area is Obstacle:
		if !invicibilty_frame:
			health_manager.hurt(area.damage)
	if area is PowerUps:
		match(area.power_type):
			PowerUps.PowerUpTypes.Speed:
				increase_speed.emit(area.amount)
				area.queue_free()
