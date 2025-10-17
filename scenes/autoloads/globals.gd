extends Node

#at default resolution use 0.0025
var sensitivity = 0.008
var volume_db := 0.0 

var is_dialogue_active: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.get_name() == "Web":
		sensitivity = 0.0125 #WEB Sensitivity for some reason should be smaller
	else:
		sensitivity = 0.008

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
