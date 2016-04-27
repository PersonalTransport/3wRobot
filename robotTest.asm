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
PrevSensL equ 0x81
CurSensL equ 0x82
PrevSensR equ 0x83
CurSensR equ 0x84
 
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
    bsf PORTB,RB5
    clrf RobotState
    
    clrf PrevSensL
    clrf PrevSensR
   

Start:
    ;GO LEFT
    movlw 0xFF
    movwf PWMCONL
    
    movlw 0xBF
    movwf PWMCONR
    
    call Delay
    call Delay
    
    ;GO RIGHT
    movlw 0xBF
    movwf PWMCONL
    
    movlw 0xFF
    movwf PWMCONR
    
    call Delay
    call Delay
    call Delay
    
    ;GO LEFT
    movlw 0xFF
    movwf PWMCONL
    
    movlw 0xBF
    movwf PWMCONR
    
    call Delay
    call Delay
    
    ;GO Straight
    movlw 0x00
    movwf PWMCONL
    
    movlw 0x00
    movwf PWMCONR
MainL: 
   
    bcf PORTB,RB5
    movlw .2
    cpfsgt SensLastL ; continue to go forward unless we should backup 
    bsf PORTB,RB5
    
    ;bsf PORTB,RB5 ; make sure light is on since we are in forward state.
    bra MainL

  
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




