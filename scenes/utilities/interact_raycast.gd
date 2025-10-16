extends RayCast3D

@onready var interact_crosshair: CenterContainer = $"../../../InteractCrosshair"
const PLACED_CAMERA = preload("uid://bbq76bxa5xt65")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		interact_crosshair.visible = true
		if Input.is_action_just_released("action") and !global.is_dialogue_active and get_collider() != null:
			var collider = get_collider()
			if collider.is_in_group("dialog"):
				Dialogic.start(collider.dialogue)
			elif collider.is_in_group("camera"):
				var pos = collider.position
				collider.queue_free()
				var cam = PLACED_CAMERA.instantiate()
				cam.position = Vector3(pos.x, pos.y + 2.0, pos.z)
				get_parent().get_parent().get_parent().get_parent().add_child(cam)
				
	else:
		interact_crosshair.visible = false
