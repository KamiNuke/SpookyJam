extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		save_settings()
	else:
		load_settings()


func save_settings() -> void:
	save_input_settings("sensitivity", global.sensitivity)
	save_audio_settings("volume", global.volume_db)
	save_graphics_settings("shadows", global.is_shadows_enabled)
	save_graphics_settings("resolution_3d", get_viewport().get_scaling_3d_scale())

func save_graphics_settings(key: String, value) -> void:
	config.set_value("Graphics", key, value)
	config.save(SETTINGS_FILE_PATH)

func save_input_settings(key: String, value) -> void:
	config.set_value("Input", key, value)
	config.save(SETTINGS_FILE_PATH)

func save_audio_settings(key: String, value) -> void:
	config.set_value("Audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_settings() -> void:
	var err = config.load(SETTINGS_FILE_PATH)
	
	if err != OK:
		return
	
	var video_settings = load_specific_settings("Graphics")
	global.is_shadows_enabled = video_settings["shadows"]
	get_viewport().set_scaling_3d_scale(video_settings["resolution_3d"])
	
	var audio_settings = load_specific_settings("Audio")
	global.volume_db = audio_settings["volume"]
	AudioManager.music_player.volume_db = global.volume_db
	AudioManager.sfx_button.volume_db = global.volume_db
	AudioManager.sfx_play.volume_db = global.volume_db
	
	var input_settings = load_specific_settings("Input")
	global.sensitivity = input_settings["sensitivity"]

func load_specific_settings(section: String) -> Dictionary:
	var settings = {}
	for key in config.get_section_keys(section):
		settings[key] = config.get_value(section, key)
	return settings
