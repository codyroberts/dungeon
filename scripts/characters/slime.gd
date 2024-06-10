extends enemy
class_name slime

signal slime_defeated(experience: int)

@onready var animation_player := AnimationPlayer.new()
@onready var animation_builder := AnimationBuilder.new()
@onready var animation_library := AnimationLibrary.new()
@onready var random := RandomNumberGenerator.new()
@onready var game_state := get_node("/root/GameState")

var direction := Vector2()
var facing_vector := Vector2()
var facing_direction: String = ""
var target_in_range: bool = false
var target_position: Vector2
var stun_state: bool = false
var health: int = 100
var dead: bool = false

func _ready() -> void:
	speed = 20.0
	random.randomize()
	add_child(animation_player)
	add_child(navigation_agent)
	animation_player.connect("animation_finished", _on_animation_finished)
	$UI/Name.text = "Slime"
	$UI/Health.health = health
	
	dungeon.connect("player_spawned", _on_player_spawned)
	
	animation_library = animation_builder.build_slime_library()
	animation_player.add_animation_library("", animation_library)
	#navigation_agent.debug_enabled = true

func _on_animation_finished(_animation_name: String) -> void:
	stun_state = false
	
	if dead:
		queue_free()

func _on_player_spawned(player: CharacterBody2D) -> void:
	player.connect("player_position_updated", _on_player_position_updated)

func _on_player_position_updated(player_position: Vector2) -> void:
	target_position = player_position

func _physics_process(_delta: float) -> void:
	
	if(navigation_agent.is_navigation_finished()):
		speed = 0.0
		navigation_agent.set_velocity(direction * speed)
		navigation_agent.set_target_position(Vector2.ZERO)
		velocity = navigation_agent.velocity
		velocity = direction * speed
	#direction = navigation_agent.get_next_path_position() - global_position
	if(target_in_range):
		#print(navigation_agent.distance_to_target())
		#print(navigation_agent.target_desired_distance)
		navigation_agent.set_target_position(target_position)
	
		direction = navigation_agent.get_next_path_position() - global_position
		direction = direction.normalized()
		#
		facing_vector = direction
		#
		facing_direction = animation_builder.get_direction(facing_vector)
		#
		if stun_state:
			speed = 0.0
			navigation_agent.set_velocity(direction * speed)
			velocity = navigation_agent.velocity
		else:
			speed = 20.0
			navigation_agent.set_velocity(direction * speed)
			velocity = navigation_agent.velocity
	elif facing_direction == "":
		facing_direction = "_down_right"
	
	if direction.x != 0 or direction.y != 0:
		
		if not stun_state:
		
			speed = 20.0
			navigation_agent.set_velocity(direction * speed)
			velocity = navigation_agent.velocity
			animation_player.play("walk" + str(facing_direction), -1, 2)
		#animation_player.play("walk_down_right")
	else:
		#animation_player.play("idle_down_right")
		if not stun_state:
			animation_player.play("idle" + str(facing_direction))
	
	move_and_slide()
	
func take_damage() -> void:
	health -= 10
	$UI/Health.health = health
	if(health <= 0):
		stun_state = true
		if not dead:
			slime_defeated.emit(10)
			animation_player.play("die", -1, 4)
			game_state.enemy_count -= 1
			dead = true
	else:
		stun_state = true
		animation_player.play("damage" + str(facing_direction), -1, 4)
	


func _on_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target_in_range = true
		target_position = body.position
		#navigation_agent.target_position = target_position


func _on_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		target_in_range = false
		#direction = Vector2.ZERO
		#velocity = direction * 0
		#navigation_agent.set_target_position(get_parent().get_child(4).position)
		#navigation_agent.target_position = global_position
