extends KinematicBody

var min_speed = Globals.max_speed * -1
var gravity = 9.8
var balls_in_robot = 0
var last_mouse_speed = 0
var set_move = Vector3()
var resetpoint = Vector3(0,0,0)
var rotate = Vector3()
var dirinput = Vector2(0,0)
var total_speed = 0
var color = Color(0,0,0,0)
#booliens 
var intaking = false
var mouse_move = false
var hideorshow = false
var timerStart = true
#float
var camtrue = "camfield"
onready var mesh = $MeshInstance
onready var cameraplayer = $Camera
onready var shootpoint = $MeshInstance/hood/shootpoint
#lists
var colorlists = []

#onready var hud = $hud
onready var camerafield = get_tree().get_root().get_node("level").get_node("CameraField")
onready var ball = preload("res://level/physics_toys/ball/ball.tscn")
var options = preload("res://option/options_menu.tscn")
var _error #garbage collection

const max_balls_in_robot = 2

func _input(event):
	if event is InputEventMouseMotion:
		mouse_move = true
	else:
		mouse_move = false

func _physics_process(delta):
	total_speed = sqrt(pow(set_move.x, 2) + pow(set_move.z, 2))
	#Movement (forward/backward)
	#all keybord imputs
	if Input.is_action_pressed("w") or Input.is_action_pressed("left stick up"):
		movement("forward")
	elif Input.is_action_pressed("s") or Input.is_action_pressed("left stick down"):
		movement("backward")
	else:
		deccelarate("forward/back")
	#Movement (left/right)
	if Input.is_action_pressed("d") or Input.is_action_pressed("left stick right"):
		movement("right")
	elif Input.is_action_pressed("a") or Input.is_action_pressed("left stick left"):
		movement("left")
	else:
		deccelarate("left/right")
				
	#change camera
	if Input.is_action_just_pressed("c"):
		if camtrue == "camfield":
			cameraplayer.set_current(true)
			camerafield.set_current(false)
			camtrue = "camplayer"
		elif camtrue == "camplayer":
			camerafield.set_current(true)
			cameraplayer.set_current(false)
			camtrue = "camfield"
			
	#ways to turn
	#if Input.is_action_pressed("rotate right") or Input.is_action_pressed("rotate left") or Input.is_action_pressed("rotate back") or Input.is_action_just_pressed("keyboard move forward"):
	#	dirinput = Vector2(Input.get_axis("rotate back", "rotate forward"), Input.get_axis("rotate right", "rotate left"))
	#mesh.rotation.y = dirinput.angle()
		
	#	dirinput = Vector2(Input.get_axis("rotate back", "rotate forward"), Input.get_axis("rotate right", "rotate left"))
	#if int(mesh.rotation.y) < dirinput.angle():
	#	mesh.rotation.y += 1
	#elif int(mesh.rotation.y) > dirinput.angle():
	#	mesh.rotation.y -= 1
	#else:
	#	mesh.rotation.y += 0
	
	#if Input.is_action_pressed("rotate right") or Input.is_action_pressed("rotate left") or Input.is_action_pressed("rotate back") or Input.is_action_just_pressed("rotate forward"):
	#	dirinput = Vector2(Input.get_axis("rotate back", "rotate forward"), Input.get_axis("rotate right", "rotate left"))
	#	
	#	if dirinput.angle() > 0 or dirinput.angle() > 180:
	#		mesh.rotation.y += .2
	#	elif dirinput.angle() < 0 or dirinput.angle() < -180:
	#		mesh.rotation.y -= .2
	
	
	#turn right
	if Input.is_action_pressed("right stick left"):
		var turn_strength = Input.get_action_strength("right stick left")
		mesh.rotation.y -= pow(turn_strength, 2) * Globals.turn_speed_multiplyer * .5
		
	#turn left
	elif Input.is_action_pressed("right stick right"):
		var turn_strength = Input.get_action_strength("right stick right")
		mesh.rotation.y += pow(turn_strength, 2) * Globals.turn_speed_multiplyer * .5
	
	#Turning with mouse
	if Input.is_action_pressed("right click") == true:
		var turn_with_mouse_vec = Input.get_last_mouse_speed()
		if abs(turn_with_mouse_vec.x - last_mouse_speed) > 0 and mouse_move == true:
			mesh.rotation.y += turn_with_mouse_vec.x * .0005 * Globals.turn_speed_multiplyer
			mouse_move = false
			
	#reset
	if Input.is_action_just_pressed("space"):
		_error = get_tree().reload_current_scene()
		print("reset")
		
	#shoot
	if Input.is_action_just_pressed("right bumper") or Input.is_action_pressed("right click") and Input.is_action_just_pressed("left click") or Input.is_action_just_pressed("right trigger"):
		var material = $MeshInstance/hood/shootparticals.process_material
		if balls_in_robot > 0:
			if Globals.rumble == true:
				Input.start_joy_vibration(0,0,1,.09)
			print("shoot")
			var b = ball.instance()
			b.shoot = true
			b.color = colorlists[0]
			b.add_to_group(b.color)
			b.add_to_group("ball")
			colorlists.pop_at(0)
			shootpoint.add_child(b)
			if Globals.particals == true:
				if b.color == "Red":
					material.color = Color(.84, .09, .09, 0)
				elif b.color == "Blue":
					material.color = Color(0, 0, .55, 0)
				$MeshInstance/hood/shootparticals.emitting = true
			balls_in_robot -= 1
			get_node("hud/VBoxContainer/TextureProgress").value = balls_in_robot
			
	
	
	#open options menu
	if Input.is_action_just_pressed("escape"):
		if hideorshow == true:
			hideorshow = false
		else:
			hideorshow = true
			var o = options.instance()
			self.add_child(o)
		
	#start intaking 
	if Input.is_action_pressed("left bumper") or Input.is_action_pressed("shift") and Input.is_action_pressed("right click"):
		if timerStart == true:
			$Timer.set_wait_time(.30)
			$Timer.start()
			timerStart = false
		if Input.is_action_pressed("left bumper") and $Timer.is_stopped() or Input.is_action_pressed("shift") and Input.is_action_pressed("right click") and $Timer.is_stopped():
			intaking = true
		else:
			intaking = false
	else:
		intaking = false
		timerStart = true
	if intaking == true:
		get_node("MeshInstance/intake/MeshInstance").visible = true
		get_node("MeshInstance/intake").monitoring = true
		if total_speed > 10 and is_on_floor() and Globals.particals == true:
			$MeshInstance/intake/Particles.emitting = true
		else:
			$MeshInstance/intake/Particles.emitting = false
	else:
		get_node("MeshInstance/intake/MeshInstance").visible = false
		get_node("MeshInstance/intake").monitoring = false
		$MeshInstance/intake/Particles.emitting = false
		
		
	#gravity
	if not is_on_floor():
		set_move.y -= gravity * delta
	_error = move_and_slide(set_move, Vector3.UP)
	get_node("hud/VBoxContainer/TextureProgress2").value = abs(sqrt(pow(set_move.x, 2) + pow(set_move.z, 2)))

