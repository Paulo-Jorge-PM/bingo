extends Node

#var vport = Viewport.new()
onready var vport = get_node("Viewport")
onready var cvitem = get_node("Viewport/Control")
onready var bg = get_node("Viewport/Control/ColorRect")
onready var label1 = get_node("Viewport/Control/ColorRect/Label1")
onready var label2 = get_node("Viewport/Control/ColorRect/Label2")
onready var label3 = get_node("Viewport/Control/ColorRect/Label3")
onready var label4 = get_node("Viewport/Control/ColorRect/Label4")
onready var label5 = get_node("Viewport/Control/ColorRect/Label5")
onready var label6 = get_node("Viewport/Control/ColorRect/Label6")
onready var label7 = get_node("Viewport/Control/ColorRect/Label7")
onready var label8 = get_node("Viewport/Control/ColorRect/Label8")

#var bg = ColorRect.new()
#var cvitem = Control.new()
#var label = Label.new()

var vport_img

func _ready():
	vport.size = Vector2(256, 128)
	#vport.render_target_update_mode = Viewport.UPDATE_ALWAYS 
	#self.add_child(vport)
	
	#vport.add_child(cvitem)
	cvitem.rect_min_size =  Vector2(256, 128)
	
	#cvitem.set_script(load("res://scripts/draw.gd"))

	#cvitem.add_child(bg)
	#bg.color = "#ffffff"
	bg.rect_min_size =  Vector2(256, 128)

	#label1.text = str("text")
	#cvitem.add_child(label)
	#label1.set("custom_colors/font_color", Color(0,0,0, 1))
	
	for i in range(99):
		saveBallTexture(str(i+1), "#ffffff")
		## 0.05 seconds to give time to take screenshot and save . otherwise numbers will be mixed and repeated
		## If your pc is slower, increase time to 0.1 for example to give enough time
		yield(get_tree().create_timer(0.05), "timeout")
		print(i)
	

	
func saveBallTexture(text, color):

	label1.text = text
	label2.text = text
	label3.text = text
	label4.text = text
	label5.text = text
	label6.text = text
	label7.text = text
	label8.text = text

	#vport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	vport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	
	vport_img = vport.get_texture().get_data()
	vport_img.flip_y()
	vport_img.save_png("res://generated_textures/"+str(text)+".png")
	

	
#	vport_img = vport.get_texture().get_data()
#	vport_img.flip_y()
#	vport_img.save_png("res://test.png")

#func _input(event):
#	if event is InputEventKey and event.pressed:
#		print("Print taken")
#		saveBallTexture(11111, "33")

	
#func _on_Button_pressed():
#	print(5)
#	vport_img = vport.get_texture().get_data()
#	vport_img.flip_y()
#	vport_img.save_png("res://test.png")
