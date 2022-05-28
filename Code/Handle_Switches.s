GPIO_PORTF_DATA_ALL	EQU 0x400253FC
GPIO_PORTF_DATA_OUT	EQU 0x40025038
GPIO_PORTF_DATA_IN	EQU 0x40025044
GPIO_PORTF_ICR 		EQU 0x4002541C
GPIO_PORTF_RIS 		EQU 0x40025414
	
					AREA 	SW_Data, DATA, READWRITE
					THUMB 
					EXPORT 	SW_DATA
SW_DATA 			DCB 	0x11

					AREA 	Handle_Switches_CODE, CODE, READONLY
					THUMB
					EXTERN 	DEBOUNCE_SW
					EXTERN 	UPDATE_FLAGS
					EXPORT 	Handle_Switches
Handle_Switches 	PROC
					PUSH 	{R0, R1, LR}
					
					LDR 	R1, =GPIO_PORTF_RIS
					LDRB 	R0, [R1]		
					ANDS 	R0, #0x11		; Check if pressed
					BLNE 	UPDATE_FLAGS 	; If no press, skip
					LDR 	R1, =GPIO_PORTF_ICR
					STRB 	R0, [R1]		; Clear the button interrupt
					;LDR 	R1, =SW_DATA
					;LDRB 	R0, [R1]
					;BL 		DEBOUNCE_SW		; Debounce the inputs
					;STRB 	R4, [R1]		; Update Previous 
					;CMP		R4, #0x11		; Relased or still
					;BNE 	SKIP			; It is pushed, skip
					;EORS 	R0, R0, R4		; Is there any change in input.
					;BLNE 	UPDATE_FLAGS	; There is change
SKIP				;MOV  	R0, R4			; Update Previous
					
					
					POP 	{R0, R1, LR}
					BX 		LR
					ENDP
						
					ALIGN
					END
