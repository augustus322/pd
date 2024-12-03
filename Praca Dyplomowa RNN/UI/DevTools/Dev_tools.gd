extends Control

var enabled = false
var spawning_mode = false
var ammount = 0
var food_spawning_mode = false

var networkthing = NeuralNetwork.new()
var creatura = preload("res://Entity/Placeholder/Creatures/LaCreatura/LaCreatura.tscn")
var borga = preload("res://Entity/Placeholder/MapObjects/Food/Borgar/Borgar.tscn")

func spawnCreatura(team):
	var e = creatura.instance()
	var net = networkthing.createNetwork(networkthing.neuronCount, e.InputArray, e.OutputArray)
	net = networkthing.initializeRandom(net)
	var pos = get_global_mouse_position()
	e.NeuralNet = net
	get_parent().get_parent().get_parent().add_child(e)
	e.position = pos
	e.team = team
	
	if team == 0:
		e.modulate = Color(1,0,0,1)
	elif team == 1:
		e.modulate = Color(0,1,0,1)
	elif team == 2:
		e.modulate = Color(0,0,1,1)

var neco_count = 0
func spawnEntity():
	if food_spawning_mode == true:
		spawning_mode = false
		$UI/ColorRect2/mode.visible = false
		if $UI/ColorRect2/CheckBox.pressed == true:
			if Input.is_action_pressed("LMB"):
				var f = borga.instance()
				var pos = get_global_mouse_position()
				get_parent().get_parent().get_parent().add_child(f)
				f.position = pos
				
		elif $UI/ColorRect2/CheckBox.pressed == false:
			if Input.is_action_just_pressed("LMB"):
				var f = borga.instance()
				var pos = get_global_mouse_position()
				get_parent().get_parent().get_parent().add_child(f)
				f.position = pos
	
	if spawning_mode == true:
		food_spawning_mode = false
		$UI/ColorRect2/food/mode.visible = false
		if $UI/ColorRect2/CheckBox.pressed == true:
			if Input.is_action_pressed("LMB"):
				spawnCreatura($UI/ColorRect2/team.value)
				neco_count += 1
				$UI/ColorRect2/Label2.text = str(neco_count)
		elif $UI/ColorRect2/CheckBox.pressed == false:
			if Input.is_action_just_pressed("LMB"):
				spawnCreatura($UI/ColorRect2/team.value)
				neco_count += 1
				$UI/ColorRect2/Label2.text = str(neco_count)

func toggleTools():
	if Input.is_action_just_pressed("ui_cancel"):
		spawning_mode = false
		food_spawning_mode = false
		$UI/ColorRect2/mode.visible = false
		$UI/ColorRect2/food/mode.visible = false
		#$UI/Crosshair.visible = false
	if Input.is_action_just_pressed("dev_tools"):
		if enabled == false:
			enabled = true
			$UI.visible = true
			print("enable")
		else:
			enabled = false
			$UI.visible = false
			spawning_mode = false
			food_spawning_mode = false
			#$UI/Crosshair.visible = false
			print("disable")
		print("toggle")

func _physics_process(_delta):
	toggleTools()
	spawnEntity()
	set_time_scale()
	
	#print($UI/Crosshair.position)


func _on_Button_pressed():
	spawning_mode = true
	#$UI/Crosshair.visible = true
	$UI/ColorRect2/mode.visible = true

func _on_SpinBox_changed():
	pass # Replace with function body.

func set_time_scale():
	#var interpolation = Engine.time_scale + (time_scale_target_value - Engine.time_scale) * 0.005
	#Engine.time_scale = interpolation
#	
	Engine.time_scale = time_scale_target_value
	$UI/ColorRect2/timescale/Label2.text = str(Engine.time_scale)

var time_scale_target_value = 1
func _on_timescaleN_value_changed(value):
	time_scale_target_value = value
	print(time_scale_target_value)

func _on_food_button_pressed():
	food_spawning_mode = true
	$UI/ColorRect2/food/mode.visible = true
