extends Control


var _error #garbage collection

#sliders and updating text
func _on_accel_slider_value_changed(new_accelaration):
	Globals.accelaration = new_accelaration
	set_label_text(get_node("VBoxContainer/accel_val_label"), str("accelaration: ", Globals.accelaration))
func _on_deccel_slider_value_changed(new_deccealaration):
	Globals.deccelaration = new_deccealaration
	set_label_text(get_node("VBoxContainer/deccel_val_label"), str("deccelaration: ", Globals.deccelaration))
func _on_max_speed_slider_value_changed(new_max_speed):
	Globals.max_speed = new_max_speed
	set_label_text(get_node("VBoxContainer/max_speed_val_label"), str("max speed: ", Globals.max_speed))
	Globals.update = true
func _on_turn_speed_multiplyer_slider_value_changed(new_turn_speed_multiplyer):
	Globals.turn_speed_multiplyer = new_turn_speed_multiplyer
	set_label_text(get_node("VBoxContainer/turn_speed_multiplyer_val"), str("turn speed multiplyer: ", Globals.turn_speed_multiplyer))
	
#making labels
func set_label_text(labelpath, text):
	labelpath.text = str(text)

func _ready():
	get_node("VBoxContainer/accel_slider").value = Globals.accelaration
	get_node("VBoxContainer/deccel_slider").value = Globals.deccelaration
	get_node("VBoxContainer/max_speed_slider").value = Globals.max_speed
	get_node("VBoxContainer/turn_speed_multiplyer_slider").value = Globals.turn_speed_multiplyer
	get_node("VBoxContainer/rumble_toggle").pressed = Globals.rumble
	get_node("VBoxContainer/particals_toggle").pressed = Globals.particals
	get_node("VBoxContainer/vr_toggle").pressed = Globals.vr

func _physics_process(_delta):
	if Input.is_action_just_pressed("escape"):
		self.queue_free()

func _on_Button_pressed():
	get_tree().quit()



func _on_particals_toggle_toggled(button_pressed):
	Globals.particals = button_pressed

func _on_reset_pressed():
	_error = get_tree().reload_current_scene()
	
func _on_vr_toggle_toggled(button_pressed): #toggle on and off vr
	Globals.vr = button_pressed
