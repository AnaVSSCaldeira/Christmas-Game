extends CharacterBody2D

@export var gravity: float = 1000

func _ready():
	randi_range(-200, -600)
	var base_force = Vector2(randi_range(-600, -400), randi_range(-600, -400))
	var random_scale = randf_range(1, 1.7)
	velocity = base_force * random_scale

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()

func setup(anim):
	$AnimatedSprite2D.animation = anim

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
