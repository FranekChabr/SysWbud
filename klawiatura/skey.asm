;
;obs³uga klawiatury matrycowej
;
CSDS equ 30h
CSDB equ 38h
KBD equ P3.5
LED equ P1.7

	ljmp start

org 40h
start:
	;w³¹czamy wyœwietlacze, wybieramy wszystkie
	mov R1, #CSDS
	mov A, #00111111b
	movx @R1, A
	clr P1.6

petla:
	MOV C, KBD
	CPL C
	MOV LED, C

	sjmp petla

end
