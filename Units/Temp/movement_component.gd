extends Node2D
class_name MovementComponent

enum unitGroups {ALLY, ENEMY, NONE}

@export var speed: float = 10.0
@export var unit_allegience: unitGroups
@export var unit_target_faction: unitGroups
@export_enum("Closest", "Farthest", "Healthiest", "LowestHP") var unit_targeting
@export var check_target_timer: Timer

var target_unit: Node2D
var attack_range: float
var is_within_attack_range: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if attack_range == 0:
		attack_range = 20.0
	
	check_target_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if unit_allegience == 2 && get_parent().get_groups() != []:
		set_allegiance()
	
	if target_unit != null && !is_within_attack_range:
		move_towards(delta)


func set_allegiance() -> void:
	var groups: Array[StringName] = get_parent().get_groups()
	if groups[0] == "Ally":
		unit_allegience = unitGroups.ALLY
		unit_target_faction = unitGroups.ENEMY
	elif groups[0] == "Enemy":
		unit_allegience = unitGroups.ENEMY
		unit_target_faction = unitGroups.ALLY


func move_towards(delta: float) -> void:
	get_parent().global_position += get_parent().global_position.direction_to(target_unit.global_position) * speed * delta
	pass
	

func _on_timer_timeout() -> void:
	target_unit = get_new_target()
	check_target_timer.start()


func get_new_target() -> Node2D:
	if unit_targeting == null: 
		return null

	if unit_targeting == 0: # CLOSEST
		return find_closest_enemy()
	else:
		print("Targeting Style Not Implemented")
	

	return null


func find_closest_enemy() -> Node2D:
	var parent_position = get_parent().global_position
	var all_enemies = get_tree().get_nodes_in_group(get_string_of_unit_group(unit_target_faction))
	var closest_distance: float
	var closest_enemy: Node2D
	for enemy in all_enemies:
		var distance_to_enemy = parent_position.distance_to(enemy.global_position)
		if  closest_enemy == null || distance_to_enemy < closest_distance:
			closest_distance = distance_to_enemy
			closest_enemy = enemy
	
	if closest_distance <= attack_range:
		is_within_attack_range = true
	else:
		is_within_attack_range = false
	
	return closest_enemy

func get_string_of_unit_group(unit_group_number: int) -> String:
	if unit_group_number == 0: # ALLY
		return "Ally"
	elif unit_group_number == 1: # ENEMY
		return "Enemy"
	else: # NOT FOUND
		return ""
