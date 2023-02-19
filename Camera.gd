extends Camera


# Declare member variables here. Examples:
# Declare member variables here. Examples:
var scaler = 0.03
var speed = 0.1
var mouse_relative = Vector2.ZERO
var transform_init
var _w = false
var _s = false
var _a = false
var _d = false
# Called when the node enters the scene tree for the first time.
func _ready():
	transform_init = transform


func _process(delta):
	if Input.is_action_pressed("scrool_up"):
		_w = true
	else:
		_w = false
	if Input.is_action_pressed("scrool_down"):
		_s = true
	else:
		_s = false
	if Input.is_action_pressed("scrool_left"):
		_a = true
	else:
		_a = false
	if Input.is_action_pressed("scrool_right"):
		_d= true
	else:
		_d = false
		
	mouse_relative *= scaler
	
	if(mouse_relative != Vector2.ZERO):
		var x_shift = mouse_relative.x
		var y_shift = mouse_relative.y
		rotate_y(-x_shift)
		rotate_object_local(Vector3(1,0,0), -y_shift)
	var move_dir = Vector3(_d as float - _a as float, 0, _s as float - _w as float)
	translate_object_local(move_dir.normalized() * speed)
func _input(event):
	if event is InputEventMouseButton:
		match event.button_index:
			BUTTON_RIGHT:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if event.is_pressed() else Input.MOUSE_MODE_VISIBLE
	if (event is InputEventMouseMotion) and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		mouse_relative = event.relative

func _on_Button_pressed():
	transform = transform_init
