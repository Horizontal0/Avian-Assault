extends CanvasLayer

@onready var levels = $MarginContainer/VBoxContainer/level
@onready var attempts = $MarginContainer/VBoxContainer/attempts

func change_level(level):
	levels.text = "Level" + str(level)

func change_attempts(attempt):
	attempts.text = "Attempts : " + str(attempt)
