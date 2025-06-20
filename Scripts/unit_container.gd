extends Node2D
class_name UnitContainer

######################################################
## Unit container that will handle all whole-unit based 
## movement initiated by the player (drag and drop units)
######################################################

@onready var area_sprite: Sprite2D = $Sprite2D
@onready var units_node: UnitsNode = $UnitsNode

var is_hovered: bool = false
var index: int
var is_enemy_container: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_sprite.modulate.a = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 

func _on_area_2d_mouse_entered() -> void:
	if !is_enemy_container:
		hover_changed(true)
	


func _on_area_2d_mouse_exited() -> void:
	if !is_enemy_container:
		hover_changed(false)

func hover_changed(_is_hovered: bool) -> void:
	if _is_hovered:
		area_sprite.modulate.a = 1.0
	else:
		area_sprite.modulate.a = 0.5
	is_hovered = _is_hovered


# Passthrough method to update the unit information
func update_unit_container(info: UnitContainerInfo) -> void:
	units_node.update_units(info)
	area_sprite.visible = true


func start_battle() -> void:
	units_node.start_battle()
	area_sprite.visible = false


func is_actively_adding_unit(active: bool, shop_card: ShopCard) -> void:
	if is_enemy_container:
		return
	
	var current_units: UnitContainerInfo = AllyArmy.unit_containers[index]
	if active:
		if current_units == null || shop_card.unit_in_card == current_units.unit_resource:
			area_sprite.modulate.a = 1
			return
	elif is_hovered:
		if current_units == null:
			if !shop_card.is_pack_card:
				AllyArmy.phylux -= shop_card.unit_in_card.cost
			var new_container = UnitContainerInfo.new(shop_card.unit_in_card, shop_card.unit_in_card.initial_count, "Ally")
			AllyArmy.update_unit_container(new_container, index)
			update_unit_container(new_container)
			shop_card.deactivate()
		elif current_units.unit_resource.name == shop_card.unit_in_card.name:
			if !shop_card.is_pack_card:
				AllyArmy.phylux -= shop_card.unit_in_card.cost
			current_units.unit_count += shop_card.unit_in_card.unit_upgrade_count
			AllyArmy.update_unit_container(current_units, index)
			update_unit_container(current_units)
			shop_card.deactivate()
		

	
	area_sprite.modulate.a = 0.5
