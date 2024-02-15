extends Puzzle

func _on_button_pressed():
	solved.emit(time_reward)
