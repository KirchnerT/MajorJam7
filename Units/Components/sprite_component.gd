extends Sprite2D
class_name SpriteComponent


@onready var player_animations: AnimationPlayer = $PlayerAnimations

func play_flash_animation() -> void:
	player_animations.play("flash")

func play_attack_animation() -> void:
	player_animations.play("attack_animation")

func play_walk_animation() -> void:
	match randi_range(1, 3):
		1:
			player_animations.play("walk_2")
		2:
			player_animations.play("walk")
		3:
			player_animations.play("walk_3")
	

func stop_walk_animation() -> void:
	player_animations.stop()
