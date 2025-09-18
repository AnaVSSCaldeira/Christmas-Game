extends Area2D

@export var player_inside = false

func _on_body_entered(body: Node2D):
	if body.name == "Player":
		player_inside = true

func _on_body_exited(body: Node2D):
	if body.name == "Player":
		player_inside = false