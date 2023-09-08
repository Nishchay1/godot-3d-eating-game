extends Node

export(int) var power_requirement = 0

func update_layers(level):
	for i in get_children():
		if power_requirement <= level:
			i.set_edible(true)
			i.set_walkable(false)
