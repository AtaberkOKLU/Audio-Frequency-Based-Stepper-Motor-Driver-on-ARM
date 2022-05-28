ADC0_PSSI  			EQU 0x40038028
; This Handler is for Triggering SS3 of ADC0 for sampling
; 2kHz
					AREA SysTickHandlerCode, CODE, READONLY
					THUMB
					EXPORT SysTick_Handler
					IMPORT UPDATE_SCRN_C
					IMPORT UPDATE_SCRN_F
SysTick_Handler		PROC
					PUSH 	{R0, R1, R2}
					; Start Conversion SS3 
					LDR 	R1, =ADC0_PSSI
					LDR 	R0, [R1]
					ORR 	R0, #0x00000008
					STR 	R0, [R1]
					
					; 1 Hz Screen Update
					LDR 	R1, =UPDATE_SCRN_C
					LDRH 	R0, [R1]
					CBNZ 	R0, SKIP

					; Start Conversion SS0
					LDR 	R1, =ADC0_PSSI
					LDR 	R0, [R1]
					ORR 	R0, #0x00000001
					STR 	R0, [R1]
					
					; Enable Screen Update
					LDR		R1, =UPDATE_SCRN_F
					MOV 	R0, #1
					STRB 	R0, [R1]
					
					LDR 	R1,=UPDATE_SCRN_C
					MOV 	R0, #2000
SKIP				SUB		R0, #1
					STRH 	R0, [R1]
					POP 	{R0, R1, R2}
					BX 		LR
					ENDP
					ALIGN
					END