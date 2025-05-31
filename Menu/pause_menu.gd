extends Control

@onready var pause = $"."
var paused = false


func _process(delta: float) -> void:
	#Only toggle the pause state if "Esc" is pressed
	if Input.is_action_just_pressed("pause"):
		pausemenu()


func _on_resume_pressed() -> void:
	if Input.get_mouse_mode() ==Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
		paused = false  	#"paused" reset to false when resuming game


func _on_main_menu_pressed() -> void:
	self.hide()
	get_tree().paused = false
	paused = false
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")


func pausemenu():
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		get_tree().paused = true
	paused = !paused
