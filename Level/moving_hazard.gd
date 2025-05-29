extends AnimatableBody3D

##Where we want the body to move to
@export var destination: Vector3
##How much time the movement is going to take
@export var duration: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()	#without a number inside (), the tween will loop indefinetly
	tween.set_trans(Tween.TRANS_SINE)	#changes the type of animation transition 
	#explanation: tween_property(object to tween, property to tween, destination, duration)
	#self refers to this AnimatableBody3D
	tween.tween_property(self, "global_position", global_position + destination, duration)
	tween.tween_property(self, "global_position", global_position, duration)
