extends Control

var level_select_path = "res://Scenes/LevelSelect.tscn"
var options_path = "res://Scenes/LevelSelect.tscn"

func _ready():
	pass

func _on_StartButton_pressed():
	SceneChanger.change_scene(level_select_path)


func _on_OptionsButton_pressed():
	SceneChanger.change_scene(options_path)
