extends Node

#Scenes
var current_scene = "Stage"#Stage Bingo
var current_step = "Start"#Start, Open, Extracting , Finished

#Balls
var ballsTombola = []
var ballsExtracted = []
var extractionsFinished = 0

#Card
var cardNumbers = []
var foundCardNumbers = 0

#EXPORT VARS:
#export var rotate_speed = 1#10

#Constants
## xx

#Nodes
#onready var player = get_tree().get_root().get_node("MainScene/balls")


#Time
# Create a timer node
#var bullet_timer = Timer.new()
#Ver no mue jogo da bola e turrents como fiz os timmings
#bullet_timer.set_wait_time(shoot_interval)
#bullet_timer.set_one_shot(false)
#bullet_timer.connect("timeout", self, "shoot")
#add_child(bullet_timer)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Button_button_down():
#	if current_step == "Start":
#		get_node("/root/MainScene/GUI/pause").text = "Start"
#	elif current_step == "Finished":
#		get_node("/root/MainScene/GUI/pause").text = "Reset"
#	else:
#		if get_tree().paused == true:
#			get_tree().paused = false
#			get_node("/root/MainScene/GUI/pause").text = "Pause"
#		else:
#			get_tree().paused = true
#			get_node("/root/MainScene/GUI/pause").text = "Resume"
