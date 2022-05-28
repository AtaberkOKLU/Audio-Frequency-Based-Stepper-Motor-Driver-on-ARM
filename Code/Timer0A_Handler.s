GPIO_PORTA_DATA_OUT	EQU 0x400043C0
TIMER0_ICR			EQU 0x40030024		
TIMER0_CTRL			EQU 0x4003000C
TIMER0_TAILR 		EQU 0x40030028
							  ; 250 ns
RELOAD_VALUE_FAST 	EQU 7500  ; 1.875 ms
RELOAD_VALUE_MD1 	EQU 15000 ; 3.750 ms
RELOAD_VALUE_MD0 	EQU 30000 ; 7.500 ms
RELOAD_VALUE_SLOW 	EQU 50000 ; 12.50 ms
FREQ_ID_MULTLIER	EQU 330	  ; (50000-7500)/128 = 332.xx
	
					AREA Timer0A_Handler_Code, CODE, READONLY
					THUMB
					EXPORT 	Timer0A_Handler
					IMPORT 	FLAGS
					IMPORT 	ADC0SS3_FFT_MAX_ID
					IMPORT 	ADC0SS3_FFT_MAX
					IMPORT 	THRESH_AMP
Timer0A_Handler 	PROC
					; This timer is for Stepper Motor Step Control
					PUSH 	{R0, R1, R2, R3}
					LDR 	R1, =GPIO_PORTA_DATA_OUT 
					LDRB 	R0, [R1]
					LDR 	R2, =FLAGS
					LDRB 	R2, [R2]
					ANDS 	R2, #0x01
					BNE		CCW	; Dir = 1
					; 		CW  ; Dir = 0
					ANDS 	R2, R0, #0x80
					MOVNE 	R0, #0x08
					LSL 	R0, #1
					B 		DONE
CCW					ANDS 	R2, R0, #0x10
					MOVNE 	R0, #0x80
					LSREQ 	R0, #1
DONE				STRB 	R0, [R1]
					
					; Check Amplitude
					; 	Get Max Amplitude
					LDR 	R0, =ADC0SS3_FFT_MAX
					LDRH 	R0, [R0]
					; 	Get Amplitude Threshold
					LDR 	R1, =THRESH_AMP
					LDRH 	R1, [R1]
					CMP 	R0, R1
					BLE 	SKIP
					; Update TAILR / Motor Speed
					LDR 	R1, =TIMER0_TAILR
					LDR 	R0, =ADC0SS3_FFT_MAX_ID
					LDR 	R0, [R0]
					LDR 	R2, =RELOAD_VALUE_SLOW
					LDR 	R3, =FREQ_ID_MULTLIER
					MLS 	R0, R3, R0, R2			; R0 = SLOW - MLT * ID
					STR 	R0, [R1]
					
					; Clear The Interrupt
SKIP				LDR 	R1, =TIMER0_ICR
					LDR 	R0, [R1]
					ORR 	R0, #0x01
					STRB 	R0, [R1]
					
					; Enable TimerA of Timer0
					LDR 	R1, =TIMER0_CTRL
					MOV 	R0, #0x01
					STRB 	R0, [R1]

					POP 	{R0, R1, R2, R3}
					
					BX LR
					ENDP
						
					ALIGN
					END
