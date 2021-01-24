	; Caleb Johnson

	area Main, code, readonly
stackstart  equ  0x40000200  ; start of stack

	ENTRY
	ldr sp, =stackstart	; set up stack pointer
	bl UARTConfig	; initialize/configure UART1
	;b TestingMode
	ldr r0, =Title
	bl OutputFromMemory
	ldr r0, =Intro
	bl OutputFromMemory
	
	;Get difficulty
	mov r1, #3
	bl GetValue
	;Easy
	cmp r1, #1
	moveq r2, #30 ; Skill point maximum
	ldreq r12, =0x12345678 ; Initialize RNG
	ldreq r0, =Easy
	;Normal
	cmp r1, #2
	moveq r2, #24 ; Skill point maximum
	ldreq r12, =0x23456789 ; Initialize RNG
	ldreq r0, =Normal
	;Hard
	cmp r1, #3
	moveq r2, #18 ; Skill point maximum
	ldreq r12, =0x3456789A ; Initialize RNG
	ldreq r0, =Hard
	
	bl OutputFromMemory
	
	ldr r0, =EachSkill
	bl OutputFromMemory
GetSkillValues
	ldr r0, =TotalCannot
	bl OutputFromMemory
	mov r3, #0 ; Keep track of total
	
	ldr r0, =EnterFighting
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Fighting ; Address of fighting skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	ldr r0, =EnterStealth
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Stealth ; Address of stealth skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	ldr r0, =EnterHacking
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Hacking ; Address of hacking skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	ldr r0, =EnterLockpicking
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Lockpicking ; Address of lockpicking skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	ldr r0, =EnterCharisma
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Charisma ; Address of charisma skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	ldr r0, =EnterLuck
	bl OutputFromMemory
	bl GetValueSkills ; Get entered skill value in [-10, 10]
	ldr r0, =Luck ; Address of luck skill
	str r1, [r0] ; Store value in memory
	add r3, r3, r1 ; Add to total
	
	cmp r3, r2 ; Make sure that total does not exceed maximum specified by difficulty
	bgt GetSkillValues ; If so, repeat loop
	
	mov r3, #0 ; Reset r3
	b Event1
;-------------------------------------------------------------
TestingMode
	ldreq r12, =0x456789AB ; Initialize RNG
	mov r1, #10 ; Set all skills to 10
	
	ldr r0, =Fighting ; Address of fighting skill
	str r1, [r0] ; Store value in memory

	ldr r0, =Stealth ; Address of stealth skill
	str r1, [r0] ; Store value in memory

	ldr r0, =Hacking ; Address of hacking skill
	str r1, [r0] ; Store value in memory

	ldr r0, =Lockpicking ; Address of lockpicking skill
	str r1, [r0] ; Store value in memory

	ldr r0, =Charisma ; Address of charisma skill
	str r1, [r0] ; Store value in memory
	
	ldr r0, =Luck ; Address of luck skill
	str r1, [r0] ; Store value in memory
	mov r3, #0 ; Checks to see if option 1 for event 1 was already chosen
;-------------------------------------------------------------
Event1
	; Output situation and choices
	ldr r0, =t1
	bl OutputFromMemory
	cmp r3, #0 ; Check if choice 1 has already been chosen
	ldreq r0, =t11c ;If not, output choice
	bleq OutputFromMemory
	ldr r0, =t12c
	bl OutputFromMemory
	ldr r0, =t13c
	bl OutputFromMemory
	mov r1, #3
	bl GetValue
	cmp r1, #1 
	beq Event1Choice1
	cmp r1, #2
	beq Event1Choice2
	cmp r1, #3
	beq Event1Choice3
	; Format: [Skill used], [DC], [Consequence of failure]
Event1Choice1 ; Luck, DC8, Nothing
	cmp r3, #1 ;Check if this has already been chosen
	beq Event1
	ldr r0, =t11 ; Text for action chosen
	bl OutputFromMemory
	mov r3, #1
	ldr r0, =Luck
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #8 ; Check if roll meets DC
	ldrge r0, =t11s
	ldrlt r0, =t11f
	bl OutputFromMemory
	cmp r1, #8
	movge r3, #0 ; Reset r3
	bge Event2 ; If successful, move to next event
	blt Event1
