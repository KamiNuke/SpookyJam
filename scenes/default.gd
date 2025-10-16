extends Node

const IN_GAME_SETTINGS = preload("res://scenes/ui/in_game_settings.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and !global.is_dialogue_active:
		add_child(IN_GAME_SETTINGS.instantiate())

func enable_input() -> void:
	set_process_input(true)
