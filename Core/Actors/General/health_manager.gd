class_name HealthManager extends Node2D

@export var max_health = 100
@onready var cur_health = max_health

var dead = false

signal died
signal took_damage(damage_amount : int)
signal was_healed
signal health_updated(cur_health: int, max_health: int)

func _ready() -> void:
	await get_tree().process_frame
	#health_updated.emit(cur_health, max_health)

func hurt(damage_amount : int):
	if dead:
		return
	cur_health -= damage_amount
	took_damage.emit(damage_amount)
	if cur_health <= 0:
		cur_health = 0
		dead = true
		died.emit()
	health_updated.emit(cur_health, max_health)
	print("health ", cur_health)

func heal(heal_amnt: int):
	if dead:
		return
	cur_health += heal_amnt
	cur_health = clamp(cur_health, 0, max_health)
	was_healed.emit()
	health_updated.emit(cur_health, max_health)
