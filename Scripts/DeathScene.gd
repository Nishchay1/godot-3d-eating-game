extends Control

signal continued

onready var animation_player = $AnimationPlayer
onready var death_text = $Label

func _ready():
	visible=false

func retry():
	print("Retry")
	get_tree().paused = false
	get_tree().reload_current_scene()

func level_select():
	print("Level Select")
	get_tree().paused=false
	SceneChanger.change_scene("res://Scenes/LevelSelect.tscn")

func _on_Button_pressed():
	retry()

func _on_Button2_pressed():
	level_select()

func _on_Player_death(t):
	get_tree().paused = true
	death_text.text=t
	visible=true
	animation_player.play("death")
