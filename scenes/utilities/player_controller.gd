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

# stairs
const MAX_STEP_HEIGHT = 0.75
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF

@onready var head: Node3D = $head
@onready var camera: Camera3D = $head/Camera3D
@onready var spotlight_front: SpotLight3D = $head/Camera3D/front_spotlight
@onready var spotlight_back: SpotLight3D = $head/equipment/move_cam2/back_spotlight

@onready var top_ray_cast: RayCast3D = $TopRayCast
@onready var bottom_ray_cast: RayCast3D = $BottomRayCast


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * global.sensitivity)
		camera.rotate_x(-event.relative.y * global.sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	
	if event.is_action_pressed("flashlight"):
		if spotlight_front.visible:
			spotlight_front.visible = false
			spotlight_back.visible = false
		else:
			spotlight_front.visible = true
			spotlight_back.visible = true

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
	if is_on_floor() or _snapped_to_stairs_last_frame:
		_last_frame_was_on_floor = Engine.get_physics_frames()
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
	
	if !_snap_up_to_stairs_check(delta):
		move_and_slide()
		_snap_down_to_stairs_check()

func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > floor_max_angle

func _snap_up_to_stairs_check(delta) -> bool:
	if !is_on_floor() and !_snapped_to_stairs_last_frame:
		return false
	var expected_move_motion = velocity * Vector3(1, 0, 1) * delta
	var step_pos_with_clearance = global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	var down_check_result = KinematicCollision3D.new()
	if (test_move(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - global_position).y
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_position() - global_position).y > MAX_STEP_HEIGHT: 
			return false
		top_ray_cast.global_position = down_check_result.get_position() + Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		top_ray_cast.force_raycast_update()
		if top_ray_cast.is_colliding() and !is_surface_too_steep(top_ray_cast.get_collision_normal()):
			global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false

func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	
	bottom_ray_cast.force_raycast_update()
	var floor_below : bool = bottom_ray_cast.is_colliding() and !is_surface_too_steep(bottom_ray_cast.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() == _last_frame_was_on_floor
	if !is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = KinematicCollision3D.new()
		if test_move(transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			var translate_y = body_test_result.get_travel().y 
			position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_last_frame = did_snap

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	
	return pos
