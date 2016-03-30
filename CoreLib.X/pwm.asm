#include p18f1220.inc
#include _core.inc
#include _pwm.inc

global PWMInit, PWMUpdate

.PWM code

PWMInit:
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
    
    BCF	PWMPORT,PWMLIN
    BTFSC PWMCONL,6
    BSF PWMPORT,PWMLIN
    
    BCF	PWMPORT,PWMRIN
    BTFSC PWMCONR,6
    BSF PWMPORT,PWMRIN
    
    BRA	    PWMDONE
    
PWMUpdate:
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

    MOVLW 0x16	; 156 should be 100 cycles
    MOVWF TMR2
    
    decf PWMCOUNT,1
PWMDONE:
    return

end