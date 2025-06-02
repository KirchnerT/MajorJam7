extends Node2D
class_name UnitsNode

######################################################
## Node that stores unit scenes and handles how units
## are intially displayed
######################################################

var cube_size: float = 64


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Takes in a container of units and overwrites previous units
# Use ONLY for scene initial loading from AllyArmy.gd global script
func update_units(info: UnitContainerInfo) -> void:
	for i in get_children():
		i.queue_free()
		remove_child(i)
	
	for i in info.unit_count:
		var scene = info.unit_resource.unit_packed_scene.instantiate()
		add_child(scene)
		scene.add_to_group(info.unit_group, true)
	
	distribute_units_in_square(cube_size, position)

func start_battle() -> void:
	for child in get_children():
		child.activate()


func end_battle() -> void:
	for child in get_children():
		child.deactivate()


# Nicifies all units in the specified space. DO NOT TOUCH
func distribute_units_in_square(square_size: float, center_position: Vector2):
	var units_array = get_children()
	var total_units = units_array.size()
	
	if total_units == 0:
		return
	
	# Calculate grid size (rows and columns)
	var columns = ceil(sqrt(total_units))
	var rows = ceil(total_units / columns)
	
	# Size of each cell
	var cell_width = square_size / columns
	var cell_height = square_size / rows
	
	# Top-left corner of the square
	var start_x = center_position.x - square_size / 2
	var start_y = center_position.y - square_size / 2
		
	for i in range(total_units):
		var row: int = i / columns
		var col = i % int(columns)
		
		# Position in center of the cell
		var x = start_x + col * cell_width + cell_width / 2
		var y = start_y + row * cell_height + cell_height / 2
		units_array[i].position = Vector2(x, y)
