extends MarginContainer

@onready var shild_bar = $HBoxContainer/ShieldBar
@onready var score_counter = $HBoxContainer/ScoreCounter

func update_score(value):
	score_counter.display_digits(value)
	
func update_shield(max_value, value):
	shild_bar.max_value = max_value
	shild_bar.value = value
