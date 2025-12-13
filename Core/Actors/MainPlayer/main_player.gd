extends CharacterBody2D

@export var path : Path2D
@export var path_follow : PathFollow2D
var speed = 20
@onready var health_manager: HealthManager = $HealthManager
signal take_dmg
func _ready() -> void:
	health_manager.took_damage.connect(on_take_dmg)

func on_take_dmg(amount):
	take_dmg.emit(amount)
	print("took %s dmg"%[amount])

func _process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right",  "ui_down", "ui_up")
	if direction:
		if direction.x != 0:
			path_follow.progress += (speed * direction.x)
		if direction.y != 0:

			path.global_position = path.global_position - Vector2(direction.y,direction.y) * speed

	


	
		
	
