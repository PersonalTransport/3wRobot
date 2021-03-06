;-------------------------------------------------------------------------------------
; FILE: robotTest.asm
; DESC: Test Robot library, should stop motion before hitting wall
; DATE: 3.7.2016 
; AUTH: Johnathan Bunn
; DEVICE: PICmicro (PIC18F1220)
;-------------------------------------------------------------------------------------
    list p=18F1220		; Set processor type
    radix hex			; Sets the default radix for data exp.
    config WDT=OFF, LVP=OFF	; Disable Watchdog timer and Low Voltage
    config	   OSC= INTIO2

#include p18f1220.inc 
#include CoreLib.X/core.inc

.roboData udata 
RobotState equ 0x80
SensDelay equ 0x85
 
ORG.   code 0x000 ; Executes after reset
    goto INIT
    
HIGH.    code 0x008 ; Executes after high priority interrupt
    goto HPRIO
    
MAIN.    code 0x020
HPRIO:
    btfsc PIR1, TMR2IF ; high priority loop
    bra RobotL
   
    retfie ; Return from interrupt

RobotL: call CoreDoLoop ; PWM_LOOP is responsible to clear the flag.
    ;why not clear here
    bra HPRIO	; return to HPRIO in case other interrupts need to be processed.

    
INIT:
    movlw   0x60	
    iorwf   OSCCON	; Set to 4mhz
    movlw   0x7F	; Set all A\D Converter Pins as
    movwf   ADCON1	; digital I/O pins
    
    ; Enable interupts and get ready for sub init code
    bsf INTCON, GIE ; enable interrupts
    bsf INTCON, PEIE ; enable all interrupts
    
    ;Do pwm init code.
    call CoreDoInit
    
    ; Set to zero for start
    movlw 0x00
    movwf PWMCONL
    
    movlw 0x00
    movwf PWMCONR
    
    bcf TRISB,RB5
    bcf PORTB,RB5
    clrf RobotState
    
;    clrf PrevSensL
;    clrf PrevSensR
   

Start:
;    ;GO LEFT
;    movlw 0xFF
;    movwf PWMCONL
;    
;    movlw 0xBF
;    movwf PWMCONR
;    
;    call Delay
;    call Delay
;    
;    ;GO RIGHT
;    movlw 0xBF
;    movwf PWMCONL
;    
;    movlw 0xFF
;    movwf PWMCONR
;    
;    call Delay
;    call Delay
;    call Delay
;    
;    ;GO LEFT
;    movlw 0xFF
;    movwf PWMCONL
;    
;    movlw 0xBF
;    movwf PWMCONR
;    
;    call Delay 
;    call Delay

ChangeDirection:
    movlw 0xF0
    movwf PWMCONL
;    
    movlw 0xFF
    movwf PWMCONR
    
    movlw .10
    movwf SensDelay
SensLoop:
    bcf PORTB,RB5
    movlw .2
    cpfsgt SensLastL
    bra BackLeft
    
    cpfsgt SensLastR
    bra BackRight
    
    decf SensDelay
    BNZ SensLoop
    bra ChangeDirection
    
BackLeft:
    bsf PORTB,RB5
    movlw .4
    cpfslt SensLastL
    bra ChangeDirection
    
    ;Go Back Left
    movlw 0xC0
    movwf PWMCONL
;    
    movlw 0xDF
    movwf PWMCONR
    call Delay
    bra BackLeft
    
BackRight:
    bsf PORTB,RB5
    movlw .4
    cpfslt SensLastR
    bra ChangeDirection
    
    ;Go Back Left
    movlw 0xC0
    movwf PWMCONR
;    
    movlw 0xDF
    movwf PWMCONL
    call Delay
    bra BackRight
    
DoneLoop:nop
    bra DoneLoop
  
Delay: MOVLW .200		    ;Loop 5 times for .5 seconds
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




