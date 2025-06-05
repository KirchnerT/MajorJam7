extends Control
class_name MainUi

signal starter_pack_selected(starter_pack: CardPack)
signal open_shop(faction: AllyArmy.FACTIONS)
signal leave_shop()
signal proceed_event()
signal leave_event()

@export var starter_packs: Array[StarterPackUi]

@onready var starter_pack_panel: Panel = $StarterPackSelection
@onready var battle_start_button: Button = $BattleStartButton
@onready var faction_shops_panel: Panel = $FactionShopsPanel
@onready var shop_leave_button: Button = $ShopLeaveButton
@onready var phylux_label: Label = $FactionShopsPanel/MoneyLabel
@onready var portrait: TextureRect = $FactionPortrait

# Event
@onready var event_panel: Panel = $EventPanel
@onready var event_title: Label = $EventPanel/EventTitle
@onready var event_description: RichTextLabel = $EventPanel/EventDescription
@onready var next_button: Button = $EventPanel/NextButton
@onready var leave_button: Button = $EventPanel/LeaveButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for starter_pack in starter_packs:
		starter_pack.starter_pack_chosen.connect(starter_pack_chosen)
	
	starter_pack_panel.visible = true
	battle_start_button.visible = false
	faction_shops_panel.visible = false
	shop_leave_button.visible = false
	portrait.visible = false
	event_panel.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func starter_pack_chosen(starter_pack: CardPack) -> void:
	starter_pack_selected.emit(starter_pack)
	starter_pack_panel.visible = false
	portrait.visible = true


func _on_button_pressed() -> void:
	battle_start_button.visible = false


func show_battle_start_button() -> void:
	battle_start_button.visible = true

func send_open_shop_signal(faction: AllyArmy.FACTIONS) -> void:
	open_shop.emit(faction)


func show_faction_shops_panel() -> void:
	faction_shops_panel.visible = true
	phylux_label.text = "$" + str(AllyArmy.phylux)
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


func update_phylux() -> void:
	phylux_label.text = "$" + str(AllyArmy.phylux)


func start_event(event_data: EventManager.EventDisplayData) -> void:
	event_panel.visible = true
	next_button.visible = true
	leave_button.visible = true
	
	event_title.text = event_data.title
	event_description.text = event_data.description.replace("(new_line)", "\n")
	
	if event_data.next_text == "":
		next_button.visible = false
	else:
		next_button.text = event_data.next_text
	
	if event_data.leave_text == "":
		leave_button.visible = false
	else:
		leave_button.text = event_data.leave_text


func end_event() -> void:
	event_panel.visible = false


func _on_next_button_pressed() -> void:
	proceed_event.emit()


func _on_leave_button_pressed() -> void:
	leave_event.emit()
