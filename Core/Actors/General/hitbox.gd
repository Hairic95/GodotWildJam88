extends Area2D

@onready var health_manager: HealthManager = $"../HealthManager"
@onready var iframe_timer: Timer = $IframeTimer
var invicibilty_frame = false

signal increase_speed(amount : int)
signal activate_shield()
signal get_crunk

var shield_on = false

func _ready() -> void:
	area_entered.connect(on_area_entered)
	health_manager.took_damage.connect(on_take_dmg)
	iframe_timer.timeout.connect(disable_i_frame)

func on_take_dmg(amount):
	invicibilty_frame = true
	iframe_timer.start()
	
func disable_i_frame():
	invicibilty_frame = false

func on_area_entered(area):
	if area is Obstacle:
		
		if !invicibilty_frame and !shield_on:
			health_manager.hurt(area.damage)
		if shield_on:
			shield_on = false
			%ShieldSprite.hide()
	if area is PowerUps:
		match(area.power_type):
			PowerUps.PowerUpTypes.Speed:
				increase_speed.emit(area.amount)
			PowerUps.PowerUpTypes.Shield:
				%ShieldSprite.show()
				shield_on = true
			PowerUps.PowerUpTypes.Alcohol:
				get_crunk.emit()
	area.queue_free()

				
