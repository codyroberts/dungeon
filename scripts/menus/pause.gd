extends Control

@onready var root: Node = get_tree().get_root()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

func _on_continue_pressed() -> void:
	get_tree().paused = false
	self.visible = false


func _on_quit_pressed() -> void:
	var children := get_tree().get_root().get_children()
	for child in children:
		if child.name != "GameState" and child.name != "Title":
			child.queue_free()
		if child.name == "Title":
			get_tree().paused = false
			print("Found title")
			child.visible = true
