extends Node


var _error #garbage collection

var startscene = {
	mainlevel = "res://level/level.tscn"
	#menu = 
	#settings = 
}

func _ready():
	#print("hello worlds")
	_error = get_tree().change_scene(startscene.mainlevel)
