	; Caleb Johnson
	
	area Subroutines, code, readonly
pinsel0  equ  0xe002c000	; controls function of pins
lcr0  equ  0xc		; line control register for UART
lsr0  equ  0x14		; line status register for UART
u0start  equ  0xe000c000	; start of UART1 registers

; subroutine UARTConfig
;   Configures the I/O pins first.
;   Then sets up the UART control register.
;   Parameters set to 8 bits, no parity, and 1 stop bit.
;   Registers used:
;   r5 - scratch register
;   r6 - scratch register
;   inputs:  none
;   outputs:  none
UARTConfig
	push {r5-r6, lr}
	
	;Setting up pinselect
	ldr r5, = pinsel0	; base address of register
	ldr r6, [r5]		; get contents
	bic r6, r6, #15		; Clear bits 3:0
	;For UART1 to transmit and receive, pinsel0 3:0 = 0101
	orr r6, r6, #5		; sets P0.1 to recieve and P0.0 to transmit
	str r6, [r5]		; r/modify/w back to register
	;Setting up UART0
	ldr r5, = u0start
	mov r6, #0x83		; set 8 bits, no parity, 1 stop bit
	strb r6, [r5, #lcr0]	; write control byte to LCR
	mov r6, #0x61		; 9600 baud @ 15MHz VPB clock
	strb r6, [r5]		; store control byte
	mov r6, #3		; set DLAB = 0
	strb r6, [r5, #lcr0]	; Tx and Rxbuffer set up
	
	pop {r5-r6, pc}
	
; subroutine MakeRoll
;   Make a roll with possible values [1, 20] (simulating a d20 roll) 
;	and add the provided value to it to produce a final result.
;   Registers used: 
; 	r1 - Scratch register
; 	r2 - Scratch register
; 	r3 - Stores random roll result
; 	r4 - Stores -1 for mul instruction
; 	r12 - RNG value
;   inputs:  r0 - Address of value to add to roll
;   outputs:  r0 - Final result
MakeRoll
	push{r1-r4, lr}
	ldr r0, [r0] ; Load value from inputted address
	bl RNG ; Run RNG function to produce random number
	mov r1, r12 ; Move RNG result to r1 for use in divide function
	mov r2, #20 ; Move 20 into r2 for use in divide function
	bl Divide ; Divide random value by 20, remainder will be a value in [0, 19]
	add r1, r1, #1 ; Add 1 to remainder, value will now be in [1, 20]
	mov r3, r1 ; Put remainder in r3 for later use
	bl BinaryToASCII ; Output number
	mov r1, r0 ; Store r0 in r1
	cmp r1, #0 ; Check if value is less than 0
	ldrlt r0, =Minus ; If < 0, output minus
	ldrge r0, =Plus ; If >= 0, output plus
	bl OutputFromMemory
	mov r0, r1 ; Put value back into r0
	cmp r1, #0 ; Make another comparison since CPSR was modified by OutputFromMemory
	movlt r4, #-1 ; Put -1 in r4 for taking absolute value in mul instruction
	mullt r1, r4, r1 ; If < 0, take absolute value for output
	bl BinaryToASCII ; Output abs of added value
	add r1, r3, r0 ; Add roll result and given value, place result in r1 for output
	ldr r0, =Equals
	bl OutputFromMemory
	bl BinaryToASCII ; Output final roll result
	mov r0, r1 ; Place final roll result in r0 for output
	mov r1, #0xA ; Output newline
	bl Transmit
	pop{r1-r4, pc}

; subroutine RNG
;   Randomizes value in r12
;   Registers used: 
;	r5 - Scratch register
;	r6 - Scratch register
;	r7 - Scratch register
;	r8 - Scratch register
;	r12 - RNG Value manipulated
;   inputs:  r12 - Input RNG value
;   outputs:  r12 - Randomized output
RNG
	push{r5-r8, lr}
	; The purpose of this function is to attempt to produce a random number based on the input,
	; therefore the following operations have no purpose other than to create randomness.
	mov r5, r12, LSL #16 ; Put right half of r12 into left half of r5, rest of r5 is zeroes
	eor r12, r12, r5 	; XOR r12 with its right half in the left half
	mov r6, r12, LSL #16 ; Put right half of r12 into left half of r6, rest of r6 is zeroes
	LSR r12, r12, #16 ; Shift left half of r12 into right half of r12
	orr r12, r12, r6 ; The effect of the last three operations is to switch the left and right halves of r12
	ldr r8, =0xFFFF0000
	bic r6, r12, r8 ; Clear left half of r12 and store in r6
	LSL r6, r6, #1 ; Shift r6 left 1 bit
	eor r5, r12, r6 ; Store result in r5
	mov r6, r5, LSR #1 ; Store r5 shifted right 1 bit into r6
	ldr r8, =0xFF80FF80
	eor r7, r6, r8 ; XOR value with constant
	mov r6, r5, LSL #31
	cmp r6, #0 ; If rightmost bit of r5 is 1, use constant 0x81808180. Else use constant 0x1FF41FF4.
	ldreq r8, =0x1FF41FF4
	ldrne r8, =0x81808180
	eor r12, r8, r7 ; XOR to get final RNG value.
	pop{r5-r8, pc}

; subroutine OutputFromMemory
;   Outputs value from chararray in memory to UART0
;   Registers used:
;	r1 - Character value from memory
;	r2 - Loop counter
;   inputs:  r0 - Starting address of char array
;   outputs:  none
OutputFromMemory
	push{r1-r2, lr}
	mov r2, #0 ; Initialize loop counter
OutputFromMemoryLoop
	ldrb r1, [r0, r2]	; Load character
	add r2, r2, #1 ; Increment counter
	cmp r1, #0		; null terminated?
	blne Transmit		; send character to UART
	add r12, r12, #1 ; Increment r12 to create randomness
	bne OutputFromMemoryLoop	; continue if not a '0'
	pop{r1-r2, pc} ; If character is null, gets here and exits
	
; subroutine GetValue
;   Gets single-digit number input from UART and outputs to r1.
;   Registers used:
;	r0 - Temp array address
;   r2 - Scratch register
;   r3 - Scratch register
;	r4 - Character index
;	r5 - Scratch register
;	r6 - Used for multiple comparisons
;	r7 - Scratch register
;   inputs:   r1 - maximum number that can be inputted 
;   outputs:  r1 - Inputted number	
GetValue
	push {r0, r2-r7, lr}
	ldr r0, =TempCharArray
	mov r7, r1 ; Create copy of r1 and put in r7
	add r7, r7, #0x30 ; Add 30 to get ASCII value
	mov r4, #0 ; Character index when storing AString
	mov r2, #0 ; Used to clear characters
	ldr r3, =u0start
GetValueLoop
	add r12, r12, #1 ; Increment r12 to create randomness
	ldrb r5, [r3, #lsr0]	; get status of buffer
	tst r5, #0x1		; buffer empty?
	beq GetValueLoop ; If buffer is empty, spin until it's not
	ldrb r1, [r3]
	cmp r4, #0
	beq GetValueWrite ; Write value
	cmp r4, #1
	beq GetValueControl ; Control value, enter or backspace
	b GetValueLoop
GetValueWrite ; Used when there is no entered value, can enter a number only
	mov r6, #0 ; Reset r6
	cmp r1, #0x31
	addge r6, r6, #1 ; Make sure value is >= ASCII 1
	cmp r1, r7
	addle r6, r6, #1 ; Make sure value is <= inputted maximum value
	cmp r6, #2 ; If r6 is 2, then value is within acceptable range
	bne GetValueLoop ; if not, return to loop, ignore character
	bl Transmit		; send character to UART0
	strb r1, [r0, r4] ; Store value in array
	add r4, r4, #1 ; Increment array index
	b GetValueLoop ; Continue loop
GetValueControl ; Used when there is an entered value, can input enter or backspace only
	cmp r1, #0x0D ; If key was enter, then go to next label
	beq GetValueExit
	cmp r1, #0x8 
	bne GetValueLoop ; If neither an enter nor a backspace, ignore
	bl Transmit	 ; If program has gotten to this point, character was a backspace
	b GetValueBackspace
GetValueBackspace ; If it was a backspace, delete last character from array
	mov r1, #0
	bl Transmit	; Transmit null to clear value in terminal
	mov r1, #0x8
	bl Transmit ; Then transmit another backspace
	sub r4, r4, #1 ; Subtract character index
	strb r2, [r0, r4] ; Store null to clear array
	b GetValueLoop
GetValueExit
	mov r1, #0xA ; Output newline
	bl Transmit
	ldrb r1, [r0] ; Move character value of number into r1
	sub r1, r1, #0x30 ; Subtract 30 to get numeric value
	pop {r0, r2-r7, pc}	
	
; subroutine GetValueSkills
;   Gets number in [-10, 10] from UART and outputs to r1
;   Registers used:
;	r0 - Temp array address
;   r2 - Scratch register
;   r3 - Scratch register
;	r4 - Character index
;	r5 - Scratch register
;	r6 - Used for multiple comparisons
;	r7 - Scratch register
;	r8 - Indicates if the value is negative or not
;	r9 - Scratch register
;   inputs:   none
;   outputs:  r1 - Inputted number	
GetValueSkills
	push {r0, r2-r9, lr}
	ldr r0, =TempCharArray
	mov r8, #1 ; Initialize r8 to 1, 1 = non-negative, -1 = negative
	mov r7, r1 ; Create copy of r1 and put in r7
	add r7, r7, #0x30 ; Add 30 to get ASCII value
	mov r4, #0 ; Character index when storing AString
	mov r2, #0 ; Used to clear characters
	ldr r3, =u0start
GetValueLoopSkills
	add r12, r12, #1 ; Increment r12 to create randomness
	ldrb r5, [r3, #lsr0]	; get status of buffer
	tst r5, #0x1		; buffer empty?
	beq GetValueLoopSkills ; If buffer is empty, spin until it's not
	ldrb r1, [r3]
	;Decide if control character or not
	mov r6, #0 ; Reset r6
	cmp r4, #0 ; If there are any characters, can control
	addgt r6, r6, #1 ; Add 1 to r6
	cmp r1, #0x0D ; Check if enter
	addeq r6, r6, #1 ; If so, add 1 to r6
	cmp r1, #0x8 ; Check if backspace
	addeq r6, r6, #1 ; Add 1 to r6
	cmp r6, #2 ; If there is at least one character entered AND input is backspace or enter,
	beq GetValueControlSkills ; go to control label.
	;If not control character
	cmp r8, #-1 ; Check if there is a negative
	moveq r9, #2 ; If so, there can be 3 characters
	movne r9, #1 ; If not, there can be 2 characters
	cmp r4, r9 ; Can only write if there are less than 2 (non-negative) or 3 (negative) characters
	beq InputZero ; If it is equal, it is the last character, which can only be zero
	blt GetValueWriteSkills ; Write value
	b GetValueLoopSkills
GetValueWriteSkills ; Used when there is no entered value, can enter a number or -
	mov r6, #0 ; Reset r6
	cmp r1, #0x2D ; See if value is -
	beq GetValueNegativeSkills
	cmp r1, #0x30
	addge r6, r6, #1 ; Make sure value is >= ASCII 0 if not -
	cmp r1, #0x39
	addle r6, r6, #1 ; Make sure value is <= ASCII 9 if not -
	cmp r6, #2 ; If r6 is 2, then value is within acceptable range
	bne GetValueLoopSkills ; if not return to loop, ignore character
	bl Transmit		; send character to UART0
	strb r1, [r0, r4] ; Store value in array
	add r4, r4, #1 ; Increment array index
	b GetValueLoopSkills ; Continue loop
GetValueControlSkills ; Used when there is an entered value, can input enter or backspace only
	cmp r1, #0x0D ; If key was enter, then go to next label
	beq GetValueEnterSkills
	cmp r1, #0x8 
	bne GetValueLoopSkills ; If neither an enter nor a backspace, ignore
	bl Transmit	 ; If program has gotten to this point, character was a backspace
	b GetValueBackspaceSkills
GetValueEnterSkills
	mov r6, #0 ; Reset r6
	cmp r8, #-1 ; If value is negative, possible only - is entered, require a number
	addeq r6, r6, #1
	cmp r4, #1 ; Check if there is only one character. If so, no number was entered.
	addeq r6, r6, #1
	cmp r6, #2 ; If r6 is 2, then only entered character is a -, cannot enter
	beq GetValueLoopSkills ; Ignore and continue loop
	b GetValueExitSkills ; If not, safe to exit
GetValueBackspaceSkills ; If it was a backspace, delete last character from array
	mov r1, #0
	bl Transmit	; Transmit null to clear value in terminal
	mov r1, #0x8
	bl Transmit ; Then transmit another backspace
	sub r4, r4, #1 ; Subtract character index
	cmp r4, #0 ; If there are no more characters, minus may have been deleted, re-initialize r8 to 1 to be safe
	moveq r8, #1 
	strb r2, [r0, r4] ; Store null to clear array
	b GetValueLoopSkills
GetValueNegativeSkills
	cmp r4, #0 ; Can only input - if there are no entered characters yet
	bne GetValueLoopSkills
	mov r8, #-1 ; Indicates value is negative
	bl Transmit		; send character to UART0
	strb r1, [r0, r4] ; Store value in array
	add r4, r4, #1 ; Increment array index
	b GetValueLoopSkills
InputZero ; This occurs if the user enters the last possible digit of the number. 
;This number can only be 0, and only if the previous character is a 1.
	mov r6, #0 ; Reset r6
	cmp r1, #0x30 ; See if value is 0
	addeq r6, #1 ; If so add 1 to r6
	sub r4, #1 ; Subtract 1 from index to fetch previous char
	ldrb r5, [r0, r4] ; Load previous char
	add r4, #1 ; Add 1 back to index
	cmp r5, #0x31 ; See if previous value was 1
	addeq r6, #1 ; If so add 1 to r6
	cmp r6, #2 ; Check if both conditions were true
	beq GetValueWriteSkills ; If so, write 0
	b GetValueLoopSkills ; If not, continue loop
GetValueExitSkills ; This is the exit for the function
	mov r1, #0xA ; Output newline
	bl Transmit
	mov r1, r4 ; Move character count to r1 for ASCIIToBinary function
	cmp r8, #-1 ; Check if value is negative
	subeq r1, r1, #1 ; If so, subtract 1 from character count
	addeq r0, r0, #1 ; If so, increment address by 1 to ignore -
	bl ASCIIToBinary ; Result in r5
	mul r1, r5, r8 ; If number is negative r8 will be -1, if not it will be 1, put final result in r1
	pop {r0, r2-r9, pc}	
	
; subroutine ASCIIToBinary
;   Converts ASCII string to binary
;   Registers used:
;   r2 - Loop counter
;   r3 - Loaded character value
;	r4 - Scratch register used because of mul statement
;   inputs:  
; 	r0 - Starting address of char array
;	r1 - Number of digits of char array
;   outputs:  r5 - Binary sum of values in char array
ASCIIToBinary
	push {r2-r4, lr}
	mov r2, #0 ; Loop counter
	mov r5, #0 ; Sum used to keep track of value to store at end
	mov r4, #10 ; Used for mul statement since immediate values are not accepted
ASCIIToBinaryLoop
	ldrb r3, [r0, r2] ; Loads character value
	sub r3, r3, #0x30 ; Subtracts ASCII value by 30 to get decimal value
	add r5, r5, r3 ; Add to sum
	add r2, r2, #1 ; Increment counter
	cmp r1, r2 ; Compare digit count and loop counter.
	beq ExitASCIIToBinary ; If equal, end of array reached, exit
	mul r5, r4, r5 ; Else, multiply sum by 10
	add r12, r12, #1 ; Increment r12 to create randomness
	b ASCIIToBinaryLoop
ExitASCIIToBinary
	pop {r2-r4, pc}
	
; subroutine BinaryToASCII
;   Converts ASCII string to binary
;   Registers used:
;   r2 - Scratch register used for division subroutine
;   r3 - Division result
;	r4 - Loop counter
;	r5 - Address of temp array
;   inputs:  r1 - Binary value
;   outputs:  none
BinaryToASCII
	push{r0-r5, lr}
	ldr r5, =TempCharArray ; Initialize temp array used for output
	mov r4, #0 ; Initialize loop counter
	mov r2, #10 ; Used for division subroutine
	cmp r1, #0 ; Check if value is < 0
	movlt r3, #-1 ; Put -1 in r3 for use in mul instruction
	mullt r1, r3, r1 ; Take absolute value of r1
	ldrlt r0, =Negative
	bllt OutputFromMemory
BinaryToASCIILoop
	bl Divide ; Divides r1 by 10
	; After division r1 is remainder, r3 is result
	add r1, r1, #0x30 ; Add 30 to remainder to get ASCII value
	strb r1, [r5, r4] ; Place value in memory
	add r4, r4, #1 ; Increment counter
	cmp r3, #0 ; If division result is 0, then loop is done
	subeq r4, r4, #1 ; Subtract 1 from counter for next loop
	beq BinaryToASCIIOutputLoop
	mov r1, r3 ; Move division result into r1
	b BinaryToASCIILoop
BinaryToASCIIOutputLoop
	ldrb r1, [r5, r4] ; Load value back from memory backwards
	bl Transmit
	cmp r4, #0
	beq BinaryToASCIIDone ; If counter is 0, subroutine is done
	sub r4, r4, #1 ; Decrement counter
	b BinaryToASCIIOutputLoop
BinaryToASCIIDone
	pop{r0-r5, pc}
	
; subroutine Transmit
;   Puts one byte into the UART for transmitting
;   Registers used:
;   r5 - scratch register
;   r6 - scratch register
;   inputs:  r1 - byte to transmit
;   outputs:  none
Transmit
	push {r5, r6, lr}
	ldr r5, = u0start
wait	ldrb r6, [r5, #lsr0]	; get status of buffer
	tst r6, #0x20		; buffer empty?
				; in above instruction, text uses cmp, but should be tst
	add r12, r12, #1 ; Increment r12 to create randomness
	beq wait		; spin until buffer is empty
	strb r1, [r5]
	pop {r5, r6, pc}	
	
; subroutine Divide
;   Divides two registers
;   Registers used:
;   r0 - scratch register
;   inputs:  
;	r1 - dividend
;	r2 - divisor
;   outputs:
;	r1 - remainder
;	r3 - division result
Divide
	PUSH {r0, r2, lr}
	MOV r0, #1 ; bit to control the division
Div1 
	CMP r2, #0x80000000 ; move r2 until greater than r1
	CMPCC r2, r1
	LSLCC r2, r2, #1
	LSLCC r0, r0, #1
	BCC Div1
	MOV r3, #0
Div2 
	CMP r1, r2 ; test for possible subtraction
	SUBCS r1, r1, r2 ; subtract if OK
	ADDCS r3, r3, r0 ; put relevant bit into result
	LSRS r0, r0, #1 ; shift control bit
	LSRNE r2, r2, #1 ; halve unless finished
	BNE Div2 ; divide result in r3 remainder in r1
	POP {r0, r2, pc}
	
	include Memory.s
	
	END