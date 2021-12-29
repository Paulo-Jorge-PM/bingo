extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_pause_button_down():
	if Global.current_step == "Start":
		get_node("/root/MainScene/GUI/pause").text = "PAUSE"
		$Title.visible = false
		Global.current_step = "Open"
	elif Global.current_step == "Finished":
		get_node("/root/MainScene/GUI/pause").text = "PAUSE"
		get_node("/root/MainScene").reset()
	else:
		if get_tree().paused == true:
			get_tree().paused = false
			get_node("/root/MainScene/GUI/pause").text = "PAUSE"
		else:
			get_tree().paused = true
			get_node("/root/MainScene/GUI/pause").text = "RESUME"
