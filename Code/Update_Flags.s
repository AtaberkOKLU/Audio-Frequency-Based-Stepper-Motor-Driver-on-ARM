NVIC_ST_RELOAD 		EQU 0xE000E014
NVIC_ST_CURRENT 	EQU 0xE000E018
							  ; 250 ns
RELOAD_VALUE_FAST 	EQU 7500  ; 1.875 ms
RELOAD_VALUE_MD1 	EQU 15000 ; 3.750 ms
RELOAD_VALUE_MD0 	EQU 30000 ; 7.500 ms
RELOAD_VALUE_SLOW 	EQU 50000 ; 12.50 ms

; Input: R0 -> Change in bit
					AREA 	UPDATE_FLAGS_Code, CODE, READONLY
					THUMB
					IMPORT 	FLAGS
					EXPORT 	UPDATE_FLAGS
UPDATE_FLAGS		PROC
					PUSH 	{R0, R1, R2, R3}
					LDR 	R1, =FLAGS
					
					MOV 	R3, #0x10
					ANDS 	R2, R0, R3
					BNE 	SW1
SW2					MOV 	R2, #0x01		; CCW
					ORR 	R0, R0, R2
					B 		DONE
SW1					MOV 	R2, #0xFE		; CW
					AND 	R0, R0, R2
DONE				STRB 	R0, [R1]
					POP 	{R0, R1, R2, R3}	
					BX 		LR
					ENDP
					ALIGN
					END