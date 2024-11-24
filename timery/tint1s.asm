;
; obs³uga przerwania zegarowego
;

org 0
	ljmp start


org 0Bh	;procedura obs³ugi przerwania od TIMER0
	setb F0			;informujemy ¿e wyst¹pi³o przerwanie
	mov TH0, #231	;¿eby nastêpne przerwanie wyst¹pi³o po 1/1152 sekundy
	reti			;powrót z przerwania

org 40h
start:

	mov TMOD, #01110000b	;wy³¹czamy TIMER1, TIMER 0 w trybie 0
	setb ET0				;zgoda na przerwania od TIMER0
	setb EA					;globalna zgoda na ob³ugê przerwañ
	mov TH0, #231			;¿eby pierwsze przerwanie nast¹pi³o po 1/1152 sekundy
	setb TR0				;zgoda na zliczanie przez TIMER0

	mov R2, #128			;zliczanie do 1152
	mov R3, #5

czekaj:
	jnb F0, czekaj			;czekamy na przerwanie zegarowe
                    		;TUTAJ jestem 1152 razy na sekundê
	clr F0					;zapominamy o przerwaniu zegarowym
	djnz R2, czekaj			;zliczamy do 1152
	djnz R3, czekaj
							;TUTAJ jestem 1 raz na sekundê
	mov R2, #128			;odnawiamy liczniki ¿eby znowu policzyæ do 1152
	mov R3, #5
   	cpl P1.7				;prze³¹czamy diodê
	sjmp czekaj				;wracamy na pocz¹tek pêtli

end