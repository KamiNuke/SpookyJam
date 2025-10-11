extends Control

signal change_scene(scene: Node, next_scene_path: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_button_button_up() -> void:
	emit_signal("change_scene", get_node("."), "res://scenes/levels/level_1.tscn")

func _on_exit_button_button_up() -> void:
	get_tree().quit()