Event1Choice2 ; Hacking, DC5, Game Over
	ldr r0, =t12 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Hacking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #5 ; Check if roll meets DC
	ldrge r0, =t12s
	ldrlt r0, =t12f
	bl OutputFromMemory
	cmp r1, #5
	movge r3, #0 ; Reset r3
	bge Event2 ; If successful, move to next event
	blt done
Event1Choice3 ; Charisma, DC5, Game Over
	ldr r0, =t13 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Charisma
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #5 ; Check if roll meets DC
	ldrge r0, =t13s
	ldrlt r0, =t13f
	bl OutputFromMemory
	cmp r1, #5
	movge r3, #0 ; Reset r3
	bge Event2 ; If successful, move to next event
	blt done
;-------------------------------------------------------------	
Event2
	; Output situation and choices
	ldr r0, =t2
	bl OutputFromMemory
	ldr r0, =t21c 
	bl OutputFromMemory
	tst r3, #1 ; Check if bit 1 is set
	ldreq r0, =t22c
	bleq OutputFromMemory
	tst r3, #2 ; Check if bit 2 is set
	ldreq r0, =t23c
	bleq OutputFromMemory
	mov r1, #3
	bl GetValue
	cmp r1, #1 
	beq Event2Choice1
	cmp r1, #2
	beq Event2Choice2
	cmp r1, #3
	beq Event2Choice3
	; Format: [Skill used], [DC], [Consequence of failure]
Event2Choice1 ; Stealth, DC10, Game Over
	ldr r0, =t21 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Stealth
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #10 ; Check if roll meets DC
	ldrge r0, =t21s
	ldrlt r0, =t21f
	bl OutputFromMemory
	cmp r1, #10
	movge r3, #0 ; Reset r3
	bge Event3 ; If successful, move to next event
	blt done
Event2Choice2 ; Lockpicking, DC13, Nothing
	tst r3, #1 ; Check if bit 1 is set
	bne Event2 ; If so, go back
	ldr r0, =t22 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #1 ; Set bit 1 of r3 to 1
	ldr r0, =Lockpicking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #13 ; Check if roll meets DC
	ldrge r0, =t22s
	ldrlt r0, =t22f
	bl OutputFromMemory
	cmp r1, #13
	movge r3, #0 ; Reset r3
	bge Event3 ; If successful, move to next event
	blt Event2
Event2Choice3 ; Hacking, DC13, Nothing
	tst r3, #2 ; Check if bit 2 is set
	bne Event2 ; If so, go back
	ldr r0, =t23 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #2 ; Set bit 2 of r3 to 1
	ldr r0, =Hacking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #13 ; Check if roll meets DC
	ldrge r0, =t23s
	ldrlt r0, =t23f
	bl OutputFromMemory
	cmp r1, #13
	movge r3, #0 ; Reset r3
	bge Event3 ; If successful, move to next event
	blt Event2
;-------------------------------------------------------------
Event3
	; Output situation and choices
	ldr r0, =t3
	bl OutputFromMemory
	ldr r0, =t31c 
	bl OutputFromMemory
	ldr r0, =t32c
	bl OutputFromMemory
	ldr r0, =t33c
	bl OutputFromMemory
	mov r1, #3
	bl GetValue
	cmp r1, #1 
	beq Event3Choice1
	cmp r1, #2
	beq Event3Choice2
	cmp r1, #3
	beq Event3Choice3
	; Format: [Skill used], [DC], [Consequence of failure]
Event3Choice1 ; Stealth, DC15, Fight
	ldr r0, =t31 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Stealth
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #15 ; Check if roll meets DC
	ldrge r0, =t31s
	ldrlt r0, =t31f
	bl OutputFromMemory
	cmp r1, #15
	bge Event4 ; If successful, move to next event
	movlt r3, #1
	blt Event3Choice3
Event3Choice2 ; Charisma, DC15, Fight
	ldr r0, =t32 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Charisma
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #15 ; Check if roll meets DC
	ldrge r0, =t32s
	ldrlt r0, =t32f
	bl OutputFromMemory
	cmp r1, #15
	bge Event4 ; If successful, move to next event
	movlt r3, #1
	blt Event3Choice3
