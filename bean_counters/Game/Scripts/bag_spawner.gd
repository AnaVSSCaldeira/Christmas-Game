extends Marker2D

var cooldown_wave_timer = 0
var current_wave = 0
var bags_configuration = {
	"0":{
		"range": 1,
		"spawn_chance": 100
		} , 
	"1":{
		"range": 2,
		"spawn_chance": 70
		},
	"2":{
		"range": 3,
		"spawn_chance": 50
		}, 
	"3":{
		"range": 4,
		"spawn_chance": 40
		},
	"4":{
		"range": 4,
		"spawn_chance": 30
		}
	}

func _on_cooldown_timer_timeout():
	var bag = preload("res://Game/Scenes/Bag.tscn").instantiate()

	var anim
	if randi_range(1, 100) <= bags_configuration[str(current_wave)]["spawn_chance"]:
		anim = "1"
	else:
		anim = str(randi_range(2, bags_configuration[str(current_wave)]["range"]))


	bag.setup(anim)
	add_child(bag)
