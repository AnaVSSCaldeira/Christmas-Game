extends Node2D

@onready var screen = $Screen

func _ready():
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
	select_sound("Instructions")
	screen.visible = !(screen.visible)

func _on_options_pressed():
	select_sound("Options")
	screen.visible = !(screen.visible)

func _on_exit_pressed():
	select_sound("Exit")
	await get_tree().create_timer(0.3).timeout
	get_tree().quit()

