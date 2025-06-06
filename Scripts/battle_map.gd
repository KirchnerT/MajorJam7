extends Node2D

@onready var shop: Shop = $Shop
@onready var day_manager: DayManager = $DayManager
@onready var event_manager: EventManager = $EventManager
@onready var ui_manager: MainUi = $UI

func _ready():
	ui_manager.starter_pack_selected.connect(_ui_manager_starter_pack_selected)
	shop.activate_adding_unit.connect(_activate_adding_unit)
	day_manager.precombat_started.connect(_day_manager_precombat_started)


func _activate_adding_unit(active: bool, shop_card: ShopCard) -> void:
	day_manager.is_actively_adding_unit(active, shop_card)
	ui_manager.update_phylux()


func _ui_manager_starter_pack_selected(starter_pack: CardPack) -> void:
	shop.show_starter_pack_cards(starter_pack)
	shop.open_shop()


func _on_shop_all_packed_cards_used() -> void:
	day_manager.all_packed_cards_used()


func _day_manager_precombat_started() -> void:
	ui_manager.show_battle_start_button()
	shop.close_shop()


func _on_ui_open_shop(faction: int) -> void:
	shop.display_faction_shop(faction)
	shop.open_shop()


func _on_day_manager_shopping_started(day: int) -> void:
	shop.open_shop()
	shop.generate_new_shop(day)
	ui_manager.show_faction_shops_panel()


func _on_ui_leave_shop() -> void:
	day_manager.leave_shop()
	shop.close_shop()


func _on_day_manager_event_started() -> void:
	event_manager.attempt_event_start()


func _on_event_manager_event_ended() -> void:
	ui_manager.end_event()
	day_manager.end_event()


func _on_event_manager_start_event(event_data: EventManager.EventDisplayData) -> void:
	ui_manager.start_event(event_data)


func _on_event_manager_proceed_event(event_data: RefCounted) -> void:
	ui_manager.start_event(event_data)


func _on_ui_proceed_event() -> void:
	event_manager.proceed()


func _on_ui_leave_event() -> void:
	event_manager.end_event()


func _on_event_manager_ally_army_was_shuffled() -> void:
	day_manager.setup_ally_army()


func _on_shop_swap_portrait_shop(faction: int) -> void:
	call_deferred("update_portrait", faction)


func _on_day_manager_faction_changed(faction: int) -> void:
	call_deferred("update_portrait", faction)


func update_portrait(faction: int) -> void:
	ui_manager.update_portrait(faction)
