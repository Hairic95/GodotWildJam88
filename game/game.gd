extends Node

@onready var play_button: Button = $MainMenu/ColorRect/PlayButton


@onready var level: Node2D = $Level
@onready var main_menu: Control = $MainMenu

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	set_state()

func on_play_button_pressed():
	GameState.change_state_to(GameState.States.Game)
	set_state()

func set_state():
	match(GameState.starting_state):
		GameState.States.MainMenu:
			main_menu.show()
			level.hide()
		GameState.States.Game:
			level.show()
			main_menu.hide()
