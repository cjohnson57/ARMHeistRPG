	;Caleb Johnson

	area Text, code, readonly
Title  dcb  "$$$$\\   $$$$\\           $$$$\\             $$$$\\     \n$$$$ |  $$$$ |          \\__|            $$$$ |    \n$$$$ |  $$$$ | $$$$$$$$$$$$\\  $$$$\\  $$$$$$$$$$$$$$\\ $$$$$$$$$$$$$\\   \n$$$$$$$$$$$$$$$ |$$$$  __$$$$\\ $$$$ |$$$$  _____|\\_$$$$  _|  \n$$$$  __$$$$ |$$$$$$$$$$$$$$$$ |$$$$ |\\$$$$$$$$$$$$\\    $$$$ |    \n$$$$ |  $$$$ |$$$$   ____|$$$$ | \\____$$$$\\   $$$$ |$$$$\\ \n$$$$ |  $$$$ |\\$$$$$$$$$$$$$$\\ $$$$ |$$$$$$$$$$$$$$  |  \\$$$$$$$$  |\n\\__|  \\__| \\_______|\\__|\\_______/    \\____/ \n", 0

Intro dcb "Welcome to Heist. Please select a difficulty.\n1) Easy- 30 Skill Points\n2) Normal- 24 Skill Points\n3) Hard- 18 Skill Points\n", 0

Easy dcb "You selected easy.\n", 0
Normal dcb "You selected normal.\n", 0
Hard dcb "You selected hard.\n", 0

Plus dcb " + ", 0
Minus dcb " - ", 0
Equals dcb " = ", 0
Negative dcb "-", 0

EachSkill dcb "For each skill, enter an integer value in [-10, 10].\n", 0
TotalCannot dcb "Total cannot exceed maximum number of skill points specified by difficulty.\n", 0
EnterFighting dcb "Fighting: ", 0
EnterStealth dcb "Stealth: ", 0
EnterHacking dcb "Hacking: ", 0
EnterLockpicking dcb "Lockpicking: ", 0
EnterCharisma dcb "Charisma: ", 0
EnterLuck dcb "Luck: ", 0

t1 dcb "You approach the back door of the bank at night.\nThe door has no mechanical lock, but just an electrical one.\nBy the door is an RFID scanner bank employees can use to get in.\nIt also has a button and a speaker, so you can call the person controlling the door and ask to be let in.\n", 0
t11c dcb "1) Try the door and hope it opens [Luck]\n", 0
t11 dcb "Just to see, you try the door.\n", 0
t11s dcb "For some reason, the door is unlocked.\n", 0
t11f dcb "As expected, the door is locked.\n", 0
t12c dcb "2) Attempt to hack the door [Hacking]\n", 0
t12 dcb "You jack into the RFID scanner and attempt to hack it.\n", 0
t12s dcb "The security on this door is bad.\nLooking through its code, you change bit is_locked from a 1 to a 0, unlocking the door.\n", 0
t12f dcb "The door is easy to crack, but while messing around with it you accidentally change the bit intruder_detected from a 0 to a 1, alerting the whole bank.\nYou attempt to make an escape, but are caught and arrested.\nGAME OVER.", 0
t13c dcb "3) Press the call button and convince the person to let you in [Charisma]\n", 0
t13 dcb "You press the call button.\n", 0
t13s dcb "You tell the person controlling the door that you’re a bank employee who left his wallet at his desk.\nHe sounds as if he’s not paying too much attention and is watching soap operas at his desk, so he lets you in.\n", 0
t13f dcb "You try to think of something to say.\nYou end up saying “Lovely night for a bank robbery, huh?” and although it sounds like the person controlling the doorwasn’t paying too much attention, he sounds the alarm.\nYou attempt to make an escape, but are caught and arrested.\nGAME OVER.", 0

t2 dcb "You walk into the bank.\nAs you found the blueprints for the building, you know where to go.\nRather than taking a left and going to the employee area,\nyou take a right and walk towards the executives-only vault.\nAs you walk, you see a security camera.\n", 0
t21c dcb "1) Find blind spots and sneak past [Stealth]\n", 0
t21 dcb "You attempt to look for blind spots in the camera’s view and when the moment is right, go between cover to avoid its gaze.\n", 0
t21s dcb "Having successfully gotten past it, you continue down the hall.\n", 0
t21f dcb "You mess up the timing, and end up in the camera’s view.\nAn alarm is sounded.\nYou attempt to make an escape, but are caught and arrested.\nGAME OVER.", 0
t22c dcb "2) Unlock a nearby electrical panel and inspect it [Lockpicking]\n", 0
t22 dcb "Seeing a nearby electrical panel with a padlock, you attempt to unlock it on a hunch.\n", 0
t22s dcb "You unlock the control panel, and look inside.\nYou flip one of the switches and the lights in the hallway turn off, but other areas seem unaffected.\nUsing cover of darkness, you continue down the hall.\n", 0
t22f dcb "The padlock is high quality, and you can’t crack it.\n", 0
t23c dcb "3) Hack into the camera and feed it a loop [Hacking]\n", 0
t23 dcb "The camera appears to have wireless capabilities.\nYou pull out your phone and attempt to connect to it.\n", 0
t23s dcb "You successfully connect to the camera, and feed it a loop.\nYou continue down the hall.\n", 0
t23f dcb "The encryption on the camera’s wireless signal is too complex, and you fail to connect to it.\n", 0

