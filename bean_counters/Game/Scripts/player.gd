extends CharacterBody2D

var speed: float = 10.0
@export var bags: int = 0
@export var is_hurt = false

func _physics_process(delta):
	if is_hurt == false:
		var mouse_pos = get_viewport().get_mouse_position()

		#teleporta para o mouse
		# global_position.x = mouse_pos.x

		#tem um delay
		global_position.x = lerp(global_position.x, mouse_pos.x, delta * speed)

		move_and_slide()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if $AnimatedSprite2D.animation != "Normal" and $AnimatedSprite2D.animation != "Hurt":
			var parent = get_parent()
			parent.update_score()

func leave_bag():
	bags -= 1

	if bags > 0:
		$AnimatedSprite2D.animation = str(bags)
	else:
		bags = 0
		$AnimatedSprite2D.animation = "Normal"

func _on_area_2d_body_entered(body):
	if is_hurt == false:
		if body.is_in_group("Bags"):
			if body.get_node("AnimatedSprite2D").animation == "1":
				bags += 1
				if bags < 6:
					$AnimatedSprite2D.animation = str(bags)
					body.queue_free()
				else:
					get_parent().damage()
			elif body.get_node("AnimatedSprite2D").animation == "life":
				get_parent().healing(body)
			else:
				get_parent().damage()
