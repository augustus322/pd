extends Node2D

var creatura = preload("res://Entity/Placeholder/Creatures/LaCreatura/LaCreatura.tscn")
var networkthing = NeuralNetwork.new()

var input = [0,0,0,0,0,0,0]
var output = [0,0,0,0,0]

func spawnCreatura():
	var e = creatura.instance()
	
	var net = networkthing.createNetwork(networkthing.neuronCount, e.InputArray, e.OutputArray)
	net = networkthing.initializeRandom(net)
#	print("Spawning La Creatura...")
#	print("Neural network:")
#	print(net)
	
	e.NeuralNet = net
	add_child(e)
	e.position.x = 0
	e.position.y = 0
#	print("Nya")

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		spawnCreatura()
