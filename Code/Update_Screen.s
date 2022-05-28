GPIO_PORTD_DC	EQU 0x40007200

				AREA 	UPDATE_SCREEN_DATA, DATA, READWRITE
				THUMB
				EXPORT 	UPDATE_SCRN_F
				EXPORT 	UPDATE_SCRN_C
UPDATE_SCRN_C 	DCW 	1999
UPDATE_SCRN_F 	DCB 	1
	
				AREA 	UPDATE_SCREEN_CODE, CODE, READONLY
				THUMB
				EXPORT 	UPDATE_SCREEN
				EXTERN 	SPI3_WRT_BYTE
				EXTERN 	UPD_LED_STS
				EXTERN 	SET_LED_STS
				IMPORT 	SCREEN_DATA
				IMPORT 	FONT6x8
UPDATE_SCREEN 	PROC
				PUSH 	{R0, R1, R2, R3, LR}
				
				; Check if Update Screen is Enabled
				LDR 	R0, =UPDATE_SCRN_F
				LDRB 	R0, [R0]
				CBZ 	R0, DONE
				
				; Set LEDs Status
				BL 		SET_LED_STS
				; Update LED Status
				BL 		UPD_LED_STS
				
				; Set Cursor to (0,0)
				; TODO H=0
				MOV 	R0, #0x80		; X = 0
				BL 		SPI3_WRT_BYTE
				MOV 	R0, #0x40		; Y = 0
				BL 		SPI3_WRT_BYTE
				
				; Switch Data Write Mode
				; TODO
				LDR 	R1, =GPIO_PORTD_DC
				MOV 	R0, #0x80
				STR 	R0, [R1]
				
				; Print Screen Data
				MOV 	R2, #0
LOOP0			LDR 	R1, =SCREEN_DATA
				CMP		R2, #84
				BEQ 	DONE0
				LDRB 	R0, [R1, R2]
				LDR 	R1, =FONT6x8
				MOV 	R3, #6
				MUL 	R0, R0, R3
				ADD 	R1, R1, R0
				MOV 	R3, #0
LOOP1			CMP 	R3, #6
				BEQ     DONE1
				LDRB 	R0, [R1, R3]
				BL 		SPI3_WRT_BYTE
				ADD 	R3, #1
				B 		LOOP1
DONE1			ADD 	R2, #1
				B 		LOOP0
				
				; Switch Command Mode
				; TODO
DONE0			LDR 	R1, =GPIO_PORTD_DC
				MOV 	R0, #0x00
				STR 	R0, [R1]
				
				; Deactivate Update Screen
				LDR 	R1, =UPDATE_SCRN_F
				MOV 	R0, #0
				STRB 	R0, [R1]
				
DONE			POP 	{R0, R1, R2, R3, LR}
				BX 		LR	
				ENDP
				ALIGN
				END