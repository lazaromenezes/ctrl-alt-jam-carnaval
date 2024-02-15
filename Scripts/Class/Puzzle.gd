extends Node
class_name Puzzle

signal solved(time_reward)
signal skipped(time_penalty)

@export var time_penalty: float = 30
@export var time_reward: float = 30

func skip():
	self.skipped.emit(time_penalty)
