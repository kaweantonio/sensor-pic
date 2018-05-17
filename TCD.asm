; Projeto de controlador de umidade do solo
#include <p16F873A.inc>

CBLOCK 0x20
	D1
	D2
	D3
	CNT0
	CNT1
ENDC

	ORG 0x0000
	GOTO INICIO

;--------
INICIO:
	; configurar portB como output
	BANKSEL TRISB
	CLRF TRISB

	MOVLW B'00000001' ; seta RB7 como outpuy
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

	; configuração do conversor A/D
	BANKSEL ADCON1

	MOVLW B'10000000'
	MOVWF ADCON1

	BANKSEL ADCON0

	MOVLW B'11000001'
	MOVWF ADCON0
	
	; salva valores em CNT1 - Alto e CNT0 - Baixo
	BSF ADCON0, 2
ESPERA:
	BTFSC ADCON0, 2
	GOTO ESPERA

	MOVF ADRESH, w
	MOVWF CNT1
	MOVF ADRESL, w
	MOVWF CNT0

	BANKSEL PORTB

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
