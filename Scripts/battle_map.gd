extends Node2D

@export var shop: Shop
@export var day_manager: DayManager
@export var ui_manager: MainUi

func _ready():
	ui_manager.starter_pack_selected.connect(_ui_manager_starter_pack_selected)
	shop.activate_adding_unit.connect(_activate_adding_unit)


func _activate_adding_unit(active: bool, shop_card: ShopCard) -> void:
	day_manager.is_actively_adding_unit(active, shop_card)

func _ui_manager_starter_pack_selected(starter_pack: CardPack) -> void:
	shop.show_starter_pack_cards(starter_pack)
