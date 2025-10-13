extends Node

@onready var music_player = $MusicPlayer
@onready var sfx_button = $SFXButton
@onready var sfx_play = $SFXPlay

# ----------------
# MUSIC
# ----------------
func play_music(fade_time := 1.0):
	if music_player.stream == null:
		push_warning("No stream assigned to MusicPlayer.")
		return
	music_player.volume_db = -30
	music_player.play()
	var tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -12, fade_time)

func stop_music(fade_time := 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(music_player, "volume_db", -30, fade_time)
	tween.tween_callback(Callable(music_player, "stop"))

# ----------------
# SFX
# ----------------
func play_sfx_button(volume_db := -10):
	if sfx_button.stream == null:
		push_warning("No stream assigned to SFXButton.")
		return
	sfx_button.volume_db = volume_db
	sfx_button.play()

func play_sfx_play(volume_db := -12, fade_time := 1.0):
	if sfx_play.stream == null:
		push_warning("No stream assigned to SFXPlay.")
		return
	sfx_play.volume_db = volume_db
	sfx_play.play()
