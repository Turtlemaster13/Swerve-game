extends Node


var _error #garbage collection

var startscene = {#levels that I can switch the start to easliy 
	mainlevel = "res://level/level.tscn"
	#menu = 
	#settings = 
}

func _ready():
	#print("hello worlds")
	_error = get_tree().change_scene(startscene.mainlevel)
