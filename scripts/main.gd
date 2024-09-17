extends Node2D

@onready var hud = $HUD
var attempts = 0
var bird_pos : Vector2
@export var menu_scene : PackedScene
var cups = 0
var max_cup: int

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	#print(get_tree().get_nodes_in_group(GameManager.GROUP_BUILD).size())
	#print(cups)
func _ready():
	bird_pos = $bird.global_position
	GameManager.on_bird_gone.connect(respawn_bird)
	GameManager.on_attempt.connect(update_attempt)
	GameManager.on_break.connect(block_destroyed)
	max_cup = get_tree().get_nodes_in_group(GameManager.GROUP_BUILD).size()
	print(get_tree().get_nodes_in_group(GameManager.GROUP_BUILD))

func respawn_bird():
	var bird_tscn = preload("res://scenes/bird.tscn")
	var bird_instance = bird_tscn.instantiate()
	add_child(bird_instance)
	bird_instance.global_position = bird_pos

func update_attempt():
	attempts += 1
	hud.change_attempts(attempts)

func block_destroyed():
	cups += 1
	printt(cups, max_cup)
	if cups == max_cup:
		print("success")
		ScoreManager.update_score(ScoreManager.level_selected, attempts)
		get_tree().change_scene_to_packed(menu_scene)
