extends Node

var scenario = Root.currentScenario
var world = find_parent("World")
var step = 0
var player
var message_sent = false

func _ready():
	if scenario == "The Basics" or scenario == "The Basics (Duplicate)":
		Root.EasyMode = true
	if scenario == "Advanced Train Driving":
		Root.EasyMode = false


func _process(delta):
	if world == null:
		world = find_parent("World")
	if player == null:
		player = world.get_node("Players/Player")
	send_message(delta)
	if scenario == "The Basics" or scenario == "The Basics (Duplicate)":
		basics(delta)
		return
	if scenario == "Advanced Train Driving":
		advanced(delta)
		return
	if scenario == "New Functions in 0.7":
		newFunctionsZeroDotSeven(delta)
		return
		
	message_sent = true


func basics(delta):
	match step:
		0:
#			message = "Welcome to Libre TrainSim!\nPlease have in mind that this is an early alpha version, in which many features are missing, and some bugs are possible.\nThe mode is now set to Easy.\n\nLet's start the engines!\nPress 'b' to set up the pantograph and wait a bit."
			message = TranslationServer.translate("TUTORIAL_0_0")
			if player.pantograph:
				next_step()
		1:
#			message = "Great! To close the Doors, press 'o'.\n\nWhith 'i' you can open the left one,\nwith 'p' you open the right door."
			message = TranslationServer.translate("TUTORIAL_0_1")
			if  not (player.doorRight or player.doorLeft):
				next_step()
		2:
#			message = "Now we are able to drive.\nOur departure is at 12:00. Let's wait for the depart message in the bottom left corner."
			message = TranslationServer.translate("TUTORIAL_0_2")
			if player.currentStationName == "":
				next_step()
		3:
#			message = "Let’s abort! Use the arrow keys to drive. \n\n\tPress the up arrow key to accelerate / release the brakes.\n\tPress the down arrow key to release acceleration / apply the brakes. \n\nHint: You can see your current command at the right tachometer."
			message = TranslationServer.translate("TUTORIAL_0_3")
			if Math.speedToKmH(player.speed) > 20:
				next_step()

		4:
#			message = "Ahead you see an orange signal. That means that the next signal is going to be red. So make sure, you apply the brakes that you will stand before the red signal.\n\nWith the left arrow key you can easily set acceleration and brakes to zero. Try it, if you have brakes or accleration applied!"
			message = TranslationServer.translate("TUTORIAL_0_4")
			if Math.speedToKmH(player.speed) == 0 and not player.overrunRedSignal:
				world.get_node("Signals/Signal2").status = 1
				next_step()
		5:
#			message = "Great... \nWait... the signal is now green! Now we need to accelerate very fast.\nTo do this, simply press the right arrow key. It instantly sets the train to max power."
			message = TranslationServer.translate("TUTORIAL_0_5")
			if player.distanceOnRail > 700 and player.currentRail.name == "Rail":
				next_step()
		6:
#			message = "The signal in front of you is blinking.. what does this mean?\nIf a signal is blinking, then its announcing a new speed limit, which is lower than your current one.\nNo fear, the blinking signal just announce it, the speed limit will become effective at the signal behind it.\n\nIf e.g. the signal displays a 8, then the speed limit is 80 km/h.\nOrange signs/digits are always announcing limits,\nWhite signs/digits will set the speed limit effective."
			message = TranslationServer.translate("TUTORIAL_0_6")
			if player.currentRail.name == "Rail2":
				next_step()
		7:
#			message = "In 600 meters there will be the next train station. Every station is announced in the left bottom corner, if its 1000m away. Certainly you already saw it.\n\nIt is recommended to brake down to about 70 or 60 km/h, and then brake softly if you are shortly before the train station.\nLets arrive!"
			message = TranslationServer.translate("TUTORIAL_0_7")
			if player.speed == 0 and player.currentStationName == "Tutorialbach" and not player.wholeTrainNotInStation:
				next_step()
		8:
#			message = "Great, you arrived securly!\nNow you have to open the doors.\nWith 'i' you can open the left one, with 'p' the right one.\nIn our case we have to open the left one with 'i'."
			message = TranslationServer.translate("TUTORIAL_0_8")
			if player.isInStation:
				next_step()
		9:
#			message = "Thank you for playing! You can now exit the game with 'Esc'"
			message = TranslationServer.translate("TUTORIAL_0_9")

func advanced(delta):
	match step:
		0:
			Root.EasyMode = false
			message = TranslationServer.translate("TUTORIAL_1_0")
			if player.currentStationName == "" and not (player.doorRight or player.doorLeft):
				next_step()
		1:
			message = TranslationServer.translate("TUTORIAL_1_1")
			if player.sifa:
				next_step()
		2:
			message = TranslationServer.translate("TUTORIAL_1_2")
			if player.currentRail.name == "Rail2":
				next_step()
		3:
			message = TranslationServer.translate("TUTORIAL_1_3")
			if player.isInStation:
				next_step()
		4:
			message = TranslationServer.translate("TUTORIAL_1_4")

func newFunctionsZeroDotSeven(delta):
	match step:
		0:
			message = TranslationServer.translate("TUTORIAL_2_0")
			if player.automaticDriving:
				next_step()
		1:
			message = TranslationServer.translate("TUTORIAL_2_1")
			if player.cameraState == 2:
				next_step()#
		2:
			message = TranslationServer.translate("TUTORIAL_2_2")
			if player.cameraState == 1:
				next_step()
		3:
			message = TranslationServer.translate("TUTORIAL_2_3")
			if Input.is_key_pressed(KEY_F1):
				next_step()
		4:
			message = TranslationServer.translate("TUTORIAL_2_4")
			if not player.isInStation:
				next_step()
		5:
			message = TranslationServer.translate("TUTORIAL_2_5")
			if player.distanceOnRail > 500 and player.currentRail.name == "Rail":
				next_step()
		6:
			message = TranslationServer.translate("TUTORIAL_2_6")
			if player.currentRail.name == "Rail2":
				next_step()
		7:
			message = TranslationServer.translate("TUTORIAL_2_7")
			if player.currentRail.name == "Rail2" and player.distanceOnRail > 200:
				next_step()
		8:
			message = TranslationServer.translate("TUTORIAL_2_8")
			if player.currentRail.name == "Rail2" and player.distanceOnRail > 400:
				next_step()
		9:
			message = TranslationServer.translate("TUTORIAL_2_9")
			if player.cameraState == 0:
				next_step()
		10:
			message = TranslationServer.translate("TUTORIAL_2_10")
			if player.isInStation:
				next_step()
		11:
			message = TranslationServer.translate("TUTORIAL_2_11")





var send_message_timer = 0
var message = ""
func send_message(delta):
	send_message_timer += delta
	if not message_sent and send_message_timer > 1:
		message_sent = true
		player.show_textbox_message(message)


func next_step():
	step += 1
	message_sent = false
	send_message_timer = 0
