extends Spatial

onready var animation_player = $AnimationPlayer


func _ready():
	animation_player.get_animation("moving").loop=true


func _on_Player_idle():
	animation_player.play("RESET")


func _on_Player_moving():
	animation_player.play("moving")
