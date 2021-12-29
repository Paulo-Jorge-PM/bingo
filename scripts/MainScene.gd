extends Spatial

onready var ball_template = preload("res://scenes/ball-template.tscn")
onready var platform = preload("res://scenes/platform.tscn")
onready var drawBallTexture = preload("res://scenes/drawTexture.tscn")
onready var pip = preload("res://scenes/pip.tscn")

onready var start_music = get_node("Music/start_music")
onready var win_sfx = get_node("SFX/win_sfx")
onready var lost_sfx = get_node("SFX/lost_sfx")
onready var spawn_balls_tombola = get_node("spawn_tombola")
onready var tombola = get_node("tombola")
onready var card = get_node("card")
onready var tv = get_node("Tv/Sprite3D/Viewport/TextureRect")
onready var curtain_left = get_node("room/curtain_left")
onready var curtain_right = get_node("room/curtain_right")
onready var pips = get_node("pips")
onready var pipsFirstSpawn = get_node("pipSpawn")

onready var curtain_leftStartPos = curtain_left.global_transform.origin
onready var curtain_rightStartPos = curtain_right.global_transform.origin

### Did the number generation with GDNative, using Rust programming language bindings
### Only to show that I can (there is no performance relevance here in using lower level machine languages)
### The built and source Rust code is in the gdnative folder at the root
### Simply loaded a node with the built script here
### NOTE: built on and for Linux (used and tested only in Linux)
onready var gdnative = get_node("GDNative-Rust")

var random = RandomNumberGenerator.new()

#onready var gdnative = preload("res://gdnative/librust_numbers_gen.gdnlib")
#onready var gdnative = preload("res://scenes/GDNative-Rust.tscn").instance()

#time bettween balls
var ball_interval = Parameters.ballInterval
var first_run = true

#var balls = {}

var ball_timer = Timer.new()

func _ready():
	#Dinamycally spawn the right number of pips for the balls for free parameterization
	if first_run == true:
		spawn_pips(Parameters.total_balls)
		
	#If the game is playing do:
	if Global.current_step == "Extracting":
		#Generate random numbers for balls
		#GDNAtive: Rust external function (compiled for Linux):
		#it generates n total numbers aleatory from a a poll of x range
		#(e.g. array of 30 numbers aleatory non repeating from 1-60 and sorted)
		#var numbers_rand = generateNumbersGDNative(Parameters.total_balls, Parameters.numbers_range)
		#Or if can't run because of Linux compatibility,
		#just comment out line above and use the next one with a GDScript version
		#Note: the GDScript randomizes each number of the array, in a range
		var numbers_rand = generateNumbers(Parameters.total_balls, Parameters.numbers_range)
		#Unfortunally had to do it, the web exporter don't like GDnative gives a bug
		
		#Spawn balls in tombola
		spawn_balls(numbers_rand, Parameters.colors, Parameters.colorsRange)
		
		#Generate Card numbers
		var genCardNumbers = generateNumbers(Parameters.card_nTotal, Parameters.card_nRange)
		#Set card nubers
		card.setCardNumbers(genCardNumbers)
		
		#Set timmers for extraction
		ball_timer.set_wait_time(ball_interval)
		# Set it as repeat
		ball_timer.set_one_shot(false)
		# Connect its timeout signal to the function to repeat
		ball_timer.connect("timeout", self, "ball_extraction")
		# Add to the tree as child of the current node
		add_child(ball_timer)
		
		#Start extraction
		#ball_extraction()
		ball_timer.start()
	

#Dynamic pips spawn for free parameterization
func spawn_pips(total):
	var row = 0
	var col = 0
	for i in range(total):
		if col > Parameters.numberPerRow-1:
			row += 1
			col = 0
		var p = pip.instance()
		p.set_name("p"+str(i+1))
		p.global_transform = pipsFirstSpawn.global_transform
		
		p.transform.origin.x = p.transform.origin.x + (Parameters.pipHorMargin * col)
		p.transform.origin.z = p.transform.origin.z - (Parameters.pipVetMargin * row)
		
		if row == 0:
			p.transform.origin.y = p.transform.origin.y - Parameters.pipFirstRowBellow
		
		pips.add_child(p)
		col += 1
		

