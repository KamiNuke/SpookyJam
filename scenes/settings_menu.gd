extends Control

signal change_scene(scene: Node, next_scene_path: String)

@onready var sensitivity_label: Label = $VBoxContainer/SensitivityContainer/SensitivityLabel
@onready var sensitivity_slider: HSlider = $VBoxContainer/SensitivityContainer/SensitivitySlider
@onready var volume_slider: HSlider = $VBoxContainer/VolumeContainer/VolumeSlider
@onready var shadows_check_box: CheckBox = $VBoxContainer/ShadowsCheckBox

@onready var resolution_label: Label = $VBoxContainer/ResolutionContainer/ResolutionLabel
@onready var resolution_slider: HSlider = $VBoxContainer/ResolutionContainer/ResolutionSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))
	
	sensitivity_label.text = "Sensitivity"
	#sensitivity_label.text = str(global.sensitivity * 10) #multiply by 10 to round numbers
	sensitivity_slider.value = global.sensitivity
	sensitivity_slider.min_value = 0.0001
	sensitivity_slider.step = 0.0001
	
	resolution_slider.value = get_viewport().get_scaling_3d_scale()
	
	shadows_check_box.button_pressed = global.is_shadows_enabled

	volume_slider.min_value = -40
	volume_slider.max_value = 0
	volume_slider.step = 0.1
	volume_slider.value = global.volume_db if "volume_db" in global else 0

	# Apply initial volume
	_on_volume_slider_value_changed(volume_slider.value)


func _on_sensitivity_slider_value_changed(value: float) -> void:
	global.sensitivity = value
	#sensitivity_label.text = str(value * 10) #multiply by 10 to round numbers


func _on_volume_slider_value_changed(value: float) -> void:
	global.volume_db = value 
	AudioManager.music_player.volume_db = value
	AudioManager.sfx_button.volume_db = value
	AudioManager.sfx_play.volume_db = value


func _on_button_button_up() -> void:
	AudioManager.play_sfx_button()
	AudioManager.stop_music(1.0)
	emit_signal("change_scene", get_node("."), "res://scenes/main_menu.tscn")



func _on_check_box_toggled(toggled_on: bool) -> void:
	global.is_shadows_enabled = toggled_on


func _on_resolution_slider_value_changed(value: float) -> void:
	get_viewport().set_scaling_3d_scale(value)
