extends Marker2D

var bag = preload("res://Game/Scenes/Bag.tscn")
var cooldown_wave_timer = 0

func _on_cooldown_timer_timeout():
	# bonus_cooldown_timer += 0.5 -> quando chamar uma nova wave
	#SPAWNAR OS SACOS
	var bag = preload("res://Game/Scenes/Bag.tscn").instantiate()
	var anim = "2"
	bag.setup(anim)
	add_child(bag)
	$Cooldown_timer.start()
