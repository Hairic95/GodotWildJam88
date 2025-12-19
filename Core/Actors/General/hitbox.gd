extends Area2D
class_name DogHitbox

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
			var obstacle : Obstacle = area
			health_manager.hurt(obstacle.damage)
			#determines what sound to use
			match(obstacle.material_type):
				obstacle.Materials.Wood:
					FmodServer.play_one_shot("event:/SFX/Hit_wood")
				obstacle.Materials.Stone:
					FmodServer.play_one_shot("event:/SFX/Hit_stone")
				obstacle.Materials.Metal:
					FmodServer.play_one_shot("event:/SFX/Hit_stone")
		if shield_on:
			health_manager.hurt(0)
			var obstacle : Obstacle = area
			match(obstacle.material_type):
				obstacle.Materials.Wood:
					FmodServer.play_one_shot("event:/SFX/Hit_wood")
				obstacle.Materials.Stone:
					FmodServer.play_one_shot("event:/SFX/Hit_stone")
				obstacle.Materials.Metal:
					FmodServer.play_one_shot("event:/SFX/Hit_stone")
			shield_on = false
			%ShieldSprite.hide()
	if area is PowerUps:
		match(area.power_type):
			PowerUps.PowerUpTypes.Speed:
				increase_speed.emit(area.amount)
				FmodServer.play_one_shot("event:/SFX/Upgrade")
			PowerUps.PowerUpTypes.Shield:
				%ShieldSprite.show()
				FmodServer.play_one_shot("event:/SFX/Shield")
				FmodServer.set_global_parameter_by_name("Shielded",1)
				shield_on = true
			PowerUps.PowerUpTypes.Alcohol:
				FmodServer.play_one_shot("event:/SFX/Alcohol")
				get_crunk.emit()
	if area is PowerUps or area is Obstacle:
		area.queue_free()

				
