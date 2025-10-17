extends AudioStreamPlayer3D

@export var footstep_sounds: Array[AudioStream]
@export var play_rate: float = 0.6
@export var min_velocity: float = 0.5
@export var no_repeat_window: int = 4       # how many last sounds to avoid repeating
@export var pitch_variation: float = 0.12     # ±10% pitch randomisation

var last_play_time: float = 0.0
var recent_indices: Array[int] = []

@onready var player: CharacterBody3D = get_parent()

func _process(delta: float) -> void:
	if not player.is_on_floor():
		return
	
	if player.velocity.length() < min_velocity:
		return

	if Time.get_unix_time_from_system() - last_play_time < play_rate:
		return

	last_play_time = Time.get_unix_time_from_system()

	if footstep_sounds.is_empty():
		return

	# Choose a random sound index not in the recent list
	var available_indices = []
	for i in range(footstep_sounds.size()):
		if i not in recent_indices:
			available_indices.append(i)

	if available_indices.is_empty():
		recent_indices.clear()
		available_indices = range(footstep_sounds.size())

	var chosen_index = available_indices[randi() % available_indices.size()]

	# Update recent history
	recent_indices.append(chosen_index)
	if recent_indices.size() > no_repeat_window:
		recent_indices.pop_front()

	# Apply pitch variation
	pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)

	# Play chosen sound
	stream = footstep_sounds[chosen_index]
	play()
