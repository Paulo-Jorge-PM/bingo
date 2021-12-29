extends Spatial

onready var army = preload("res://scenes/ball.tscn")
#onready var armies = get_node("Armies")

#func spawn_armies():
#	for i in range(4):
#		var a = army.instance()
#		armies.add_child(a)
#		a.global_translate(Vector3(2*(i+1),0,2*(i+1)))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _process(delta):
#	if Global.selected_army == self:
#		elapsed_seconds += delta
#		if elapsed_seconds > BLIP_SPEED:
#			elapsed_seconds = 0
#			selected()
#	if destination:
#		move(delta)
#	if collision:
#		center_camera(delta, get_transform().origin)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
