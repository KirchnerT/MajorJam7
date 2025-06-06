extends Node2D
class_name Shop

signal activate_adding_unit(active: bool, shop_card: ShopCard)
signal all_packed_cards_used()
signal swap_portrait_shop(faction: AllyArmy.FACTIONS)

@export var witch_units: Array[UnitResource]
@export var lich_units: Array[UnitResource]
@export var imp_units: Array[UnitResource]
@export var devil_units: Array[UnitResource]
@export var card_packed_scene: PackedScene
@export var card_holders: Array[ShopCardHolder]

@onready var cards_container: Node2D = $CardHolderContainer
@onready var packed_cards_container: Node2D = $PackedCardsContainer
@onready var shop_center: Node2D = $Center

var witch_shop: Array[UnitResource]
var lich_shop: Array[UnitResource]
var devil_shop: Array[UnitResource]
var imp_shop: Array[UnitResource]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cards_container.visible = false
	
	for card_holder in card_holders:
		card_holder.activate_adding_unit.connect(_activate_adding_unit)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_shop() -> void:
	visible = true
	pass


func close_shop() -> void:
	cards_container.visible = false
	for card in packed_cards_container.get_children():
		if card != null:
			card.queue_free()
	visible = false
	pass


func _activate_adding_unit(active: bool, shop_card: ShopCard) -> void:
	activate_adding_unit.emit(active, shop_card)


func show_starter_pack_cards(starter_pack: CardPack) -> void:
	var number_of_cards = randi_range(starter_pack.min_number_of_units, starter_pack.max_number_of_units) as int
	var added_cards: Array[Node2D]
	for i in number_of_cards:
		added_cards.append(add_new_card_scene(starter_pack.unit_pool[randi_range(0, starter_pack.unit_pool.size() - 1)], true))
	distribute_cards_in_square(added_cards, 500, shop_center.global_position)


func add_new_card_scene(unit_to_add: UnitResource, is_packed_card: bool) -> ShopCard:
	var new_card_scene = card_packed_scene.instantiate() as ShopCard
	new_card_scene.is_pack_card = is_packed_card
	new_card_scene.change_unit_in_card(unit_to_add)
	packed_cards_container.add_child(new_card_scene)
	new_card_scene.activate_adding_unit.connect(_activate_adding_unit)
	
	return new_card_scene

func generate_new_shop(day: int) -> void:
	print("Generating New Shop Inventory")
	witch_shop = generate_random_units_for_shop(witch_units)
	lich_shop = generate_random_units_for_shop(lich_units)
	imp_shop = generate_random_units_for_shop(imp_units)
	devil_shop = generate_random_units_for_shop(devil_units)


func generate_random_units_for_shop(potential_units: Array[UnitResource]) -> Array[UnitResource]:
	var new_shop_inventory: Array[UnitResource] = []
	
	for i in card_holders.size():
		var unit_to_add: UnitResource = potential_units[randi_range(0, potential_units.size() - 1)]
		new_shop_inventory.append(unit_to_add)
		pass
	
	return new_shop_inventory


func display_faction_shop(faction: AllyArmy.FACTIONS):
	print("Opening shop: " + str(faction))
	if faction == 0: # WITCH
		generate_faction_cards_for_shop(witch_shop)
	elif faction == 1: # LICH
		generate_faction_cards_for_shop(lich_shop)
	elif faction == 2: # IMP
		generate_faction_cards_for_shop(imp_shop)
	elif faction == 3: # DEVIL
		generate_faction_cards_for_shop(devil_shop)
	
	swap_portrait_shop.emit(faction)
	cards_container.visible = true


func generate_faction_cards_for_shop(units_to_add: Array[UnitResource]) -> void:
	
	var new_cards: Array[ShopCard] = []

	for i in units_to_add.size():
		card_holders[i].update_unit_inside_card(units_to_add[i])

# Nicifies all cards in the specified space. DO NOT TOUCH
func distribute_cards_in_square(cards_to_distribute: Array[Node2D], square_size: float, center_position: Vector2):
	var total_cards = cards_to_distribute.size()
	
	if total_cards == 0:
		return

	# Calculate grid size (rows and columns)
	var columns = total_cards
	var rows = 1
	
	# Size of each cell
	var cell_width = square_size / columns
	var cell_height = square_size / rows
	
	# Top-left corner of the square
	var start_x = center_position.x - square_size / 2
	var start_y = center_position.y - square_size / 2
		
	for i in range(total_cards):
		var row: int = i / columns
		var col = i % int(columns)
		
		# Position in center of the cell
		var x = start_x + col * cell_width + cell_width / 2
		var y = start_y + row * cell_height + cell_height / 2
		cards_to_distribute[i].position = Vector2(x, y)


func _on_pulled_cards_container_child_exiting_tree(node: Node) -> void:
	if packed_cards_container.get_children().size() - 1 <= 0:
		all_packed_cards_used.emit()
