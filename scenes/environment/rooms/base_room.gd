extends TileMap

signal enemy_spawned(enemy: CharacterBody2D)

@onready var dungeon: Node2D = get_parent()
@onready var enemy: PackedScene = preload("res://scenes/characters/slime.tscn")
@onready var spawn_area := $Spawn_Area
@onready var spawn_area_shape := $Spawn_Area/CollisionShape2D
@onready var game_state := get_node("/root/GameState")

func _ready() -> void:
	print(dungeon)
	#dungeon.connect("dungeon_completed", _on_dungeon_completed)

#func _on_dungeon_completed() -> void:
	#var enemy_chance: int = randi() % 100
	#
	#if(enemy_chance >= 45):
		#var centerpos: Vector2 = spawn_area.position + spawn_area_shape.position
		#var size: Vector2 = spawn_area_shape.shape.extents
		#var spawn_position: Vector2 = Vector2.ZERO
		#spawn_position.x = ((randi() % int(size.x)) - (size.x/2) + centerpos.x)
		#spawn_position.y = ((randi() % int(size.y)) - (size.y/2) + centerpos.y)
		#var new_enemy := enemy.instantiate()
		#new_enemy.position = spawn_position
		#add_child(new_enemy)
		#game_state.enemy_count += 1
