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
# var wave_timer = 10 #MUDAR
var wave_timer = 41 #Valor real
var player_life = 5
var can_pause = true

func _ready():
	setup()
	
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
	bag_spawner.current_wave = wave_count - 1
	if wave_count <= 5:
		can_pause = false
		await get_tree().create_timer(2, false).timeout
		$Next_wave_counter.start_counter()
		await get_tree().create_timer(4, false).timeout
		level_count.text = str(wave_count)
		can_pause = true
		wave_timer += 20 #MUDAR
		spawn_timer -= 0.5
		$Wave_timer.start(wave_timer)
		bag_spawner_timer.start(spawn_timer)
	
	else:
		await get_tree().create_timer(2).timeout
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$Screens_End_Game.visible = true
		$Screens_End_Game/GameOver.visible = false
		$Screens_End_Game/Winner/Win.text = "Uhuuul!\nScore: "+ score_count.text +" points!\nTry again?"
		$Screens_End_Game/Winner.visible = true

func healing(body):
	body.queue_free()
	if player_life > 0 and player_life + 1 <= 5:
		player.get_node("Heal").play()
		player_life += 1
		life_count.text = str(player_life)
		
func damage():
	if player_life > 0:
		$Player/Damage.play()
		player.bags = 0

		player.is_hurt = true
		player.get_node("AnimatedSprite2D").animation = "Hurt"
		player.get_node("CollisionShape2D").disabled = true
		player.collision_layer = 2

		player_life  = player_life - 1
		life_count.text = str(player_life)

		if player_life <= 0:
			game_over()
		
		await get_tree().create_timer(2).timeout

		player.is_hurt = false
		player.get_node("AnimatedSprite2D").animation = "Normal"
		player.get_node("CollisionShape2D").disabled = false
		player.collision_layer = 1

func game_over():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	bag_spawner_timer.stop()
	$Wave_timer.stop()
	get_tree().paused = true
	$Screens_End_Game.visible = true
	$Screens_End_Game/GameOver.visible = true
	$Screens_End_Game/Winner.visible = false

func setup():
	player_life = 1
	life_count.text = str(player_life)
	score_count.text = "0"
	wave_count = 1
	level_count.text = str(wave_count)
	wave_timer = 41 #MUDAR
	wave_timer = 3
	spawn_timer = 2.5
	$Wave_timer.start(wave_timer)
	bag_spawner_timer.start(spawn_timer)
	can_pause = true
	$Pause.visible = false
	$Screens_End_Game.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	#Botoes de pause
	for button in $Pause/Buttons.get_children():
		button.connect("mouse_entered", Callable(self, "_on_button_hovered").bind(button))
	$Pause/Close.connect("mouse_entered", Callable(self, "_on_button_hovered").bind($Pause/Close))
	
	#Botoes de fim de jogo
	for button in $Screens_End_Game/Buttons.get_children():
		button.connect("mouse_entered", Callable(self, "_on_button_hovered").bind(button))

func _input(event):
	if event.is_action_pressed("pause") and can_pause:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$Pause/VBoxContainer/SliderMusic.value = db_to_linear(AudioServer.get_bus_volume_db(1))
		$Pause/VBoxContainer/SliderSFX.value = db_to_linear(AudioServer.get_bus_volume_db(2))
		$Pause.visible = true
		get_tree().paused = true

func select_sound(root):
	var button = get_node(root)
	var sound = button.get_node("Click")
	if sound:
		sound.play()

func _on_close_pressed():
	select_sound("Pause/Close")
	$Pause.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_save_pressed():
	select_sound("Pause/Buttons/Save")
	AudioServer.set_bus_volume_db(1, linear_to_db($Pause/VBoxContainer/SliderMusic.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($Pause/VBoxContainer/SliderSFX.value))

	$"/root/global".music_vol = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"/root/global".sfx_vol = db_to_linear(AudioServer.get_bus_volume_db(2))

func _on_menu_pressed():
	select_sound("Pause/Buttons/Menu")
	await get_tree().create_timer(0.5).timeout
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Scenes/Menu.tscn")

func _on_restart_pressed():
	select_sound("Pause/Buttons/Restart")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()

func _on_button_hovered(button): #repeticao do codigo, depois melhor refatorar chamando uma função no script global
	var sound = button.get_node("Hover")
	if sound:
		sound.play()

func _on_yes_pressed():
	select_sound("Screens_End_Game/Buttons/Yes")
	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()

func _on_no_pressed():
	select_sound("Screens_End_Game/Buttons/No")
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Scenes/Menu.tscn")
