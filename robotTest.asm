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
#include edbot.inc
   
RobotState equ 0x80
LastSensL equ 0x81
CurSensL equ 0x82
 
start   code 0x000 ; Executes after reset
    goto INIT
    
high    code 0x008 ; Executes after high priority interrupt
    goto HPRIO
    
main    code 0x020
HPRIO:
    btfsc PIR1, TMR2IF ; high priority loop
    bra RobotL
   
    retfie ; Return from interrupt

RobotL: call RobotDoLoop ; PWM_LOOP is responsible to clear the flag.
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
    call RobotDoInit
    
    ; Set to zero for start
    movlw 0x00
    movwf PWMCONL
    
    movlw 0x00
    movwf PWMCONR
    
    bcf TRISB,RB5
    bsf PORTB,RB5
    clrf RobotState
    
    clrf LastSensL
MainL: movff SensLastL, CurSensL
    movf CurSensL, 0
    xorwf LastSensL, 0		
    bz MainL
    
    btfsc RobotState,0 ; we are in forward state unless this is set
    bra Backup
    
    bsf PORTB,RB5 ; turn on light since we are in forward state ;
    movlw .2 
    cpfslt CurSensL ; continue to go forward unless we should backup
    bra MainL
    
    ; if we are here we should backup
    movlw 0xA4
    movwf PWMCONL
    
    movlw 0xA4
    movwf PWMCONR
    
    bsf RobotState,0 ; okay backing up after this
    bra MainL
    
Backup:
    bcf PORTB,RB5 ; okay kill the light we are backing up
    
    movlw .2
    cpfsgt CurSensL ; keep backing up untill greater than 6 away
    bra MainL
    
    ; we are here so both sides say we are good so lets go forward
    movlw 0xE4
    movwf PWMCONL
    
    movlw 0xE4
    movwf PWMCONR
    
    bcf RobotState,0
    bra MainL
    
    end




