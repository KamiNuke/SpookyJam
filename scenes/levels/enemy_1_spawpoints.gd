extends Node

const ENEMY = preload("uid://dmd4syhpkdst5")

@onready var area1: Area3D = $area1
@onready var area2: Area3D = $area2
#@onready var area3: Area3D = $area3
#@onready var area4: Area3D = $area4

@onready var basement_monster_area_1: Area3D = $basement_monster_area1

func _ready() -> void:
	pass

func _on_area_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var enemy = ENEMY.instantiate()
		enemy.position = Vector3(0.6, 1, 3.2)
		get_parent().add_child(enemy)
		area1.queue_free()


func _on_area_2_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var enemy = ENEMY.instantiate()
		enemy.position = Vector3(10, 1.3, -5.6)
		get_parent().add_child(enemy)
		area2.queue_free()


func _on_basement_monster_area_1_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		var enemy = ENEMY.instantiate()
		enemy.position = Vector3(7.909, -7.107, -17.975)
		enemy.timer_left = 40
		get_parent().add_child(enemy)
		basement_monster_area_1.queue_free()
		get_parent().are_boxes1_falling = true
