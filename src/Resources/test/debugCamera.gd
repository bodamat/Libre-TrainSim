extends Camera

# General purpose configurable camera script
export var flyspeed := 0.5
export var mouseSensitivity := 20
export var rotate_camera := true

var prevFlySpeed: float = flyspeed

var yaw = 0
var pitch = 0

# Saves the camera position at the beginning. The Camera Position will be changed, when the train is accelerating, or braking
onready var cameraZeroTransform = transform

# Reference delta at 60fps
const refDelta = 0.0167 # 1.0 / 60

onready var world = find_parent("World")

func _ready():
	if rotate_camera:
		# Initialization here
		self.set_process_input(true)
		self.set_process(true)
		#set mouse position
	else:
		self.set_process_input(false)
		self.set_process(false)


func _enter_tree():
	if rotate_camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _exit_tree():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

var mouseMotion = Vector2(0,0)

func _input(event):
	if current and event is InputEventMouseMotion:
		mouseMotion = mouseMotion + event.relative
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				prevFlySpeed += 0.05
			if event.button_index == BUTTON_WHEEL_DOWN:
				prevFlySpeed -= 0.05
			
			prevFlySpeed = clamp(prevFlySpeed, 0.05, 4)
	
onready var cameraY = rotation_degrees.y - 90.0
onready var cameraX = -rotation_degrees.x

func _process(delta):
	if not current:
		pass
	#mouse movement
	
	if not Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if mouseMotion.length() > 0:
		var motionFactor = (refDelta / delta * refDelta) * mouseSensitivity
		cameraY += -mouseMotion.x * motionFactor
		cameraX += +mouseMotion.y * motionFactor
		if cameraX > 85: cameraX = 85
		if cameraX < -85: cameraX = -85
		rotation_degrees.y = cameraY +90
		rotation_degrees.x = -cameraX
		mouseMotion = Vector2(0,0)
	
	var deltaFlyspeed = (delta / refDelta) * flyspeed

	if(Input.is_key_pressed(KEY_W)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * deltaFlyspeed)
	if(Input.is_key_pressed(KEY_S)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(0,0,1) * -deltaFlyspeed)
	if(Input.is_key_pressed(KEY_A) and not Input.is_key_pressed(KEY_CONTROL)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * deltaFlyspeed)
	if(Input.is_key_pressed(KEY_D)):
		self.set_translation(self.get_translation() - get_global_transform().basis*Vector3(1,0,0) * -deltaFlyspeed)
	if(Input.is_key_pressed(KEY_SHIFT)):
		flyspeed = prevFlySpeed * 2
	else:
		flyspeed = prevFlySpeed
	
	if (Input.is_key_pressed(KEY_E)):
		transform.origin.y += deltaFlyspeed
	if (Input.is_key_pressed(KEY_Q)):
		transform.origin.y -= deltaFlyspeed
