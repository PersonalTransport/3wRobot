;-------------------------------------------------------------------------------------
; FILE: main.asm
; DESC: Experiment 1 ? Simple EDBot Test
; DATE: 4-8-2016
; AUTH: Class
; DEVICE: PICmicro (PIC18F1220)
;-------------------------------------------------------------------------------------
    list 	p=18F1220	; Set processor type
    radix 	hex	; Sets the default radix for data exp.
	config	WDT=OFF, LVP=OFF	; Disable Watchdog timer and Low Voltage

#define 	PORTA	0xF80
#define  	PORTB	0xF81
#define  	TRISA	0xF92
#define  	TRISB	0xF93
#define  	ADCON1	0xFC1
	
.org   code 	0x000	; Set the program origin (start) to absolute 0x000
    ; Initialize all I/O ports
    CLRF  	PORTA 	; Initialize PORTA
    CLRF  	PORTB 	; Initialize PORTB
    MOVLW  	0x7F 	; Set all A\D Converter Pins as
    MOVWF 	ADCON1 	; digital I/O pins
    MOVLW 	0x00 	; Value used to initialize data direction
    MOVWF 	TRISB 	; Set Port B RB<7:0> as outputs
    MOVWF 	TRISA 	; Set Port A RA<7:0> as outputs
    BSF		TRISA,6	; set button to input
    MOVLW	0x00	; W = 0

    ; Toggle Portb,5, direction, and delay.
    ; start by going forward for first delay cycle
Main:
    BCF	    PORTB,5	    ; Set LED to off
    BSF	    PORTA,1	    ; Enable right motor
    BSF	    PORTA,0	    ; Forward right
    BSF	    PORTA,3	    ; Enable left motor
    BCF	    PORTA,2	    ; Backward right
    CALL Delay		    ; Wait .5 seconds
    
    BCF	    PORTA,0	    ; Backwards right
    BSF	    PORTA,2	    ; Forwards Left
    CALL Delay		    ; Second .5 second pause
    
    BCF	    PORTA,1	    ; Stop Right
    BCF	    PORTA,3         ; Stop Left
    
    MOVFF PORTA, 0x82 ; prime for first cycle.
Loop: BTG   PORTB,5	    ; Toggle LED
    CALL Delay 
    MOVFF PORTA, 0x83	; INPUT = PORTA
    MOVF 0x83, 0		; W = PORTA
    XORWF 0x82, 0		; W = W XOR LASTIN
    BZ Loop			; Loop if zero
    BRA Main	    ; Something changed so assume it is switch and restart

Delay: MOVLW .5		    ;Loop 5 times for .5 seconds
    MOVWF 0x81
DelayLoop:CALL DelayOnce
    DECF    0x81
    BNZ DelayLoop
    RETURN
DelayOnce:  CLRF 0x80	;.1 second delay loop
DelayOnceLoop:  NOP	; delay
    INCF    0x80	;increment counter
    BNZ	DelayOnceLoop
    RETURN
    end