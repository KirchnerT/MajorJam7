extends Resource
class_name EnemyArmyResource

###########################################################
## A resource that stores information about enemy armies
## on specific days. This will give variety to what armies 
## players go up against
###########################################################

## NOTE: This resource will get more complex over time as we add leveling and other attributes

@export var day: int
@export var unit_types: Array[UnitResource] # An array that stores the unit scenes for enemies. Index 0 is grid 0 ect
@export var unit_count: Array[int] # An array that stores the number of units for the types above.
