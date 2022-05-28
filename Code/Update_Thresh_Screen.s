FREQ_RES_CONTS 			EQU 	7813 ; (2000/256) = 7.8125
						AREA 	UPDATE_THRESH_SCREEN_DATA, DATA, READWRITE
						THUMB
						EXPORT 	THRESH2	; Low Freq Thresh
						EXPORT 	THRESH3	; High Freq Thresh
THRESH2					DCB 	39
THRESH3					DCB 	77
						
						
						
						AREA 	UPDATE_THRESH_SCREEN_CODE, CODE, READONLY
						THUMB
						EXPORT 	UPDATE_THRESH_SCREEN
						EXTERN 	DigitExtractor
						EXTERN 	OutStr
						IMPORT 	NMBR
						IMPORT 	SCREEN_DATA
						IMPORT 	SET_THRSH_MSG
UPDATE_THRESH_SCREEN	PROC
						PUSH 	{R0-R5, LR}
						; Inputs: R0 (Freq), R6 (Thresh ID)
						; Update Screen
						CMP 	R6, #1
						MOVEQ	R3, #21
						MOVNE 	R3, #35
						
						; 	Extract Thresh
						LDR 	R5, =NMBR
						LDR 	R1, =SCREEN_DATA
						ADD 	R1, R1, R3
						STR 	R8, [R1]
						MOV 	R4, R0
						BL 		DigitExtractor
						; 	Update Screen - Amplitude
						LDRB 	R2, [R5], #1
LOOP0					SUB 	R2, #32
						STRB 	R2, [R1], #1
						LDRB 	R2, [R5], #1
						CMP 	R2, #0x0D
						BNE 	LOOP0
						
						; Update Thresh
						; Calculate Freq ID
						LDR 	R1, =FREQ_RES_CONTS	; (16 bit)
						MOV 	R2, #1000	
						MUL 	R0, R0, R2					
						UDIV	R0, R0, R1			; R0: Freq ID
						; Save Freq ID
						CMP 	R6, #1
						LDREQ	R1, =THRESH2
						LDRNE 	R1, =THRESH3
						STRB 	R0, [R1]
						
						LDR 	R5, =SET_THRSH_MSG
						BL 		OutStr
						
						POP 	{R0-R5, LR}
						BX 		LR
						ENDP
						ALIGN
						END