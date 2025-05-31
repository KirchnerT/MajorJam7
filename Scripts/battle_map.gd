extends Node2D

@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]
@export var enemy_armies: Array[EnemyArmyResource]

var temp_soldier_resource: UnitResource = preload("res://Units/Temp/temp_soldier_resource.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## TEST CODE
	
	# Adding information to AllyArmy for testing
	var test_container = UnitContainerInfo.new(temp_soldier_resource, temp_soldier_resource.initial_count, 0, 0, 0, Vector2(1,1), "Ally")
	AllyArmy.update_unit_container(test_container, 0)
	var test_container2 = UnitContainerInfo.new(temp_soldier_resource, temp_soldier_resource.initial_count, 0, 0, 0, Vector2(1,1), "Ally")
	AllyArmy.update_unit_container(test_container2, 3)
	
	# Simulating Day X for testing
	var enemy_army = enemy_armies[0]
	for i in 5:
		var test_container_enemy = UnitContainerInfo.new(enemy_army.unit_types[i], enemy_army.unit_count[i], 0, 0, 0, Vector2(1,1), "Enemy")
		enemy_unit_containers[i].update_unit_container(test_container_enemy)
	
	## TEST CODE
	
	# Set all unit containers with all unit info found in AllyArmy globals
	for i in ally_unit_containers.size():
		ally_unit_containers[i].update_unit_container(AllyArmy.unit_containers[i])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
