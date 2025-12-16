extends CanvasLayer

@onready var main_player: CharacterBody2D = $"../Path2D/PathFollow2D/MainPlayer"
@onready var health_bar: ProgressBar = %HealthBar
@onready var score_label: Label = $Control/ScoreLabel

var score = 0

func _ready() -> void:
	main_player.take_dmg.connect(on_player_take_dmg)

func on_player_take_dmg(dmg):
	health_bar.value -= dmg
	if health_bar.value <= 0:
		GameState.gameOver.emit()

func _process(delta: float) -> void:
	score += delta * 10
	score_label.text = str(int(score))
