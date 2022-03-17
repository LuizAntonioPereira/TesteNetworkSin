extends VBoxContainer

const port = 3000
export(int) var user = 4
var in_value = 0

onready var display = $Status
onready var input = $LineEdit

func _ready():
	input.connect("text_entered", self, "send_message")
	get_tree().connect("connected_to_server", self, "enter_room")
	get_tree().connect("network_peer_connected", self, "user_entered")
	get_tree().connect("network_peer_disconnected", self, "user_exited")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	$HBoxContainer/ClientButton.connect("button_up", self, "join_room")
	$HBoxContainer/ServerButton.connect("button_up", self, "host_room")

func enter_room():
	display.text = "Successfully Joined Room\n"

func leave_room():
	display.text += "Left Room\n"
	get_tree().set_network_peer(null)

func host_room():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(port, user)
	get_tree().set_network_peer(host)
	enter_room()
	display.text = "Room Created\n"

func join_room():
	var ip = $HBoxContainer/TextEdit.text
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip, port)
	get_tree().set_network_peer(host)

func user_entered(id):
	display.text += str(id) + " joined the room\n"

func user_exited(id):
	display.text += str(id) + " left the room\n"

func _server_disconnected():
	display.text += "Disconnected from Server\n"
	leave_room()

func send_message(msg):
	input.text = ""
	var id = get_tree().get_network_unique_id()
	if get_tree().is_network_server():
		#rpc("client_message", id, msg)
		#rpc_id(1,"calc", id, msg)
		#rpc("client_message", id, msg)
		pass
	else:		
		rpc_id(1,"calc", id, msg)			

remotesync func client_message(id, msg):	
	display.text += str(id) + ": " + msg + "\n"
	
remotesync func calc(id, msg):
	in_value +=1
	in_value += float(msg)
	rpc("client_message",id,str(in_value))
	#display.text += str(id) + ": " + str(in_value) + "\n"		
