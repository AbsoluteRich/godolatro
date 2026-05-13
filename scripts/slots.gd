extends Node2D

@onready var lever = $Lever


func _input(event):
	if event.is_action_pressed("gamble"):
		lever.play("default")
		print("test!")
