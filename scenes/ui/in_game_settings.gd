extends Control

signal change_scene(scene: Node, next_scene_path: String)

@onready var sensitivity_label: Label = $VBoxContainer/SensitivityContainer/SensitivityLabel
@onready var sensitivity_slider: HSlider = $VBoxContainer/SensitivityContainer/SensitivitySlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	
	sensitivity_label.text = "Sensitivity"
	#sensitivity_label.text = str(global.sensitivity * 10) #multiply by 10 to round numbers
	sensitivity_slider.value = global.sensitivity
	sensitivity_slider.min_value = 0.0001
	sensitivity_slider.step = 0.0001


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sensitivity_slider_value_changed(value: float) -> void:
	global.sensitivity = value
	#sensitivity_label.text = "Sensitivity" + str(value * 10) #multiply by 10 to round numbers


func _on_volume_slider_value_changed(value: float) -> void:
	pass # Replace with function body.


func _on_return_button_button_up() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	queue_free()


func _on_exit_button_button_up() -> void:
	emit_signal("change_scene", get_tree().get_root(), "res://scenes/quit_scene.tscn")
