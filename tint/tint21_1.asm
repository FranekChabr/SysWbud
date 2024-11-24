;=======================================
;
;	TIMER INTERRUPT
;

TEST	BIT	P1.7
BUZZ	BIT	P1.5

;=======================================
;	RESET

	ORG	00H		;reset
	LJMP	START

;=======================================
;	TIMER 0 INTERRUPT
	ORG	0BH

	MOV	TH0, #256-32
	MOV	TL0, #5

	CPL	TEST
	CPL	BUZZ
	RETI

;=======================================
;	PROGRAM

	ORG	100H
START:

	MOV	IE,	#00h	;blokada wszystkich przerwan

	MOV	TMOD,	#71h	;T1.GATE=0 T1.C/T=C T1.MODE=3 T0.GATE=0 T1.C/T=T T0.MODE=1
	MOV	TCON,	#10h	;m.in. blokada zliczania przez T1, aktywuje zliczanie przez timer 0
	SETB	ET0		;aktywuje przerwanie od timer 0
	SETB	EA		;globalne zezwolenie na obsluge przerwan

LoopRun:
	SJMP LoopRun
