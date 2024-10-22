; komentarz
LED bit P1.7
BUZZ equ P1.5 ;brzeczyk ten caly
TIME_MS equ 100

org 0
	ljmp start

org 40h
start:
	mov R1, #255
	mov R2, #40H
petla:
	DJNZ R1, petla
	DJNZ R2, petla

	cpl LED
	;cpl BUZZ
	sjmp petla





end