extends CharacterBody3D

signal on_spawn

@export var speed = 3.25
const JUMP_VELOCITY = 4.5

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var timer: Timer = $Timer
var timer_left = 5

var obsctable = false

func _ready() -> void:
	timer.start(timer_left)
	on_spawn.emit()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var next_location = nav_agent.get_next_path_position()
	var cur_location = global_transform.origin
	var direction = (next_location - cur_location).normalized()
	var new_velocity = direction * speed
	
	# rotation towards the player
	const ROTATION_SPEED = 10
	rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), ROTATION_SPEED * delta)
	
	velocity = velocity.move_toward(new_velocity, 0.25)
	move_and_slide()

func target_position(target):
	nav_agent.target_position = target

func _on_navigation_agent_3d_target_reached() -> void:
	var map = get_parent()
	if map != null and map.has_signal("block_cameras"):
		map.block_cameras.emit()
		queue_free()

func _on_navigation_agent_3d_link_reached(_details: Dictionary) -> void:
	obsctable = true

func _on_timer_timeout() -> void:
	queue_free()
