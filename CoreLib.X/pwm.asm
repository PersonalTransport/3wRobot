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
    
    movlw 0x0D	
    movwf TRISA ; set PortA To output.
    movlw 0xC7
    movwf TRISB
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
    addlw   .6	; this is to make 1 a usable setting
    MOVWF   PWMONL
    
    ;get roncount
    MOVF   PWMCONR,0
    ANDLW   0x1F
    addlw   .6	; this is to make 1 a usable setting
    MOVWF   PWMONR
    
    BCF PWMOnPORT,PWMLCE
    BCF PWMOnPORT,PWMRCE
    
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
    
    btfss PwmCon,6  ;If this bit is off we should always be on because PWM is disabled 
    bra _pwmOn
    
    tstfsz PwmOn    ;now we see if we have cycles we should be on remaining.
    bra _pwmOnDec
    
    bra _pwmStop    ;we should be off for the rest of the cycle let's verify
_pwmStop:
    bcf PWMOnPORT,EnableBit
    bra _pwmDone
_pwmOnDec:
    decf PwmOn	    ; decrement the count of remaining cycles
_pwmOn:
    bsf PWMOnPORT,EnableBit
_pwmDone:
    endm
    
PwmUpdate:
    _DoPWM PWMCONL,PWMONL,PWMLCE    ; Do left wheel pwm
    _DoPWM PWMCONR,PWMONR,PWMRCE    ; Do right wheel pwm
    decf PWMCOUNT,1		    ;Decrement count to make sure things get changed;
    
;PwmUpdate:
;    ;local _pwmStop,_pwmOn,_pwmOnDec,_pwmStop,_pwmDone
;    btfss PWMCONL,7  ;If the motor should be off let's ensure that it's off
;    bra _pwmStop
;    
;    btfss PWMCONL,6  ;If this bit is off we should always be on because PWM is disabled 
;    bra _pwmOn
;    
;    tstfsz PWMONL    ;now we see if we have cycles we should be on remaining.
;    bra _pwmOnDec
;    
;    bra _pwmStop    ;we should be off for the rest of the cycle let's verify
;_pwmStop:
;    bcf PWMOnPORT,PWMLCE
;    bra _pwmDone
;_pwmOnDec:
;    decf PWMONL	    ; decrement the count of remaining cycles
;_pwmOn:
;    bsf PWMOnPORT,PWMLCE
;_pwmDone:
;    
;     decf PWMCOUNT,1
;    
    
PWMDONE:
    return

    end