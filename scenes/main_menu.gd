extends Control

signal change_scene(scene: Node, next_scene_path: String)
@onready var mainNode: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_play_button_button_up() -> void:
	emit_signal("change_scene", get_node("."), "res://scenes/levels/fabric-blockout.tscn")

func _on_exit_button_button_up() -> void:
	emit_signal("change_scene", get_node("."), "res://scenes/quit_scene.tscn")

func _on_settings_button_button_up() -> void:
	emit_signal("change_scene", get_node("."), "res://scenes/settings_menu.tscn")
