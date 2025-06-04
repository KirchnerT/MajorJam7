extends Node
#############################################
## This is a global class used to house
## player stats and player army information
#############################################

enum FACTIONS {WITCHES, LICHES, IMPS, DEVILS}


var unit_containers: Array[UnitContainerInfo]
var max_containers: int = 6
var starter_pack: CardPack
var money: int = 0
var current_law: Enums.LawEffects = Enums.LawEffects.NONE
var unit_count: int

func _ready() -> void:
	# Set all unit containers to null
	for i in max_containers:
		unit_containers.insert(i, null)

func update_unit_container(unit_container_info: UnitContainerInfo, index: int) -> void:
	# TO DO: add safe gaurd on index so you cannot update past max_containers containers
	if unit_containers[index] != null:
		unit_count -= unit_containers[index].unit_count
	unit_count += unit_container_info.unit_count
	unit_containers[index] = unit_container_info