func reset():
	ball_timer.stop()
	for x in len(Global.ballsTombola):
		Global.ballsTombola[x].queue_free()
	Global.ballsTombola = []
	for x in len(Global.ballsExtracted):
		Global.ballsExtracted[x].queue_free()
	Global.ballsExtracted = []
	Global.extractionsFinished = 0
	Global.cardNumbers = []
	Global.foundCardNumbers = 0
	Global.current_step = "Extracting"
	_ready()
	

func generateNumbersGDNative(totalBalls, rangeNumbers):
	return gdnative.generateNumbers(totalBalls, rangeNumbers)

#Used GNdative instead just to show that I can use low level faster languages
#But compiled the lib for Linux, not tested in windows,
#If you get comoile erros for windows use this instead:
#NOTE: web exporter don't support GDNative without WASM compile yet, it fails 
#So had to abort the GDNative and use the slower Gdscript again pff
func generateNumbers(nTotal, nRange):
	#var random = RandomNumberGenerator.new()
	var numbers_rand = []
	# NOTE: nRange cant never be less than nTotal or the while loop goes infinite (nver reaches the total unique ball numbers
	while len(numbers_rand) != nTotal:
		random.randomize()
		var n = random.randi_range(1, nRange)
		#var n = randi() % (nRange - 1) + 1
		if !numbers_rand.has(n):
			numbers_rand.append(n)
	numbers_rand.sort_custom(SortArray, "sort")
	return numbers_rand

class SortArray:
	static func sort(a, b):
		if a < b:
			return true
		return false

#Spawn balls in tombola
func spawn_balls(numbers_rand, colors, colorsRange):
	#Set the texture drawer tool
	# Note: read bellow in the call: disabled it, ran only once is enough
	#var draw = drawBallTexture.instance()
	#add_child(draw)
	var numbers = []
	var yy = 0.0001#this is to avoid bugs for spawning in same space and time
	var total = len(numbers_rand)
	#var ballPerColor = ceil(total / float(len(colors)))
	var colorIndex = 0
	var colorCounter = 1
	for i in range(total):
		if colorCounter >= colorsRange:
			colorCounter = 1
			if colorIndex+1 < len(colors):#to avoid bugs, in case Parameter colors are not enough 
				colorIndex+=1
		colorCounter+=1
		var ball = ball_template.instance()
		ball.transform.origin.y += yy
		yy+=0.0002
		spawn_balls_tombola.add_child(ball)
		
		#Set number
		ball.number = i+1
		
		#Set ball color
		ball.color=colors[colorIndex]
		ball.setBallColorNumber(colors[colorIndex], str(i+1))
		
		#Draw and save texture with color and name
		### NOTE: generated the textures with this function
		### but it takes a little seconds and I/O,
		### So did it one time and disabled
		### IF the ball range number changes, simply use it again
		### Ideally by running the scene itself isolated, without the full game running
		#draw.saveBallTexture(ball.number, colors[colorIndex])
		#yield(get_tree().create_timer(0.05), "timeout")
		
		#Set ball texture
		#ball.setAlbedoColor(colors[colorIndex])
		
		#Update in the global state
		Global.ballsTombola.append(ball)
		
func _process(delta):
	#spin tombola animation
	tombola.rotate_y(0.02)
	
	#Show / Hide the card by pressin SPACE
	if Input.is_action_pressed("show_card"):
		card.card_state = "show"
	else:
		card.card_state = "hide"
	
	if Global.current_step == "Open":
		var target_left = curtain_leftStartPos
		target_left.x = curtain_leftStartPos.x - Parameters.curtainTravelDistance
		var target_right = curtain_rightStartPos
		target_right.x = curtain_rightStartPos.x + Parameters.curtainTravelDistance
		#print(curtain_leftStartPos)
		if curtain_left.global_transform.origin.x > (target_left.x + Parameters.curtainStopDistance):
			curtain_left.global_transform.origin = curtain_left.global_transform.origin.linear_interpolate(target_left, delta*Parameters.curtains_speed)
			curtain_right.global_transform.origin = curtain_right.global_transform.origin.linear_interpolate(target_right, delta*Parameters.curtains_speed)
		else:
			#start_music.playing = false
			start_music.volume_db = Parameters.mudicBgVolumeDown
			Global.current_step = "Extracting"
			reset()
			
