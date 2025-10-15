extends RayCast3D

@onready var interact_crosshair: CenterContainer = $"../../../InteractCrosshair"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		interact_crosshair.visible = true
		if Input.is_action_just_released("action") and !global.is_dialogue_active:
			if get_collider().is_in_group("dialog"):
				Dialogic.start(get_collider().dialogue)
	else:
		interact_crosshair.visible = false
