; OutChar.s
; Runs on TM4C123
		
; Sends ASCII character placed in R5
; out through UART0

; Baud = 9600, 8-bit, No Parity
; 1 Stop bit, No flow control

	
; GPIO Registers *****************
RCGCGPIO		  	EQU 0x400FE608	; GPIO clock register
; GPIO base address	  = 0x40004000
PORTA_DEN			EQU 0x4000451C	; Digital Enable
PORTA_PCTL		  	EQU 0x4000452C	; Alternate function select
PORTA_AFSEL		 	EQU 0x40004420	; Enable Alt functions
PORTA_AMSEL		 	EQU 0x40004528	; Enable analog
PORTA_DR2R			EQU	0x40004500	; Drive current select
	
; UART Registers *****************
RCGCUART			EQU	0x400FE618	; UART clock register
	
UART0_DR			EQU	0x4000C000	; UART0 data / base address
UART0_CTL			EQU	0x4000C030	; UART0 control register
UART0_IBRD			EQU	0x4000C024	; Baud rate divisor Integer part
UART0_FBRD			EQU	0x4000C028	; Baud rate divisor Fractional part
UART0_LCRH			EQU	0x4000C02C	; UART serial parameters
UART0_CC			EQU 0x4000CFC8	; UART clock config
UART0_FR			EQU 0x4000C018	; UART status

SYSCTL_RCC2_R       EQU 0x400FE070	; PLL control
SYSCTL_RIS_PLLLRIS  EQU 0x00000040
						

        AREA    |.text|, READONLY, CODE, ALIGN=2
					
        THUMB
		
;		EXTERN	Delay
		
;		EXPORT	OutCharInit
        EXPORT  OutChar				; make availavle to other programs

;OutCharInit
OutChar
	PUSH		{R0-R4}					; store registers

	; Enable UART clock
	LDR		R1, =RCGCUART
	LDR		R0, [R1]
	ORR		R0, R0, #0x01				; set bit 0 to enable UART0 clock
	STR		R0, [R1]
	NOP									; Let clock stabilize
    NOP
    NOP  

; Setup GPIO
	; Enable GPIO clock to use debug USB as com port (PA0, PA1)
	LDR		R1, =RCGCGPIO
	LDR		R0, [R1]
	ORR		R0, R0, #0x01				; set bit 0 to enable port A clock
	STR		R0, [R1]
	NOP									; Let clock stabilize
    NOP
    NOP 
	
	; Make PA0, PA1 digital
	LDR		R1, =PORTA_DEN
	LDR		R0, [R1]
	ORR		R0, R0, #0x03				; set bits 1,0 to enable alt functions on PA0, PA1
	STR		R0, [R1]
	
	; Disable analog on PA0, PA1
	LDR		R1, =PORTA_AMSEL
	LDR		R0, [R1]
	BIC		R0, R0, #0x03				; clear bits 1,0 to disable analog on PA0, PA1
	STR		R0, [R1]
	
	; Enable alternate functions selected
	LDR		R1, =PORTA_AFSEL
	LDR		R0, [R1]
	ORR		R0, R0, #0x03				; set bits 1,0 to enable alt functions on PA0, PA1
	STR		R0, [R1]
	
	; Select alternate function to be used (UART on PA0, PA1)
	LDR		R1, =PORTA_PCTL
	LDR		R0, [R1]
	ORR		R0, R0, #0x11				; set bits 4,0 to select UART Rx, Tx
	STR		R0, [R1]
	
; Setup UART
	; Disable UART while setting up
	LDR		R1, =UART0_CTL
	LDR		R0, [R1]
	BIC		R0, R0, #0x01				; Clear bit 0 to disable UART0 wjile
	STR		R0, [R1]					; setting up
	
	; Set baud rate to 9600. Divisor = 16MHz/(16*9600)= 104.16666
	; Set integer part to 104
	LDR		R1, =UART0_IBRD
	MOV		R0, #26					; 26 -> 38400
	STR		R0, [R1]
	
	; Set fractional part
	;	0.16666*64+0.5 = 11.16666 => Integer = 11
	LDR		R1, =UART0_FBRD
	MOV		R0, #3					;  3 -> 38400
	STR		R0, [R1]
	
	; Set serial parameters
	LDR		R1, =UART0_LCRH
	MOV		R0, #0x70			; No stick parity, 8bit, FIFO enabled, 
	STR		R0, [R1]				; One stop bit, Disable parity, Normal use
	
	;; Enable UART, TX, RX
	;LDR		R1, =UART0_CTL
	;LDR		R0, [R1]
	;MOV		R2, #0x00000301				; Set bits 9,8,0
	;ORR		R0, R0, R2
	;STR		R0, [R1]
	
	;POP		{R0-R4}						; restore registers
	
	;BX		LR
	
;OutChar

	;PUSH		{R0-R4}					; store registers
	
	; Enable UART, TX, Disable RX
	LDR		R1, =UART0_CTL
	MOV		R2, #0x00000101				; Set bits 8,0
	STR		R2, [R1]
	
	
	; Disable PLL
	LDR		R1,=SYSCTL_RCC2_R
	LDR		R0,[R1]
	PUSH	{R0}						; store current state
	ORR		R0,R0,#0x00002000  			; Power-Down PLL 2
	STR		R0,[R1] 
	
	
	
	
;	MOV		R5, #0x01					; reset delay count
;	BL		Delay						; delay conversions


	; load flag register location
	LDR 	R1, =UART0_FR	

waitR
	; check if UART is ready (buffer is empty)
				; load UART status register address
	LDR		R0, [R1]
    ANDS	R0,R0,#0x20                 ; check if TXFF = 1
    BNE 	waitR	                    ; If so, UART is full, so wait / check again
	
	; load R4 with UART data address
	LDR		R4, =UART0_DR
	STR		R5,[R4]						; Put character in UART data register	
	
waitD
	; check if UART is done transmitting
	LDR		R0, [R1]
    ANDS	R0,R0,#0x08                 ; check if BUSY = 1
    BNE 	waitD	                    ; If so, UART is busy, so wait / check again
	
	; Disable UART, TX, Disable RX
	LDR		R1, =UART0_CTL
	MOV		R2, #0x00000000				; clear bits 8,0
	STR		R2, [R1]
	
	; Restore PLL
	LDR		R1,=SYSCTL_RCC2_R
	POP		{R0}						; restore state
	STR		R0,[R1]
	
	


	POP		{R0-R4}						; restore registers
	BX  	LR							; Return to caller
	
	
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
