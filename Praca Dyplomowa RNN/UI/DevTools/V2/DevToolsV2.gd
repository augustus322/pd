extends Control

var enabled = false

func toggleTools():
	if Input.is_action_just_pressed("dev_tools"):
		if enabled == false:
			enabled = true
			visible = true
			print("enable")
		else:
			enabled = false
			visible = false
			print("disable")

func _ready():
	visible = false
	enabled = false

func _physics_process(_delta):
	toggleTools()
	#$pointer.position = get_local_mouse_position()
