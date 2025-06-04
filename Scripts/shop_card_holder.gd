extends Node2D
class_name ShopCardHolder

signal activate_adding_unit(active: bool, shop_card: ShopCard)

@onready var card: ShopCard = $ShopCard
@onready var name_label: Label = $CardName
@onready var cost_label: Label = $CostLabel

var devil_bought: bool = false
var imp_bought: bool = false
var lich_bought: bool = false
var witch_bought: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func update_unit_inside_card(new_unit: UnitResource) -> void:
	card.change_unit_in_card(new_unit)
	name_label.text = new_unit.name
	cost_label.text = "$" + str(card.unit_in_card.cost)


func _on_shop_card_activate_adding_unit(active: bool, shop_card: ShopCard) -> void:
	activate_adding_unit.emit(active, shop_card)
