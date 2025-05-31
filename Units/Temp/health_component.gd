extends Node2D
class_name HealthComponent

signal check_unit_is_dead(is_dead: bool)
#Global Variables
@export var unit_health: float

var is_dead: bool = false


func death() -> void: 
	check_unit_is_dead.emit(true)
	print("Unit died... for now")
	
	
	
func is_unit_dead() -> bool:
	if self.unit_health > 0:
		return false
	else:
		death()
		return true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# function that changes the health components health value
func take_damage(damage_taken: float) -> void:
	print(get_parent().name + " took " + str(damage_taken) + " damage ")
	self.unit_health = self.unit_health - damage_taken
	is_unit_dead()
	pass
