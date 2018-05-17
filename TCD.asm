; Projeto de controlador de umidade do solo
#include <p16F873A.inc>

CBLOCK 0x20
	D1
	D2
	D3
ENDC

	ORG 0x0000
	GOTO INICIO

;--------
INICIO:
	; configurar portB como output
	BANKSEL TRISB
	CLRF TRISB

	MOVLW B'01000000'
	MOVWF TRISB

	BANKSEL PORTB
	
	BCF PORTB,7
	
	; rotina de delay antes de ligar o sensor (20s)
LOOP:
	MOVLW 0xB5 ; W = 181
	MOVWF D1 ; D1 = W
	MOVLW 0x99; w = 153
	MOVWF D2 ; D2 = W
	MOVLW 0x2C ; W = 44
	MOVWF D3 ; D3 = W
DELAY_1:
	DECFSZ D1, F
	GOTO $+2
	DECFSZ D2, F
	GOTO $+2
	DECFSZ D3, F
	GOTO DELAY_1

	GOTO $+1
	NOP

	BSF PORTB,7

	; rotina depois de ligar o sensor (10s)
	MOVLW 0x5A ; W = 90
	MOVWF D1 ; D1 = W
	MOVLW 0xCD; w = 205
	MOVWF D2 ; D2 = W
	MOVLW 0x16 ; W = 22
	MOVWF D3 ; D3 = W
DELAY_2:
	DECFSZ D1, F
	GOTO $+2
	DECFSZ D2, F
	GOTO $+2
	DECFSZ D3, F
	GOTO DELAY_2

	BCF PORTB,7

	GOTO LOOP

	END

	
