			AREA Init_SRAM_Code, CODE, READONLY
			THUMB
			EXPORT 	INIT_SRAM
			IMPORT 	KeyPattern
			IMPORT 	COL_DATA
			IMPORT 	COLM_CNTR
			IMPORT 	FLAGS
			IMPORT 	SW_DATA
			IMPORT 	ADC0SS3_DT_RDY_F
			IMPORT  ADC0SS3_FFT_MAX_ID
			IMPORT 	ADC0SS3_SIZE
			IMPORT 	UPDATE_SCRN_F
			IMPORT 	UPDATE_SCRN_C
			IMPORT 	SCREEN_DATA
			IMPORT 	THRESH_IN_FLG
			IMPORT 	THRESH_NMBR_CNT
			IMPORT 	THRESH_NMBR
			IMPORT 	THRESH2			; Low Freq Thresh
			IMPORT 	THRESH3			; High Freq Thresh
		
INIT_SRAM	PROC
			PUSH 	{R0, R1, LR}
			
			LDR 	R1, =FLAGS
			MOV 	R0, #0x00
			STRB 	R0, [R1]
			
			LDR 	R1, =COLM_CNTR
			STR 	R0, [R1]
			
			LDR 	R1, =COL_DATA
			MOV 	R0, #0x0F0F0F0F
			STR 	R0, [R1]
			
			LDR 	R1, =KeyPattern
			LDR 	R0, =0x41333231
			STR 	R0, [R1], #4
			LDR 	R0, =0x42363534
			STR 	R0, [R1], #4
			LDR 	R0, =0x43393837
			STR 	R0, [R1], #4
			LDR 	R0, =0x4423302A
			STR 	R0, [R1]
			
			LDR 	R1, =SW_DATA
			MOV 	R0, #0x11
			STRB 	R0, [R1]
			
			LDR 	R1, =ADC0SS3_DT_RDY_F
			MOV		R0, #0x00
			STRB 	R0, [R1]
			
			LDR 	R1, =ADC0SS3_SIZE
			STRB 	R0, [R1]
			
			LDR 	R1, =THRESH_IN_FLG
			STRB 	R0, [R1]
			
			LDR 	R1, =THRESH_NMBR_CNT
			STRB 	R0, [R1]
			
			LDR 	R1, =THRESH_NMBR
			STR 	R0, [R1]
			
			LDR 	R1, =ADC0SS3_FFT_MAX_ID
			STR 	R0, [R1]
			
			LDR 	R1, =UPDATE_SCRN_C
			MOV 	R0, #1999
			STRH 	R0, [R1]
			
			LDR 	R1, =UPDATE_SCRN_F
			MOV 	R0, #1
			STRB 	R0, [R1]
			
			LDR 	R1, =THRESH2
			MOV 	R0, #39
			STRB 	R0, [R1]
			
			LDR 	R1, =THRESH3
			MOV 	R0, #77
			STRB 	R0, [R1]
			

			; Screen Data		
			LDR 	R1, =SCREEN_DATA
			; 1st Row
			MOV 	R0, #52
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #50
			STRB 	R0, [R1], #1
			MOV 	R0, #51
			STRB 	R0, [R1], #1
			MOV 	R0, #17
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			
			; 2st Row
			MOV 	R0, #52
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #50
			STRB 	R0, [R1], #1
			MOV 	R0, #51
			STRB 	R0, [R1], #1
			MOV 	R0, #18
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #19
			STRB 	R0, [R1], #1
			MOV 	R0, #16
			STRB 	R0, [R1], #1
			MOV 	R0, #16
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #90
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			
			
			; 3st Row
			MOV 	R0, #52
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #50
			STRB 	R0, [R1], #1
			MOV 	R0, #51
			STRB 	R0, [R1], #1
			MOV 	R0, #19
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #22
			STRB 	R0, [R1], #1
			MOV 	R0, #16
			STRB 	R0, [R1], #1
			MOV 	R0, #16
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #90
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1					
					
			; 4th Row
			MOV 	R0, #38
			STRB 	R0, [R1], #1
			MOV 	R0, #50
			STRB 	R0, [R1], #1
			MOV 	R0, #37
			STRB 	R0, [R1], #1
			MOV 	R0, #49
			STRB 	R0, [R1], #1
			MOV 	R0, #00
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #40
			STRB 	R0, [R1], #1
			MOV 	R0, #90
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1

			; 5th Row
			MOV 	R0, #33
			STRB 	R0, [R1], #1
			MOV 	R0, #45
			STRB 	R0, [R1], #1
			MOV 	R0, #48
			STRB 	R0, [R1], #1
			MOV 	R0, #44
			STRB 	R0, [R1], #1
			MOV 	R0, #52
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			
			; 6th Row
			MOV 	R0, #44
			STRB 	R0, [R1], #1
			MOV 	R0, #37
			STRB 	R0, [R1], #1
			MOV 	R0, #36
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #26
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #13
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			MOV 	R0, #0
			STRB 	R0, [R1], #1
			
			POP 	{R0, R1, LR}	
			BX LR
			
			ENDP
			ALIGN
			END