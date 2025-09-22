extends CharacterBody2D

@export var gravity: float = 1000
var destroy = 0

func _ready():
	randi_range(-200, -600)
	var base_force = Vector2(randi_range(-600, -400), randi_range(-600, -400))
	var random_scale = randf_range(1, 1.7)
	velocity = base_force * random_scale

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
		move_and_slide()
	else:
		destroy += 1
		if destroy == 1:
			await get_tree().create_timer(2).timeout
			queue_free()



func setup(anim):
	$AnimatedSprite2D.animation = anim

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
