GPIO_PORTB_DATA_IN	EQU 0x4000503C
	
; 	Inputs: NONE
; 	Outputs: R4 -> Debounced

			AREA 	DEBOUNCE_K_CODE, CODE, READONLY
			THUMB
			EXPORT 	DEBOUNCE_K
				
DEBOUNCE_K	PROC
			PUSH 	{R0, R1, R2, LR}

			MOV 	R2, #0x4F4F
			LDR 	R1, =GPIO_PORTB_DATA_IN
			LDR 	R4, [R1]
			
LOOP		CBZ 	R2, DONE
			; Read Raw Input
			LDR 	R1, =GPIO_PORTB_DATA_IN
			LDR 	R0, [R1]
			CMP 	R0, R4
			MOVNE 	R2, #0x4F4F
			; Move to Previous
			MOV 	R4, R0
			SUBS 	R2, #1
			BNE  	LOOP	; It is same for long enough
			
DONE		POP 	{R0, R1, R2, LR}	
			BX 		LR
			ENDP
				
			ALIGN
			END