;
;obs�uga klawiatury matrycowej
;
CSDS equ 30h
CSDB equ 38h
KB1  equ 21h  ;pierwszy bufor klawiatury
KB2  equ 22h  ;drugi bufor klawiatury

	ljmp start

org 40h
start:
	;w��czamy wy�wietlacze, wybieramy wszystkie
	mov R1, #CSDS
	mov A, #00111111b
	movx @R1, A
	clr P1.6

petla:
	mov R0, #KB2
	movx A, @R0
	;wzorek na wy�wietlacz
	mov R1, #CSDB
	movx @R1, A

	sjmp petla

end
