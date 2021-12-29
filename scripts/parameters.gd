extends Node

########################
### Editable Parameteres

#Ball
export var total_balls = 30
export var numbers_range = 60
### IMPORTANT: numbers_range cant never be less than total_balls, or else game entrers an infinit loop
# reason: I used the rule to generate x unique ball numbers untill it reachs the total expected balls
# if the range is less it never reachs the total unique numbers
export var colors = ["#ff0000", "#0028ff", "#045e03"]#if not enough colors here for colorsRange, the last color will repeat
export var colorsRange = 10#how many balls to paint of the same color
export var showBallPipeSpeed = 1.5
export var ballInterval = 3.0

#Card
export var card_speed = 1.5
var show_position = Vector3(-0.2, 0.9, 4.7)
var hide_position = Vector3(-0.2, 0.0, 5.1)
var card_nTotal = 15
var card_nRange = 60
## IMPORTANT: same as above regarding numbers_range and total_balls

#Curtains
var curtains_speed = 0.5
var curtainTravelDistance = 6.0
var curtainStopDistance = 2.0

#Pips
var numberPerRow = 15
var pipHorMargin = 0.5
var pipVetMargin = 0.5
var pipFirstRowBellow = 0.23

#Sound
var mudicBgVolumeDown = -8.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
