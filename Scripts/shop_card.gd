extends Node2D
class_name ShopCard

signal activate_adding_unit(active: bool, shop_card: ShopCard)

@onready var unit_sprite: Sprite2D = $UnitSprite
@onready var tooltip: Tooltip = $Tooltip

var is_hovered: bool = false
var offset: Vector2 # snap location if card is within unit container and player lets go of card
var initial_pos: Vector2 # if player lets go of card and is outside of a unit container, the card will snap to it's original position

var is_pack_card: bool = false
var unit_in_card: UnitResource:
	get:
		return unit_in_card
	set(value):
		unit_in_card = value
		call_deferred("update_unit_sprite", unit_in_card.texture)

var is_following: bool = false:
	get:
		return is_following
	set(value):
		if is_following != value:
			activate_adding_unit.emit(value, self)
			is_following = value

# hover variables
var original_size: Vector2 = Vector2(1,1)
var hovered_size: Vector2 = Vector2(1.05, 1.05)

var static_color: Color = Color.WHITE
var dragging_color: Color = Color.MEDIUM_PURPLE


func _process(delta: float) -> void:
	if is_hovered:
		if Input.is_action_just_pressed("click") && (AllyArmy.phylux >= unit_in_card.cost || is_pack_card):
			tooltip.deactivate_tooltip()
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
			is_following = true
		else:
			tooltip.activate_tooltip()
	else:
		tooltip.deactivate_tooltip()
		is_following = false
	if is_following:
		tooltip.deactivate_tooltip()
		if Input.is_action_pressed("click"):
				global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			#var tween = get_tree().create_tween()
			#tween.tween_property(self, "global_position", initial_pos, 0.05).set_ease(Tween.EASE_OUT)
			global_position = initial_pos
			is_following = false


func _on_area_2d_mouse_entered() -> void:
	hover_changed(true) # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	if !is_following:
		hover_changed(false) # Replace with function body.


# Slightly increases the sprite size when mouse hovers over the sprite
func hover_changed(_is_hovered: bool) -> void:
	if _is_hovered:
		scale = hovered_size 
	else:
		scale = original_size
	is_hovered = _is_hovered


func change_unit_in_card(new_unit: UnitResource) -> void:
	unit_in_card = new_unit


func update_unit_sprite(unit_texture: Texture) -> void:
	unit_sprite.texture = unit_texture


func deactivate() -> void:
	if is_pack_card:
		self.queue_free()
