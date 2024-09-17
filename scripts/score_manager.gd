extends Node

const default_score = 999
const SCORE_PATH = "user://aviator.json"

var level_selected :int = 0
var best_score : Dictionary = {}

func _ready():
	load_score_file()

func save_score_file():
	var file = FileAccess.open(SCORE_PATH, FileAccess.WRITE)
	var best_score_json = JSON.stringify(best_score)
	file.store_string(best_score_json)
	pass

func load_score_file():
	var file = FileAccess.open(SCORE_PATH, FileAccess.READ)
	if file == null:
		save_score_file()
	else:
		var content = file.get_as_text()
		best_score = JSON.parse_string(content)
	pass

func check_n_add(level):
	level = str(level)
	if !best_score.has(level):
		best_score[level] = default_score
		
func get_best_score(level):
	level = str(level)
	check_n_add(level)
	return best_score[level]

func update_score(level, score):
	check_n_add(level)
	level = str(level)
	if best_score[level] > score:
		best_score[level] = score
		save_score_file()
