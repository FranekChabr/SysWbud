;
;	obs³uga przerwania zegarowego
;

org 0
	ljmp start
	
org 0Bh		;procedura obs³ugi przerwania zegarowego
	cpl P1.5
	ret

org 40h
start:

	mov TMOD, #01110000b
	setb ET0
	setb EA
	setb TR0

	sjmp $

end
