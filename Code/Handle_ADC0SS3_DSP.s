FREQ_RES_CONTS 			EQU 7813 ; (2000/256) = 7.8125						
						AREA 	Handle_ADC0SS3_DSP_CODE, CODE, READONLY
						THUMB
						EXPORT 	Handle_ADC0SS3_DSP
						EXTERN 	arm_cfft_q15
						EXTERN 	arm_cmplx_mag_squared_q15
						EXTERN  arm_max_q15
						EXTERN 	arm_cfft_sR_q15_len256
						EXTERN  SPI3_WRT_BYTE
						EXTERN 	Print_ADC0SS3Data
						EXTERN 	DigitExtractor
						IMPORT 	ADC0SS3_DT_RDY_F
						IMPORT 	ADC0SS3_DATA
						IMPORT 	ADC0SS3_FFT
						IMPORT  ADC0SS3_FFT_MAX
						IMPORT  ADC0SS3_FFT_MAX_ID
						IMPORT 	NMBR
						IMPORT  SCREEN_DATA
Handle_ADC0SS3_DSP		PROC
						PUSH 	{R0-R5, LR}
						
						; 	Check whether the data is ready
						LDR 	R1, =ADC0SS3_DT_RDY_F
						LDRB 	R0, [R1]
						CMP 	R0, #0
						BEQ 	DONE
						;CBZ		R0, DONE
						
						; Print Data
						;BL 		Print_ADC0SS3Data
						
						; 	ENABLE FFT
						LDR 	R0, =arm_cfft_sR_q15_len256
						LDR 	R1, =ADC0SS3_DATA
						MOV 	R2, #0
						MOV 	R3, #1
						BL 		arm_cfft_q15
						
						LDR 	R0, =ADC0SS3_DATA
						LDR 	R1, =ADC0SS3_FFT
						MOV 	R2, #256
						BL 		arm_cmplx_mag_squared_q15
						
						LDR 	R0, =ADC0SS3_FFT
						MOV 	R1, #256
						LDR 	R2, =ADC0SS3_FFT_MAX
						LDR 	R3, =ADC0SS3_FFT_MAX_ID
						BL 		arm_max_q15
						
						; 	Update Screen Freq & Amplitude
						
						; 	Extract Amplitude
						LDR 	R5, =NMBR
						LDR 	R1, =SCREEN_DATA
						STR 	R8, [R1, #63]!
						LDRH 	R4, [R2]
						BL 		DigitExtractor
						; 	Update Screen - Amplitude
						LDRB 	R0, [R5], #1
LOOP0					SUB 	R0, #32
						STRB 	R0, [R1], #1
						LDRB 	R0, [R5], #1
						CMP 	R0, #0x0D
						BNE 	LOOP0
						
						; 	Extract Frequency
						LDR 	R5, =NMBR
						LDR 	R1, =SCREEN_DATA
						STR 	R8, [R1, #49]!
						LDR 	R4, [R3]
						LDR		R0, =FREQ_RES_CONTS
						MUL		R4, R4, R0
						MOV 	R0, #1000
						UDIV 	R4, R4, R0
						BL 		DigitExtractor
						; 	Update Screen - Frequency
						LDRB 	R0, [R5], #1
LOOP1					SUB 	R0, #32
						STRB 	R0, [R1], #1
						LDRB 	R0, [R5], #1
						CMP 	R0, #0x0D
						BNE 	LOOP1
								
						; 	Clear The Data Ready Flag
						LDR 	R1, =ADC0SS3_DT_RDY_F
						MOV 	R0, #0
						STRB 	R0, [R1]
						
DONE					POP 	{R0-R5, LR}
						BX 		LR
						ENDP
						ALIGN
						END