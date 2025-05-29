extends Node
#############################################
## This is a global class used to house
## player stats and player army information
#############################################

## Unit Container 1
	## Unit Type
	## Unit Count
	## Unit Damage
	## Unit Health
	## Unit Attack Speed
	## Unit position
## Unit Container 2
	## Unit Type
	## Unit Count
	## Unit Damage
	## Unit Health
	## Unit Attack Speed

var unit_containers: Array[UnitContainerInfo]

func _ready() -> void:
	# Set all unit containers to null
	for i in 6:
		unit_containers.insert(i, null)

func update_unit_container(unit_container_info: UnitContainerInfo, index: int) -> void:
	# add safe gaurd on index
	unit_containers[index] = unit_container_info
