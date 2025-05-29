extends Node2D

@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

var temp_soldier_resource = "res://Units/Temp/temp_soldier_resource.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## TEST CODE
	var test_container = UnitContainerInfo.new(load(temp_soldier_resource), 4, 0, 0, 0, Vector2(1,1))
	AllyArmy.update_unit_container(test_container, 0)
	print(AllyArmy.unit_containers[0])
	## TEST CODE
	
	# Set all unit containers with all unit info found in AllyArmy globals
	for i in ally_unit_containers.size():
		ally_unit_containers[i].update_unit_container(AllyArmy.unit_containers[i])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
