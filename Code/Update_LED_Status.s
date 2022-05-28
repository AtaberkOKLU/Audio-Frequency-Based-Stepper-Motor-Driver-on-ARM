GPIO_PORTF_DATA_OUT EQU 0x40025038
				
					AREA 	UPD_LED_STS_CODE, CODE, READONLY
					THUMB
					EXPORT 	UPD_LED_STS
					IMPORT 	SCREEN_DATA
UPD_LED_STS 		PROC
					PUSH 	{R0-R3}
					LDR 	R1, =GPIO_PORTF_DATA_OUT
					LDRB 	R0, [R1]
					CBZ 	R0, B_OFF
					
					ANDS 	R3, R0, #0x02		; R
					MOVNE 	R2, #17
					BNE		DONE
					ANDS 	R3, R0, #0x08 		; G
					MOVNE 	R2, #18
					BNE		DONE
					ANDS 	R3, R0, #0x04 		; B
					MOVNE 	R2, #19
					BNE		DONE
					
B_OFF				MOV 	R2, #16
DONE				LDR 	R1, =SCREEN_DATA
					STRB 	R2, [R1, #77]
					POP 	{R0-R3}
					BX 		LR	
					ENDP
					ALIGN
					END