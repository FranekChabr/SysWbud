;
;	obsluga wyswietlacza 7 segmentowego
;

CSDS equ 30H ; bufor wyboru wskaünika 7-segmentowego
CSDB equ 38H ; bufor danych wskaünika 7-segmentowego


KEYB equ 7Ch	;4 ostatnie stany klawiatury
CZAS equ 75h	;tablica przechowujπca wskazanie zegara
SS equ 74h
MM equ 73h
GG equ 72h



org 0
	ljmp start

org 40h
start:

	clr P1.6           ; wlaczam wyswietlacze
	mov R7, #00000001b ; wybieram najmlodszy wyswietlacz

petla:
	mov R0, #CSDB      ; adres bufora segmentow do R0
	mov A, @R1         ; aktualna cyfra do ACC spod adresu @R1
	setb P1.6          ; wylaczam wyswietlacze zeby nie bylo duchow
	movx @R0, A        ; wysylam wzorek do bufora
	inc R1             ; idziemy wskaünikiem po tablicy CZAS

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

	mov R1, #CZAS      ; i wracamy na poczπtek tablicy CZAS
	mov A, #00000001b  ; jezeli tak to wracam na najmlodszy wyswietlacz
	mov CZAS+6, KEYB	;kopiujemy stan klawiatury na LEDy wyúwietlacza
	mov KEYB, #0		;zerujemy stan klawiatury na nastepne 6(7) obrotÛw petli

noACC7:
	mov R7, A          ; zapamietuje nowowybrany wyswietlacz
	
	sjmp petla
end