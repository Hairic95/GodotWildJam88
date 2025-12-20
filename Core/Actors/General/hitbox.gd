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
	if area is PackageArea:
		var package_node : PackageNode = area.owner
		var package_resource : Package = package_node.package_resource
		
		match(package_resource.package_type):
			Package.PackageTypes.Powerups:
				var power_up_resource : PowerUp = package_resource
				on_hit_power_up(power_up_resource)
				call_deferred("delete_area", package_node)
			Package.PackageTypes.Obstacles:
				pass

func delete_area(package_node):
	package_node.queue_free()
	
func on_hit_power_up(power_up_resource : PowerUp):
	match(power_up_resource.power_up_types):
		PowerUp.PowerUpTypes.Speed:
			increase_speed.emit(power_up_resource.amount)
			FmodServer.play_one_shot("event:/SFX/Upgrade")
		PowerUp.PowerUpTypes.Shield:
			%ShieldSprite.show()
			FmodServer.play_one_shot("event:/SFX/Shield")
			shield_on = true
			#FmodServer.set_global_parameter_by_name("Shielded",1)
		PowerUp.PowerUpTypes.WarmClothes:
			FmodServer.play_one_shot("event:/SFX/Upgrade")
			GameState.decrease_frost.emit(power_up_resource.amount)
		PowerUp.PowerUpTypes.FirstAid:
			pass
	
	


		
		
		
	#PowerUps.PowerUpTypes.Alcohol:
		#FmodServer.play_one_shot("event:/SFX/Alcohol")
		#get_crunk.emit()
		

	
	#if area is Obstacle:
		#
		#if !invicibilty_frame and !shield_on:
			#var obstacle : Obstacle = area
			#play_material_sound(obstacle)
			#health_manager.hurt(obstacle.damage)
			##determines what sound to use
#
		#if shield_on:
			#var obstacle : Obstacle = area
			#play_material_sound(obstacle)
			#health_manager.hurt(0)
			##FmodServer.set_global_parameter_by_name("Shielded",0)
			#
			#shield_on = false
			#%ShieldSprite.hide()


func play_material_sound(obstacle):	
	match(obstacle.material_type):
		obstacle.Materials.Wood:
			FmodServer.play_one_shot("event:/SFX/Hit_wood")
		obstacle.Materials.Stone:
			FmodServer.play_one_shot("event:/SFX/Hit_stone")
		obstacle.Materials.Metal:
			FmodServer.play_one_shot("event:/SFX/Hit_stone")
