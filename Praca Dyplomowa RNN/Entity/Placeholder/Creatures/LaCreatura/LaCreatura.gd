extends KinematicBody2D

#neural network object
var NeuralNet = {}

var team = 0

#input variables
var health = 20
var strength = 1
var size = 1
var numberOfAllies = 0
var numberOfEnemies = 0
var hunger = 100
var numberOfFood = 0

var lastState = 0

#input array for neural network
var InputArray = [health, strength, size, numberOfAllies, numberOfEnemies, hunger, numberOfFood, lastState]
var OutputArray = [0,0,0,0]

#function for setting state
func set_state(s):
	match s:
		0:
			#print("state 0")
			state = 0
		1:
			#print("state 1")
			state = 1
		2:
			#print("state 2")
			state = 2
		3:
			#print("state 3")
			state = 3
var state = 0

func executeState(s):
	if s==0:
		wander()
	elif s==1:
		eat()
	elif s==2:
		attack()
	elif s==3:
		runAway()

#function updating behaviour
func update():
	lastState = state
	#update inputarray
	InputArray = [health, strength, size, numberOfAllies, numberOfEnemies, hunger, numberOfFood, lastState]
	
	#run netowrk
	runNetwork(NeuralNet)
	
	#find index of max value from network outputs
	var temp = NeuralNet["Values"][1].max()
	var state_index = (NeuralNet["Values"][1]).find(temp)
	
	set_state(state_index)
	#only for visualization
	var state_name = ""
	match state_index:
		0:
			#print("state 0")
			state_name = "wander"
		1:
			#print("state 1")
			state_name = "eat"
		2:
			#print("state 2")
			state_name = "attack"
		3:
			#print("state 3")
			state_name = "run away"
	$Visualization/Panel/state.text = str(state_index, "(", state_name ,")")

func runNetwork(network):
	var result = 0

	#neuron values
	for n in network['Information']['NumberOfNeurons']:
		for i in network['Information']['NumberOfInputs']:
			result += InputArray[i] * network['Structure'][0][i][n][0]
			#result += network['Structure'][0][i][n][1]
		result += 1
		result = tanh(result)
		network['Values'][0][n] = result
#		print(network['Values'][0][n])
		result = 0
	#reset just in case
	result = 0
	#outputs
#	print("outputs")
	for o in network['Information']['NumberOfOutputs']:
		for n in network['Information']['NumberOfNeurons']:
			result += network['Values'][0][n] * network['Structure'][1][n][o][0]
			#result += network['Structure'][0][i][n][1]
		result += 1
		result = tanh(result)
		network['Values'][1][o] = result
#		print(network['Values'][1][o])
		result = 0
	return network

func _ready():
	#pass
	update()

#===================================================================
#actions
var speed = 200
var motion = Vector2()
var rng = RandomNumberGenerator.new()

func randomizeDirections():
	rng.randomize()
	var v = rng.randi_range(-1,1)
	var h = rng.randi_range(-1,1)
	return [v, h]

var vDir = 0
var hDir = 0
func wander():
	vDir = randomizeDirections()[0]
	hDir = randomizeDirections()[1]
	#randomly wanders around
	motion = Vector2(hDir, vDir) * speed
	#motion = Vector2(1,0).rotated(rotation) * speed
	#rotation_degrees += 1
	motion = motion.normalized() * speed

var closestFood = null
func eat():
	if not food_in_proximity.empty():
		#print("all food: ", food_in_proximity, " first food in list: ", food_in_proximity[0])
		if closestFood == null:
			closestFood = food_in_proximity[0]
		for food in food_in_proximity:
			if closestFood.global_position.distance_to(position) > food.global_position.distance_to(position):
				closestFood = food
		var foodVector = (closestFood.position - position).normalized()
		motion = Vector2(foodVector) * speed
		motion = motion.normalized() * speed
		
		interact(closestFood)
	#goes to closest food source and eats
	
	#print("eating")
	#pass

func attack():
	#attacks an enemy
	#print("attacking")
	pass

func runAway():
	#runs away from threat
	#print("逃げ積んだよ！")
	pass


func death():
	print("NECO IS DEAD")
	queue_free()

#===================================================================

func _process(delta):
	#wander()
	executeState(state)
	move_and_slide(motion)
	#print(state_machine.current_state)

#for now only display current state, maybe make whole network visualization
func _on_EnableVisulization_pressed():
	if $Visualization.visible == true:
		$Visualization.visible = false
	elif $Visualization.visible == false:
		$Visualization.visible = true


# detection code
var entities_in_proximity = []
var food_in_proximity = []

func _on_Detection_body_entered(body):
	#look for food
	if body.is_in_group("Borgar"):
		numberOfFood += 1
		food_in_proximity.append(body)
	
	#look for creatures
	if body.is_in_group("Creatura"):
		entities_in_proximity.append(body)
		#print("entities_in_proximity: ", entities_in_proximity)
		if body.team != team:
			numberOfEnemies += 1
		elif body.team == team:
			numberOfAllies += 1
	
	update()
	$Visualization/Panel2/Label2.text = str(numberOfEnemies)
	$Visualization/Panel2/Label3.text = str(numberOfAllies)

func _on_Detection_body_exited(body):
	if body.is_in_group("Borgar"):
		numberOfFood -= 1
	#nie dziala :(
	#entities_in_proximity.remove(body)
	if body.is_in_group("Creatura"):
		#print("entities_in_proximity: ", entities_in_proximity)
		
		if body.team != team:
			numberOfEnemies -= 1
		elif body.team == team:
			numberOfAllies -= 1
	
	update()
	$Visualization/Panel2/Label2.text = str(numberOfEnemies)
	$Visualization/Panel2/Label3.text = str(numberOfAllies)

func _on_HungerTimer_timeout():
	if hunger > 0:
		hunger -= 1
		print("hunger: ", hunger)
		update()
	else:
		if health <= 0:
			death()
		else:
			health -= 1
			print("starving, health: ", health)


func interact(object):
	if not interaction_radius.empty():
		if $ActionTimer.time_left == 0:
			if state == 1:
				print("eating", object)
				$ActionTimer.start(1)
				if hunger <= 200:
					hunger += 10
					update()

var interaction_radius = []
func _on_Interaction_body_entered(body):
	interaction_radius.append(body)

func _on_Interaction_body_exited(body):
	interaction_radius.remove(interaction_radius.find(body))