Event3Choice3 ; Fighting, DC15/18, Game Over
	cmp r3, #1 ; This determines whether the player was forced into the fight action or chose it
	ldreq r0, =t33h ; Text if player was forced into fight
	moveq r4, #18 ; DC if player was forced into fight
	ldrne r0, =t33w ; Text if player chose to fight
	movne r4, #15 ; DC if player chose to fight
	bl OutputFromMemory
	ldr r0, =Fighting
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, r4 ; Check if roll meets DC
	ldrge r0, =t33s
	ldrlt r0, =t33f
	bl OutputFromMemory
	cmp r1, r4
	movge r3, #0 ; Reset r3
	bge Event4 ; If successful, move to next event
	blt done
;-------------------------------------------------------------
Event4
	; Output situation and choices
	cmp r3, #7 ; If r3 = 7, all three options have been exhausted, game over
	ldreq r0, =t4f
	bleq OutputFromMemory
	beq done
	ldr r0, =t4
	bl OutputFromMemory
	tst r3, #1 ; Check if bit 1 is set
	ldreq r0, =t41c
	bleq OutputFromMemory
	tst r3, #2 ; Check if bit 2 is set
	ldreq r0, =t42c
	bleq OutputFromMemory
	tst r3, #4 ; Check if bit 3 is set
	ldreq r0, =t43c
	bleq OutputFromMemory
	mov r1, #3
	bl GetValue
	cmp r1, #1 
	beq Event4Choice1
	cmp r1, #2
	beq Event4Choice2
	cmp r1, #3
	beq Event4Choice3
	; Format: [Skill used], [DC], [Consequence of failure]
Event4Choice1 ; Luck, DC15, Nothing
	tst r3, #1 ; Check if bit 1 is set
	bne Event4 ; If so, go back
	ldr r0, =t41 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #1 ; Set bit 2 of r3 to 1
	ldr r0, =Luck
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #15 ; Check if roll meets DC
	ldrge r0, =t41s
	ldrlt r0, =t41f
	bl OutputFromMemory
	cmp r1, #15
	movge r3, #0 ; Reset r3
	bge Event5 ; If successful, move to next event
	blt Event4
Event4Choice2 ; Lockpicking, DC15, Nothing
	tst r3, #2 ; Check if bit 2 is set
	bne Event4 ; If so, go back
	ldr r0, =t42 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #2 ; Set bit 2 of r3 to 1
	ldr r0, =Lockpicking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #15 ; Check if roll meets DC
	ldrge r0, =t42s
	ldrlt r0, =t42f
	bl OutputFromMemory
	cmp r1, #15
	movge r3, #0 ; Reset r3
	bge Event5 ; If successful, move to next event
	blt Event4
Event4Choice3 ; Fighting, DC15, Nothing
	tst r3, #4 ; Check if bit 3 is set
	bne Event4 ; If so, go back
	ldr r0, =t43 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #4 ; Set bit 2 of r3 to 1
	ldr r0, =Fighting
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #15 ; Check if roll meets DC
	ldrge r0, =t43s
	ldrlt r0, =t43f
	bl OutputFromMemory
	cmp r1, #15
	movge r3, #0 ; Reset r3
	bge Event5 ; If successful, move to next event
	blt Event4
;-------------------------------------------------------------
Event5
	; Output situation and choices
	ldr r0, =t5
	bl OutputFromMemory
	tst r3, #1 ; Check if bit 1 is set
	ldreq r0, =t51c ;
	bleq OutputFromMemory
	ldr r0, =t52c
	bl OutputFromMemory
	ldr r0, =t53c
	bl OutputFromMemory
	ldr r0, =t54c
	bl OutputFromMemory
	ldr r0, =t55c
	bl OutputFromMemory
	mov r1, #5
	bl GetValue
	cmp r1, #1 
	beq Event5Choice1
	cmp r1, #2
	beq Event5Choice2
	cmp r1, #3
	beq Event5Choice3
	cmp r1, #4
	beq Event5Choice4
	cmp r1, #5
	beq Event5Choice5
	; Format: [Skill used], [DC], [Consequence of failure]
Event5Choice1 ; Luck, DC25, Nothing
	tst r3, #1 ; Check if bit 1 is set
	bne Event5 ; If so, go back
	orr r3, r3, #1 ; Set bit 1 of r3
	ldr r0, =t51 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Luck
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #25 ; Check if roll meets DC
	ldrge r0, =t51s
	ldrlt r0, =t51f
	bl OutputFromMemory
	cmp r1, #25
	bge GameWin ; If successful, game win
	orrlt r3, r3, #2 ; Set bit 2 of r3
	blt Event5
