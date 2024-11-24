;=======================================
;
;	TIMER INTERRUPT
;

;=======================================
;	RESET

	ORG	00H		;reset
	LJMP	START

;=======================================
;	PROGRAM

	ORG	100H
START:

LoopRun:
	SJMP LoopRun
