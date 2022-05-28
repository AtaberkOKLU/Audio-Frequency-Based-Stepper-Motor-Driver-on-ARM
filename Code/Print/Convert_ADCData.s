ADC_VOLTAGE_RES			EQU 103		;(3.300.000/4096)*(2^7/1000) = 103.125	; mV/*bit
DC_ANALOG_OFFSET		EQU 1535 	;((1.65/3.3)*4096) = 2048				; bit
	
; Input : R0 (Raw ADC Reading in bits)
; Output: R0 (ADC Reading in mV in the consideration of DC offset )
						AREA Convert_ADCData_Code, CODE, READONLY
						THUMB
						EXPORT Convert_ADCData
Convert_ADCData 		PROC
						PUSH 	{R1}
						LDR 	R1, =DC_ANALOG_OFFSET
						SUB 	R0, R1
						LDR 	R1, =ADC_VOLTAGE_RES
						SMULBB  R0, R0, R1
						ASR 	R0, #7
						POP		{R1}
						BX 		LR
						ENDP
						ALIGN
						END