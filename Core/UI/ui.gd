extends CanvasLayer

@onready var main_player: CharacterBody2D = $"../Path2D/PathFollow2D/Dog"
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var score_label: Label = $Control/ScoreLabel
@onready var node_2d: Node2D = $".."

var score = 0

func _ready() -> void:
	main_player.take_dmg.connect(on_player_take_dmg)
	node_2d.update_y.connect(set_label_y)

func on_player_take_dmg(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		GameState.gameOver.emit()

func set_label_y(y):

	score_label.text = str(int(abs(y)))

	
