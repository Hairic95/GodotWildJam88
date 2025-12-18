extends ColorRect
class_name StatusEffectNode

@export var status_effect : StatusEffect
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var duration_timer: Timer = $durationTimer

func _ready() -> void:
	mouse_entered.connect(on_mouse_enter)
	mouse_exited.connect(on_mouse_exited)
	label.hide()
	
func on_mouse_enter():
	label.show()
	
func _process(delta: float) -> void:
	%DurationLabel.text= str(int(duration_timer.time_left))
	
func on_mouse_exited():
	label.hide()

func add_to_timer(duration : float):
	duration_timer.stop()
	duration_timer.start(duration_timer.time_left + duration)

func setup(statuseffect : StatusEffect):
	status_effect = statuseffect
	color = status_effect.color
	texture_rect.texture = status_effect.status_texture
	duration_timer.wait_time = statuseffect.duration
	duration_timer.timeout.connect(on_timer_timeout)
	duration_timer.start()
	
func on_timer_timeout():
	GameState.stauts_complete.emit(status_effect)
	call_deferred("queue_free")
