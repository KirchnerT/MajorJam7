extends Resource
class_name CardPack

@export var faction: AllyArmy.FACTIONS
@export var min_number_of_units: int
@export var max_number_of_units: int

@export var unit_pool: Array[UnitResource]
