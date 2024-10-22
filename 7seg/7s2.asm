;program wy�wietla statycznie dwie cyfry lub kropk� na wybranych wy�wietlaczach

SEG_ON equ P1.6
WYSWIETLACZ equ 00100001b

KROPKA equ 10000000b
JEDEN equ 00000011b
;DWA ...

CSDS equ 30h  ;0FF30h je�li u�ywamy DPTR
CSDB equ 38h  ;0FF38h je�li u�ywamy DPTR

org 0
	ljmp start

org 100h
start:
	mov R0, #CSDS ; R0, R1, DPTR
	mov A, #WYSWIETLACZ
	movx @R0, A

	mov R0, #CSDB
	mov A, #KROPKA
	; odkomentowa�, �eby wy�wietla�y si� cyfry
	;mov A, #2
	;mov DPTR, #wzory
	;movc A, @A+DPTR   ; A = *(DPTR+A)
	movx @R0, A			; *R0=A

	clr SEG_ON

	sjmp $

wzory:
db 00111111b, 00000110b, 01011011b, 01001111b	;0-3
db 01100110b, 01101101b, 01111101b, 00000111b	;4-7
db 01111111b, 01101111b, 01110111b, 01111100b	;8-b

end