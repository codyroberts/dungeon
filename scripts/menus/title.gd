extends Control


var cursor := preload("res://assets/interface/Cursor-0-Big.png")
@onready var root: Node = get_tree().get_root()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(cursor.get_width(), cursor.get_height()) / 2)
	pass # Replace with function body.

func _on_play_pressed() -> void:
	print("Play pressed")
	var world: Node = load("res://scenes/environment/world.tscn").instantiate()
	root.add_child(world)
	self.visible = false
	
func _on_quit_pressed() -> void:
	print("Quit pressed")
	get_tree().quit()
