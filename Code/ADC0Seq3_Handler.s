; This Handler is for saving ADC0 SS3 FIFO to SRAM
ADC0_ISC 			EQU 0x4003800C
ADC0_SSFIFO3		EQU 0x400380A8
;ADC0_SS3_DC_OFFSET 	EQU 1535; (1.25V/3.3V)*4096

					AREA ADC0SS3_SAMPLE_DATA, DATA, READWRITE
					THUMB
					ALIGN
					EXPORT ADC0SS3_DATA
					EXPORT ADC0SS3_DT_RDY_F
					EXPORT ADC0SS3_SIZE
					EXPORT ADC0SS3_FFT
					EXPORT ADC0SS3_FFT_MAX
					EXPORT ADC0SS3_FFT_MAX_ID
ADC0SS3_DATA		SPACE 	256*4			;	256 Samples * (2 Bytes REAL + 2 Bytes IMG = 4 Bytes)
ADC0SS3_FFT			SPACE 	256*2			;  	256 Outputs
ADC0SS3_SIZE		DCB 	0x00
ADC0SS3_DT_RDY_F 	DCB 	0x00
ADC0SS3_FFT_MAX 	DCW 	0x0000		; 	Max Value
ADC0SS3_FFT_MAX_ID 	DCD 	0x00000000	; 	Max Index
	
					AREA ADC0Seq3_Handler_Code, CODE, READONLY
					THUMB
					EXPORT	ADC0Seq3_Handler
ADC0Seq3_Handler 	PROC
					PUSH 	{R0, R1, R2}
					
					; Skip if data is already ready
					LDR 	R1, =ADC0SS3_DT_RDY_F
					LDRB 	R0, [R1]
					CBNZ 	R0, SKIP					
					
					; Save The Data
					LDR 	R0, =ADC0_SSFIFO3
					LDR 	R0, [R0]
					SUB 	R0, #1535
					LSL 	R0, #4
					MOVT 	R0, #0x0000			; For Img Part
					LDR 	R1, =ADC0SS3_SIZE
					LDRB 	R1, [R1]
					LDR 	R2, =ADC0SS3_DATA
					STR 	R0, [R2, R1, LSL #2]
					
					; Increment Size
					ADD 	R1, #1
					LDR 	R0, =ADC0SS3_SIZE
					STRB 	R1, [R0]		; STRH: Sets/Resets the Data Ready Flag Automatically
					
					; Set Data Ready Flag
					CMP 	R1, #256
					BNE 	SKIP		; Size = 256
					LDR 	R1, =ADC0SS3_DT_RDY_F
					MOV 	R0, #1
					STRB 	R0, [R1]
					
					; Clear Interrupt of SS3
SKIP				LDR 	R1, =ADC0_ISC
					LDR 	R0, [R1]
					ORR 	R0, #0x08
					STRB 	R0, [R1]
					
					POP 	{R0, R1, R2}				
					BX 		LR
					ENDP
					
					ALIGN
					END