extends Node3D

@onready var player: CharacterBody3D = $PlayerController

signal block_cameras

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().enable_input()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("enemy", "target_position", player.global_transform.origin)
