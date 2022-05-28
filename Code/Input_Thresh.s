				AREA 	INPUT_THRESH_CODE, CODE, READONLY
				THUMB
				EXPORT 	INPUT_THRESH
				EXTERN 	UPDATE_THRESH_SCREEN
				IMPORT 	THRESH_NMBR_CNT
				IMPORT 	THRESH_NMBR
				IMPORT 	THRESH_IN_FLG
INPUT_THRESH	PROC
				PUSH 	{R0 - R6, LR}
				; 	Input R5 in Char
				
				; 	Check If Flag is set
				LDR 	R1, =THRESH_IN_FLG
				LDRB 	R6, [R1]
				CBZ 	R6, DONE_1
				
				; 	Save Char
				LDR	 	R2, =THRESH_NMBR_CNT
				LDRB 	R3, [R2]
				LDR 	R1, =THRESH_NMBR
				ADD 	R1, R1, R3
				
				; 	Check End Case
				CMP 	R5, #'A'			; -
				SUBEQ 	R1, #1
				BEQ		CLC_NUM				; -
				CMP 	R5, #'B'			; -
				SUBEQ 	R1, #1
				BEQ		CLC_NUM				; -
				
SAVE_NUM		SUB 	R5, R5, #48 		; Make it Digit from Char
				STRB 	R5, [R1]
				ADD 	R3, #1
				CMP 	R3, #3
				BNE		DONE_2
				; 	Calculate Number
CLC_NUM			CMP	 	R3, #0
				BEQ 	DONE_3
				MOV 	R4, #1
				MOV 	R0, #0
				MOV 	R2, #10
				LDRB 	R5, [R1]			; Take 1st Digit
				MLA 	R0, R5, R4, R0		; R0 = R0 + 1 * R5 | 1st Digit
				CMP 	R3, #1
				BEQ 	UPD_SC
				LDRB 	R5, [R1, #-1]		; Take 2nd Digit
				MUL		R4, R4, R2			; Make R4 = R4*10 = 10
				MLA 	R0, R5, R4, R0		; R0 = R0 + 10 * R5
				CMP 	R3, #2
				BEQ 	UPD_SC
				LDRB 	R5, [R1, #-2]		; Take 3rd Digit
				MUL		R4, R4, R2			; Make R4 = R4*10 = 100 
				MLA 	R0, R5, R4, R0		; R0 = R0 + 100 * R5
				
UPD_SC			BL 		UPDATE_THRESH_SCREEN; Inputs: R0 (Number), R6 (Thresh ID)
				
				;  	Reset Counter
				MOV 	R3, #0x00
				LDR	 	R2, =THRESH_NMBR_CNT
				
				; 	Clear Flag
DONE_3			LDR 	R1, =THRESH_IN_FLG
				STRB 	R8, [R1]			; Set Flag = 0
				
DONE_2			STRB 	R3, [R2]			; Set Digit Counter
DONE_1			POP 	{R0 - R6, LR}
				BX 		LR
				ENDP
					
				ALIGN
				END