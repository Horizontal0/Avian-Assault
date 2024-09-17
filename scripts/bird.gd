extends RigidBody2D

enum BIRD_STATE {READY, DRAG, RELEASE}

@onready var _bird = $"."
@onready var _label = $Label
@onready var Arrow = $Arrow

@onready var screen_size : Vector2 = get_viewport().size

var ROTATION_OFFSET = 45
var _state = BIRD_STATE.READY
var gmp : Vector2
var start_pos : Vector2
var start_drag : Vector2
var current_drag : Vector2
var radius : float


func _ready():
	radius = screen_size.x / 4
	#print(screen_size)

func _physics_process(delta):
	gmp = get_global_mouse_position()
	if Input.is_action_pressed("click") and _state == BIRD_STATE.DRAG:
		handle_drag()
	if Input.is_action_just_released("click") and _state == BIRD_STATE.DRAG:
		handle_release()
	check_if_out()
	update_label()

func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click") and _state == BIRD_STATE.READY :
		handle_ready()

func handle_drag():
	current_drag = gmp - start_drag
	if current_drag.length() > radius:
		current_drag = current_drag.normalized() * radius
	global_position = start_pos + current_drag
	Arrow.rotation = current_drag.angle()
	Arrow.rotation_degrees -= ROTATION_OFFSET
	#Arrow.scale.x = current_drag.x/radius*0.3
	

func handle_ready():
	start_drag = gmp
	start_pos = global_position
	Arrow.show()
	_state = BIRD_STATE.DRAG

func handle_release():
	_bird.freeze = false
	_state = BIRD_STATE.RELEASE
	apply_central_impulse(current_drag*-8)
	Arrow.hide()
	GameManager.on_attempt.emit()


func update_label():
	_label.text = "%s\n%s\n%s" % [BIRD_STATE.keys()[_state],current_drag,current_drag.x/radius*0.3]
	#_label.text = "\n"

func check_if_out():
	if global_position.y > screen_size.y + 200 or global_position.x > screen_size.x:
		#print("gone")
		queue_free()
		GameManager.on_bird_gone.emit()
		


func _on_sleeping_state_changed():
	var cup = get_colliding_bodies()
	#GameManager.on_attempt.emit()
	if cup[0].has_method("die"):
		cup[0].die()
	else:
		#print("don have die")
		#var Timer1 = Timer.new()
		#add_child(Timer1)
		#Timer1.timeout.connect(run)
		await get_tree().create_timer(3).timeout
		queue_free()
		GameManager.on_bird_gone.emit()

#func run():
	#pass







