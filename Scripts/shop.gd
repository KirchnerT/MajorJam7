extends Node2D
class_name Shop

signal activate_adding_unit(active: bool, shop_card: ShopCard)

@export var cards_in_shop: Array[ShopCard]
@export var witch_units: Array[UnitResource]
@export var lich_units: Array[UnitResource]
@export var imp_units: Array[UnitResource]
@export var devil_units: Array[UnitResource]
@export var card_packed_scene: PackedScene

@onready var shop_center: Node2D = $Center


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func open_shop() -> void:
	pass


func close_shop() -> void:
	visible = false
	pass


func connect_to_card_signals() -> void:
	for card in cards_in_shop:
		card.activate_adding_unit.connect(_activate_adding_unit)


func _activate_adding_unit(active: bool, shop_card: ShopCard) -> void:
	activate_adding_unit.emit(active, shop_card)


func show_starter_pack_cards(starter_pack: CardPack) -> void:
	var number_of_cards = randi_range(starter_pack.min_number_of_units, starter_pack.max_number_of_units) as int
	
	for i in number_of_cards:
		var new_card_scene = card_packed_scene.instantiate() as ShopCard
		new_card_scene.is_pack_card = true
		new_card_scene.change_unit_in_card(starter_pack.unit_pool[randi_range(0, starter_pack.unit_pool.size() - 1)])
		add_child(new_card_scene)
		new_card_scene.activate_adding_unit.connect(_activate_adding_unit)
	
	distribute_cards_in_square(500, shop_center.global_position)


# Nicifies all cards in the specified space. DO NOT TOUCH
func distribute_cards_in_square(square_size: float, center_position: Vector2):
	var cards_in_shop = get_children()
	var total_cards = cards_in_shop.size()
	
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
		cards_in_shop[i].position = Vector2(x, y)
