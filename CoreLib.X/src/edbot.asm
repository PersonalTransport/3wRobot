#include p18f1220.inc 
    
global RobotDoLoop
global RobotDoInit

_SensCount equ 0x88
_PWMCount equ 0x89
PWMCONL equ 0x090
PWMCONR equ 0x091
PWMCOUNT equ 0x092
PWMONL equ 0x093
PWMONR equ 0x094

SensStatus equ 0x95
SensCount  equ 0x96
SensLastL equ 0x97
SensLastR equ 0x98
 
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
  
RobotDoInit:
	    
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
 
RobotDoLoop:
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

SensPublish:
    btfss SensStatus,7
    bra PublishL
    bra PublishR
PublishL:
    movff SensCount,SensLastL
    bcf SensStatus,StatusDone
    return
PublishR:
    movff SensCount,SensLastR
    bcf SensStatus,StatusDone
    return
    
SkipCount:
    btfss SensStatus,StatusCount
    bra SkipAgain
    
    bcf SensStatus,StatusTrig
    bcf SensStatus,StatusSkip
    bsf SensStatus,StatusCount
    bra RobotLoopDone
    
SkipAgain:
    bsf SensStatus,StatusCount
    bra RobotLoopDone
    
SensEndTrigger:
    bcf SensPort,TrigL
    bcf SensPort,TrigR
    bcf SensStatus,StatusTrig ; turn off trigger state
    bsf SensStatus,StatusSkip ; turn on skip state
    return
    
SensTrigger:
    clrf _SensCount ; esnure we get here again
    ;Determine which is on, if Status is 0 we turn right on, if status is 1 we turn left on
    btfsc SensStatus,7 ; 0 is left 1 is right
    bra TriggerLeft
    bra TriggerRight


KillSens macro echoBit, SensLast
    bcf TRISB,echoBit
    bcf SensPort,echoBit
    nop ; adding a couple nops to test
    nop ; this may provide a cleaner kill
    bsf TRISB,echoBit
    setf SensLast
endm
    
TriggerLeft:
    ;Check if right sensor is still on
    ;Right Sensor has had it's chance, time to kill it if it isn't allready done
   ; bcf PORTB,RB5 ; for testing
    btfsc SensPort,EchoR ; if this is still high we need to kill it now before we continue
    KillSens EchoR,SensLastR

    bsf SensPort,EchoL ; Set input to recieve echo
    bsf SensPort,TrigL ; Set Trigger
    
    ; set status 
    clrf SensStatus
    ; no need to set any bits since 0 is left
    
    bra TriggerDone

    
TriggerRight:
    ;Check if left sensor is still on
    ;leftt Sensor has had it's chance, time to kill it if it isn't allready done
  ;  bcf PORTB,RB5 ; for testing
    btfsc SensPort,EchoL ; if this is still high we need to kill it now before we continue
    KillSens EchoL,SensLastL

    bsf SensPort,EchoR ; Set input to recieve echo
    bsf SensPort,TrigR ; Set Trigger
    
    ; set status 
    clrf SensStatus
    bsf SensStatus,7 ; set this to 1 for right
    
    bra TriggerDone

TriggerDone: 
    bsf SensStatus,StatusTrig ; this set's trigger stop state we need to clean
    ; up and stop the sensor on the next cycle
    clrf SensCount
    bra RobotLoopDone
    

;    
;KillRight:
;    ;set echo to output and clear
;    bcf TRISB,EchoR
;    bcf SensPort,EchoR
;    nop ; adding a couple nops to test
;    nop ; this maybe helps provide a cleaner kill
;    bsf TRISB,EchoR
;   ; bsf PORTB,RB5 ; for testing
;    setf SensLastR ; this was doing some wierd things, killing it for now, should prolly set an error flag somewhere else.
;    return
;    
;KillLeft:
;    ;set echo to output and clear
;    bcf TRISB,EchoL
;    bcf SensPort,EchoL
;    nop ; adding a couple nops to test
;    nop ; this maybe helps provide a cleaner kill
;    bsf TRISB,EchoL
;   ; bsf PORTB,RB5 ;for testing
;    setf SensLastL ; same as above, seeing if this fixes it.
;    return

SensRead:
    btfss SensStatus,7
    bra SensReadL
    bra SensReadR
    
SensReadL:
    ;check if trigger is on
    btfss SensPort,EchoL
    bra clearTrigger ; it went off sometime between the last update and now so we do not increment
    incf SensCount
    bra SensDone
    
SensReadR:
     ;check if trigger is on
    btfss SensPort,EchoR
    bra clearTrigger ; it went off sometime between the last update and now so we do not increment
    incf SensCount
    bra SensDone
    
clearTrigger:
    bcf SensStatus,StatusCount ; no longer counting
    bsf SensStatus,StatusDone ; should now publish on next cycle
    bra SensDone
    
SensDone:    
    return
PWMLoop:
    clrf _PWMCount ; ensure we get here again
    tstfsz  PWMCOUNT
    bra PWMUPDATE
    bra PWMInit
    
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
    
PWMUPDATE:
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