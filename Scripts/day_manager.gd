extends Node2D
class_name DayManager

enum RoundState {STARTER_DECK, SHOP, PRECOMBAT, COMBAT, POSTCOMBAT, EVENT}

@export var current_day: int = 0
@export var enemy_armies: Array[EnemyArmyResource]
@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

var temp_soldier_resource: UnitResource = preload("res://Units/Temp_Soldier/temp_soldier_resource.tres")
var temp_archer_resource: UnitResource = preload("res://Units/Temp_Archer/temp_archer_resource.tres")

var round_state: RoundState = RoundState.SHOP:
	get:
		return round_state
	set(value):
		round_state_transition(round_state, value)
		round_state = value

# Current VALID state transitions
# STARTER_DECK --> PRECOMBAT
# SHOP         --> PRECOMBAT
# PRECOMBAT    --> COMBAT
# COMBAT       --> POSTCOMBAT
# POSTCOMBAT   --> EVENT


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_state = RoundState.PRECOMBAT
	
	for i in ally_unit_containers.size():
		ally_unit_containers[i].index = i

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Test Round Start"):
		start_battle()
	
	if round_state == RoundState.COMBAT:
		check_for_winner()

func start_battle() -> void:
	round_state = RoundState.COMBAT
	
	setup_armies()
	for unit_container in ally_unit_containers:
		unit_container.start_battle()
	for unit_container in enemy_unit_containers:
		unit_container.start_battle()
	


func start_precombat() -> void:
	setup_armies()


func stop_day() -> void:
	current_day += 1
	setup_ally_army()


func setup_armies() -> void:
	setup_enemy_army()
	setup_ally_army()


func setup_enemy_army() -> void:
	var prospect_armies: Array[EnemyArmyResource]
	
	for army in enemy_armies:
		if army.day == current_day:
			prospect_armies.append(army)
	
	var enemy_army = prospect_armies[randi_range(0, prospect_armies.size() - 1)]
	
	for i in enemy_unit_containers.size() - 1:
		var test_container_enemy = UnitContainerInfo.new(enemy_army.unit_types[i], enemy_army.unit_count[i], "Enemy")
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
			round_state = RoundState.POSTCOMBAT
		elif all_enemies.size() == 0:
			round_state = RoundState.POSTCOMBAT


func round_state_transition(prev_state: RoundState, new_state: RoundState) -> void:
	print(str(prev_state) + " --> " + str(new_state))
	if prev_state == RoundState.COMBAT && new_state == RoundState.POSTCOMBAT:
		setup_ally_army()
	else:
		print("ERROR")
