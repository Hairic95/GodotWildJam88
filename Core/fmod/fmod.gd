extends Node

@onready var fmom_music_emitter_2d: FmodEventEmitter2D = $FmomMusicEmitter2D

var fmod_event : FmodEvent 
@export var play_music: bool

func _ready() -> void:
	if 11:
		fmod_event =FmodServer.create_event_instance_with_guid("{2516882b-bba2-4d09-b663-26cd9f19cfa8}")
		fmod_event.start()
		fmod_event.release()
	fmod_event =FmodServer.create_event_instance("event:/SFX/Ride")
	#fmod_event =FmodServer.create_event_instance("event:/Music/MainTrack")
	fmod_event.start()
	fmod_event.release()



func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("1"):
		FmodServer.set_global_parameter_by_name("Stage",1.0)
		FmodServer.set_global_parameter_by_name("Speed",1.0)
	if Input.is_action_just_pressed("2"):
		FmodServer.set_global_parameter_by_name("Speed",2.0)
	if Input.is_action_just_pressed("3"):
		FmodServer.set_global_parameter_by_name("Speed",3.0)
	if Input.is_action_just_pressed("4"):
		FmodServer.set_global_parameter_by_name("Speed",4.0)

func change_speed():
	#fmom_music_emitter_2d.set_parameter("Speed")
	pass
