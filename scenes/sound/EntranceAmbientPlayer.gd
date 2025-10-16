extends AudioStreamPlayer

@export var fade_in_time: float = 1.5
@export var fade_out_time: float = 1.5

var tween: Tween = null

func _ready():
	volume_db = -50  # start silent
	stop()  # ensure player is not playing initially

func fade_in():
	if not playing:
		play()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "volume_db", +2, fade_in_time)

func fade_out():
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "volume_db", -60, fade_out_time)
	tween.tween_callback(Callable(self, "stop"))