t3 dcb "At an intersection of several hallways, there sits a guard in a chair.\nHe’s reading a novel, but appears to still be looking up and and watching fairly often.\n", 0
t31c dcb "1) Sneak past [Stealth]\n", 0
t31 dcb "You attempt to sneak past the guard.\nYou hide behind a plant, and wait for the perfect moment.\nImmediately after the guard looks up, around, then down at his book again, you make your move.\n", 0
t31s dcb "Staying low and as far as possible to keep out of his peripheral vision, you move past, taking a right turn and making your way towards the vault.\n", 0
t31f dcb "Not being very light of foot, you accidentally kick the wall as you attempt to make a turn down the hallway.\nThe guard looks up, shocked, and draws his baton.\n", 0
t32c dcb "2) Act like you belong [Charisma]\n", 0
t32 dcb "You decide to act like you belong.\nYou put on your best brave face, and stroll confidently toward the intersection.\nThe guard looks up at you.\n", 0
t32s dcb "Attempting to impersonate the executives allowed in this area, you smile and give him a greeting.\n“Just making a deposit,” you say.\nThe guard, seemingly satisfied, goes back to his book.\n", 0
t32f dcb "In this intense situation, you can’t help but feel nervous.\nThe guard gives you a look, and you can feel your face losing its composure.\nYou offer up a shaky “Oh, hi, uh, just, y’know, passing through,” but the guard seems unconvinced.\nHe stands up and draws his baton.\n", 0
t33c dcb "3) Fight him! [Fighting]\n", 0
t33w dcb "You walk right up to the guard, and get in a fighting stance.\nShocked, he stands up and draws his baton.\n", 0
t33h dcb "The guard approaches with his baton, and begins swinging.\n", 0
t33s dcb "Using what you know of boxing, you skillfully dodge his swings and manage to hit him until he’s knocked out.\nWith the threat gone, you take a right and continue towards the vault.\n", 0
t33f dcb "You attempt to dodge his attacks, but he is too fast.\nHe swings his baton, hitting you repeatedly, until you can fight no more.\nHe calls for backup, and you are arrested.\nGAME OVER.", 0

t4 dcb "You’re now approaching the vault.\nYou come to a large metal door, and from your blueprints you know the vault is on the other side.\nThe door has no electronic locks, just mechanical.\n", 0
t41c dcb "1) Try door and hope it opens [Luck]\n", 0
t41 dcb "You check to see if the door is unlocked.\n", 0
t41s dcb "For some reason, it is.\n", 0
t41f dcb "Of course it’s locked, why wouldn’t it be?\n", 0
t42c dcb "2) Unlock door [Lockpicking]\n", 0
t42 dcb "You try to pick the lock on the door.\n", 0
t42s dcb "You manage to get the tumblers just right, and you hear the satisfying click of the door unlocking.\n", 0
t42f dcb "The lock on this door is too well made, and you can’t quite get it.\n", 0
t43c dcb "3) Bash door open [Fighting]\n", 0
t43 dcb "You attempt to bash the door down with a well-placed kick.\n", 0
t43s dcb "Summoning all your strength, you manage to kick the door near the handle so that it opens before you.\n", 0
t43f dcb "The door is much too tough, and all you manage to do is sprain your ankle.\n", 0
t4f dcb "You exhaust all your options to open this door.\nYou came this far, but a metal door has thoroughly defeated you.\nHead hung in shame, you give up and go home.\nGAME OVER.", 0

