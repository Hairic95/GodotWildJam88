extends CanvasLayer

@onready var main_player: CharacterBody2D =$"../YPath2D2/YPathFollow2D/Path2D/PathFollow2D/Dog"
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var score_label: Label = $Control/ScoreLabel
@onready var node_2d: Node2D = $".."

@onready var dash_bar: TextureProgressBar = %DashBar

var score = 0

const status_effect_node = preload("uid://yj1c6bxdbf7f")
@onready var status_h_box_container: HBoxContainer = %StatusHBoxContainer

func _ready() -> void:
	main_player.take_dmg.connect(on_player_take_dmg)
	main_player.set_status_effect.connect(on_set_status_effect)
	node_2d.update_y.connect(set_label_y)
	GameState.on_dash_changed.connect(on_dash_updated)
	GameState.change_speed_amount.connect(on_change_player_speed)

func on_set_status_effect(_status_effect : StatusEffect):
	#check if this isn't a duplicate status_effect
	for child : StatusEffectNode in status_h_box_container.get_children():
		if child.status_effect == _status_effect:
			child.add_to_timer(_status_effect.duration)
			return
	
	var status_effect = status_effect_node.instantiate()
	%StatusHBoxContainer.add_child(status_effect)
	status_effect.setup(_status_effect)

func on_change_player_speed():
	%player_speed_label.text = str(GameState.player_speed)

func on_dash_updated(dash):
	dash_bar.value = dash

func on_player_take_dmg(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		GameState.gameOver.emit()

func set_label_y(y):

	score_label.text = str(int(abs(y)))

	
