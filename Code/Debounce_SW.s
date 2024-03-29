GPIO_PORTF_DATA_ALL	EQU 0x400253FC
GPIO_PORTF_DATA_OUT	EQU 0x40025038
GPIO_PORTF_DATA_IN	EQU 0x40025044
	
; 	Inputs: NONE
; 	Outputs: R4 -> Debounced

			AREA 	DEBOUNCE_SW_CODE, CODE, READONLY
			THUMB
			EXPORT 	DEBOUNCE_SW
				
DEBOUNCE_SW	PROC
			PUSH 	{R0, R1, R2, LR}

			MOV 	R2, #0x4F4F
			LDR 	R1, =GPIO_PORTF_DATA_IN
			LDR 	R4, [R1]
			
LOOP		CBZ 	R2, DONE
			; Read Raw Input
			LDR 	R1, =GPIO_PORTF_DATA_IN
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