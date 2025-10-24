extends Node3D

signal change_scene(scene: Node, next_scene_path: String)

@onready var sun: DirectionalLight3D = $Sun
@onready var spotlight_1: SpotLight3D = $light/spotlight1
@onready var spotlight_2: SpotLight3D = $light/spotlight2


@onready var player: CharacterBody3D = $PlayerController
@onready var npc_1: CharacterBody3D = $NPC1
@onready var npc_1_anims: AnimationPlayer = $NPC1/bomj/AnimationPlayer
@onready var label: Label = $Label
@onready var obstacles_to_remove_1: Node = $obstacles_to_remove1
@onready var pickle_man: CharacterBody3D = $pickle_man_path/PathFollow3D/PickleMan
@onready var pickle_man_anims: AnimationPlayer = $pickle_man_path/PathFollow3D/PickleMan/bomj/AnimationPlayer
@onready var pickle_man_path: Path3D = $pickle_man_path
@onready var pickle_man_path_follow: PathFollow3D = $pickle_man_path/PathFollow3D
@onready var final_area_3d: Area3D = $final_area3d

const DEAD_PICKLE_MAN = preload("uid://djp2bycq5xkyd")
@onready var area_to_block_path: Area3D = $area_to_block_path


var placed_cameras = 0
var can_pickle_man_walk: bool = false

signal place_camera
signal block_cameras

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var transition = get_parent().get_node("TransitionController")
	connect("change_scene", Callable(transition, "_change_scene"))
	npc_1_anims.play("talk")
	pickle_man_anims.play("talk")
	get_parent().enable_input()
	Dialogic.start("dialogue1")
	Dialogic.timeline_started.connect(func(): label.visible = false)
	Dialogic.timeline_ended.connect(func(): label.visible = true)
	Dialogic.signal_event.connect(_on_dialogic_signal_map)
	
	label.text = "Place {cams}/4 cameras".format({"cams" : placed_cameras})


func toggle_shadows() -> void:
	sun.shadow_enabled = global.is_shadows_enabled
	spotlight_1.shadow_enabled = global.is_shadows_enabled
	spotlight_2.shadow_enabled = global.is_shadows_enabled

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	toggle_shadows()
	get_tree().call_group("enemy", "target_position", player.global_transform.origin)
	
	if can_pickle_man_walk and pickle_man != null:
		pickle_man_anims.play("run")
		pickle_man_path_follow.progress += 6 * delta
		if pickle_man_path_follow.progress_ratio >= 0.9:
			pickle_man_path.queue_free()
			label.text = "find a pickle man"
			var dead_pickle = DEAD_PICKLE_MAN.instantiate()
			dead_pickle.position = Vector3(-4.443, 0.493, 2.859)
			dead_pickle.rotation = Vector3(0, 90, 0)
			add_child(dead_pickle)

#func _on_dialogic_signal(argument: String):
	#if argument == "finish_dialogue1":
		#print("Something was activated!")


func _on_place_camera() -> void:
	placed_cameras += 1
	if placed_cameras == 1:
		npc_1.queue_free()
		npc_1_anims.queue_free()
	
	label.text = "Place {cams}/4 cameras".format({"cams" : placed_cameras})
	
	if placed_cameras >= 4:
		label.text = "go to the basement"
		pickle_man.visible = true
		pickle_man.set_collision_layer_value(3, true)
		pickle_man.add_to_group("dialog")
		pickle_man.dialogue = "pickle1"
		#do stuff after all cameras are placed
		pass

func _on_dialogic_signal_map(argument: String):
	if argument == "pickle_run":
		can_pickle_man_walk = true
		pickle_man.set_collision_layer_value(3, false)
	if argument == "dead_pickle":
		obstacles_to_remove_1.queue_free()
		label.text = "Run to the basement"
		area_to_block_path.monitoring = true
		area_to_block_path.monitorable = true


func _on_final_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		emit_signal("change_scene", get_node("."), "res://scenes/levels/final_cutscene.tscn")

@onready var block_basement_2: StaticBody3D = $block_basement2

func _on_area_to_block_path_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		block_basement_2.position = Vector3(7.781, -3.107, -3.194)
		block_basement_2.rotation = Vector3(0, 0, 0)
		label.text = "Find an exit"
