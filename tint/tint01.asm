;=======================================
;
;	TIMER INTERRUPT
;

TEST	BIT	P1.7

;=======================================
;	RESET

	ORG	00H		;reset
	LJMP	START

;=======================================
;	TIMER 0 INTERRUPT
	ORG	0BH
	CPL	TEST
	RETI

;=======================================
;	PROGRAM

	ORG	100H
START:

	SETB	ET0		;aktywuje przerwanie od timer 0
	SETB	EA		;globalne zezwolenie na obsluge przerwan
	SETB	TR0		;aktywuje zliczanie przez timer 0

LoopRun:
	SJMP LoopRun
