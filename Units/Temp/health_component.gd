extends Node2D
class_name HealthComponent

#
# add custom signal here to state that the health went below 0
#

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# function that changes the health components health value
func take_damage(damage_taken: float) -> void:
	print(get_parent().name + " took " + str(damage_taken) + " damage ")
	# call signal above if unit has died
	pass
