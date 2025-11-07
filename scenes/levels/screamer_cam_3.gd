extends Node

@onready var visibile_on_screen_notifier_3d_screamer: VisibleOnScreenNotifier3D = $VisibileOnScreenNotifier3DScreamer
@onready var jumping_screamer: Node3D = $JumpingScreamer
@onready var area3d_toggle_screamer: Area3D = $ToggleScreamer

func _on_visibile_on_screen_notifier_3d_screamer_screen_entered() -> void:
	jumping_screamer.visible = true
	jumping_screamer.start_timer()
	visibile_on_screen_notifier_3d_screamer.queue_free()


func _on_toggle_screamer_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		visibile_on_screen_notifier_3d_screamer.visible = true
		area3d_toggle_screamer.queue_free()


func _on_jumping_screamer_finished() -> void:
	queue_free()
