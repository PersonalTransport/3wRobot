#include p18f1220.inc 
#include _core.inc

    global CoreDoLoop, CoreDoInit

    ;things we need from pwm.asm
    extern PwmSetup, PwmLoop
    ;things we need from sens.asm
    extern SensSetup,SensTrigger
		
.Core code
  
CoreDoInit:
	    
    call PwmSetup
    call SensSetup
    
    ; clear robot loop vars
    clrf _PWMCount
    clrf _SensCount
    
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
    call PwmLoop
    
    incf _SensCount
    movlw .120
    cpfslt _SensCount
    bra DoTrigger
    
 
DoTrigger: ; this is to ensure we don't trigger and read on the same cycle
    call SensTrigger
    ;bra RobotLoopDone
    
RobotLoopDone:
    bcf PIR1, TMR2IF ; Clear Timer 1 Interrupt Flag
    return
    
    end