extends Node2D

var is_hovered: bool = false
var draggable: bool = false
var is_inside_droppable: bool = false
var offset: Vector2 # snap location if card is within unit container and player lets go of card
var initial_pos: Vector2 # if player lets go of card and is outside of a unit container, the card will snap to it's original position
var body_ref

# hover variables
var original_size: Vector2 = Vector2(1,1)
var hovered_size: Vector2 = Vector2(1.05, 1.05)

var static_color: Color = Color.WHITE
var dragging_color: Color = Color.MEDIUM_PURPLE

@onready var card_sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	if draggable:
		if Input.is_action_just_pressed("click"):
			initial_pos = global_position
			offset = get_global_mouse_position() - global_position
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			var tween = get_tree().create_tween()
			if is_inside_droppable:
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_pos, 0.2).set_ease(Tween.EASE_OUT)
			


func _on_area_2d_mouse_entered() -> void:
	draggable = true
	hover_changed(true) # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	if Input.is_action_pressed("click"):
		return
	else:
		draggable = false
		hover_changed(false) # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.get_tree().get_nodes_in_group("droppable"):
		is_inside_droppable = true
		body.modulate = dragging_color
		body_ref = body
		  # Replace with function body.
	
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.get_tree().get_nodes_in_group("droppable"):
		is_inside_droppable = false
		body.modulate = static_color
		body_ref = body # Replace with function body.

# Slightly increases the sprite size when mouse hovers over the sprite
func hover_changed(_is_hovered: bool) -> void:
	if _is_hovered:
		scale = hovered_size 
	else:
		scale = original_size
	is_hovered = _is_hovered
