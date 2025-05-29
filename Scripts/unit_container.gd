extends Node2D
class_name UnitContainer

@onready var area_sprite: Sprite2D = $Sprite2D
@onready var units_node: UnitsNode = $UnitsNode

var unit: Node2D
var number_of_units: int

var is_hovered: bool = false
var has_unit: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	hover_changed(true)


func _on_area_2d_mouse_exited() -> void:
	hover_changed(false)

func hover_changed(_is_hovered: bool) -> void:
	area_sprite.visible = _is_hovered
	is_hovered = _is_hovered

func update_unit_container(info: UnitContainerInfo) -> void:
	units_node.update_units(info)
