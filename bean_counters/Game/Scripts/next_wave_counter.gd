extends Marker2D

var timer_on = false
var game_over = false

func _process(delta):

	if game_over:
		print("oi")
		$Countdown.stop()

	if timer_on and game_over == false:
		if int($Timer.time_left) > 0:
			$Numbers.text = str(int($Timer.time_left))
		else:
			$Numbers.text = "Go!"
	else:
		$Numbers.text = ""

func start_counter():
	$Timer.start(4)
	$Countdown.play()
	timer_on = true

func _on_timer_timeout():
	timer_on = false
