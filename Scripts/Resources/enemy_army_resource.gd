extends Resource
class_name EnemyArmyResource

###########################################################
## A resource that stores information about enemy armies
## on specific days. This will give variety to what armies 
## players go up against
###########################################################

## NOTE: This resource will get more complex over time as we add leveling and other attributes

var faction: AllyArmy.FACTIONS
var day: int
var units: Array[UnitArray]
var reward_phylux: int = 15 # Amount of phylux to be earned after the battle

var power_level: int

func _init() -> void:
	for i in 6:
		units.append(UnitArray.new())

class UnitArray:
	var unit_type: UnitResource
	var unit_count: int
