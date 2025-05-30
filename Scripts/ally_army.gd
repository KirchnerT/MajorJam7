extends Node
#############################################
## This is a global class used to house
## player stats and player army information
#############################################

var unit_containers: Array[UnitContainerInfo]
var max_containers: int = 6

func _ready() -> void:
	# Set all unit containers to null
	for i in max_containers:
		unit_containers.insert(i, null)

func update_unit_container(unit_container_info: UnitContainerInfo, index: int) -> void:
	# TO DO: add safe gaurd on index so you cannot update past max_containers containers
	unit_containers[index] = unit_container_info
