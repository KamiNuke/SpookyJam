extends CharacterBody3D

var speed
const WALK_SPEED = 1.25
const SPRINT_SPEED = 1.5

const JUMP_VELOCITY = 4.5

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.025
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const CHANGE_FOV = 1.5

@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var spotlight_3d: SpotLight3D = $head/Camera3D/Spotlight/SpotLight3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * global.sensitivity)
		camera.rotate_x(-event.relative.y * global.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	if event.is_action_pressed("flashlight"):
		if spotlight_3d.visible:
			spotlight_3d.visible = false
		else:
			spotlight_3d.visible = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			# the smaller the number the longer will be slide, basically inertia 
			const SLIDE = 10
			velocity.x = lerp(velocity.x, direction.x * speed, delta * SLIDE)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * SLIDE)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2.0)
	var target_fov = BASE_FOV + CHANGE_FOV * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	return pos
