					AREA Print_ADC0SS3Data_MSGS, DATA, READONLY
					THUMB
MSG_INF 			DCB "The Measured Voltage (mV): ", 0x09, 0x04

					AREA Print_ADC0SS3Data_VARS, DATA, READWRITE
					THUMB
					EXPORT NMBR
NMBR 				SPACE 8

					AREA Print_ADC0SS3Data_Code, CODE, READONLY
					THUMB
					EXPORT Print_ADC0SS3Data
					EXTERN Convert_ADCData
					EXTERN OutStr
					EXTERN OutChar
					EXTERN DigitExtractor
					IMPORT ADC0SS3_DT_RDY_F
					IMPORT ADC0SS3_DATA
					IMPORT ADC0SS3_SIZE
Print_ADC0SS3Data 	PROC
					PUSH 	{R0, R1, R4, R5, LR}

					MOV 	R1, #0
					
LOOP				CMP 	R1, #256
					BEQ 	DONE
					LDR 	R0, =ADC0SS3_DATA
					LDR 	R0, [R0, R1, LSL #2]
					BL 		Convert_ADCData		; Inputs: R0 (RAW ADC Reading) 
												; Outputs: R0 (Converted to mV with predefined offset)
					;LDR 	R5, =MSG_INF
					;BL 		OutStr
					CMP 	R0, #0
					BPL 	POSITIVE	
NEGATIVE			RSB		R0, R0, #0			; R0 = 0 - R0 = - R0
					MOV 	R5, #'-'
					BL 		OutChar
POSITIVE			MOV 	R4, R0
					LDR		R5, =NMBR
					BL 		DigitExtractor
					BL 		OutStr
					ADD 	R1, R1, #1
					B 		LOOP
DONE				POP		{R0, R1, R4, R5, LR}
					BX 		LR
					ENDP
					ALIGN
					END
	