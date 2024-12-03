extends Control

var spawning_mode = false

var creatura = preload("res://Entity/Placeholder/Creatures/LaCreatura/LaCreatura.tscn")
var burger = preload("res://Entity/Placeholder/MapObjects/Food/Borgar/Borgar.tscn")
var selected_entity

var networkthing = NeuralNetwork.new()

func spawnFood(e):
	var pos = get_global_mouse_position()
	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(e)
	#get_parent().add_child(e)
	e.position = pos

func spawnCreature(e, team):
	var net = networkthing.createNetwork(networkthing.neuronCount, e.InputArray, e.OutputArray)
	net = networkthing.initializeRandom(net)
	var pos = get_global_mouse_position()
	e.NeuralNet = net
	get_parent().get_parent().get_parent().get_parent().get_parent().add_child(e)
	#get_parent().add_child(e)
	e.position = pos
	e.team = team
	
	if team == 0:
		e.modulate = Color(1,0,0,1)
	elif team == 1:
		e.modulate = Color(0,1,0,1)
	elif team == 2:
		e.modulate = Color(0,0,1,1)

func spawnEntity():
	if spawning_mode == true:
		if Input.is_action_just_pressed("LMB"):
			var e = selected_entity.instance()
			if e.is_in_group("Food"):
				spawnFood(e)
			elif e.is_in_group("Creature"):
				var team = $Options/Team/HSlider.value
				
				spawnCreature(e, team)
			else:
				e.queue_free()

func cancel():
	if Input.is_action_just_pressed("ui_cancel"):
		spawning_mode = false
		$Selection/Rat.visible = false
		$Selection/Burger.visible = false

func _physics_process(_delta):
	spawnEntity()
	cancel()

func _on_Rat_pressed():
	spawning_mode = true
	selected_entity = creatura
	$Selection/Rat.visible = true
	$Selection/Burger.visible = false

func _on_Burger_pressed():
	spawning_mode = true
	selected_entity = burger
	$Selection/Rat.visible = false
	$Selection/Burger.visible = true


func _on_HSlider_value_changed(value):
	$Options/Team/Value.text = str(value)
