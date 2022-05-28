TIMER0_CTRL		EQU 0x4003000C
TIMER0_CNFG		EQU 0x40030000
TIMER0_TAMR		EQU 0x40030004
TIMER0_TAPR		EQU 0x40030038
TIMER0_TAILR 		EQU 0x40030028
TIMER0_ICR			EQU 0x40030024
TIMER0_IMR 			EQU 0x40030018
RCGCTIMER			EQU 0x400FE604
PRTIMER 			EQU 0x400FEA04
NVIC_EN0 			EQU 0xE000E100 
NVIC_PRI4       	EQU 0xE000E410
							  ; 250 ns
RELOAD_VALUE_FAST 	EQU 7500  ; 1.875 ms
RELOAD_VALUE_MD1 	EQU 15000 ; 3.750 ms
RELOAD_VALUE_MD0 	EQU 30000 ; 7.500 ms
RELOAD_VALUE_SLOW 	EQU 50000 ; 12.50 ms
FREQ_ID_MULTLIER	EQU 330	  ; (50000-7500)/128 = 332.xx
	
				AREA INIT_TIMER0_CODE, CODE, READONLY
				THUMB
				EXPORT INIT_TIMER0
INIT_TIMER0		PROC
				PUSH 	{R0, R1}
				
				; Enable Timer0 Clock
				LDR 	R1, =RCGCTIMER
				LDR 	R0, [R1]
				ORR 	R0, #0x01
				STRB 	R0, [R1]

				; Check Timer0 Ready Status
CHK_PRT			LDR 	R1, =PRTIMER
				LDR 	R0, [R1]
				ANDS  	R0, #0x01
				BEQ 	CHK_PRT
				
				; Disable TimerA and TimerB
				LDR 	R1, =TIMER0_CTRL
				MOV 	R0, #0x0000
				STR 	R0, [R1]
				
				; Select 32 Bit Timer
				LDR 	R1, =TIMER0_CNFG
				MOV 	R0, #0x04
				STR 	R0, [R1]
				
				; Configure Timer0 TimerA Prescaler
				LDR 	R1, =TIMER0_TAPR
				MOV 	R0, #3		; 16 MHz / (3 + 1) : 4 MHz , 250 ns
				STRB 	R0, [R1]
				
				; Configure TimerA of Timer0
				LDR 	R1, =TIMER0_TAMR
				MOV 	R0, #0x01 	; One-Shot & Counting Down
				STRB 	R0, [R1]
				
				; Configure TimerA of Timer0 Load Value
				LDR 	R1, =TIMER0_TAILR
				LDR 	R0, =RELOAD_VALUE_SLOW
				STR 	R0, [R1]
				
				; Enable Interrupts
				LDR 	R1, =TIMER0_IMR
				MOV 	R0, #0x01	; Enable TimerA Time-out Interrupt
				STRB 	R0, [R1]
				
				; Clear TimerA of Timer0 Interrupt
				LDR 	R1, =TIMER0_ICR
				MOV 	R0, #0x0F
				STRB 	R0, [R1]
				
				; Enable TimerA of Timer0
				LDR 	R1, =TIMER0_CTRL
				MOV 	R0, #0x01
				STRB 	R0, [R1]
				
				; NVIC Interrupt Priority (Timer0A 19)
				LDR R1, =NVIC_PRI4
				LDR R0, [R1]
				ORR R0, #0x40000000
				STR R0, [R1]
				
				; Enable NVIC Interrupt
				LDR 	R1, =NVIC_EN0
				LDR 	R0, [R1]
				ORR 	R0, #0x00080000
				STR 	R0, [R1]
				
				POP 	{R0, R1}			
				BX 		LR
				ENDP
				
				ALIGN
				END