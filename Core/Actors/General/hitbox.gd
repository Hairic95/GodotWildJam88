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
			play_material_sound(obstacle)
			health_manager.hurt(obstacle.damage)
			#determines what sound to use

		if shield_on:
			var obstacle : Obstacle = area
			play_material_sound(obstacle)
			health_manager.hurt(0)
			
			shield_on = false
			%ShieldSprite.hide()
		FmodServer.play_one_shot("event:/SFX/Bumps")
	if area is PowerUps:
		match(area.power_type):
			PowerUps.PowerUpTypes.Speed:
				increase_speed.emit(area.amount)
				FmodServer.set_global_parameter_by_name("Pups",1)
				#FmodServer.play_one_shot("event:/SFX/Upgrade")
			PowerUps.PowerUpTypes.Shield:
				%ShieldSprite.show()
				shield_on = true
				FmodServer.set_global_parameter_by_name("Pups",0)
				#FmodServer.play_one_shot("event:/SFX/Shield")
			PowerUps.PowerUpTypes.Alcohol:
				#FmodServer.play_one_shot("event:/SFX/Alcohol")
				get_crunk.emit()
			PowerUps.PowerUpTypes.WarmClothes:
				FmodServer.set_global_parameter_by_name("Pups",2)
				#FmodServer.play_one_shot("event:/SFX/Upgrade")
				GameState.decrease_frost.emit(area.amount)
		FmodServer.play_one_shot("event:/SFX/Pups")
	if area is PowerUps or area is Obstacle:
		area.queue_free()

func play_material_sound(obstacle):	
	match(obstacle.material_type):
		obstacle.Materials.Wood:
			FmodServer.set_global_parameter_by_name("Bumps",0)
			#FmodServer.play_one_shot("event:/SFX/Hit_wood")
		obstacle.Materials.Stone:
			FmodServer.set_global_parameter_by_name("Bumps",1)
			#FmodServer.play_one_shot("event:/SFX/Hit_stone")
		obstacle.Materials.Metal:
			FmodServer.play_one_shot("event:/SFX/Hit_stone")
