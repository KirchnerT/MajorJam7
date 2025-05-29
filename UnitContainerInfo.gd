class_name UnitContainerInfo

var unit_type: bool # Change BOOL to base unit type class
var unit_count: int
var unit_damage: float
var unit_health: float
var unit_attack_speed: float
var unit_position: Vector2

func _init(unit_type: bool, unit_count: int, unit_damage: float, unit_health: float, unit_attack_speed: float, 
		   unit_position: Vector2):
	self.unit_type = unit_type
	self.unit_count = unit_count
	self.unit_damage = unit_damage
	self.unit_health = unit_health
	self.unit_attack_speed = unit_attack_speed
	self.unit_position = unit_position
