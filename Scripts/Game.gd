extends Spatial

export(int) var level_threshold

onready var pause_button = $Pause/PauseButton
onready var pause_pop_up = $Pause/ColorRect

onready var timer = $CountdownTimer/Timer
onready var timer_label = $CountdownTimer/Label

signal paused
signal resumed

func _process(delta):
	timer_label.text = str(timer.time_left)

func _ready():
	randomize()
	pause_pop_up.visible = false
	pause_button.visible = true

func level_complete():
	timer.stop()
	SceneChanger.change_scene("res://Scenes/LevelSelect.tscn")

func _on_Player_level_up(level):
	if level>=level_threshold:
		level_complete()

func pause():
	emit_signal("paused")
	pause_pop_up.visible = true
	pause_button.visible = false
	get_tree().paused = true

func resume():
	emit_signal("resumed")
	pause_pop_up.visible = false
	pause_button.visible = true
	get_tree().paused = false

func _on_PauseButton_pressed():
	pause()


func _on_ResumeButton_pressed():
	resume()


func _on_Player_death(_t):
	pause_button.visible=false
	pause_pop_up.visible=false


func _on_DeathScene_continued():
	pause_button.visible=true
	pause_pop_up.visible=false
