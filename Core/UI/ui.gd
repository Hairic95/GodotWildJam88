extends CanvasLayer

@onready var main_player: CharacterBody2D =$"../YPath2D2/YPathFollow2D/Path2D/PathFollow2D/Dog"
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var score_label: Label = $Control/ScoreLabel
@onready var node_2d: Node2D = $".."
@onready var dash_bar: TextureProgressBar = %DashBar
var score = 0

const status_effect_node = preload("uid://yj1c6bxdbf7f")
@onready var status_h_box_container: HBoxContainer = %StatusHBoxContainer
@onready var avalanche_path_2d_3: Path2D = $"../AvalanchePath2D3"
@onready var replay_button: Button = $Control/GameOverPanel/VBoxContainer/ReplayButton

func _ready() -> void:
	main_player.take_dmg.connect(on_player_take_dmg)
	main_player.healed.connect(new_health)
	main_player.set_status_effect.connect(on_set_status_effect)
	node_2d.update_y.connect(set_label_y)
	GameState.on_dash_changed.connect(on_dash_updated)
	GameState.change_map_speed_.connect(on_change_map_speed)
	on_change_map_speed(GameState.speed)
	avalanche_path_2d_3.change_frost.connect(on_change_frost)
	GameState.gameOver.connect(on_game_over)
	replay_button.pressed.connect(on_replay_button_pressed)
	
func new_health(cur_health):
	%HealthBar.value = cur_health
	
func on_game_over():
	%FinalScoreLabel.text = str(int(score))
	%GameOverPanel.show()
	
func on_replay_button_pressed():
	FmodServer.play_one_shot("event:/UI/Button")
	get_tree().reload_current_scene()

func on_change_frost(frost_level):
	if %FrostBar.value >= 100:
		GameState.gameOver.emit()
		FmodServer.play_one_shot("event:/SFX/Freeze")
		return
	%FrostBar.value = frost_level

func on_set_status_effect(_status_effect : StatusEffect):
	#check if this isn't a duplicate status_effect
	for child : StatusEffectNode in status_h_box_container.get_children():
		if child.status_effect == _status_effect:
			child.add_to_timer(_status_effect.duration)
			return
	var status_effect = status_effect_node.instantiate()
	%StatusHBoxContainer.add_child(status_effect)
	status_effect.setup(_status_effect)

func on_change_map_speed(new_speed):
	%player_speed_label.text = str(new_speed)

func on_dash_updated(dash):
	dash_bar.value = dash

func on_player_take_dmg(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		GameState.gameOver.emit()

func set_label_y(y):
	score_label.text = str(int(abs(y)))
	score = y

	
