extends Area3D

@export var ambient_player: AudioStreamPlayer

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _on_body_entered(body: Node):
	if body.name == "PlayerController":
		ambient_player.fade_in()

func _on_body_exited(body: Node):
	if body.name == "PlayerController":
		ambient_player.fade_out()
		
