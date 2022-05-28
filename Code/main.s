			AREA CNTRL_FLAGS, DATA, READWRITE
			THUMB
			EXPORT FLAGS
FLAGS 		DCB 0x00 ;	[...| SPEED1 . SPEED0 | DRCTION ] 
					 ;	[11: Fast, 00:Slow, 0: Cw, 1: CCW]

			AREA 	MainCode, CODE, READONLY
			THUMB
			EXPORT 	__main
			EXTERN 	Handle_KeyPad
			EXTERN 	Handle_Switches
			EXTERN 	Handle_ADC0SS3_DSP
			EXTERN 	INIT_GPIOA
			EXTERN 	INIT_GPIOB
			EXTERN 	INIT_GPIOD
			EXTERN 	INIT_GPIOE
			EXTERN 	INIT_GPIOF
			EXTERN 	INIT_ADC0
			EXTERN 	INIT_TIMER0
			EXTERN 	INIT_SPI3
			EXTERN 	INIT_SRAM
			EXTERN 	INIT_SysTick
			EXTERN 	INIT_Nokia5110
			EXTERN 	UPDATE_SCREEN
		
__main		BL 		INIT_SRAM
			BL 		INIT_GPIOA		; Motor Step Output	(4 output)
			BL 		INIT_GPIOB		; For KeyPad		(4 output+ 4 input)
			BL 		INIT_GPIOD	 	; For SPI3 			(SCK3, CS3, MISO3, MOSI3) [PD0 - PD3] | RST,DC [PD6, PD7]
			BL 		INIT_GPIOE		; For ADC0			(2 inputs: E2, E3) (Outputs: E4 (High), E5 (Open Drain))
			BL 		INIT_GPIOF		; For LEDs			(3 outputs + 2 Inputs [SW0, SW1])
			BL 		INIT_ADC0		; S3: PE3 (Microphone), S0: PE2 (Potentiometer)
			BL 		INIT_TIMER0		; Timer0A Motor Step Handling
			BL 		INIT_SPI3		; SPI for Nokia 5110 LCD Screen
			BL 		INIT_SysTick	; For ADC Trigger 2kHz
			BL 		INIT_Nokia5110	; Initiation Precedures of Nokia5110
			
			CPSIE 	I
			
LOOP		BL 		Handle_KeyPad
			BL		Handle_Switches
			BL 		Handle_ADC0SS3_DSP
			BL 		UPDATE_SCREEN

			B 		LOOP
			ALIGN
			END