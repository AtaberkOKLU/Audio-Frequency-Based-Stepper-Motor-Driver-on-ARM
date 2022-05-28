				AREA 	SCREEN_MEM, DATA, READWRITE
				THUMB
				EXPORT 	SCREEN_DATA
				; 14 Chars (6bit*14 = 84) in each row.
				; 48 / 8 = 6 row;
				; ________________
				; |THRS1: ---    |	; Amplitude 	(+)
				; |THRS2: --- Hz | 	; Low 	- 300 	(+)
				; |THRS3: --- Hz | 	; High 	- 600   (+)
				; |FREQ : --- Hz |					(+)
				; |AMPLT: ---    |					(+)
				; |LED  : -      |	; 0: OFF (1,2,3)(+)
				; ----------------
				
SCREEN_DATA		DCB 52, 40, 50, 51, 17, 26, 0x00, 13, 13, 13, 0x00, 0x00, 0x00, 0x00,\
					52, 40, 50, 51, 18, 26, 0x00, 19, 16, 16, 0x00, 40, 90, 0x00,\
					52, 40, 50, 51, 19, 26, 0x00, 22, 16, 16, 0x00, 40, 90, 0x00,\
					38, 50, 37, 49, 00, 26, 0x00, 13, 13, 13, 0x00, 40, 90, 0x00,\
					33, 45, 48, 44, 52, 26, 0x00, 13, 13, 13, 0x00, 0x00, 0x00, 0x00,\
					44, 37, 36, 0, 0,   26, 0x00, 13, 0 , 0 , 0x00, 0x00, 0x00, 0x00	
				ALIGN
				END