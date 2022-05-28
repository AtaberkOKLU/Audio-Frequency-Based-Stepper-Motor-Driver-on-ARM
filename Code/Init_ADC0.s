ADC0_RCGCADC 	EQU 0x400FE638
ADC0_PRADC		EQU 0x400FEA38
ADC0_ACTSS		EQU 0x40038000
ADC0_EMUX		EQU 0x40038014
ADC0_SSCTL0		EQU 0x40038044
ADC0_SSMUX0		EQU 0x40038040
ADC0_SSCTL3		EQU 0x400380A4
ADC0_SSMUX3		EQU 0x400380A0
ADC0_PSSI  		EQU 0x40038028
ADC0_IM			EQU 0x40038008
ADC0_SSPRI 		EQU 0x40038020
NVIC_EN0 		EQU 0xE000E100 
NVIC_PRI3       EQU 0xE000E40C
NVIC_PRI4       EQU 0xE000E410

				AREA INIT_ADC0_CODE, CODE, READONLY
				THUMB
				EXPORT INIT_ADC0
				
INIT_ADC0		PROC
				PUSH 	{R0, R1}
				
				; Enable ADC0 Clock
				LDR 	R1, =ADC0_RCGCADC
				MOV 	R0, #0x01
				STR 	R0, [R1]
				
				; Check Clock
CHK_PRT			LDR 	R1, = ADC0_PRADC
				LDR 	R0, [R1]
				ANDS  	R0, #0x01
				BEQ 	CHK_PRT
				
				; Disable Sample Sequentials
				LDR 	R1, =ADC0_ACTSS
				MOV 	R0, #0x00
				STRB 	R0, [R1]
				
				; Configure SS3
				LDR 	R1, =ADC0_SSCTL3
				MOV 	R0, #0x06		; End Of Sequence: one-conversion + End Interrupt
				STRB 	R0, [R1]
				
				; Configure SS0
				LDR 	R1, =ADC0_SSCTL0
				MOV 	R0, #0x06		; End Of Sequence: one-conversion + End Interrupt
				STR 	R0, [R1]
				
				; Configure SS3 Pin
				LDR 	R1, =ADC0_SSMUX3
				MOV 	R0, #0x00 		; PE3 -> AIN0
				STRB 	R0, [R1]
				
				; Configure SS0 Pins
				LDR 	R1, =ADC0_SSMUX0
				MOV 	R0, #0x00000001 ; PE2 -> AIN1
				STR 	R0, [R1]
				
				LDR 	R1, =ADC0_SSPRI
				MOV 	R0, #0x00000213
				STR 	R0, [R1]
				
				; Configure SS0 Interrupt
				LDR 	R1, =ADC0_IM
				MOV 	R0, #0x00000009 ; ADC0Seq0_Handler (14) + ADC0Seq3_Handler (17)
				STR 	R0, [R1]
				
				; NVIC Interrupt Priority (ADC0 Sequence 0: 14)
				LDR R1, =NVIC_PRI3
				LDR R0, [R1]
				ORR R0, #0x00400000
				STR R0, [R1]
				
				
				; NVIC Interrupt Priority (ADC0 Sequence 3: 17)
				LDR R1, =NVIC_PRI4
				LDR R0, [R1]
				ORR R0, #0x00002000
				STR R0, [R1]
				
				; Enable NVIC Interrupt
				LDR 	R1, =NVIC_EN0
				LDR 	R0, [R1]
				ORR 	R0, #0x00024000
				STR 	R0, [R1]
				
				; Enable Sample Sequentials
				LDR 	R1, =ADC0_ACTSS
				MOV 	R0, #0x09		; SS0 + SS3
				STRB 	R0, [R1]
				
				; Start Conversion for SS0 -> Potantiometer
				LDR 	R1, =ADC0_PSSI
				MOV 	R0, #0x00000001
				STR 	R0, [R1]
				
				POP 	{R0, R1}	
				BX 		LR
				ENDP
				
				ALIGN
				END