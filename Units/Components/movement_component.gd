extends Node2D
class_name MovementComponent

enum unitGroups {ALLY, ENEMY, NONE}

signal new_target_found(closest_target: Node2D)

@export var speed: float = 10.0
@export var unit_allegience: unitGroups
@export var unit_target_faction: unitGroups
@export_enum("Closest", "Farthest", "Healthiest", "LowestHP") var unit_targeting

@onready var check_target_timer: Timer = $CheckTargetTimer

var target_unit: Node2D
var attack_range: float
var can_move: bool = true

# Taunt Variables
var is_taunted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if attack_range == 0:
		attack_range = 1.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if unit_allegience == 2 && get_parent().get_groups() != []:
		set_allegiance()
	
	if target_unit != null && can_move:
		move_towards(delta, target_unit)
	else:
		check_target_timer.stop()
		target_unit = get_new_target()
		new_target_found.emit(target_unit)
		check_target_timer.start()


func set_allegiance() -> void:
	var groups: Array[StringName] = get_parent().get_groups()
	if groups[0] == "Ally":
		unit_allegience = unitGroups.ALLY
		if AllyArmy.current_law == Enums.LawEffects.ALLYATTACK:
			unit_target_faction = unitGroups.ALLY
		else:
			unit_target_faction = unitGroups.ENEMY
	elif groups[0] == "Enemy":
		unit_allegience = unitGroups.ENEMY
		if AllyArmy.current_law == Enums.LawEffects.ALLYATTACK:
			unit_target_faction = unitGroups.ENEMY
		else:
			unit_target_faction = unitGroups.ALLY


func move_towards(delta: float, target: Node2D) -> void:
	get_parent().global_position += get_parent().global_position.direction_to(target.global_position) * speed * delta
	pass
	

func _on_timer_timeout() -> void:
	if unit_allegience != 2:
		target_unit = get_new_target()
		new_target_found.emit(target_unit)
	
	check_target_timer.start()


func get_new_target() -> Node2D:
	if unit_targeting == null:
		return null
	
	if is_taunted:
		return target_unit
	
	if unit_targeting == 0: # CLOSEST
		return find_closest_enemy()
	elif unit_targeting == 3: # LOWEST HP
		return find_lowest_hp_enemy()
	else:
		print("Targeting Style Not Implemented")
	
	return null


func find_lowest_hp_enemy() -> Node2D:
	var all_enemies = get_tree().get_nodes_in_group(get_string_of_unit_group(unit_target_faction))
	var lowest_hp: float
	var lowest_enemy: Node2D
	var self_index = all_enemies.find(self)
	if self_index != -1:
		all_enemies.remove_at(self_index)
	
	for enemy in all_enemies:
		if enemy.movement_component != self || all_enemies.size() == 1:
			var enemy_cur_health = enemy.get_cur_health()
			if  lowest_enemy == null || enemy_cur_health < lowest_hp:
				lowest_hp = enemy_cur_health
				lowest_enemy = enemy
	
	return lowest_enemy


func find_closest_enemy() -> Node2D:
	var parent_position = get_parent().global_position
	var all_enemies = get_tree().get_nodes_in_group(get_string_of_unit_group(unit_target_faction))
	var closest_distance: float
	var closest_enemy: Node2D
	
	for enemy in all_enemies:
		if enemy.movement_component != self || all_enemies.size() == 1:
			var distance_to_enemy = parent_position.distance_to(enemy.global_position)
			if  (closest_enemy == null || distance_to_enemy < closest_distance):
				closest_distance = distance_to_enemy
				closest_enemy = enemy
	
	return closest_enemy

func get_string_of_unit_group(unit_group_number: int) -> String:
	if unit_group_number == 0: # ALLY
		return "Ally"
	elif unit_group_number == 1: # ENEMY
		return "Enemy"
	else: # NOT FOUND
		return ""


func taunt_effect(is_active: bool, taunted_by: Node2D = null):
	is_taunted = is_active
	
	if !is_active:
		target_unit = get_new_target()
		new_target_found.emit(target_unit)
		check_target_timer.start()
	else:
		target_unit = taunted_by
		check_target_timer.stop()
