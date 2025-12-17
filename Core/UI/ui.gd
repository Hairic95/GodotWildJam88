extends CanvasLayer

@onready var main_player: CharacterBody2D = $"../Path2D/PathFollow2D/Dog"
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var score_label: Label = $Control/ScoreLabel
@onready var node_2d: Node2D = $".."

@onready var dash_bar: TextureProgressBar = %DashBar

var score = 0

func _ready() -> void:
	main_player.take_dmg.connect(on_player_take_dmg)
	#main_player.dash.connect(on_player_dash)
	node_2d.update_y.connect(set_label_y)
	GameState.on_dash_changed.connect(on_dash_updated)

func on_dash_updated(dash):
	dash_bar.value = dash

func on_player_take_dmg(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		GameState.gameOver.emit()

func set_label_y(y):

	score_label.text = str(int(abs(y)))

	
