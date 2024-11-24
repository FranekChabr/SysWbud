;=======================================
;
;	TIMER INTERRUPT
;
;	1000 przerwan na sekunde od timer 0 w trybie 0

TEST	BIT	P1.7
BUZZ	BIT	P1.5

T0IB	BIT	7FH		;timer 0 interrupt bit

;=======================================
;	RESET

	ORG	00H			;reset
	LJMP	START

;=======================================
;	TIMER 0 INTERRUPT
	ORG	0BH

	LJMP	TI0MAIN		;w ten sposob omijamy ograniczenie do 8 bajtow


;=======================================
;	TIMER 0 INTERRUPT MAIN
	ORG	0B0H			;od B0h do 100h jest 80 bajtow, na pewno wystarczy

TI0MAIN:
	PUSH	ACC			;zabezpieczamy wykorzystywane rejestry
	PUSH	PSW			;

	MOV	TH0, #255-28	;wartosc typowa

	MOV	A, #32 - 26 + 1	; + 1 aby nadrobic strate
	ADD	A, TL0		;uwzglednia opoznienie wywolania przerwania
	MOV	TL0, A		;TL0 ustawione wlasciwie

	JNC	TI0MAIN_TH0_OK	;jezeli nie Carry to jest OK
	INC	TH0			;wpr podbijamy TH0 w stosuku do wartosci typowej

TI0MAIN_TH0_OK:			;TH0 ustawione wlasciwie

	POP	PSW			;odzyskujemy wykorzystywane rejestry
	POP	ACC			;

	SETB	T0IB			;informujemy petle glowna o przerwaniu

	RETI				;powrot z przerwania

;=======================================
;	PROGRAM

	ORG	100H
START:
	MOV	IE,	#00h	;blokada wszystkich przerwan

	MOV	TMOD,	#70h	;T1.GATE=0 T1.C/T=C T1.MODE=3 T0.GATE=0 T1.C/T=T T0.MODE=0
	MOV	TCON,	#10h	;m.in. blokada zliczania przez T1, aktywuje zliczanie przez timer 0
	SETB	ET0		;aktywuje przerwanie od timer 0
	SETB	EA		;globalne zezwolenie na obsluge przerwan

LoopRun:
	JNB	T0IB, LoopRun	;czeka na przerwanie

	CLR	T0IB		;zapomina ze bylo przerwanie

	CPL	TEST		;przelacza diode
	CPL	BUZZ		;przelacza przeczyk

	SJMP	LoopRun
