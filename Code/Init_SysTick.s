NVIC_ST_CTRL 		EQU 0xE000E010
NVIC_ST_RELOAD 		EQU 0xE000E014
NVIC_ST_CURRENT 	EQU 0xE000E018
SHP_SYSPRI3 		EQU 0xE000ED20
								; 250 ns
RELOAD_VALUE_2kHZ 	EQU 2000	; 0.5 ms -> 2kHz
	
				AREA INIT_SysTick_Code, CODE, READONLY
				THUMB
				EXPORT INIT_SysTick
			
INIT_SysTick	PROC
				PUSH {R0, R1}
				LDR R1, =NVIC_ST_CTRL
				MOV R0, #0
				STR R0, [R1]

				LDR R1, =NVIC_ST_RELOAD
				LDR R0, =RELOAD_VALUE_2kHZ
				STR R0, [R1]

				LDR R1, =NVIC_ST_CURRENT
				STR R0, [R1]

				; Interrupt Priority
				LDR R1, =SHP_SYSPRI3
				LDR R0, [R1]
				ORR R0, #0x20000000
				STR R0, [R1]

				; Enable SysTick and Interrupt
				LDR R1, =NVIC_ST_CTRL
				MOV R0, #0x03
				STR R0, [R1]
				
				POP {R0, R1}				
				BX LR
				ENDP
			
				ALIGN
				END