func ball_extraction():
	if Global.foundCardNumbers == Parameters.card_nTotal:
		Global.current_step = "Finished"
		Global.current_scene = "Bingo"
		#Show win screen
		##To do
	
	elif len(Global.ballsTombola) > 0:
		#var n = randi() % (MAX - MIN) + MIN
		random.randomize()
		var ballIndex = random.randi_range(0, len(Global.ballsTombola)-1)#len starts 1, but index 0, so -1
		#var ballIndex = randi() % (len(Global.ballsTombola) - 1) + 1
		Global.ballsExtracted.append(Global.ballsTombola[ballIndex])
		Global.ballsTombola.remove(ballIndex)
		
		### Here I changed the mode (from rigid body to kinematic) to reset the angular velocity from inside the tombola
		Global.ballsExtracted[-1].set_mode(3)
		Global.ballsExtracted[-1].global_transform = $spawn_extraction.global_transform
		Global.ballsExtracted[-1].set_mode(0)
		
		Global.ballsExtracted[-1].ball_state = "extraction"
		
		tv.texture = Global.ballsExtracted[-1].get_node("CollisionShape/ball").material_override.albedo_texture
		#tv.texture = Global.ballsExtracted[-1].get_node("CollisionShape/ball").material_override.albedo_color
		if Global.ballsExtracted[-1].number in Global.cardNumbers:
			tv.get_parent().get_parent().modulate = "#b6f89f"#green:#b6f89f red:#f89f9f
		else:
			tv.get_parent().get_parent().modulate = "#f89f9f"
	else:
		Global.current_step = "Finished"
		get_node("/root/MainScene/GUI/pause").text = "RESET"
		## SHOW END SCREEN
	
	#var b = ball_template.instance()
	#add_child(b)
	#b.transform = $spawn_extraction.global_transform
	#b.ball_velocity = -b.transform.basis.z * b.ball_velocity
	#b.ball_state = "extraction"

#func platformGo():
#	var p = platform.instance()
#	p.global_transform = $target_extraction.global_transform
#	add_child(p)
	
	#p.target = $destine1
	#$destine1.global_transform
	#$bump.move_and_slide($destine1.global_transform.origin)


func _on_AreaDirection_body_entered(body):
	#print(body.get_name())
	#if body.name == "ball-template":
	
	if body is RigidBody:
		#platformGo()
		#print(Global.ballsExtracted)
		Global.ballsExtracted[-1].ballDir = "downnnn"
		
		var pos = get_node("pips/p1").global_transform
		pos.origin.y = 0
		var extractedN = len(Global.ballsExtracted)
		#$pips/p1/base
		Global.extractionsFinished += 1
		
		Global.ballsExtracted[-1].set_mode(3)
		
		## Prepare teleport to pip animation
		var spwan_pos = get_node("pips/p"+str(Global.extractionsFinished)+"/base").global_transform.origin
		Global.ballsExtracted[-1].show_position = spwan_pos
		
		### A little under, to give illusion of going up the pip. Te ball-template dows the animation
		spwan_pos.y = spwan_pos.y - 0.2
		
		Global.ballsExtracted[-1].global_transform.origin = spwan_pos
		Global.ballsExtracted[-1].ballDir = "stop"
		
		#CHECK IF CARD HAS NUMBER
		card.checkNumber(Global.ballsExtracted[-1].number)
		#Global.ballsExtracted[-1].sleeping = true
		#Global.ballsExtracted[-1].angular_velocity = Vector3(0, 0, 0)
		#Global.ballsExtracted[-1].linear_velocity = Vector3.ZERO
		
		
