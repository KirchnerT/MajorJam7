extends Sprite2D
class_name SpriteComponent


@onready var player_animations: AnimationPlayer = $PlayerAnimations

func play_flash_animation() -> void:
	player_animations.play("flash")

func play_attack_animation() -> void:
	player_animations.play("attack_animation")

func play_walk_animation() -> void:
	player_animations.play("walk")
