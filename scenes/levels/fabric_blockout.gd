extends Node3D

@onready var player: CharacterBody3D = $PlayerController
@onready var npc_1: CharacterBody3D = $NPC1
@onready var label: Label = $Label
@onready var obstacles_to_remove_1: Node = $obstacles_to_remove1
@onready var pickle_man: CharacterBody3D = $pickle_man_path/PathFollow3D/PickleMan
@onready var pickle_man_path: Path3D = $pickle_man_path
@onready var pickle_man_path_follow: PathFollow3D = $pickle_man_path/PathFollow3D

var placed_cameras = 4
var can_pickle_man_walk: bool = false

signal place_camera
signal block_cameras

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().enable_input()
	Dialogic.start("dialogue1")
	Dialogic.timeline_started.connect(func(): label.visible = false)
	Dialogic.timeline_ended.connect(func(): label.visible = true)
	Dialogic.signal_event.connect(_on_dialogic_signal_map)
	
	label.text = "Place {cams}/4 cameras".format({"cams" : placed_cameras})
	_on_place_camera()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_tree().call_group("enemy", "target_position", player.global_transform.origin)
	
	if can_pickle_man_walk and pickle_man != null:
		pickle_man_path_follow.progress += 6 * delta
		if pickle_man_path_follow.progress_ratio >= 0.9:
			pickle_man_path.queue_free()

#func _on_dialogic_signal(argument: String):
	#if argument == "finish_dialogue1":
		#print("Something was activated!")


func _on_place_camera() -> void:
	placed_cameras += 1
	if placed_cameras == 1:
		npc_1.queue_free()
	
	label.text = "Place {cams}/4 cameras".format({"cams" : placed_cameras})
	
	if placed_cameras >= 4:
		label.text = ""
		pickle_man.visible = true
		pickle_man.set_collision_layer_value(3, true)
		pickle_man.add_to_group("dialog")
		pickle_man.dialogue = "pickle1"
		#obstacles_to_remove_1.queue_free()
		#do stuff after all cameras are placed
		pass

func _on_dialogic_signal_map(argument: String):
	if argument == "pickle_run":
		can_pickle_man_walk = true
		pickle_man.set_collision_layer_value(3, false)
