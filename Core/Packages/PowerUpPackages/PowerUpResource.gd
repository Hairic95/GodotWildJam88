@tool
extends Package
class_name PowerUp

enum PowerUpTypes {None, Speed, Shield, Alcohol, WarmClothes, FirstAid}

@export var power_up_types : PowerUpTypes
@export var amount : int

const MONSTER_ENERGY = preload("uid://cp4ucbu2pohvp")
const SHIELD_ICON = preload("uid://chulp65b4tqvg")
const WARMUP_GEAR = preload("uid://blhumbjqm0cmr")
const HEAL_ITEM = preload("uid://bhvr8axan1epr")

func return_texture():
	print(power_up_types)
	match(power_up_types):
		PowerUpTypes.Speed:
			return MONSTER_ENERGY
		PowerUpTypes.Shield:
			return SHIELD_ICON
		PowerUpTypes.WarmClothes:
			return WARMUP_GEAR
		PowerUpTypes.FirstAid:
			return HEAL_ITEM
