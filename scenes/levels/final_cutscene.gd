extends Node3D

signal change_scene(scene: Node, next_scene_path: String)

@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))
	
	Dialogic.start("final1")
	Dialogic.signal_event.connect(_on_dialogic_signal_map)
	animation_player.play("1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "1_5":
		Dialogic.start("final2")

func _on_dialogic_signal_map(argument: String):
	if argument == "final1":
		animation_player.play("1_5")
	elif argument == "final2":
		animation_player.play("2")
	elif argument == "final3":
		animation_player.play("3")
	elif argument == "final4":
		emit_signal("change_scene", get_node("."), "res://scenes/main_menu.tscn")
