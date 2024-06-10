extends CharacterBody2D

signal player_position_updated(player_position: Vector2)

var speed: float = 40.0
var direction: Vector2 = Vector2.ZERO
var health: int = 100
var stun_state: bool = false
@onready var healthbar := $Camera2D/UI/Health
@onready var animation_player := AnimationPlayer.new()
@onready var animation_builder := AnimationBuilder.new()
@onready var previous_player_position := global_position
@onready var current_player_position := global_position

# Get the gravity from the project settings to be synced with RigidBody nodes.

func _ready() -> void:
	$Camera2D/UI/Name.text = "Goblin"
	add_child(animation_player)
	var library := animation_builder.build_character_library()
	animation_player.add_animation_library("", library)
	healthbar.connect("health_depleted", _on_health_depleted)
	animation_player.connect("animation_finished", _on_animation_finished)
	healthbar.health = health
	
func _on_health_depleted()-> void:
	$Camera2D/Label.text = "You Died"
	healthbar.visible = false
	$Sprite2D.visible = false
	if(healthbar.health <= 0):
		speed = 0
		stun_state = true
		
func _on_animation_finished(_animation_name: String) -> void:
	if(healthbar.health > 0):
		stun_state = false

func _physics_process(_delta: float) -> void:

	if(global_position != current_player_position):
		previous_player_position = current_player_position
		current_player_position = global_position
		player_position_updated.emit(current_player_position)

#Get the input direction and handle the movement/deceleration.
	direction = Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
		).normalized()
	
	if stun_state:
		speed = 0	
	elif direction:
		speed = 120.0
		velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)
	
	#direction = Vector2(
		#Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		#Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up") 
	#)
	#
	#velocity = direction * speed
			
	var facing_vector := get_local_mouse_position() - direction
	var facing_direction := animation_builder.get_direction(facing_vector)
	
	if Input.is_action_just_pressed("ui_menu"):
		get_tree().paused = true
		$Camera2D/UI/Pause.visible = true
	elif Input.is_action_just_pressed("ui_accept"):
		direction = Vector2.ZERO
		stun_state = true
		animation_player.play("damage" + facing_direction, -1, 7)
		healthbar.health -= 10
	elif Input.is_action_just_pressed("ui_attack"):
		match facing_direction:
			"_up_right":
				for body: Node2D in $Attack_Range_UR.get_overlapping_bodies():
					if(body.name == "Slime"):
						body.take_damage()
			"_up_left":
				for body: Node2D in $Attack_Range_UL.get_overlapping_bodies():
					if(body.name == "Slime"):
						body.take_damage()
			"_down_right":
				for body: Node2D in $Attack_Range_DR.get_overlapping_bodies():
					if(body.name == "Slime"):
						body.take_damage()
			"_down_left":
				for body: Node2D in $Attack_Range_DL.get_overlapping_bodies():
					if(body.name == "Slime"):
						body.take_damage()
		if(not stun_state):
			stun_state = true
			direction = Vector2.ZERO
			animation_player.play("attack" + facing_direction, -1, 8)	
	elif direction.x != 0 or direction.y != 0: 
		if(not stun_state):
			animation_player.play("walk" + facing_direction, -1, 4)
	else:
		if(not stun_state):
			animation_player.play("idle" + facing_direction)
	
	velocity = direction * speed


	move_and_slide()
