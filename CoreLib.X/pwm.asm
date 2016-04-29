#include p18f1220.inc
#include _pwm.inc

    global PwmSetup, PwmLoop

.PWM code
 
PwmSetup:
    ; Clear PWM Variables
    clrf PWMCONL
    clrf PWMCONR
    clrf PWMCOUNT
    clrf PWMONL
    clrf PWMONR
    
    movlw 0x00	
    movwf TRISA ; set PortA To output.
    clrf PORTA ; Clear port a to make sure that the motors start stopped.
    
    return
    
PwmLoop:
    clrf _PWMCount ; ensure we get here again
    tstfsz  PWMCOUNT
    bra PwmUpdate
    bra PwmInit
    return
    
PwmInit: 
    movlw   0x32
    movwf   PWMCOUNT
    
    ;get loncount
    movf    PWMCONL,0
    andlw   0x1F
    ;addlw   .6	; this is to make 1 a usable setting
    MOVWF   PWMONL
    
    ;get roncount
    MOVF   PWMCONR,0
    ANDLW   0x1F
    ;addlw   .6	; this is to make 1 a usable setting
    MOVWF   PWMONR
    
    BCF PWMPORT,PWMLCE
    BCF PWMPORT,PWMRCE
    
    BCF	PWMPORT,PWMLIN
    BTFSC PWMCONL,6
    BSF PWMPORT,PWMLIN
    
    BCF	PWMPORT,PWMRIN 
    BTFSC PWMCONR,6
    BSF PWMPORT,PWMRIN
    
    BRA	    PWMDONE


_DoPWM macro PwmCon, PwmOn, EnableBit
    local _pwmStop,_pwmOn,_pwmOnDec,_pwmStop,_pwmDone
    btfss PwmCon,7  ;If the motor should be off let's ensure that it's off
    bra _pwmStop
    
    btfss PwmCon,7  ;this should force us on if it is off, assuming we didn't 
    bra _pwmOn
    
    tstfsz PwmOn    ;now we see if we have cycles we should be on remaining.
    bra _pwmOnDec
    
    bra _pwmStop    ;we should be off for the rest of the cycle let's verify
_pwmStop:
    bcf PWMPORT,EnableBit
    bra _pwmDone
_pwmOnDec:
    decf _pwmOn	    ; decrement the count of remaining cycles
_pwmOn:
    bsf PWMPORT,EnableBit
_pwmDone:
    endm
    
PwmUpdate:
    _DoPWM PWMCONL,PWMONL,PWMLCE    ; Do left wheel pwm
    _DoPWM PWMCONR,PWMONR,PWMRCE    ; Do right wheel pwm
    decf PWMCOUNT,1		    ;Decrement count to make sure things get changed;
PWMDONE:
    return

    end