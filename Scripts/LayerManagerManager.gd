extends Node

func _ready():
	update_stuff(0)

func update_stuff(level):
	for i in get_children():
		i.update_layers(level)

func _on_Player_level_up(l):
	update_stuff(l)
