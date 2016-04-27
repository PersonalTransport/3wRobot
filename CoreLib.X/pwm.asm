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
    ; do init 
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
    
    BCF PWMPORT,PWMLCE
    BCF PWMPORT,PWMRCE
    
    BCF	PWMPORT,PWMLIN
    BTFSC PWMCONL,6
    BSF PWMPORT,PWMLIN
    
    BCF	PWMPORT,PWMRIN
    BTFSC PWMCONR,6
    BSF PWMPORT,PWMRIN
    
    BRA	    PWMDONE
    
PwmUpdate:
    ; update Left motor
    BTFSS PWMCONL,7
    BRA PWMLeftNop
  
    BTFSS PWMCONL,5
    BRA PWMTurnLOn
    
    TSTFSZ PWMONL
    BRA PWMDecL
   
    BCF PWMPORT,PWMLCE
    BRA PWMLeftDone
PWMLeftNop:
    NOP
    NOP
    NOP
    NOP ; these nops are to balance timing so all cycles are the same
    BRA PWMLeftDone
PWMDecL: DECF PWMONL,1
	NOP ; to balance
PWMTurnLOn: BSF PWMPORT,PWMLCE
PWMLeftDone:   
    ; update Right motor
    BTFSS PWMCONR,7
    BRA PWMRightNop
    BTFSS PWMCONR,5
    BRA PWMTurnROn
    
    TSTFSZ PWMONR
    BRA PWMDecR
   
    BCF PWMPORT,PWMRCE
    BRA PWMRightDone
PWMRightNop:
    nop
    nop
    nop
    nop ; these nops are to balance timing so all cycles are the same
    bra PWMRightDone
PWMDecR: DECF PWMONR,1  
    nop ; to balance
PWMTurnROn: BSF PWMPORT,PWMRCE
PWMRightDone:   

   ; MOVLW 0x16	; 156 should be 100 cycles
   ; MOVWF TMR2
    
    decf PWMCOUNT,1
PWMDONE:
    return

    end