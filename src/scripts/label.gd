extends Label


func _ready() -> void:
	visible = true
	await get_tree().create_timer(4.0).timeout
	visible = false
