extends Node2D
class_name DayManager

signal precombat_started()
signal shopping_started(day: int)
signal event_started()

enum RoundState {STARTER_DECK = 1,
				SHOP = 2,
				PRECOMBAT = 3,
				COMBAT = 4,
				POSTCOMBAT = 5,
				EVENT = 6,
				GAMEOVER = 7,
				STARTOFDAY = 8}

@export var current_day: int = 0
@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

var current_enemy_army: EnemyArmyResource

var power_level: int = 8 # test variable to do endless mode
var should_mix_units: bool = false
@export var power_level_scaling: Curve
@export var units: Array[UnitResource]

var round_state: RoundState = RoundState.STARTER_DECK:
	get:
		return round_state
	set(value):
		var prev_state = round_state
		round_state = value
		round_state_transition(prev_state, round_state)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	for i in ally_unit_containers.size():
		ally_unit_containers[i].index = i
	
	for i in enemy_unit_containers.size():
		enemy_unit_containers[i].is_enemy_container = true
	
	current_enemy_army = get_new_enemy_army()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_state == RoundState.COMBAT:
		check_for_winner()

func start_battle() -> void:
	for unit_container in ally_unit_containers:
		unit_container.start_battle()
	for unit_container in enemy_unit_containers:
		unit_container.start_battle()
	

func start_new_day() -> void:
	current_day += 1
	increase_power_level()
	current_enemy_army = get_new_enemy_army()
	round_state = RoundState.SHOP


func increase_power_level() -> void:
	print("Increasing Power Level: " + str(power_level) + " --> " + str(power_level + (power_level * power_level_scaling.sample(current_day / 100.0))))
	power_level += (power_level * power_level_scaling.sample(current_day / 100.0))


func get_new_enemy_army() -> EnemyArmyResource:
	var new_army: EnemyArmyResource = EnemyArmyResource.new()
	new_army.faction = randi_range(0, 3)
	
	var units_in_faction: Array[UnitResource] = []
	
	for unit in units:
		if unit.faction == new_army.faction:
			units_in_faction.append(unit)
	
	units_in_faction.shuffle()
	
	while(new_army.power_level < power_level):
		for i in new_army.units.size():
			#var cur_container: UnitResource = new_army.unit_types[i]
			#var cur_num_container: int = new_army.unit_count[i]
			var cur_unit_array: EnemyArmyResource.UnitArray = new_army.units[i]
			
			if cur_unit_array.unit_type == null:
				# get random unit types
				var random_unit: UnitResource = units_in_faction[randi_range(0, units_in_faction.size() - 1)]
				
				# add random number of them up to power level
				var max_units_to_add: int = ((power_level - new_army.power_level) / random_unit.unit_power_value)
				var num_units_to_add: int = randi_range(0, max_units_to_add)
				if num_units_to_add == 0 && new_army.power_level < power_level:
					num_units_to_add = 1
				
				if num_units_to_add > 0:
					new_army.units[i] = cur_unit_array
					cur_unit_array.unit_type = random_unit
					cur_unit_array.unit_count = num_units_to_add
					new_army.power_level += (num_units_to_add * random_unit.unit_power_value)
			else:
				# add random number of them up to power level
				var max_units_to_add: int = ((power_level  - new_army.power_level)/ cur_unit_array.unit_type.unit_power_value)
				var num_units_to_add: int = randi_range(0, max_units_to_add)
				
				if num_units_to_add == 0 && new_army.power_level < power_level:
					num_units_to_add = 1
				
				if num_units_to_add > 0:
					new_army.units[i] = cur_unit_array
					cur_unit_array.unit_count = num_units_to_add
					new_army.power_level += (num_units_to_add * cur_unit_array.unit_type.unit_power_value)	
	
	return new_army


func start_precombat() -> void:
	setup_armies()


func setup_armies() -> void:
	setup_enemy_army()
	setup_ally_army()


func setup_enemy_army() -> void:
	current_enemy_army.units.shuffle()
	for i in enemy_unit_containers.size() - 1:
		var cur_unit_array: EnemyArmyResource.UnitArray = current_enemy_army.units[i]
		var test_container_enemy = UnitContainerInfo.new(cur_unit_array.unit_type, cur_unit_array.unit_count, "Enemy")
		enemy_unit_containers[i].update_unit_container(test_container_enemy)


# Set all unit containers with all unit info found in AllyArmy globals
func setup_ally_army() -> void:
	for i in ally_unit_containers.size():
		ally_unit_containers[i].update_unit_container(AllyArmy.unit_containers[i])


func is_actively_adding_unit(active: bool, shop_card: ShopCard) -> void:
	for unit_container in ally_unit_containers:
		unit_container.is_actively_adding_unit(active, shop_card)


func check_for_winner() -> void:
		var all_allies: Array[Node] = get_tree().get_nodes_in_group("Ally")
		var all_enemies: Array[Node] = get_tree().get_nodes_in_group("Enemy")
		
		if all_allies.size() == 0:
			round_state = RoundState.GAMEOVER
		elif all_enemies.size() == 0:
			round_state = RoundState.POSTCOMBAT


func round_state_transition(prev_state: RoundState, new_state: RoundState) -> void:
	if prev_state == RoundState.COMBAT && new_state == RoundState.POSTCOMBAT:
		AllyArmy.current_law = Enums.LawEffects.NONE
		print("EVENT SET IN ALLY ARMY: " + str(AllyArmy.current_law))
		await get_tree().create_timer(1.0).timeout
		print("Combat to Postcombat")
		setup_ally_army()
		
		var random_extra_reward: float = randi_range(-30, 30) / (current_enemy_army.reward_phylux as float)
		print(random_extra_reward)
		AllyArmy.phylux += current_enemy_army.reward_phylux + random_extra_reward
		round_state = RoundState.EVENT
	elif prev_state == RoundState.STARTER_DECK && new_state == RoundState.PRECOMBAT:
		print("Starter to Precombat")
		start_precombat()
		precombat_started.emit()
	elif prev_state == RoundState.PRECOMBAT && new_state == RoundState.COMBAT:
		print("Precombat to Combat")
		start_battle()
	elif prev_state == RoundState.COMBAT && new_state == RoundState.GAMEOVER:
		get_tree().change_scene_to_file("res://Scenes/game_over_screen.tscn")
	elif prev_state == RoundState.POSTCOMBAT && new_state == RoundState.EVENT:
		print("Postcombat to Event")
		event_started.emit()
	elif prev_state == RoundState.EVENT && new_state == RoundState.STARTOFDAY:
		print("EVENT SET IN ALLY ARMY: " + str(AllyArmy.current_law))
		print("Event to Start of Day")
		print("DO START OF DAY STUFF")
		start_new_day()
	elif prev_state == RoundState.STARTOFDAY && new_state == RoundState.SHOP:
		print("Start of Day to Shop")
		shopping_started.emit(current_day)
	elif prev_state == RoundState.SHOP && new_state == RoundState.PRECOMBAT:
		print("Shop to Precombat")
		start_precombat()
		precombat_started.emit()
	else:
		print("STATE TRANSITION NOT NOTED: " + str(prev_state) + " --> " + str(new_state))


func leave_shop() -> void:
	round_state = RoundState.PRECOMBAT


func all_packed_cards_used() -> void:
	if round_state == RoundState.STARTER_DECK:
		round_state = RoundState.PRECOMBAT


func _on_battle_start_button_pressed() -> void:
	round_state = RoundState.COMBAT


func end_event() -> void:
	round_state = RoundState.STARTOFDAY
