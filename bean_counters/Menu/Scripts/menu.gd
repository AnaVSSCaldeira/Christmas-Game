extends Node2D

@onready var screen1 = $Options_screen
@onready var screen2 = $Control_screen

func _ready():
	screen1.visible = false
	screen2.visible = false
	for button in $Control/VBoxContainer.get_children():
		button.connect("mouse_entered", Callable(self, "_on_button_hovered").bind(button))

	$Options_screen/Save.connect("mouse_entered", Callable(self, "_on_button_hovered").bind($Options_screen/Save))

func _on_button_hovered(button):
	var sound = button.get_node("Hover")
	if sound:
		sound.play()

func select_sound(type_button):
	var button = get_node("Control/VBoxContainer/%s" % type_button)
	var sound = button.get_node("Click")
	if sound:
		sound.play()

func _on_play_pressed():
	$"/root/global".music_vol = db_to_linear(AudioServer.get_bus_volume_db(1))
	$"/root/global".sfx_vol = db_to_linear(AudioServer.get_bus_volume_db(2))
	select_sound("Play")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Game/Scenes/Game.tscn")

func _on_instructions_pressed():
	if screen1.visible == true:
		screen1.visible = false
	select_sound("Instructions")
	screen2.visible = !(screen2.visible)

func _on_options_pressed():
	# $Options_screen/VBoxContainer/SliderMaster.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$Options_screen/VBoxContainer/SliderMusic.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	$Options_screen/VBoxContainer/SliderSFX.value = db_to_linear(AudioServer.get_bus_volume_db(2))

	if screen2.visible == true:
		screen2.visible = false
	select_sound("Options")
	screen1.visible = !(screen1.visible)

func _on_exit_pressed():
	select_sound("Exit")
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

func _on_save_pressed():
	var button = get_node("Options_screen/Save")
	var sound = button.get_node("Click")
	if sound:
		sound.play()
	# AudioServer.set_bus_volume_db(0, linear_to_db($Options_screen/VBoxContainer/SliderMaster.value))
	AudioServer.set_bus_volume_db(1, linear_to_db($Options_screen/VBoxContainer/SliderMusic.value))
	AudioServer.set_bus_volume_db(2, linear_to_db($Options_screen/VBoxContainer/SliderSFX.value))

func _on_slider_master_mouse_exited():
	$Options_screen.release_focus()

func _on_slider_music_mouse_exited():
	$Options_screen.release_focus()

func _on_slider_sfx_mouse_exited():
	$Options_screen.release_focus()
