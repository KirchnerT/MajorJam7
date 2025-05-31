extends Node2D
class_name AttackComponent

signal is_within_attack_range_changed(is_within_attack_range: bool)

@export var attack_damage: float

var target_unit: Node2D
var attack_range: float
var is_within_attack_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Start timer and add its signal to this script to do attack rate
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if target_unit == null:
		return
	
	var distance_to_target = get_parent().global_position.distance_to(target_unit.global_position)

	if distance_to_target <= attack_range && is_within_attack_range == false:
		is_within_attack_range = true
		is_within_attack_range_changed.emit(true)
	elif distance_to_target > attack_range && is_within_attack_range == true:
		is_within_attack_range = false
		is_within_attack_range_changed.emit(false)

func attack_target() -> void:
	# Check if target is able to be damaged (ie: has health component, or you can assume they do since they are targetable)
	#	call the targets damage function
	pass
