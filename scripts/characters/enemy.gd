extends CharacterBody2D
class_name enemy


@export var speed: int = 50
@export var navigation_agent: NavigationAgent2D

var target: Vector2 = Vector2.ZERO
var player_position: Vector2 = Vector2.ZERO
var home: Vector2 = Vector2.ZERO
var state: String = "idling"
var aggro: bool = false

@onready var dungeon := get_parent().get_parent()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	home = self.global_position
	target = home
	
	navigation_agent.path_desired_distance = 4
	navigation_agent.target_desired_distance = 60
	navigation_agent.debug_enabled = true
	
	dungeon.connect("player_spawned", _on_player_spawned)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	#if navigation_agent.is_navigation_finished():
		#return
	
	if Input.is_action_just_pressed("ui_attack") and aggro:
		print("target desired distance: ", navigation_agent.target_desired_distance)
		print("Distance to target: ", navigation_agent.distance_to_target())
	state_handler()

func state_handler() -> void:
	match state:
		"walking":
			var direction: Vector2 = to_local(navigation_agent.get_next_path_position()).normalized()
			velocity = direction * speed
			
			move_and_slide()
		"attacking":
			pass
		"idling":
			pass
	pass	

func calculate_path() -> void:
	if aggro:
		navigation_agent.target_position = target
	else:
		navigation_agent.target_position = home

func animation_handler() -> void:
	pass

func _on_break_range_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		aggro = false

func _on_aggro_range_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		state = "walking"
		aggro = true

func _on_recalculate_timeout() -> void:
	calculate_path()

func _on_player_spawned(player: CharacterBody2D) -> void:
	player.connect("player_position_updated", _on_player_position_updated)

func _on_player_position_updated(new_position: Vector2) -> void:
	target = new_position

func take_damage() -> void:
	pass