Event5Choice2 ; Charisma, DC20, Fight
	ldr r0, =t52 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Charisma
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #20 ; Check if roll meets DC
	ldrge r0, =t52s
	ldrlt r0, =t52f
	bl OutputFromMemory
	cmp r1, #20
	bge GameWin ; If successful, game win
	orrlt r3, r3, #2 ; Set bit 2 of r3
	blt Event5Choice5
Event5Choice3 ; Stealth, DC20, Fight
	ldr r0, =t53 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Stealth
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #20 ; Check if roll meets DC
	ldrge r0, =t53s
	ldrlt r0, =t53f
	bl OutputFromMemory
	cmp r1, #20
	bge GameWin ; If successful, game win
	orrlt r3, r3, #2 ; Set bit 2 of r3
	blt Event5Choice5
Event5Choice4 ; Stealth, DC17, Fight
	ldr r0, =t54 ; Text for action chosen
	bl OutputFromMemory
	ldr r0, =Stealth
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #17 ; Check if roll meets DC
	ldrlt r0, =t54f
	bllt OutputFromMemory
	cmp r1, #17
	movge r3, #0 ; Reset r3
	bge Event5SubEvent ; If successful, move to sub event
	orrlt r3, r3, #2 ; Set bit 2 of r3
	blt Event5Choice5
Event5Choice5 ; Fighting, DC20/23, Game Over
	tst r3, #2 ; This determines whether the player was forced into the fight action or chose it
	ldrne r0, =t55h ; Text if player was forced into fight
	movne r4, #23 ; DC if player was forced into fight
	ldreq r0, =t55w ; Text if player chose to fight
	moveq r4, #20 ; DC if player chose to fight
	bl OutputFromMemory
	ldr r0, =Fighting
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, r4 ; Check if roll meets DC
	ldrge r0, =t55s
	ldrlt r0, =t55f
	bl OutputFromMemory
	cmp r1, r4 ; Check if roll meets DC
	bge GameWin ; If successful, game win
	b done ; Game over if fail
;-------------------------------------------------------------
Event5SubEvent
	; Output situation and choices
	cmp r3, #3 ; If r3 = 3, both options have been exhausted, must fight
	ldreq r0, =t54sf
	ldrne r0, =t54s
	bl OutputFromMemory
	cmp r3, #3 ; Check r3 again
	beq Event5Choice5 ; Fight guard, return to main event
	tst r3, #1 ; Check if bit 1 is set
	ldreq r0, =t541c
	bleq OutputFromMemory
	tst r3, #2 ; Check if bit 2 is set
	ldreq r0, =t542c
	bleq OutputFromMemory
	mov r1, #2
	bl GetValue
	cmp r1, #1 
	beq Event5SubEventChoice1
	cmp r1, #2
	beq Event5SubEventChoice2
	; Format: [Skill used], [DC], [Consequence of failure]
Event5SubEventChoice1 ; Lockpicking, DC17, Nothing
	tst r3, #1 ; Check if bit 1 is set
	bne Event5SubEvent ; If so, go back
	ldr r0, =t541 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #1 ; Set bit 2 of r3 to 1
	ldr r0, =Lockpicking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #17 ; Check if roll meets DC
	ldrge r0, =t541s
	ldrlt r0, =t541f
	bl OutputFromMemory
	cmp r1, #17
	bge GameWin ; If successful, game win
	blt Event5SubEvent
Event5SubEventChoice2 ; Hacking, DC17, Nothing
	tst r3, #2 ; Check if bit 2 is set
	bne Event5SubEvent  ; If so, go back
	ldr r0, =t542 ; Text for action chosen
	bl OutputFromMemory
	orr r3, r3, #2 ; Set bit 2 of r3 to 1
	ldr r0, =Hacking
	bl MakeRoll
	mov r1, r0 ; Move result to r1
	cmp r1, #17 ; Check if roll meets DC
	ldrge r0, =t542s
	ldrlt r0, =t542f
	bl OutputFromMemory
	cmp r1, #17
	bge GameWin ; If successful, game win
	blt Event5SubEvent
;-------------------------------------------------------------
GameWin
	ldr r0, =t5s
	bl OutputFromMemory
done	b done

	include Subroutines.s
	
	END