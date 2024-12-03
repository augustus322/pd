extends Camera2D

var move_speed = 5
var zoom_value = 0.1
var speed_increment = 0.5

func _physics_process(_delta):
	if Input.is_action_pressed("zoom_out"):
		zoom.x += zoom_value
		zoom.y += zoom_value
		scale.x += zoom_value
		scale.y += zoom_value
		move_speed += speed_increment
	
	if Input.is_action_pressed("zoom_in") and zoom.x > 0.2:
		zoom.x -= zoom_value
		zoom.y -= zoom_value
		scale.x -= zoom_value
		scale.y -= zoom_value
		move_speed -= speed_increment
	
	if Input.is_action_pressed("ui_right"):
		position.x += move_speed
	if Input.is_action_pressed("ui_left"):
		position.x -= move_speed
	if Input.is_action_pressed("ui_down"):
		position.y += move_speed
	if Input.is_action_pressed("ui_up"):
		position.y -= move_speed

	if Input.is_action_just_pressed("ui_select"):
		if get_tree().paused == false:
			get_tree().paused = true
			print("pause")
		elif get_tree().paused == true:
			get_tree().paused = false
			print("unpause")
