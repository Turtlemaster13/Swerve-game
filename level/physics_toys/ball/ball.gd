extends RigidBody

var shoot = false
const speed = 10
const BLUE = Color(0, 0, .55, 0)
const RED = Color(.84, .09, .09, 0)
var color = "e"
func _ready():
	self.set_as_toplevel(true)
	#self.get_tree().set()
	if shoot == true:
		apply_impulse(-transform.basis.x, transform.basis.x * speed)
		apply_impulse(-transform.basis.y, transform.basis.y * speed)
	
	if color == "e":
		var randint = randi() % 2
		if randint == 1:
			var material = $MeshInstance.get_surface_material(0).duplicate()
			material.albedo_color = BLUE
			$MeshInstance.set_surface_material(0, material)
			color = "Blue"
		elif randint == 0:
			var material = $MeshInstance.get_surface_material(0).duplicate()
			material.albedo_color = RED
			$MeshInstance.set_surface_material(0, material)
			color = "Red"
		self.add_to_group(color)
		
	if shoot == true:
		if color == "Blue":
			var material = $MeshInstance.get_surface_material(0).duplicate()
			material.albedo_color = BLUE
			$MeshInstance.set_surface_material(0, material)
			color = "Blue"
		elif color == "Red":
			var material = $MeshInstance.get_surface_material(0).duplicate()
			material.albedo_color = RED
			$MeshInstance.set_surface_material(0, material)
			color = "Red"
export (PackedScene) var Bullet

