extends ProgressBar

@onready var timer := $Timer
@onready var damage_bar := $Damage
signal health_depleted

var health: int = 0 : set = _set_health

func init_health(_health: int) -> void:
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
	
func _set_health(new_health: int) -> void:
	var prev_health: int = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		health_depleted.emit()
		
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


func _on_timer_timeout() -> void:
	damage_bar.value = health
