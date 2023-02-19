extends Spatial

signal port_changed(new_port)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var save_dict = {
	"port": 9080
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var path = OS.get_executable_path()
	
	path = path.get_base_dir() + "/tumblingboxsettings.json"
	print(path)
	var save_settings = File.new()
	if not save_settings.file_exists(path):
		save_settings.open(path, File.WRITE)
		save_settings.store_line(to_json(save_dict))
		save_settings.close()
	else:
		save_settings.open(path, File.READ)
		while save_settings.get_position() < save_settings.get_len():
		# Get the saved dictionary from the next line in the save file
			var settings_data = parse_json(save_settings.get_line())
			emit_signal("port_changed", settings_data["port"] as int)
		save_settings.close()
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#todo: moving camera,
	# and change color of cube
	pass


