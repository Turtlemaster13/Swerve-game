extends Spatial


var oldpos
var newpos

func _ready():
	newpos = get_viewport().get_mouse_position()
		
func _process(_delta):
	oldpos = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(1):
		$robot2.rotate_y((oldpos.x - newpos.x)*.005)
		$robot2.rotate_z((oldpos.y - newpos.y)*.005)
	newpos = oldpos


func _on_Button_pressed():
	$robot2.rotation_degrees = Vector3(0,0,0)
