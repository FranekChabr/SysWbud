; SOS
LED bit P1.7
BUZZ equ P1.5
TIME_MS_SHORT equ 100
TIME_MS_LONG equ 255

org 0h
	ljmp start

org 40h
start:
	acall short_delay

	acall short_blink
	acall short_blink
	acall short_blink
	
	acall short_delay
	
	acall long_blink
    acall long_blink
    acall long_blink
    
    acall short_delay

    acall short_blink
	acall short_blink
	acall short_blink
	
	acall long_delay
	acall long_delay
	acall long_delay
	
	sjmp start
	
short_blink:
	setb LED
	acall short_delay
	clr LED
	acall short_delay
	ret

long_blink:
    setb LED
	acall long_delay
	clr LED
	acall long_delay
	ret

short_delay:
	mov R1, #255
	mov R2, #TIME_MS_SHORT
delay_loop_short:
	DJNZ R1, delay_loop_short
	DJNZ R2, delay_loop_short
	ret

long_delay:
	mov R1, #255
	mov R2, #TIME_MS_LONG
delay_loop_long:
	DJNZ R1, delay_loop_long
	DJNZ R2, delay_loop_long
	ret


end