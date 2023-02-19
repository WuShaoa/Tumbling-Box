extends Node

signal angles_ready(ax, ay, az)
# The port we will listen to
export var PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketServer.new()
var dataRx = RegEx.new()

func _ready():
	# Connect base signals to get notified of new client connections,
	# disconnections, and disconnect requests.
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	# This signal is emitted when not using the Multiplayer API every time a
	# full packet is received.
	# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
	# in a loop for each connected peer.
	_server.connect("data_received", self, "_on_data")
	# Start listening on the given port.
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)

func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected with protocol: %s" % [id, proto])

func _close_request(id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	dataRx.compile("(\\S+)\\s+(\\S+)\\s+(\\S+)")
	
	var pkt = _server.get_peer(id).get_packet()
	var data_raw = pkt.get_string_from_utf8()
	var result = dataRx.search(data_raw)
	if(result != null):
		emit_signal("angles_ready", result.get_string(1).to_float(), result.get_string(2).to_float(), result.get_string(3).to_float())
		print("Got data from client %d: %s %s %s \n" % [id, result.get_string(1), result.get_string(2), result.get_string(3)])
	

	_server.get_peer(id).put_packet(pkt)

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()


func _on_World_port_changed(new_port):
	if new_port == PORT:
		pass
	else:
		_server.stop()
		_server = WebSocketServer.new()
		# Connect base signals to get notified of new client connections,
		# disconnections, and disconnect requests.
		_server.connect("client_connected", self, "_connected")
		_server.connect("client_disconnected", self, "_disconnected")
		_server.connect("client_close_request", self, "_close_request")
		# This signal is emitted when not using the Multiplayer API every time a
		# full packet is received.
		# Alternatively, you could check get_peer(PEER_ID).get_available_packets()
		# in a loop for each connected peer.
		_server.connect("data_received", self, "_on_data")
		var err = _server.listen(new_port)
		if err != OK:
			print("Unable to start server")
			set_process(false)
