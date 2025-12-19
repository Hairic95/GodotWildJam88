extends Node

@onready var play_button: Button = $MainMenu/ColorRect/PlayButton
@onready var level: Node2D = $Level
@onready var main_menu: Control = $MainMenu

func _ready() -> void:
	play_button.pressed.connect(on_play_button_pressed)
	set_state()

func on_play_button_pressed():
	var fmod_event = FmodEvent
	FmodServer.set_global_parameter_by_name("Stage",1)
	fmod_event =FmodServer.create_event_instance("event:/SFX/Ride")
	#fmod_event =FmodServer.create_event_instance("event:/Music/MainTrack")
	fmod_event.start()
	fmod_event.release()
	GameState.change_state_to(GameState.States.Game)
	set_state()

func set_state():
	match(GameState.starting_state):
		GameState.States.MainMenu:
			#FmodServer.set_global_parameter_by_name("Stage",0.0)
			main_menu.show()
			level.hide()
		GameState.States.Game:
			level.show()
			main_menu.hide()
