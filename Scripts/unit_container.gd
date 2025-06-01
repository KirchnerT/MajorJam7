extends Node2D
class_name UnitContainer

######################################################
## Unit container that will handle all whole-unit based 
## movement initiated by the player (drag and drop units)
######################################################

@onready var area_sprite: Sprite2D = $Sprite2D
@onready var units_node: UnitsNode = $UnitsNode

var is_hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_sprite.modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func _on_area_2d_mouse_entered() -> void:
	hover_changed(true)


func _on_area_2d_mouse_exited() -> void:
	hover_changed(false)

func hover_changed(_is_hovered: bool) -> void:
	if _is_hovered:
		area_sprite.modulate.a = 1.0
	else:
		area_sprite.modulate.a = 0.5
	is_hovered = _is_hovered


# Passthrough method to update the unit information
func update_unit_container(info: UnitContainerInfo) -> void:
	if (info == null):
		return
	
	units_node.update_units(info)
