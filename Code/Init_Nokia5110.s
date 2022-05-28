GPIO_PORTD_RST	EQU 0x40007100
GPIO_PORTD_DC	EQU 0x40007200 ; (D = 1, C = 0)
	
				AREA INIT_Nokia5110_CODE, CODE, READONLY
				THUMB
				EXPORT 	INIT_Nokia5110
				EXTERN 	SPI3_WRT_BYTE
				EXTERN 	UPDATE_SCREEN
INIT_Nokia5110 	PROC
				PUSH 	{R0, R1, R2, LR}
				; Set Reset Low LCD for 100ns 
				; TODO
				LDR 	R1, =GPIO_PORTD_RST
				MOV 	R0, #0
				STR 	R0, [R1]
				
				; Wait a while as Low (109 us)*1
				LDR 	R2, =250
LOOP_W0			NOP
				NOP
				NOP
				NOP
				SUBS 	R2, #1
				BNE 	LOOP_W0
				
				; Set Reset High Again
				MOV 	R0, #0x40
				STR 	R0, [R1]
				
				; Wait a while as High to stabilize (109 us)
				MOV 	R2, #250
LOOP_W1			NOP
				NOP
				NOP
				NOP
				SUBS 	R2, #1
				BNE 	LOOP_W1
				
				; Switch Command Mode
				; TODO
				LDR 	R1, =GPIO_PORTD_DC
				MOV 	R0, #0x00
				STR 	R0, [R1]
				
				MOV 	R0, #0x21		; LCD Extended Commands.
				BL 		SPI3_WRT_BYTE	
				MOV 	R0, #0xB0		; Set LCD Vop
				BL 		SPI3_WRT_BYTE
				MOV 	R0, #0x04		; Set Temp coefficent.
				BL 		SPI3_WRT_BYTE
				MOV 	R0, #0x13 		; Voltage Bias.
				BL 		SPI3_WRT_BYTE
				MOV 	R0, #0x20		; LCD Basic Commands.
				BL 		SPI3_WRT_BYTE
				MOV 	R0, #0x0C		; LCD Normal Mode 
				BL 		SPI3_WRT_BYTE
				
				; Initialize Screen RAM
				BL 		UPDATE_SCREEN
				
				POP 	{R0, R1, R2, LR}
				BX 		LR
				ENDP
				ALIGN
				END