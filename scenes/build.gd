extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func die():
	animation_player.play("new_animation")
	
func _on_animation_player_animation_finished(anim_name):
	
	GameManager.on_break.emit()
	queue_free()
