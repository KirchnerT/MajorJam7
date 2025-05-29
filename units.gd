extends Node2D
class_name Units

@export var unit_array: Array[Node2D]

var cube_size: float = 90.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distribute_units_in_square(unit_array, cube_size, position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func distribute_units_in_square(units: Array, square_size: float, center_position: Vector2):
	var total_units = units.size()
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
		
		units[i].position = Vector2(x, y)
