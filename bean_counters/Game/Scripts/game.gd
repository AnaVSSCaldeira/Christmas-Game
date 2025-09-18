extends Node2D

@onready var player = $Player
@onready var score = $Score

@onready var life_count = $Control/HBoxContainer/Life/Life_count
@onready var score_count = $Control/HBoxContainer/Score/Score_count
@onready var level_count = $Control/HBoxContainer/Level/Level_count
@onready var timer_count = $"Control/HBoxContainer/Time left/Timer_count"

@onready var bag_spawner_timer = $BagSpawner/Cooldown_timer

func _ready():
	score_count.text = "0"
	life_count.text = str(player.life)
	level_count.text = "1"
	$Wave_timer.start(41)
	bag_spawner_timer.start(2.5)
	
func _process(delta):
	if $Wave_timer.is_stopped() == false:
		timer_count.text = str(int($Wave_timer.time_left))
	else:
		timer_count.text = "0"

func update_score():
	if score.player_inside == true:
		score_count.text = str(int(score_count.text) + 10)
		player.leave_bag()

func _on_wave_timer_timeout():
	bag_spawner_timer.stop()

func damage():
	if player.life > 0:
		player.bags = 0

		player.is_hurt = true
		player.get_node("AnimatedSprite2D").animation = "Hurt"
		player.get_node("CollisionShape2D").disabled = true
		player.collision_layer = 2

		player.life -= 1
		life_count.text = str(player.life)
		if player.life == 0:
			game_over()
		
		await get_tree().create_timer(3).timeout

		player.is_hurt = false
		player.get_node("AnimatedSprite2D").animation = "Normal"
		player.get_node("CollisionShape2D").disabled = false
		player.collision_layer = 1

func game_over():
	print("fim de jogo")