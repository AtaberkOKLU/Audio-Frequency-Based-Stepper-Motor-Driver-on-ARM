ADC0_ISC			EQU 0x4003800C
ADC0_SSFIFO0 		EQU 0x40038048

					AREA ADC0SS0_SAMPLE_DATA, DATA, READWRITE
					THUMB
					ALIGN
					EXPORT 	THRESH_AMP
THRESH_AMP			SPACE 2

					AREA ADC0Seq0_Handler_Code, CODE, READONLY
					THUMB
					EXPORT ADC0Seq0_Handler
					EXTERN DigitExtractor
					IMPORT SCREEN_DATA
					IMPORT NMBR
ADC0Seq0_Handler 	PROC
					PUSH 	{R0, R1, R4, R5, LR}
					
					; Get The Data
					LDR 	R0, =ADC0_SSFIFO0
					LDR 	R0, [R0]
					; Process the data
					LSR 	R0, #4 				; Make 8-bit to be compatible with FREQ_MAX
					; Save the data
					LDR 	R1, =THRESH_AMP
					STRH 	R0, [R1]
					
					; Extract Thresh_Amp
					LDR 	R5, =NMBR
					LDR 	R1, =SCREEN_DATA
					STR 	R8, [R1, #7]!
					MOV 	R4, R0
					BL 		DigitExtractor
					; Update Screen - Amplitude Threshold
					LDRB 	R0, [R5], #1
LOOP0				SUB 	R0, #32
					STRB 	R0, [R1], #1
					LDRB 	R0, [R5], #1
					CMP 	R0, #0x0D
					BNE 	LOOP0
					
					; Clear Interrupt
					LDR 	R1, =ADC0_ISC
					LDR 	R0, [R1]
					ORR 	R0, #0x01
					STRB 	R0, [R1] 			; Clear SS0 Interrupt
					
					POP 	{R0, R1, R4, R5, LR}
					BX 		LR
					ENDP
						
					ALIGN
					END