;
;obs³uga wyœwietlacza 7 segmentowego
;

CSDS equ 30H	;bufor wyboru wskaŸnika 7-segmentowego
CSDB equ 38H	;bufor danych wskaŸnika 7-segmentowego

KEYB equ 7Ch	;4 ostatnie stany klawiatury
CZAS equ 75h	;tablica przechowuj¹ca wskazanie zegarka
SS equ 74h		;sekundy
MM equ 73h		;
GG equ 72h		;

org 0
	ljmp start

org 0Bh		;procedura obs³ugi przerwania zegarowego
	mov TH0, #231	;¿eby nastêpne przerwanie wyst¹pi³o po 1/1152 sekundy
	setb F0		;informujemy o wyst¹pieniu przerwania
	reti		;wracamy z przerwania

org 40H
start:

	;145026

	mov SS, #26
	mov MM, #50
	mov GG, #14
	mov DPTR, #wzory     ;adres wzorow do DPTR
	acall przelicz

	mov R7, #00000001b   ;najmlodszy wyswietlacz do r7
	mov R1, #CZAS        ;adres najmlodszej cyfry w tablicy CZAS do R1

	mov R2, #128	;inicjujemy liczniki na zliczanie do 1152
	mov R3, #5

	mov TMOD, #01110000b	;blokujemy TIMER1, TIMER0 w trybie 0
	setb ET0			;zgoda na przerwania od TIMER0
	setb EA				;globalna zgoda na przerwania
	mov TH0, #231	;¿eby pierwsze przerwanie wyst¹pi³o po 1/1152 sekundy
	setb TR0			;zgoda na zliczanie przez TIMER0

	mov CZAS+6, #00100000b

petla:
	jnb F0, petla	;czekamy na informacjê o wyst¹pieniu przerwania
	clr F0			;zapominamy o wyst¹pieniu przerwania
;	cpl P1.5		;TUTAJ jestem 1152 razy na sekundê

	mov R0, #CSDB  		 ;adres bufora segmentow do R0
	mov A, @R1      	 ;aktualna cyfra z CZAS do ACC
	inc R1          	 ;inkremetuje R1 na potrzeby nastepnego obrotu petli
	setb P1.6            ;wy³¹czam wyswietlacze ¿eby nie bylo duchow
;	movc A, @A+DPTR   	 ;zamieniam cyfre na odpwiadajacy jej wzorek
	movx @R0, A    		 ;wysylam wzorek do bufora

	mov R0, #CSDS        ;adres bufora wyswietlaczy do R0
	mov A,	R7           ;altualny wyswietlacz z r7 do ACC
	movx @R0, A          ;wysylam aktualny wyswietlacz
	clr P1.6             ;wlaczam wyswietlacze

	mov C, P3.5			;kopiujemy stan klawisza do C
	jnc noKey			;je¿eli klawisz nie jest naciœniêty to pomiñ
	orl KEYB, A			;zapamiêtujemy naciœniêty klawisz

noKey:

	rl A                 ;przesuwam wybrany wyswietlacz o 1 w lewo
	jnb ACC.7, noACC7    ;testuje czy nie minalem wszystkich wyswietlaczy
	mov R1, #CZAS        ;wracamy na pocz¹tek tablicy CZAS
	mov CZAS+6, KEYB	;poka¿emy stan klawiatury na diodach F1...
	mov A, KEYB			;stan klawiatury do akumulatora
	jz zmiana			;je¿eli nic nie jest naciœniête to pomiñ
	cjne A, KEYB+1, zmiana
	cjne A, KEYB+2, zmiana
	cjne A, KEYB+3, bezZmiany
	sjmp zmiana
bezZmiany:
	cjne A, #00000100b, niePrawo
	acall incSSMMGG
	sjmp zmiana
niePrawo:
	cjne A, #00010000b, nieDol
	acall incMMGG
	sjmp zmiana
nieDol:
	cjne A, #00100000b, zmiana	;nieLewo
	acall incGG

zmiana:
	mov KEYB+3, KEYB+2
	mov KEYB+2, KEYB+1
	mov KEYB+1, KEYB
	mov KEYB, #0		;¿eby od nowa sk³adaæ stan klawiatury
	mov A, #00000001b    ;jezeli tak to wracam na najmlodszy bit

noACC7:
	mov R7, A            ;zapamietuje nowowybrany wyswietlacz w R7

	djnz R2, petla	;zliczamy przerwania do 1152
	djnz R3, petla
;	cpl P1.7		;TUTAJ jestem 1 raz na sekundê
	mov R2, #128	;reinicjujemy liczniki na zliczanie do 1152
	mov R3, #5

	acall incSSMMGG
   	ajmp petla

incSSMMGG:
	inc SS
	mov A, SS
	cjne A, #60, nie60
	mov SS, #00
incMMGG:
	inc MM
	mov A, MM
	cjne A, #60, nie60
	mov MM, #00
incGG:
	inc GG
	mov A, GG
	cjne A, #24, nie60
	mov GG, #00
nie60:
;	acall przelicz
;	ret

przelicz:
	mov A, SS
	mov B, #10
	div AB
	movc A, @A+DPTR	;zamiana 10tek sekund na odp wzorek
	mov CZAS+1, A	;wzorek na swoje miejsce w tablicy CZAS
	mov A, B
	movc A, @A+DPTR	;zamiana jednostek sekund na odp wzorek
	mov CZAS+0, A

	mov A, MM
	mov B, #10
	div AB
	movc A, @A+DPTR	;zamiana 10tek minut na odp wzorek
	mov CZAS+3, A
	mov A, B
	movc A, @A+DPTR	;zamiana jednostek minut na odp wzorek
	mov CZAS+2, A

	mov A, GG
	mov B, #10
	div AB
	movc A, @A+DPTR	;zamiana 10tek godzin na odp wzorek
	mov CZAS+5, A
	mov A, B
	movc A, @A+DPTR	;zamiana jednostek godzin na odp wzorek
	mov CZAS+4, A

	ret

wzory:
db 00111111b,00000110b,01011011b,01001111b ;0,1,2,3
db 01100110b,01101101b,01111101b,00000111b ;4,5,6,7
db 01111111b,01101111b,01110111b,01111100b ;89,AB
db 01011000b,01011110b,01111001b,01110001b ;cdef

end
