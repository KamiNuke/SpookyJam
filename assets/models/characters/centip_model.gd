extends Node3D

@export var move_speed: float = 0.0
@export var turn_speed: float = 1.0

func _on_enemy_on_spawn() -> void:
	move_speed = get_parent_node_3d().speed

#func _process(delta: float) -> void:
	
