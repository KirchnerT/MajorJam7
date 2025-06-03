extends UnitBase
class_name BoneChanneler

@export var skeleton_scene: PackedScene
@export var skeletons_to_spawn: int
@export var skeleton_spawn_radius: float


func _on_ability_component_use_ability() -> void:
	for i in skeletons_to_spawn:
		var new_tony = skeleton_scene.instantiate()
		new_tony.position = self.position + (_random_inside_unit_circle() * skeleton_spawn_radius)
		new_tony.rotation = rotation
		call_deferred("activate_tony", new_tony)
		
		for group in get_groups():
			new_tony.add_to_group(group)
		
		get_parent().add_child(new_tony)


func activate_tony(tony: UnitBase) -> void:
	tony.activate()

func _random_inside_unit_circle() -> Vector2:
	var theta : float = randf() * 2 * PI
	return Vector2(cos(theta), sin(theta)) * sqrt(randf())

## Radius of the circle
#var circle_radius = 75.0
## Color of the circle
#var circle_color = Color(1, 0, 0) # Red
#
#func _draw():
	## Draw the circle at the node's position.
	#draw_circle(Vector2(0, 0), circle_radius, circle_color)
