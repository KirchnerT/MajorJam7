extends Node2D

@export var current_day: int = 0
@export var enemy_armies: Array[EnemyArmyResource]
@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

var temp_soldier_resource: UnitResource = preload("res://Units/Temp_Soldier/temp_soldier_resource.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	## TEST CODE
	current_day = 1
	# Adding information to AllyArmy for testing
	var test_container = UnitContainerInfo.new(temp_soldier_resource, temp_soldier_resource.initial_count, 0, 0, 0, Vector2(1,1), "Ally")
	AllyArmy.update_unit_container(test_container, 0)
	var test_container2 = UnitContainerInfo.new(temp_soldier_resource, temp_soldier_resource.initial_count, 0, 0, 0, Vector2(1,1), "Ally")
	AllyArmy.update_unit_container(test_container2, 3)
	
	setup_armies()
	## TEST CODE
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_battle() -> void:
	pass


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
		var test_container_enemy = UnitContainerInfo.new(enemy_army.unit_types[i], enemy_army.unit_count[i], 0, 0, 0, Vector2(1,1), "Enemy")
		enemy_unit_containers[i].update_unit_container(test_container_enemy)


# Set all unit containers with all unit info found in AllyArmy globals
func setup_ally_army() -> void:
	for i in ally_unit_containers.size():
		ally_unit_containers[i].update_unit_container(AllyArmy.unit_containers[i])
