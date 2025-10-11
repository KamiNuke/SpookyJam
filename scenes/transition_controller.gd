extends CanvasLayer

@onready var colorRect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func change_scene(scene: Node, next_scene_path: String):
	colorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("fadeIn")
	await animation_player.animation_finished
	
	scene.queue_free()
	var next_scene = load(next_scene_path).instantiate()
	get_tree().current_scene.add_child(next_scene)

	animation_player.play("fadeOut")
	await animation_player.animation_finished

	colorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func change_scene_to_node(node):
	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(node)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(node)
