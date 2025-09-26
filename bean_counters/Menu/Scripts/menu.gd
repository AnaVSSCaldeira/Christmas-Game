extends Node2D

@onready var screen1 = $Options_screen
@onready var screen2 = $Control_screen

func _ready():
	screen1.visible = false
	screen2.visible = false
	for button in $Control/VBoxContainer.get_children():
		button.connect("mouse_entered", Callable(self, "_on_button_hovered").bind(button))

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
	select_sound("Play")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Game/Scenes/Game.tscn")

func _on_instructions_pressed():
	if screen1.visible == true:
		screen1.visible = false
	select_sound("Instructions")
	screen2.visible = !(screen2.visible)

func _on_options_pressed():
	if screen2.visible == true:
		screen2.visible = false
	select_sound("Options")
	screen1.visible = !(screen1.visible)

func _on_exit_pressed():
	select_sound("Exit")
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

