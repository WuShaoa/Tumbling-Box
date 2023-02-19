extends Spatial


# Declare member variables here. Examples:
var old_rot = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	 pass
	 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ServerNode_angles_ready(ax, ay, az):
	#Transform().translated()
	# Z-Y-X
	var Rz = Transform().rotated(Vector3(-1,0,0), deg2rad(az))
	var Ry = Transform().rotated(Rz * Vector3(0,1,0), deg2rad(ay))
	var Rx = Transform().rotated(Ry * Rz * Vector3(0, 0, 1), deg2rad(ax))
	self.transform = Rx * Ry * Rz
	#old_rot = Vector3(alp, bet, gam)


func _on_Button_pressed():
	transform = Transform.IDENTITY