t5 dcb "You enter the room containing the vault.\nIn here is a large guard.\nHe looks much stronger and more alert than the last one.\nBehind the guard is the vault door.\n", 0
t51c dcb "1) Hope he suddenly drops dead from a heart attack [Luck]\n", 0
t51 dcb "You hope with all your heart that this guard suddenly has a heart attack.\n", 0
t51s dcb "You can’t believe your eyes, but before you, the guard suddenly drops to the ground, clutching his chest.\nStill barely believing this is happening, you walk up to him and grab his key card from his belt.\nYou use his key card to open the vault door.\n", 0
t51f dcb "Well that was a waste of time.\n", 0
t52c dcb "2) Convince the guard you work for the bank [Charisma]\n", 0
t52 dcb "You walk right up to the guard, and attempt to convince him you belong here.\n", 0
t52s dcb "The guard is wary when you tell him you’re a bank executive.\nYou see him reaching for his stun gun at his side.\nYou feign anger, and threaten that the other executives will hear about this.\nHe pauses.\nYou pull out your phone, saying that you’ll call his bosses right now and get him fired for not letting you in.\nThe guard apologizes profusely for not recognizing you, and allows you entry into the vault.\nYou smile and thank him.\n", 0
t52f dcb "Your walk lacks confidence, and in that slight moment of hesitation the guard knows you shouldn’t be here.\nHe draws his stun gun, and begins firing at you.\n", 0
t53c dcb "3) Sneak and pickpocket his keycard on the way [Stealth] \n", 0
t53 dcb "You decide stealth is the best option, and manage to stay out of the way of his watchful gaze.\nAs you sneak past, however, you realize how much easier it would be to get into the vault door with his key card.\n", 0
t53s dcb "Using the steadiest hands you’ve ever had, you manage to get your hands around the key card and lift it from his belt without him noticing.\nUsing the keycard, you enter the vault.\n", 0
t53f dcb "As you reach towards his key card, his hand suddenly shoots out and grabs your arm.\nHe gives you a look that tells you that he knew you were here long before you tried to grab his card.\nHe draws his stun gun, and begins firing at you.\n", 0
t54c dcb "4) Sneak past to door to vault [Stealth]\n", 0
t54 dcb "You decide stealth is the best option, and attempt to stay in the shadows out of his watchful gaze.\n", 0
t54s dcb "You get past him to the vault door, but the fight is still not over.\nYou now must open the door, and quickly.\n", 0
t541c dcb "1) Unlock door [Lockpicking]\n", 0
t541 dcb "You attempt to use your lockpicking skills to open the vault door.\n", 0
t541s dcb "Although this is probably the hardest lock you’ve ever tried at, you successfully get the door open,\nand the path into the vault lies open.\nYou enter it.\n", 0
t541f dcb "You've never seen a lock this hard before, and you can't get past it.\n", 0
t542c dcb "2) Hack door [Hacking]\n", 0
t542 dcb "You attempt to hack into the door to release its maglocks.\n", 0
t542s dcb "The security is tough, but you manage to crack it.\nGetting access to the system, you release the maglocks, allowing you to open the door.\nYou open the door to the vault and enter.\n", 0
t542f dcb "You attempt to hack into the door's controls, but the encryption is too good for you to crack.\n", 0
t54sf dcb "You've spent too long trying to get into this door, and the guard has discovered you! He draws his stun gun and prepares for a fight.\n", 0
t54f dcb "Your footfalls are light, but this guard’s ears are unbelievably good.\nHe suddenly turns and stares directly at you, stun gun raised towards you.\n", 0
t55c dcb "5) Fight him!!! [Fighting]\n", 0
t55w dcb "You step out and get into a fighting stance, challenging this guard to a one on one fight.\nSeemingly liking this challenge, he smiles, and draws his stun gun.\n", 0
t55h dcb "The guard fires his stun gun at you, and you try to dodge and get in close to knock him out.\n", 0
t55s dcb "The guard is tough and fast, but you’re tougher and faster.\nYou dodge his shot, disarm him, and knock him unconscious.\nSeeing the key card in his belt, you take it and use it to open the vault door.\nYou enter.\n", 0
t55f dcb "You’re not fast enough, and the guard hits you directly in the chest with the stun gun.\nYou fall to the ground, seizing, and are quickly handcuffed by him.\nYou go to jail.\nGAME OVER.", 0
t5s dcb "In the vault is more money than you could ever imagine.\nYou pack your duffle bags until they can fit no more,\nbut even 1/10th of what you could carry would have you set for life.\nSatisfied with a job well done, you make your way out of the bank.\nGAME WIN.", 0

	area Storage, data, readwrite
		
TempCharArray dcb 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

Fighting dcd 0 ; Value for fighting skill
Stealth dcd 0 ; Value for stealth skill
Hacking dcd 0 ; Value for hacking skill
Lockpicking dcd 0 ; Value for lockpicking skill
Charisma dcd 0 ; Value for charisma skill
Luck dcd 0 ; Value for luck skill
	
	end