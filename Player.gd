extends RigidBody3D

##How much vertical force is applied when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
##How much rotational force is applied when tunring
@export var torque_thrust: float = 100.0

var is_transitioning: bool = false  #this is for stopping "if" checks in _on_body_entered from repeating

#"@onready" annotation lets us store a Node in a variable, and let us access its functions and properties
#"AudioStreamPlayer" is for audio heard equally everywhere
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
#"AudioStreamPlayer3D" is for audio that follows player/object
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
#"GPUParticles3D" is for 3D particles
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


#Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		#position.y += delta		#moves up as long as we press W/spacebar/up-arroww 
		#apply_central_force(Vector3.UP * delta  * 1000) 	#Vector3.UP is shorthand for Vector3(0, 1, 0)
		apply_central_force(basis.y * delta * thrust)	#3D Nodes store their rotation in a matrix called basis, basis.y let's us move up towards where the body is pointing (local up)
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()
	
	if Input.is_action_pressed("rotate_left"):
		#rotate_z(delta)			#turns counter-clockwise when pressing A/left-arrow
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_right"):
		#rotate_z(-delta)			#turns clockwise when pressing D/right-arrow
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

#This is a "signal", it can be found under the Node panel beside the Inspector panel
func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		#if body.name == "LandingPad":		#if LandingPad has a different name this wouldn't work so we make a group
		if "Goal" in body.get_groups():		#Goal is a "group", it can be found under the Node panel beside the Inspector panel
			#print("You Win!")
			complete_level(body.file_path)
		
		if "Hazard" in body.get_groups():	#Hazard is a "group"
			#print("You crashed!")
			crash_sequence()

#get_tree() gives us access to the SceneTree in code, using this Object we can change, restart and quit levels, pause the game and more
#tween is an Object you can create to animate and sequence changes; ideal for simple animations and can animate properties, call funtions and wait
func crash_sequence() -> void:
	print("KABOOM!")
	rocket_audio.stop()
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)  	#stops the _process function so we lose control of the rocket
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.75)
	tween.tween_callback(get_tree().reload_current_scene)
	#get_tree().reload_current_scene()

func complete_level(next_level_file: String) -> void:
	print("Level Completed!")
	rocket_audio.stop()
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	#get_tree().change_scene_to_file(next_level_file)
	#get_tree().quit()
