extends SpotLight3D

@export var time_to_turn_off = 3
@export var time_to_turn_on = 0.35

@onready var timer_to_disable: Timer = $TimerToDisable
@onready var timer_to_enable: Timer = $TimerToEnable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	shadow_enabled = global.is_shadows_enabled


func _on_timer_timeout() -> void:
	#visible = false if visible else true
	visible = false
	timer_to_enable.start()


func _on_timer_to_enable_timeout() -> void:
	visible = true
	timer_to_disable.start()
