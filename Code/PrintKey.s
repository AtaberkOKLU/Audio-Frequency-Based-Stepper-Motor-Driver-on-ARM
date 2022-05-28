GPIO_PORTB_DATA_OUT	EQU 0x400053C0
SYSCTL_RCGCGPIO		EQU 0x400FE608
SYSCTL_PRGPIO 		EQU 0x400FEA08

; 	INPUTS: R0 -> Changed Buttons
; 	Calculates Matrix button ID
; 	No Outputs , Prints to Serial Key
				AREA 	PRINT_KEY_MSGS, DATA, READONLY
				THUMB
				EXPORT 	SET_THRSH_MSG
INPUT_THRSH_MSG DCB 	0x0D, "Please Provide 3-digit Threshold in Hz: ", 0x04
SET_THRSH_MSG 	DCB 	0x0D, "Frequency Threshold is Set!", 0x0D, 0x04
				AREA 	PRINT_KEY_DATA, DATA, READWRITE
				THUMB
				EXPORT 	KeyPattern
				EXPORT 	THRESH_IN_FLG
				EXPORT 	THRESH_NMBR
				EXPORT 	THRESH_NMBR_CNT
KeyPattern		DCB 	'1', '2', '3', 'A', \
						'4', '5', '6', 'B', \
						'7', '8', '9', 'C', \
						'*', '0', '#', 'D'
THRESH_IN_FLG	SPACE 	1
THRESH_NMBR_CNT SPACE 	1
THRESH_NMBR 	SPACE   3

				AREA 	PRINT_KEY_CODE, CODE, READONLY
				THUMB
				EXPORT 	PRINT_KEY
				EXTERN 	OutChar
				EXTERN 	OutStr
				EXTERN 	INPUT_THRESH
PRINT_KEY		PROC
				PUSH 	{R0, R1, R2, R3, R4, R5, R6, LR}
				; Poll for Finding the Interrupt Source
FIND_COL		MOV 	R6, #1
				ANDS 	R2, R0, R6
				BNE 	COL1
				ANDS 	R2, R0, R6, LSL #1
				BNE 	COL2
				ANDS 	R2, R0, R6, LSL #2
				BNE		COL3
				BEQ 	COL4
COL1 			MOV		R2, #0x00
				B 		FIND_ROW
COL2			MOV		R2, #0x01
				B 		FIND_ROW
COL3			MOV		R2, #0x02
				B 		FIND_ROW
COL4			MOV 	R2, #0x03
				
FIND_ROW 		LDR 	R1, =GPIO_PORTB_DATA_OUT
				LDR 	R0, [R1]
				EOR 	R0, R0, #0xFF	;R0 = ~R0
				LSR 	R0, #4
				ANDS 	R3, R0, R6
				BNE 	ROW1
				ANDS 	R3, R0, R6, LSL #1
				BNE 	ROW2
				ANDS 	R3, R0, R6, LSL #2
				BNE		ROW3
				BEQ 	ROW4
ROW1			MOV		R3, #0x00
				B 		CALC_ID
ROW2			MOV		R3, #0x04
				B 		CALC_ID
ROW3			MOV		R3, #0x08
				B 		CALC_ID				
ROW4			MOV		R3, #0x0C
CALC_ID			ADD 	R5, R2, R3
				LDR 	R4, =KeyPattern
				LDRB 	R5, [R4, R5]
				LDR 	R1, =THRESH_IN_FLG	; Enable Input Mode
				LDRB 	R0, [R1]
				CBNZ 	R0, SKIP
				CMP 	R5, #'A'
				MOVEQ 	R0, #1
				BEQ 	INPUT	
				CMP 	R5, #'B'
				MOVEQ 	R0, #2
				BNE 	SKIP
INPUT			LDR 	R1, =THRESH_IN_FLG	; Enable Input Mode
				STRB 	R0, [R1]
				LDR 	R5, =INPUT_THRSH_MSG
				BL 		OutStr
				B 		DONE
SKIP			ADD 	R5, R2, R3
				LDR 	R4, =KeyPattern
				LDRB 	R5, [R4, R5]
				BL 		OutChar	; Print Char
				BL 		INPUT_THRESH		; Input R5 char
				
DONE			POP 	{R0, R1, R2, R3, R4, R5, R6, LR}
				BX 		LR
				ENDP
					
				ALIGN
				END