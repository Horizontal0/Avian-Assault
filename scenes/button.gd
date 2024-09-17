extends TextureButton

@onready var button = $"."
@onready var label = $MarginContainer/VBoxContainer/LevelLabel
@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel

@export var level : int

var HOVER_SCALE = Vector2(1.5,1.5)
var DEFAULT_SCALE = Vector2(1.3,1.3)
var scene_level

func _ready():
	scene_level = load("res://scenes/level_%s.tscn" % level)
	scale = DEFAULT_SCALE
	score_label.text = str(ScoreManager.get_best_score(level))
	
func _process(delta):
	label.text = str(level)
	#print(scale)

func _on_mouse_entered():
	scale = HOVER_SCALE

func _on_mouse_exited():
	scale = DEFAULT_SCALE

func _on_pressed():
	ScoreManager.level_selected = level
	get_tree().change_scene_to_packed(scene_level)
