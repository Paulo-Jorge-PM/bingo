extends RigidBody

onready var ballDir = "left"

onready var ballMesh = get_node("CollisionShape/ball")
#onready var ball = get_node("ball-body")
var ballTexture = load("res://textures/bg-alpha.png")

var number = ""
var color = "#0028ff"#HexadecimalE.g. #ff0000 (red), #0028ff (blue), #045e03 (green)
var show_position = null
#onready var ballDir = "left"

export var ball_interval = 10.0
export var ball_velocity = Vector3.ZERO
var ball_state = "tombola"#set: tombola, extraction, extracted

export var temp_angular_velocity = Vector3(0,0,0)
export var rotate_speed = 5
export var max_rotate = 15

func _ready():
	#get_parent().get_node("AreaDirection").connect("body_entered", self, "_on_AreaDirection_body_entered")
	#ballDir = "left"
	###For interaction with the phisic forces through _integrate_forces()
	set_physics_process(true)

func setBallColorNumber(hexColor, number):
	var newMaterial = SpatialMaterial.new()
	newMaterial.albedo_color = hexColor#Color(0.92, 0.69, 0.13, 1.0)
	newMaterial.albedo_texture = load("res://generated_textures/"+number+".png")#ballTexture
	newMaterial.flags_transparent = true
	newMaterial.roughness = 0.0
	ballMesh.material_override = newMaterial
	color = hexColor
	#ballMesh.material_override = null
	#ballMesh.get_surface_material(0).albedo_color = hexColor
	#ballMesh.get_active_material(0).albedo_color = hexColor

func _integrate_forces(state):
	#print(ballDir)
	if ball_state == "extraction":
		temp_angular_velocity = state.angular_velocity
		#Limite velocity to the defined max
		if ballDir == "left":
			if temp_angular_velocity.z <= max_rotate:
				temp_angular_velocity.z += rotate_speed
				state.set_angular_velocity(temp_angular_velocity)
		elif ballDir == "down":
			#print(owner.temp_angular_velocity.z)
			if temp_angular_velocity.x <= max_rotate:
				temp_angular_velocity.x += rotate_speed
				state.set_angular_velocity(temp_angular_velocity)
		elif ballDir == "stop":
#			var p = state.get_transform()
#			var target = get_node("/root/MainScene/pips/p"+str(Global.extractionsFinished)+"/base").global_transform.origin
#			p.origin.x = target.x
#			p.origin.y = target.y
#			p.origin.z = target.z
#			state.set_transform(p)
			pass#state.set_angular_velocity(Vector3(0, 0, 0))
			#state.linear_velocity = Vector3.ZERO


func _process(delta):
	if ballDir == "stop":
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(show_position, delta*Parameters.showBallPipeSpeed)

#func _on_AreaDirection_body_entered(body):
#	print("yuppp")
	
#if body.name == "ball-template":
#	print(9999)
#	print(ballDir)
#	ballDir = "down"
#	print(ballDir)
