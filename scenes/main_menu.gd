extends Control

signal change_scene(scene: Node, next_scene_path: String)
@onready var mainNode: Node = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))
	AudioManager.play_music()
	get_tree().set_quit_on_go_back(true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_play_button_button_up() -> void:
	AudioManager.play_sfx_play()
	AudioManager.stop_music(1.0) 
	get_tree().set_quit_on_go_back(false)
	emit_signal("change_scene", get_node("."), "res://scenes/levels/fabric-blockout.tscn")
	
func _on_exit_button_button_up() -> void:
	AudioManager.play_sfx_button()
	AudioManager.stop_music(1.0)
	emit_signal("change_scene", get_node("."), "res://scenes/quit_scene.tscn")
	
func _on_settings_button_button_up() -> void:
	AudioManager.play_sfx_button()
	emit_signal("change_scene", get_node("."), "res://scenes/settings_menu.tscn")
