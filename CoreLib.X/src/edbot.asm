#include p18f1220.inc 
    
global CoreDoLoop
global CoreDoInit

cblock 0x90 
; important that the first of these match the public include
    PWMCONL ;Control register for Left PWM    
    PWMCONR ;Control register for Right PWM
    SensLastL ; last read on Left Sensor
    SensLastR ; Last read on Right sensor
; now for private internal variables, anything below here doesn't strictly need
; to match public order, I will stick to PWM followed by Sens for ease of tracking
    _PWMCount ; internal count used to determine when to do a pwm calculation
    _SensCount ; internal count used for determing when to read a sensor

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

; This currently just copies and clears and returns, but I don't have to type it twice
_SensSave macro destination
    movff SensCount, destination
    bcf SensStatus,StatusDone
    return
endm

; what im doing here may look wierd, but I am testing how macro's get called
; the results of this is less code repetition, but I have to use two branches to acheive 
SensPublish: ; 
    btfss SensStatus,7
    bra SensSaveL
    bra SensSaveR
SensSaveL: _SensSave SensLastL
SensSaveR: _SensSave SensLastR
    
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

_SensKill macro echoBit, SensLast
    bcf TRISB,echoBit
    bcf SensPort,echoBit
    nop ; adding a couple nops to test
    nop ; this may provide a cleaner kill
    bsf TRISB,echoBit ; Set input 
    setf SensLast
endm

_SensTrigger macro NewEchoBit, NewTrigBit, OldEchoBit, LastSensDest
    local continue,kill,skip
    ; we should skip to the end if this is set, this is a bit wierd but it works
    btfss SensStatus,7
    bra skip  
    
    ;Check if old sensor is still on
    btfsc SensPort,OldEchoBit ; if this is still high we need to kill it now
    bra kill
    
continue:
    bsf TRISB,NewEchoBit ; just to be absolutely sure its at input
    bsf SensPort,NewTrigBit ; set trigger, this gets turned off at next cycle
    
    clrf SensStatus ; set to 0 state so that skip is next.
    bra TriggerDone
    
kill:
    _SensKill OldEchoBit,LastSensDest ; this is fun, macro from macro
    bra continue
skip:
endm
    
SensTrigger:
    clrf _SensCount ; esnure we get here again
    ;Determine which is on, if Status is 0 we turn right on, if status is 1 we turn left on
    ; this is now done inside the macro as it simplifies the code, this must be called in this order
    ; for things to properly unfold
    _SensTrigger EchoL, TrigL, EchoR, SensLastR ; Trigger Left sensor
    _SensTrigger EchoR, TrigR, EchoL, SensLastL ; Trigger Right sensor

TriggerDone: 
    bsf SensStatus,StatusTrig ; this set's trigger stop state we need to clean
    ; up and stop the sensor on the next cycle
    clrf SensCount
    bra RobotLoopDone

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