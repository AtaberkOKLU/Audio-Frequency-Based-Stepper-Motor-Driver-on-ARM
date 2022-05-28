GPIO_PORTB_DATA_OUT	EQU 0x400053C0					

					AREA 	KeyPad_Data, DATA, READWRITE
					THUMB 
					EXPORT 	COL_DATA
					EXPORT 	COLM_CNTR
COL_DATA 			DCB 0x0F, 0x0F, 0x0F, 0x0F
COLM_CNTR 			DCB 0x00

					AREA 	Handle_KeyPad_CODE, CODE, READONLY
					THUMB
					EXTERN 	DEBOUNCE_K
					EXTERN 	PRINT_KEY
					EXPORT 	Handle_KeyPad

; Inputs: NONE
; Outputs: NONE + R5:Pressed Key ID

Handle_KeyPad		PROC
					PUSH 	{R0, R1, R2, R3, R4, LR}
					
					LDR 	R1, =COLM_CNTR
					LDR 	R2, =COL_DATA
					LDRB 	R3, [R1]		; Load Column Counter
					LDRB 	R0, [R2, R3] 	; Load Previous Input Value of That Columns
					BL 		DEBOUNCE_K		; Debounce the inputs
					STRB 	R4, [R2, R3]	; Update Previous inputs by Debounced input
					ADD		R3, #1			; Increment Column Counter
					CMP 	R3, #4			; Boundry Check for Column Counter R3 < 4
					MOVEQ 	R3, #0
					STRB 	R3, [R1]		; Update Column Counter
					CMP		R4, #0x0F		; Relased or still
					BNE 	SKIP			; It is pushed, skip
					EORS 	R0, R0, R4		; Is there any change in input.
					BLNE 	PRINT_KEY		; There is change
SKIP				LDR 	R1, =GPIO_PORTB_DATA_OUT
					LDRB 	R0, [R1]
					;	Shift the 0 at output
					ORR 	R0, #0x0F 		; Fill 0-3 bits one
					LSL 	R0, #1
					EOR 	R4, R0, #0xFF 	; R4 ~= R0
					ANDS 	R4, #0xF0		; Check High Bits
					MOVEQ 	R0,	#0xE0 		; All outputs are closed so Reset
					STRB 	R0, [R1]
					
					POP  	{R0, R1, R2, R3, R4, LR}
					BX 		LR
					ENDP
					ALIGN
					END