#movement
func movement(direction):
	var move_options = {
		"forward": {apply_movement = 1, axis = "x"},
		"backward": {apply_movement = -1, axis = "x"},
		"right": {apply_movement = 1, axis = "z"},
		"left": {apply_movement = -1, axis = "z"}
	}
	var move_speed = set_move[move_options[direction].axis]
	move_speed += Globals.accelaration * move_options[direction].apply_movement

	if move_speed < min_speed:
		move_speed = min_speed
	elif move_speed > Globals.max_speed:
		move_speed = Globals.max_speed
		
	set_move[move_options[direction].axis] = move_speed
	
	total_speed = sqrt(pow(set_move.x, 2) + pow(set_move.z, 2))
	if total_speed > Globals.max_speed:
		var extraction = Vector3()
		extraction = set_move.normalized() * Globals.max_speed
		set_move[move_options[direction].axis] = extraction[move_options[direction].axis]
	#imitparticals
#decelaration
func deccelarate(what_direction):
	var axis = {
		"left/right" : {axis = "z"},
		"forward/back" : {axis = "x"}
	}
	if set_move[axis[what_direction].axis] > 0:
		if set_move[axis[what_direction].axis] - Globals.deccelaration < 0:
			set_move[axis[what_direction].axis] = 0
		else:
			set_move[axis[what_direction].axis] -= Globals.deccelaration
	elif set_move[axis[what_direction].axis] < 0:
		if set_move[axis[what_direction].axis] + Globals.deccelaration > 0:
			set_move[axis[what_direction].axis] = 0
		else:
			set_move[axis[what_direction].axis] += Globals.deccelaration
			
	
	"""var total_speed = sqrt(pow(set_move.x, 2) + pow(set_move.z, 2))
	var too_fast = "-" 
	var new_speed_axis = null
	var new_speed_dir = null
	if (total_speed > max_speed):
		too_fast = "faassst"		
		if move_options[direction].axis == "x":
			new_speed_axis = "z"
		else:
			new_speed_axis = "x"
		if set_move[new_speed_axis] < 0:
			new_speed_dir = -1
		else:
			new_speed_dir = 1
		
		var new_speed_val = sqrt(pow(max_speed, 2) - pow(move_speed, 2))
		set_move[new_speed_axis] = new_speed_val * new_speed_dir
		"""
		
#intake code
func _on_Area_body_entered(body):
	if intaking == true and body.is_in_group("ball") and balls_in_robot < max_balls_in_robot:
		body.queue_free()
		print(body.get_groups())
		var tempcolor = body.get_groups().pop_at(-1)
		colorlists.append(tempcolor)
		balls_in_robot += 1
		get_node("hud/VBoxContainer/TextureProgress").value = balls_in_robot
		
		
