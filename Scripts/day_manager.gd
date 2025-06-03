extends Node2D
class_name DayManager

signal precombat_started()
signal shopping_started(day: int)

enum RoundState {STARTER_DECK = 1,
				SHOP = 2,
				PRECOMBAT = 3,
				COMBAT = 4,
				POSTCOMBAT = 5,
				EVENT = 6,
				GAMEOVER = 7,
				STARTOFDAY = 8}

@export var current_day: int = 0
@export var enemy_armies: Array[EnemyArmyResource]
@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

var current_enemy_army: EnemyArmyResource

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if round_state == RoundState.COMBAT:
		check_for_winner()

func start_battle() -> void:	
	setup_armies()
	for unit_container in ally_unit_containers:
		unit_container.start_battle()
	for unit_container in enemy_unit_containers:
		unit_container.start_battle()
	

func start_new_day() -> void:
	#current_day += 1
	round_state = RoundState.STARTOFDAY


func start_precombat() -> void:
	setup_armies()


func stop_day() -> void:
	#current_day += 1
	setup_ally_army()


func setup_armies() -> void:
	setup_enemy_army()
	setup_ally_army()


func setup_enemy_army() -> void:
	var prospect_armies: Array[EnemyArmyResource]
	
	for army in enemy_armies:
		if army.day == current_day:
			prospect_armies.append(army)
	
	current_enemy_army = prospect_armies[randi_range(0, prospect_armies.size() - 1)]
	
	for i in enemy_unit_containers.size() - 1:
		var test_container_enemy = UnitContainerInfo.new(current_enemy_army.unit_types[i], current_enemy_army.unit_count[i], "Enemy")
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
		await get_tree().create_timer(1.0).timeout
		print("Combat to Postcombat")
		setup_ally_army()
		AllyArmy.money += current_enemy_army.reward_money
		round_state = RoundState.EVENT
	elif prev_state == RoundState.STARTER_DECK && new_state == RoundState.PRECOMBAT:
		print("Starter to Precombat")
		precombat_started.emit()
	elif prev_state == RoundState.PRECOMBAT && new_state == RoundState.COMBAT:
		print("Precombat to Combat")
		start_battle()
	elif prev_state == RoundState.COMBAT && new_state == RoundState.GAMEOVER:
		print("GAME OVER")
	elif prev_state == RoundState.POSTCOMBAT && new_state == RoundState.EVENT:
		print("Postcombat to Event")
		print("DO EVENT STUFF (^.^)")
		start_new_day()
	elif prev_state == RoundState.EVENT && new_state == RoundState.STARTOFDAY:
		print("Event to Start of Day")
		print("DO START OF DAY STUFF")
		round_state = RoundState.SHOP
	elif prev_state == RoundState.STARTOFDAY && new_state == RoundState.SHOP:
		print("Start of Day to Shop")
		shopping_started.emit(current_day)
	elif prev_state == RoundState.SHOP && new_state == RoundState.PRECOMBAT:
		print("Shop to Precombat")
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
