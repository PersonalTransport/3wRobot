#include p18f1220.inc 

; Define this so that the extern does not collide with the global
#define __CORE_SKIP_PUBLIC
#include core.inc
global CoreDoLoop
global CoreDoInit

; this should continue from where the public header left off
cblock MemoryStart 
; important that the first of these match the public include
;    PWMCONL ;Control register for Left PWM    
;    PWMCONR ;Control register for Right PWM
;    SensLastL ; last read on Left Sensor
;    SensLastR ; Last read on Right sensor
; now for private internal variables, anything below here doesn't strictly need
; to match public order, I will stick to PWM followed by Sens for ease of tracking


    PWMCOUNT ; count of the internal PWM cycles, this goes to 50 and resets
    PWMONL ; count of how many PWM cycles left should be on to reach desired PWM
    PWMONR ; count of how many PWM cycles right should be on to reach desired PWM

    SensStatus ; internal register used to track the sensor state and last sensor
    SensCount ; internal count of echo cycles as sensor is being read
endc
 
StatusTrig equ 0
StatusSkip equ 1
StatusCount equ 2
StatusDone equ 3

SensPort equ PORTB
TrigL equ RB0
EchoL equ RB1
TrigR equ RB2
EchoR equ RB3

PWMPORT	equ PORTA
PWMRIN	equ RA0
PWMRCE	equ RA1

PWMLIN	equ RA2
PWMLCE	equ RA3
		
pwm code 0x400
  
CoreDoInit:
	    
    ; Clear PWM Variables
    clrf PWMCONL
    clrf PWMCONR
    clrf PWMCOUNT
    clrf PWMONL
    clrf PWMONR
    
    ; clear robot loop vars
    clrf _PWMCount
    clrf _SensCount
    clrf SensStatus
    clrf SensCount
    clrf SensLastL
    clrf SensLastR
    
    movlw 0x00	
    movwf TRISA ; set PortA To output.
    clrf PORTA ; Clear port a to make sure that the motors start stopped.
    
    movlw 0x0A
    movwf TRISB ; setup inputs and outputs for PORT B for Sensor Triggering
    clrf PORTB;
    bcf PORTB,RB5
    
    ; Timer 2 Initialization + interrupt enable/disable
    bsf PIE1, TMR2IE ; enable Timer1 Interrupt
    bsf IPR1, TMR2IP ; Set Timer 1 Interrupt to High priority
     
    ; TMR2 is used for pwm so it works here too
    clrf TMR2 
    movlw 0x00 
    movwf T2CON 
    movlw 0xFA
    movwf PR2
    
    bsf T2CON,TMR2ON
    return 
 
CoreDoLoop:
    incf _PWMCount
    movlw .4
    cpfslt _PWMCount
    call PWMLoop
    
    incf _SensCount
    movlw .120
    cpfslt _SensCount
    bra SensTrigger
    
    btfsc SensStatus,StatusTrig ; if trigger is set then we need to stop it
    call SensEndTrigger
    
    btfsc SensStatus,StatusSkip ; skip this cycle to give it a chance to display
    bra SkipCount
    
    btfsc SensStatus,StatusCount ; we should either be counting or waiting here, about to see
    call SensRead
    
    btfsc SensStatus,StatusDone ; we should now publish to the proper register
    call SensPublish
 ;   btfsc SensR,6
 ;   call SensReadR ; if trigger is set read that side
 
RobotLoopDone:
    bcf PIR1, TMR2IF ; Clear Timer 1 Interrupt Flag
    return


PWMLoop:
    clrf _PWMCount ; ensure we get here again
    tstfsz  PWMCOUNT
    call PWMUPDATE
    call PWMInit
    return
    
end