extends Control

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var confirm_quit: Panel = $ConfirmQuit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	confirm_quit.visible = false


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Level/level.tscn")


func _on_options_pressed() -> void:
	main_buttons.visible = false
	options.visible = true
	confirm_quit.visible = false


func _on_quit_pressed() -> void:
	main_buttons.visible = false
	options.visible = false
	confirm_quit.visible = true


func _on_back_options_pressed() -> void:
	_ready()


func _on_quit_yes_pressed() -> void:
	get_tree().quit()


func _on_quit_no_pressed() -> void:
	_ready()
