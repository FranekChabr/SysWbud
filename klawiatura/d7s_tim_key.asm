;
;	obsluga wyswietlacza 7 segmentowego
;

CSDS equ 30H ; bufor wyboru wska�nika 7-segmentowego
CSDB equ 38H ; bufor danych wska�nika 7-segmentowego


KEYB equ 7Ch	;4 ostatnie stany klawiatury
CZAS equ 75h	;tablica przechowuj�ca wskazanie zegara
SS equ 74h
MM equ 73h
GG equ 72h



org 0
	ljmp start

org 0Bh	;procedura obs�ugi przerwania od TIMER0
	setb F0			;informujemy �e wyst�pi�o przerwanie
	mov TH0, #231	;�eby nast�pne przerwanie wyst�pi�o po 1/1152 sekundy
	reti			;powr�t z przerwania

org 40h
start:

	;134852

	mov SS, #45
	mov MM, #36
	mov GG, #17
	mov DPTR, #wzory   ; adres wzorkow do DPTR
	acall przelicz

	clr P1.6           ; wlaczam wyswietlacze
	mov R7, #00000001b ; wybieram najmlodszy wyswietlacz
	mov R1, #CZAS      ; adres tablicy CZAS do R1

	mov TMOD, #01110000b	;wy��czamy TIMER1, TIMER 0 w trybie 0
	setb ET0				;zgoda na przerwania od TIMER0
	setb EA					;globalna zgoda na ob�ug� przerwa�
	mov TH0, #231			;�eby pierwsze przerwanie nast�pi�o po 1/1152 sekundy
	setb TR0				;zgoda na zliczanie przez TIMER0

	mov R2, #128			;zliczanie do 1152
	mov R3, #5
	
	mov CZAS+6, #00100000b

petla:
	jnb F0, petla		;czekamy na przerwanie zegarowe
                    	;TUTAJ jestem 1152 razy na sekund�
	clr F0				;zapominamy o przerwaniu zegarowym
	;TUTAJ jestem 1152 razy na sekund�
	mov R0, #CSDB      ; adres bufora segmentow do R0
	mov A, @R1         ; aktualna cyfra do ACC spod adresu @R1
	setb P1.6          ; wylaczam wyswietlacze zeby nie bylo duchow
;	movc A, @A+DPTR    ; zamieniam cyfre na wzorek dla wyswietlacza 7seg
	movx @R0, A        ; wysylam wzorek do bufora
	inc R1             ; idziemy wska�nikiem po tablicy CZAS

	mov R0, #CSDS   ; adres bufora wyswietlaczy do R0
	mov A, R7 		; aktualny wyswietlacz do ACC (# oznacza zaladuj wartosc, bez # zaladuj ten adres)
	movx @R0, A     ; wysylam wybrany wyswietlacz
	clr P1.6        ; wylaczam wyswietlacze

	mov C, P3.5
	jnc noKey
	orl KEYB, A

noKey:

	rl A 			   ; natepny wyswietlacz w lewo, przesuniecie bitowe w lewo, cykliczne czyli z 10000000 przechodzi na 00000001 zamiast znikac
	jnb ACC.7, noACC7  ; testuje czy nie minalem wszystkich wyswietlaczy

	mov R1, #CZAS      ; i wracamy na pocz�tek tablicy CZAS
	mov A, #00000001b  ; jezeli tak to wracam na najmlodszy wyswietlacz
	mov CZAS+6, KEYB	;kopiujemy stan klawiatury na LEDy wy�wietlacza
	mov KEYB, #0		;zerujemy stan klawiatury na nastepne 6(7) obrot�w petli

noACC7:
	mov R7, A          ; zapamietuje nowowybrany wyswietlacz

	djnz R2, petla			;zliczamy do 1152
	djnz R3, petla
							;TUTAJ jestem 1 raz na sekund�
	mov R2, #128			;odnawiamy liczniki �eby znowu policzy� do 1152
	mov R3, #5
;  	cpl P1.7				;prze��czamy diod�

	inc SS
	mov A, SS
	cjne A, #60, nie60
	mov SS, #00
	inc MM
	mov A, MM
	cjne A, #60, nie60
	mov MM, #00
	inc GG
	mov A, GG
	cjne A, #24, nie60
	mov GG, #00
nie60:
	acall przelicz
	sjmp petla          ; wracam na poczatek petli

przelicz:
	mov A, SS			;sekundy do akumulatora
	mov B, #10			;dzielnik do B
	div AB				;dzielenie ca�kowite, wynik w A, reszta w B
	movc A, @A+DPTR		;zamieniamy cyfr� dziesi�tek na jej wzorek
	mov CZAS+1, A		;wzorek dziesi�tek sekund na swoje miejsce w tablicy CZAS
	mov A, B			;kopiujemy jednostki do ACC
	movc A, @A+DPTR		;zamieniamy cyfr� jednostek na jej wzorek
	mov CZAS+0, A		;wzorek jednostek sekund na swoje miejsce w tablicy CZAS

	mov A, MM
	mov B, #10
	div AB
	movc A, @A+DPTR
	mov CZAS+3, A
	mov A, B
	movc A, @A+DPTR
	mov CZAS+2, A

	mov A, GG
	mov B, #10
	div AB
	movc A, @A+DPTR
	mov CZAS+5, A
	mov A, B
	movc A, @A+DPTR
	mov CZAS+4, A

	ret

wzory:
db 00111111b, 00000110b, 01011011b, 01001111b ;0123
db 01100110b, 01101101b, 01111101b, 00000111b ;4567
db 01111111b, 01101111b, 01110111b, 01111100b ;89Ab
db 01011000b, 01011110b, 01111001b, 01110001b ;cdEF

end