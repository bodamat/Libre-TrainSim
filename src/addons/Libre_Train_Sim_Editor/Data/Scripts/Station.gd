tool
extends Spatial

var type = "Station"
onready var world = find_parent("World")
var personsNode

export (int) var stationLength


export (int) var platformSide
export (bool) var personSystem = true
export (float) var platformHeight = 1.2
export (float) var platformStart = 2.5
export (float) var platformEnd = 4.5

export (String) var attachedRail
export (int) var onRailPosition
export (bool) var update setget setToRail
export var forward = true

var waitingPersonCount = 20
var attachedPersons = []

var rail
func _ready():
	if Engine.is_editor_hint():
		if get_parent().name == "Signals":
			return
		if get_parent().is_in_group("Rail"):
			attachedRail = get_parent().name
		var signals = find_parent("World").get_node("Signals")
		get_parent().remove_child(self)
		signals.add_child(self)
		setToRail(true)
	if not Engine.is_editor_hint():
		$MeshInstance.queue_free()
		setToRail(true)
		
		
func _process(delta):
	if rail == null:
		setToRail(true)
	
	if not Engine.editor_hint:
		handlePersons()



# warning-ignore:unused_argument
func setToRail(newvar):
	if find_parent("World") == null:
		return
	if find_parent("World").has_node("Rails/"+attachedRail) and attachedRail != "":
		rail = get_parent().get_parent().get_node("Rails/"+attachedRail)
		rail.register_signal(self.name, onRailPosition)
		self.translation = rail.get_pos_at_RailDistance(onRailPosition)
		
		
func get_scenario_data():
	return null
func set_scenario_data(d):
	return

func spawnPersonsAtBeginning():
	while(rail.visible and attachedPersons.size() < waitingPersonCount):
		spawnRandomPerson()

func handlePersons():
	if platformSide == 0:
		return
	if rail == null:
		return
	
	if rail.visible and attachedPersons.size() < waitingPersonCount:
		spawnRandomPerson()
		
func spawnRandomPerson():
	randomize()
	var person = preload("res://addons/Libre_Train_Sim_Editor/Data/Modules/Person.tscn")
	var personVI = world.personVisualInstances[int(rand_range(0, world.personVisualInstances.size()))]
	var personI = person.instance()
	personI.add_child(personVI.instance())
	personI.attachedStation = self
	personI.translation = getRandomLocationAtPlatform()
	personI.owner = world
	personsNode.add_child(personI)
	
	attachedPersons.append(personI)
	
	
func getRandomLocationAtPlatform():
	var randRailDistance = int(rand_range(onRailPosition, onRailPosition+stationLength))
	if platformSide == 1: # Left
		return rail.get_shifted_pos_at_RailDistance(randRailDistance, rand_range(platformStart, platformEnd)) + Vector3(0, platformHeight, 0)
	if platformSide == 2: ## right
		return rail.get_shifted_pos_at_RailDistance(randRailDistance, -rand_range(platformStart, platformEnd)) + Vector3(0, platformHeight, 0)
		
func setDoorPositions(doors, doorsWagon): ## Called by the train
	if doors.size() == 0:
		return
	for person in attachedPersons:
		var nearestDoorIndex = 0
		for i in range(doors.size()):
			if doors[i].worldPos.distance_to(person.translation) <  doors[nearestDoorIndex].worldPos.distance_to(person.translation):
				nearestDoorIndex = i
		person.destinationPos.append(doors[nearestDoorIndex].worldPos)
		person.transitionToWagon = true
		person.assignedDoor = doors[nearestDoorIndex]
		person.attachedWagon = doorsWagon[nearestDoorIndex]
		
		
func deregisterPerson(personToDelete):
	for i in range(attachedPersons.size()):
		if attachedPersons[i] == personToDelete:
			attachedPersons.remove(i)
			waitingPersonCount -=1
			return
			
	
