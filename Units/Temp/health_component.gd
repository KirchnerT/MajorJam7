extends Node2D
class_name HealthComponent

signal unit_has_died

#Global Variables
@export var unit_health: float

# function that changes the health components health value
func take_damage(damage_taken: float) -> void:
	unit_health = unit_health - damage_taken
	
	if unit_health <= 0:
		unit_has_died.emit()
