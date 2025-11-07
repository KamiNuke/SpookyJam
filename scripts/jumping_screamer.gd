extends StaticBody3D

#@onready var player: CharacterBody3D = $"../../PlayerController"
var player = null

@export var speed : float = 25

var can_move: bool = false

signal finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_parent().get_node("PlayerController")
	if player == null:
		print("Error occured, Player node is %s in %s" % [player, get_node(".")])
		get_tree().quit()
	pass

func _physics_process(delta: float) -> void:
	if can_move:
		move_towards_player(delta)
	look_at(player.global_position, Vector3.UP)

func move_towards_player(delta: float) -> void:
	var direction = (player.global_position - global_position).normalized()
	
	global_translate(direction * speed * delta)


func _on_timer_timeout() -> void:
	can_move = true

func start_timer() -> void:
	$Timer.start()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("finished")
