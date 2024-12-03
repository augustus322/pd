class_name NeuralNetwork

var rng = RandomNumberGenerator.new()
var neuronCount = 6

func rand():
	var ran = rng.randf_range(1, -1)
	return ran

func initializeRandom(network):
	rng.randomize()
	for i in network['Information']['NumberOfInputs']:
		for n in network['Information']['NumberOfNeurons']:
			network['Structure'][0][i][n][0] = rand()
			#bias
			network['Structure'][0][i][n][1] = 1
	
	for n in network['Information']['NumberOfNeurons']:
		for o in network['Information']['NumberOfOutputs']:
			network['Structure'][1][n][o][0] = rand()
			#bias
			network['Structure'][1][n][o][1] = 1
			
	var stryng = to_json(network)
	print(stryng)
	return network

func createNetwork(neuron_count, input, output):
	var network_structure = [[],[]]
	var network_values = [[],[]]
	var temp = []
	
	for i in input:
		for n in neuron_count:
			temp.append(['1w','1b'])
		network_structure[0].append(temp)
		temp = []
	
	for o in neuron_count:
		for n in output.size():
			temp.append(['2w','2b'])
		network_structure[1].append(temp)
		temp = []
	
	for v in neuron_count:
		network_values[0].append(0)
	
	for o in output.size():
		network_values[1].append(0)
	
	var net = {
		'Information': {
			'NumberOfNeurons': neuron_count,
			'NumberOfInputs': input.size(),
			'NumberOfOutputs': output.size()
		},
		'Structure': network_structure,
		'Values': network_values
	}

	return net

func _init():
	pass
