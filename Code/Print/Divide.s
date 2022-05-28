		AREA DivideA, CODE, READONLY
		THUMB
		EXPORT Divide

;Precondition : R0 % R1 is the required computation
;Postcondition: R0 has the result of R0 % R1
;             : R2 has R0 / R1



Divide 	PROC
		CMP   R0, #0         ; return 0,0 instead of divide error for the 0/0 corner case.
		BEQ   zero_dividend 

		CMP   R1, #0
		BEQ   div_by_zero
       
		UDIV  R2, R0, R1      ; 1 <- 10 / 7       ; R2 <- R0 / R1
		MLS   R0, R1, R2, R0  ; 3 <- 10 - (7 * 1) ; R0 <- R0 - (R1 * R2 )
		BX 	  LR
div_by_zero      
		SUBS  R0, #1         

zero_dividend    
		MOVS  R0, #0 
		MOV   R2, #0
		BX    LR
		ENDP
		  
		ALIGN
		END