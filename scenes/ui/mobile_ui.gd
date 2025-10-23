extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() != "Android":
		queue_free()
	Dialogic.timeline_started.connect(dialogue_start)
	Dialogic.timeline_ended.connect(dialogue_finish)

func dialogue_start() -> void:
	hide()

func dialogue_finish() -> void:
	show()
