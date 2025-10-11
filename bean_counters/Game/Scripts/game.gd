extends Node2D

@onready var player = $Player
@onready var score = $Score

@onready var life_count = $Control/HBoxContainer/Life/Life_count
@onready var score_count = $Control/HBoxContainer/Score/Score_count
@onready var level_count = $Control/HBoxContainer/Level/Level_count
@onready var timer_count = $"Control/HBoxContainer/Time left/Timer_count"

@onready var bag_spawner_timer = $BagSpawner/Cooldown_timer
@onready var bag_spawner = $BagSpawner

@onready var global = $"/root/global"

var wave_count = 0
var spawn_timer = 2.5
var wave_timer = 41
var player_life = 5

func _ready():
	$Pause.visible = false
	get_tree().paused = false
	score_count.text = "0"
	life_count.text = str(player_life)
	level_count.text = str(wave_count + 1)
	$Wave_timer.start(wave_timer)
	bag_spawner_timer.start(spawn_timer)
	
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
	wave_count += 1
	bag_spawner.current_wave = wave_count
	level_count.text = str(wave_count + 1)
	
	if wave_count < 4:
		await get_tree().create_timer(5).timeout
		wave_timer += 20
		spawn_timer -= 0.5
		$Wave_timer.start(wave_timer)
		bag_spawner_timer.start(spawn_timer)
	
	else:
		print("fim")

func damage():
	if player_life > 0:
		$Player/Damage.play()
		player.bags = 0

		player.is_hurt = true
		player.get_node("AnimatedSprite2D").animation = "Hurt"
		player.get_node("CollisionShape2D").disabled = true
		player.collision_layer = 2

		player_life -= 1
		life_count.text = str(player_life)
		if player_life == 0:
			game_over()
		
		await get_tree().create_timer(3).timeout

		player.is_hurt = false
		player.get_node("AnimatedSprite2D").animation = "Normal"
		player.get_node("CollisionShape2D").disabled = false
		player.collision_layer = 1

func game_over():
	bag_spawner_timer.stop()
	$Wave_timer.stop()
	restart()

func restart():
	player_life = 5
	life_count.text = str(player_life)
	score_count.text = "0"
	wave_count = 0
	level_count.text = str(wave_count + 1)
	wave_timer = 41
	spawn_timer = 2.5
	$Wave_timer.start(wave_timer)
	bag_spawner_timer.start(spawn_timer)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$Pause.visible = true
		get_tree().paused = true