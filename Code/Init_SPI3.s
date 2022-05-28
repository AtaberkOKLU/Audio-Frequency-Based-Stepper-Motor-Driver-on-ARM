RCGCSSI			EQU 0x400FE61C
PRSSI			EQU 0x400FEA1C
SSI3_SSICR0		EQU 0x4000B000
SSI3_SSICR1		EQU 0x4000B004
SSI3_SSICPSR 	EQU 0x4000B010
	
				AREA INIT_SPI3_CODE, CODE, READONLY
				THUMB
				EXPORT INIT_SPI3
INIT_SPI3		PROC
				PUSH 	{R0 ,R1}
				
				; Enable SSI3
				LDR 	R1, =RCGCSSI
				LDRB 	R0, [R1]
				ORR 	R0, #0x08
				STRB 	R0, [R1]
				
				; Check Ready SSI3
CHECK			LDR 	R1, =PRSSI
				LDRB 	R0, [R1]
				ANDS 	R0, #0x08
				BEQ		CHECK
				
				; Disable SSI3
				LDR 	R1, =SSI3_SSICR1
				MOV 	R0, #0x00
				STRB 	R0, [R1]
				
				; Configure Clock Divider to 4 -> 16Mhz/4
				LDR 	R1, =SSI3_SSICPSR
				MOV 	R0, #0x10
				STRB 	R0, [R1]
				
				; Configure as Master 8-bit frame and FreeScale
				LDR 	R1, =SSI3_SSICR0
				MOV 	R0, #0x0007
				STRH 	R0, [R1]
				
				; Enable SSI3
				LDR 	R1, =SSI3_SSICR1
				MOV 	R0, #0x02
				STRB 	R0, [R1]

				POP 	{R0, R1}
				BX 		LR
				ENDP
				ALIGN
				END