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
#include CoreLib.X/src/edbot.inc
   
RobotState equ 0x80
PrevSensL equ 0x81
CurSensL equ 0x82
PrevSensR equ 0x83
CurSensR equ 0x84
 
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
    
    clrf PrevSensL
    clrf PrevSensR
    
MainL: movff SensLastL, CurSensL
    movf CurSensL, 0
    xorwf PrevSensL, 0		
    bz CheckRight ; left has not changed lets check right
    bra SensChanged

CheckRight: movff SensLastR, CurSensR
    movf CurSensR, 0
    xorwf PrevSensR, 0
    bz MainL ; neither sensor has changed so continue to loop
    ; right has changes so continue down to Sens Changed..
SensChanged:
   ; lets check if it is an error state, and if so wait for a new state
   movlw 0xFF
   cpfslt CurSensL
   bra Err ; We have an error state on Left
   
   cpfslt CurSensR
   bra Err ; We have an error state on right
   
   ; btfsc RobotState,0 ; we are in forward state unless this is set
   ; bra Backup
   bcf PORTB,RB5
   
  ;  bsf PORTB,RB5 ; make sure light is on since we are in forward state.
  ;  movlw .2
  ;  cpfsgt CurSensL ; continue to go forward unless we should backup 
  ;  bcf PORTB,RB5
    
  ;  bsf RobotState,0 ; okay backing up after this
    bra MainL

Err:
    bsf PORTB,RB5
Backup:
    bcf PORTB,RB5 ; okay kill the light we are backing up
    
    movlw .7
    cpfsgt CurSensL ; keep backing up untill greater than 6 away
    bra MainL
    
    
    bcf RobotState,0
    bra MainL
    
    end




