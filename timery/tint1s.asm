;
; obs�uga przerwania zegarowego
;

org 0
	ljmp start


org 0Bh	;procedura obs�ugi przerwania od TIMER0
	setb F0			;informujemy �e wyst�pi�o przerwanie
	mov TH0, #231	;�eby nast�pne przerwanie wyst�pi�o po 1/1152 sekundy
	reti			;powr�t z przerwania

org 40h
start:

	mov TMOD, #01110000b	;wy��czamy TIMER1, TIMER 0 w trybie 0
	setb ET0				;zgoda na przerwania od TIMER0
	setb EA					;globalna zgoda na ob�ug� przerwa�
	mov TH0, #231			;�eby pierwsze przerwanie nast�pi�o po 1/1152 sekundy
	setb TR0				;zgoda na zliczanie przez TIMER0

	mov R2, #128			;zliczanie do 1152
	mov R3, #5

czekaj:
	jnb F0, czekaj			;czekamy na przerwanie zegarowe
                    		;TUTAJ jestem 1152 razy na sekund�
	clr F0					;zapominamy o przerwaniu zegarowym
	djnz R2, czekaj			;zliczamy do 1152
	djnz R3, czekaj
							;TUTAJ jestem 1 raz na sekund�
	mov R2, #128			;odnawiamy liczniki �eby znowu policzy� do 1152
	mov R3, #5
   	cpl P1.7				;prze��czamy diod�
	sjmp czekaj				;wracamy na pocz�tek p�tli

end