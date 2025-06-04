extends Control
class_name MainUi

signal starter_pack_selected(starter_pack: CardPack)
signal open_shop(faction: AllyArmy.FACTIONS)
signal leave_shop()

@export var starter_packs: Array[StarterPackUi]

@onready var starter_pack_panel: Panel = $StarterPackSelection
@onready var battle_start_button: Button = $BattleStartButton
@onready var faction_shops_panel: Panel = $FactionShopsPanel
@onready var shop_leave_button: Button = $ShopLeaveButton
@onready var money_label: Label = $FactionShopsPanel/MoneyLabel
@onready var portrait_border: TextureRect = $PortraitBorder

# Event
@onready var event_panel: Panel = $EventPanel
@onready var event_title: Label = $EventPanel/EventTitle
@onready var event_description: Label = $EventPanel/EventDescription
@onready var choice_button_1: Button = $EventPanel/ChoiceButton_1
@onready var choice_button_2: Button = $EventPanel/ChoiceButton_2
@onready var choice_button_3: Button = $EventPanel/ChoiceButton_3
@onready var leave_button: Button = $EventPanel/LeaveButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for starter_pack in starter_packs:
		starter_pack.starter_pack_chosen.connect(starter_pack_chosen)
	
	starter_pack_panel.visible = true
	battle_start_button.visible = false
	faction_shops_panel.visible = false
	shop_leave_button.visible = false
	portrait_border.visible = false
	event_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func starter_pack_chosen(starter_pack: CardPack) -> void:
	starter_pack_selected.emit(starter_pack)
	starter_pack_panel.visible = false
	portrait_border.visible = true


func _on_button_pressed() -> void:
	battle_start_button.visible = false


func show_battle_start_button() -> void:
	battle_start_button.visible = true

func send_open_shop_signal(faction: AllyArmy.FACTIONS) -> void:
	open_shop.emit(faction)


func show_faction_shops_panel() -> void:
	faction_shops_panel.visible = true
	money_label.text = "$" + str(AllyArmy.money)
	shop_leave_button.visible = true


func _on_witch_shop_pressed() -> void:
	send_open_shop_signal(AllyArmy.FACTIONS.WITCHES)


func _on_devil_shop_pressed() -> void:
	send_open_shop_signal(AllyArmy.FACTIONS.DEVILS)


func _on_lich_shop_pressed() -> void:
	send_open_shop_signal(AllyArmy.FACTIONS.LICHES)


func _on_imp_shop_pressed() -> void:
	send_open_shop_signal(AllyArmy.FACTIONS.IMPS)


func _on_shop_leave_button_pressed() -> void:
	shop_leave_button.visible = false
	faction_shops_panel.visible = false
	leave_shop.emit()


func update_money() -> void:
	money_label.text = "$" + str(AllyArmy.money)


func start_event(event_data: EventManager.EventDisplayData) -> void:
	event_panel.visible = true
	event_title.text = event_data.title
	event_description.text = event_data.description
	choice_button_1.text = event_data.choice_1_text
	choice_button_2.text = event_data.choice_2_text
	choice_button_3.text = event_data.choice_3_text
	leave_button.text = event_data.leave_text
