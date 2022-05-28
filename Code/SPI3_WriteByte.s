GPIO_PORTD_DATA_CS	EQU 0x40007080					
SSI3_SSISR 			EQU 0x4000B00C
SSI3_SSIDR 			EQU 0x4000B008

					; Inputs: R0, Byte Data
					AREA 	SPI3_WRT_BYTE_CODE, CODE, READONLY
					THUMB
					EXPORT 	SPI3_WRT_BYTE
SPI3_WRT_BYTE 		PROC
					PUSH 	{R0, R1, R2}
					
					; Set Low to CS
					LDR		R1, =GPIO_PORTD_DATA_CS
					LDR 	R2, [R1]
					BIC 	R2, #0x02
					STRB 	R2, [R1]
					
					; Check Fullness of TX FIFO and Busy Flag
					LDR 	R1, =SSI3_SSISR
CHECH_FULLNESS		LDR 	R2, [R1]
					ANDS	R2, #0x02
					BEQ		CHECH_FULLNESS
					
					; Check Busy Flag
CHECH_BUSY			LDR 	R2, [R1]
					ANDS 	R2, #0x10
					BNE 	CHECH_BUSY
					
					; Put Data
					LDR 	R1, =SSI3_SSIDR
					STRB 	R0, [R1]
					
					; Wait Until Data is Sent
					LDR 	R1, =SSI3_SSISR
CHECH_SENT			LDR 	R2, [R1]
					ANDS	R2, #0x10
					BNE		CHECH_SENT

					; Set High to CS
					LDR 	R1, =GPIO_PORTD_DATA_CS
					LDR 	R0, [R1]
					ORR 	R0, #0x02
					STRB 	R0, [R1]
					
					POP 	{R0, R1, R2}
					BX 		LR
					ENDP
					ALIGN
					END