extends Node2D

signal dungeon_completed
signal player_spawned(player: CharacterBody2D)

@onready var player: PackedScene = preload("res://scenes/characters/player.tscn")
@onready var room: PackedScene = preload("res://scenes/environment/rooms/base_room.tscn")
@onready var start_position_x: int = 0
@onready var start_position_y: int = 0
@onready var rows: int = 8
@onready var cols: int = 8
@onready var room_size: int = 168
@onready var floorplan: Array = []
@onready var rooms: int = 0
@onready var min_rooms: int = 8
@onready var max_rooms: int = 32
@onready var game_state := get_node("/root/GameState")

var enemies: int = 0

func _ready() -> void:
	var new_player: CharacterBody2D = player.instantiate()
	for i in range(rows):
		floorplan.append([])
		for j in range(cols):
			floorplan[i].append(null)
	
	dungeon_builder()
	dungeon_completed.emit()
	new_player.position = floorplan[0][0].get_child(4).position
	self.add_child(new_player)
	player_spawned.emit(new_player)
	$CanvasLayer/EnemyCounter.text = "Enemies: " + str(game_state.enemy_count)

func dungeon_builder() -> void:
	var new_room: Node2D = room.instantiate()
	new_room.position.x = start_position_x + (room_size * 0)
	new_room.position.y = start_position_y + (room_size * 0)
	floorplan[0][0] = new_room
	brancher(new_room, 0, 0)
	self.add_child(new_room)
	

func brancher(last_room: TileMap, x: int, y: int) -> void:
	var neighbors: int = (randi() % 4) + 1
	
	for i in range(neighbors):
		var selection: int = (randi() % 4) + 2
		
		match selection:
			2:
				if not floorplan[x][y - 1]:
					var new_room: Node2D = room.instantiate()
					new_room.position.x = last_room.position.x + (room_size * 0)
					new_room.position.y = last_room.position.y + (room_size * -1)
					#last_room.clear_layer(2)
					#new_room.clear_layer(3)
					floorplan[x][y - 1] = new_room
					neighbor_decider(x, y - 1)
					rooms += 1
					if rooms < max_rooms:
						if rooms > min_rooms:
							var branch_chance: int = randi() % 100
							if(branch_chance > 5):
								brancher(new_room, x, y - 1)
						else:
							brancher(new_room, x, y - 1)
					
					self.add_child(new_room)
			3:
				if not floorplan[x][y + 1]:
					var new_room: Node2D = room.instantiate()
					new_room.position.x = last_room.position.x + (room_size * 0)
					new_room.position.y = last_room.position.y + (room_size * 1)
					floorplan[x][y + 1] = new_room
					neighbor_decider(x, y + 1)
					rooms += 1
					
					if rooms < max_rooms:
						if rooms > min_rooms:
							var branch_chance: int = randi() % 100
							if(branch_chance > 50):
								brancher(new_room, x, y + 1)
						else:
								brancher(new_room, x, y + 1)
							
					self.add_child(new_room)
			4:
				if not floorplan[x - 1][y]:
					var new_room: Node2D = room.instantiate()
					new_room.position.x = last_room.position.x + (room_size * -1)
					new_room.position.y = last_room.position.y + (room_size * 0)
					floorplan[x - 1][y] = new_room
					neighbor_decider(x - 1, y)
					rooms += 1
					
					if rooms < max_rooms:
						if rooms > min_rooms:
							var branch_chance: int = randi() % 100
							if(branch_chance > 50):
								brancher(new_room, x - 1, y)
						else:
								brancher(new_room, x - 1, y)
							
					self.add_child(new_room)
			5:
				if not floorplan[x + 1][y]:
					var new_room: Node2D = room.instantiate()
					new_room.position.x = last_room.position.x + (room_size * 1)
					new_room.position.y = last_room.position.y + (room_size * 0)
					floorplan[x + 1][y] = new_room
					neighbor_decider(x + 1, y)
					rooms += 1
					
					if rooms < max_rooms:
						if rooms > min_rooms:
							var branch_chance: int = randi() % 100
							if(branch_chance > 50):
								brancher(new_room, x + 1, y)
						else:
								brancher(new_room, x + 1, y)
							
					self.add_child(new_room)

#func dungeon_builder() -> void:
	#for x in range(rows):
		#for y in range(cols):
			#var new_room: Node2D = room.instantiate()
			#new_room.position.x = start_position_x + (room_size * x)
			#new_room.position.y = start_position_y + (room_size * y)
			#floorplan[x][y] = new_room
			#neighbor_decider(x, y)
			#self.add_child(new_room)
#
func neighbor_decider(x: int, y: int) -> void:
	
	if x > 0:
		if(floorplan[x - 1][y]):
			floorplan[x][y].clear_layer(4)
			floorplan[x - 1][y].clear_layer(5)
	if x < (rows - 1):
		if(floorplan[x + 1][y]):
			floorplan[x][y].clear_layer(5)
			floorplan[x + 1][y].clear_layer(4)
	if y > 0:
		if(floorplan[x][y - 1]):
			floorplan[x][y].clear_layer(2)
			floorplan[x][y - 1].clear_layer(3)
	if y < (cols - 1):
		if(floorplan[x][y + 1]):
			floorplan[x][y].clear_layer(3)
			floorplan[x][y + 1].clear_layer(2)
			
func _physics_process(_delta: float) -> void:
	$CanvasLayer/EnemyCounter.text = "Enemies: " + str(game_state.enemy_count)
	
	if game_state.enemy_count <= 0:
		$CanvasLayer/EnemyCounter.text = "You Win!"
