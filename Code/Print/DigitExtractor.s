				AREA DigitExtractorArea, CODE, READONLY
				THUMB
				EXPORT DigitExtractor
				EXTERN Divide
				
				; Input R4 -> Number, R5 -> Char Address
			
DigitExtractor	PROC
				PUSH 	{LR}
				PUSH	{R0, R1, R2, R3, R4, R5}
				MOV 	R0, R4
				MOV		R1, #10
				MOV 	R3, #0			; # of Digits
				;Precondition : R0 % R1 is the required computation
				;Postcondition: R0 has the result of R0 % R1
				;             : R2 has R0 / R1
				
				;; input:  R1=divisor,  R0=dividend (R0/R1)
loop			BL		Divide
				;; output: R2=quotient, R0=remainder, C flag unset.
				PUSH 	{R0}
				ADD		R3, #1
				MOV 	R0, R2		; Dividend
				MOV 	R1, #10		; Divisor
				CMP   	R2, #0		; Cmp Quotient
				BNE 	loop
print 
				POP 	{R0}
				ADD 	R0, #48
				STRB 	R0, [R5], #1
				SUBS 	R3, #1 
				BNE	print

done			MOV 	R3, #0x0D 	; End Character
				STRB 	R3, [R5], #1
				MOV 	R3, #0x04 	; End Character
				STRB 	R3, [R5]
				POP		{R0, R1, R2, R3, R4, R5}
				POP 	{PC}
				; BX LR
				ENDP

								
				ALIGN
				END