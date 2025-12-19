extends Node2D

@onready var avalanche_path_follow_2d: PathFollow2D = $AvalanchePathFollow2D

func _ready() -> void:
	GameState.change_speed_amount.connect(on_change_speed)

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
