extends Spatial

onready var card_values = get_node("card_viewport/Control/values")

var card_state = "hide"#hide / show
var card_speed = Parameters.card_speed
var show_position = Parameters.show_position
var hide_position = Parameters.hide_position


# Called when the node enters the scene tree for the first time.
func _ready():
	#$Sprite3D.pixel_size = 
	pass

func setCardNumbers(cardNumbers):
	Global.cardNumbers = cardNumbers
	for i in len(cardNumbers):
		card_values.get_node("Label"+str(i+1)).text = str(cardNumbers[i])
		#Repeat this step, so the reset function dont need to worry about this
		card_values.get_node("Label"+str(i+1)).set("custom_colors/font_color", Color(0,0,0, 1))

func checkNumber(number):
	var wonOne = false
	for i in len(Global.cardNumbers):
		if str(Global.cardNumbers[i]) == str(number):
			card_values.get_node("Label"+str(i+1)).set("custom_colors/font_color", Color(0,1,0, 1))
			Global.foundCardNumbers += 1
			### PLAY SOUND WIN
			get_parent().win_sfx.play()
			wonOne = true
	if wonOne == false:
		### PLAY SOUND LOOSE
		get_parent().lost_sfx.play()

func _process(delta):
	if card_state == "show":
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(show_position, delta*card_speed)
	elif card_state == "hide":
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(hide_position, delta*card_speed)
