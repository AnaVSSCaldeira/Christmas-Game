extends Marker2D

var timer_on = false

func _process(delta):

	if timer_on:
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
