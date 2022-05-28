GPIO_PORTF_DATA_OUT EQU 0x40025038
				
					AREA 	SET_LED_STS_CODE, CODE, READONLY
					THUMB
					EXPORT 	SET_LED_STS
					IMPORT 	SCREEN_DATA
					IMPORT 	ADC0SS3_FFT_MAX
					IMPORT 	ADC0SS3_FFT_MAX_ID
					IMPORT 	THRESH_AMP
					IMPORT 	THRESH2
					IMPORT 	THRESH3
SET_LED_STS 		PROC
					PUSH 	{R0-R2}
					; 	Get Max Amplitude
					LDR 	R0, =ADC0SS3_FFT_MAX
					LDRH 	R0, [R0]
					; 	Get Amplitude Threshold
					LDR 	R1, =THRESH_AMP
					LDRH 	R1, [R1]
					CMP 	R0, R1
					BLE 	LED_OFF				; [0-39(300 Hz)-77(600 Hz)-128(1kHz)]
					; 	Compare Freq and Thresholds
					LDR 	R0, =ADC0SS3_FFT_MAX_ID
					LDR 	R0, [R0]
					LDR 	R1, =THRESH2
					LDRB 	R1, [R1]
					CMP 	R0, R1
LED_ON				BGE		LED_GB
LED_R				MOV 	R2, #0x02
					B 		DONE
LED_GB				LDR 	R1, =THRESH3
					LDRB 	R1, [R1]
					CMP		R0, R1
					BGE		LED_B
LED_G				MOV 	R2, #0x08
					B 		DONE
LED_B				MOV 	R2, #0x04
					B 		DONE
LED_OFF				MOV 	R2, #0x00
DONE				LDR 	R1, = GPIO_PORTF_DATA_OUT
					STRB 	R2, [R1]
					POP 	{R0-R2}
					BX 		LR	
					ENDP
					ALIGN
					END