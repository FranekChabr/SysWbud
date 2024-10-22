;program wyœwietla kolejne cyfry

SEG_ON equ P1.6
WYSWIETLACZ equ 00000001b
CSDS equ 30h  
CSDB equ 38h  

org 0
	ljmp start

org 100h
start:
	clr SEG_ON
	mov R7, #WYSWIETLACZ
	mov R4, #0 ; cyfra
	mov DPTR, #wzory
	mov R3, #4 ; dla opóŸniaczki
	
petla:
	mov R0, #CSDS 
	mov A, R7
	movx @R0, A
	rl A
	mov R7, A

	mov R0, #CSDB
	mov A, R4
	movc A, @A+DPTR
	movx @R0, A
	inc R4

czekaj:
	DJNZ R6, czekaj
	DJNZ R5, czekaj
	DJNZ R3, czekaj
	mov R3, #4

	sjmp petla

wzory:
db 00111111b, 00000110b, 01011011b, 01001111b	;0-3
db 01100110b, 01101101b, 01111101b, 00000111b	;4-7
db 01111111b, 01101111b, 01110111b, 01111100b	;8-b

end