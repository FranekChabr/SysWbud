;program wy�wietla statycznie dwie jedynki na najm�odszych wy�wietlaczach

SEG_ON equ P1.6
DISP equ 03h
ZNAK equ 06h  ; 00000110b
CSDS equ 30h  ;Bufor wyboru wy�wietlacza ;0FF30h je�li u�ywamy DPTR
CSDB equ 38h  ;Bufor wyboru diod ;0FF38h je�li u�ywamy DPTR

org 0
	ljmp start

org 100h
start:
	mov R0, #CSDS ;R0, R1, DPTR
	mov A, #DISP ;A=DISP
	movx @R0, A ;*R0=A

	mov R0, #CSDB ;R0=CSDB
	mov A, #ZNAK  ;A=ZNAK
	movx @R0, A ;*R0=A

	clr SEG_ON

	sjmp $
	
end