extends Node2D

@onready var avalanche_path_follow_2d: PathFollow2D = $AvalanchePathFollow2D
@onready var avalanche_area_2d: Area2D = $AvalanchePathFollow2D/Avalache/AvalancheArea2D

var frost_meter = 0
var dog_in = false
func _ready() -> void:
	GameState.change_speed_amount.connect(on_change_speed)
	avalanche_area_2d.area_entered.connect(on_area_entered)
	avalanche_area_2d.area_exited.connect(on_area_exit)

func on_area_entered(area):
	if area is FrostArea and !dog_in:
		print("in")
		dog_in = true

func on_area_exit(area):
	if area is FrostArea and dog_in:
		print("out")
		dog_in = false

func _process(delta: float) -> void:
	if dog_in:
		frost_meter += delta * 8
		print("frost meter ", frost_meter)
func on_change_speed():
	var new_progress_ratio 
	if GameState.player_speed < 0:
		match(GameState.player_speed):
			-1:
				new_progress_ratio = 0.2
			-2:
				new_progress_ratio = 0.4
			-3:
				new_progress_ratio = 0.6
			-4:
				new_progress_ratio = 0.8
			-5:
				new_progress_ratio = 1.0
	else:
		new_progress_ratio = 0.0
	
	var tween = get_tree().create_tween()
	tween.tween_property(avalanche_path_follow_2d, "progress_ratio",new_progress_ratio,1.0)
