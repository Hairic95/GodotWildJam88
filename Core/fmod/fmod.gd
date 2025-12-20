extends Node

@onready var fmom_music_emitter_2d: FmodEventEmitter2D = $FmomMusicEmitter2D

var fmod_event : FmodEvent 
@export var play_music: bool

func _ready() -> void:
	if 11:
		fmod_event =FmodServer.create_event_instance_with_guid("{2516882b-bba2-4d09-b663-26cd9f19cfa8}")
		fmod_event.start()
		fmod_event.release()
		fmod_event.volume = 0.0
	GameState.change_speed_amount.connect(on_change_speed)

func on_change_speed():
	match(GameState.player_speed):
		0:
			FmodServer.set_global_parameter_by_name("Speed",1.0)
		1:
			FmodServer.set_global_parameter_by_name("Speed",1.0)
		2:
			FmodServer.set_global_parameter_by_name("Speed",2.0)
		3:
			FmodServer.set_global_parameter_by_name("Speed",3.0)
		4:
			FmodServer.set_global_parameter_by_name("Speed",4.0)
		#_:
			#FmodServer.set_global_parameter_by_name("Speed",1.0)

func change_speed():
	#fmom_music_emitter_2d.set_parameter("Speed")
	pass
