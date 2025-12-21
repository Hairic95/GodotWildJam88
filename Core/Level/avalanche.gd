extends Node2D

@onready var avalanche_path_follow_2d: PathFollow2D = $AvalanchePathFollow2D
@onready var avalanche_area_2d: Area2D = $AvalanchePathFollow2D/Avalache/AvalancheArea2D

var frost_meter = 0
var dog_in = false

signal change_frost

func _ready() -> void:
	GameState.change_speed_amount.connect(on_change_speed)
	avalanche_area_2d.area_entered.connect(on_area_entered)
	avalanche_area_2d.area_exited.connect(on_area_exit)
	GameState.decrease_frost.connect(on_decrease_frost)
	less_snowy()

func on_decrease_frost(amount):
	var new_amount = frost_meter + amount
	frost_meter = clampf(new_amount, 0,100)
	change_frost.emit(frost_meter)
	

func on_area_entered(area):
	if area is FrostArea and !dog_in:
		super_snowy()
		dog_in = true

func super_snowy():
	var tween = get_tree().create_tween()
	tween.tween_property(%SnowShader,"material:shader_parameter/count", 2000, 2.0)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(%SnowShader,"material:shader_parameter/speed", 15.0, 2.0)
	%SnowShader.material.set_shader_parameter("slant", 0.183)

func less_snowy():
	var tween = get_tree().create_tween()
	tween.tween_property(%SnowShader,"material:shader_parameter/count", 200, 2.0)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(%SnowShader,"material:shader_parameter/speed", 5.0, 2.0)
	
	%SnowShader.material.set_shader_parameter("slant", 0.183)

func on_area_exit(area):
	if area is FrostArea and dog_in:
		less_snowy()
		dog_in = false

func _process(delta: float) -> void:
	if dog_in:
		print(frost_meter)
		frost_meter += delta * 11
		change_frost.emit(frost_meter)
		
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
