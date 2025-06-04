extends Resource
class_name UnitResource

######################################################
## A resource that stores information about units
## as well as a scene for instantiation when needed
######################################################

@export var name: String
@export var faction: AllyArmy.FACTIONS
@export var texture: Texture2D
@export var cost: int
@export var initial_count: int
@export var unit_packed_scene: PackedScene
@export var unit_upgrade_count: int
@export var attack_damage: float
@export var health: float
@export var unit_power_value: int
