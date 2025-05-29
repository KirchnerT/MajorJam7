extends Node2D

@export var ally_unit_containers: Array[UnitContainer]
@export var enemy_unit_containers: Array[UnitContainer]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var test_container = UnitContainerInfo.new(true, 44, 0, 0, 0, Vector2(1,1))
	AllyArmy.unit_container_01 = test_container

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
