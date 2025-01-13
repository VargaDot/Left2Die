extends Node

var peer: ENetMultiplayerPeer = null

var lobby_ip: String = ""
var lobby_port: int = 9999
var lobby_max: int = 4

var connected_peers: Array = []

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func create_server(port: int, max_players: int) -> Error:
	lobby_port = port
	lobby_max = max_players

	peer = ENetMultiplayerPeer.new()

	var error: Error = peer.create_server(lobby_port, lobby_max)
	if error != OK:
		prints("Cannot host due to error",error)
		return error

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	return error

func create_client(ip: String, port: int) -> Error:
	lobby_ip = ip
	lobby_port = port

	peer = ENetMultiplayerPeer.new()

	var error: Error = peer.create_client(lobby_ip, lobby_port)
	if error != OK:
		prints("Cannot join due to error",error)
		return error

	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	return error

func _on_peer_connected(id: int) -> void:
	prints(str(id),"Has connected")

func _on_peer_disconnected(id: int) -> void:
	prints(str(id),"Has disconnected")

### CLIENT SIGNALS

func _on_connected_to_server() -> void:
	prints("Connected to server")

func _on_connection_failed() -> void:
	prints("Couldn't connect")
