#include p18f1220.inc
#include _sens.inc

    global SensSetup, SensUpdate, SensTrigger

.SENSE code

SensSetup:
    clrf SensCount
    clrf SensLastL
    clrf SensLastR
    clrf SensStatus
    
    movlw 0x0A
    movwf TRISB ; setup inputs and outputs for PORT B for Sensor Triggering
    clrf PORTB;
    bcf PORTB,RB5
    
    return

SensUpdate:
    btfsc SensStatus,StatusTrig ; if trigger is set then we need to stop it
    bra SensEndTrigger
    
    btfsc SensStatus,StatusSkip ; skip this cycle to give it a chance to display
    bra SkipCount
    
    btfsc SensStatus,StatusCount ; we should either be counting or waiting here, about to see
    bra SensRead
    
    btfsc SensStatus,StatusDone ; we should now publish to the proper register
    bra SensPublish
    
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
    return
    
SkipAgain:
    bsf SensStatus,StatusCount
    return
    
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

_SensTriggerRight macro
    local skip
    btfsc SensStatus,7
    bra skip
    _SensTrigger EchoL, TrigL, EchoR, SensLastR
    bsf SensStatus,7
    skip:
    endm


_SensTriggerLeft macro
    local skip
    btfsc SensStatus,7
    bra skip
    _SensTrigger EchoR, TrigR, EchoL, SensLastL
    bcf SensStatus,7
    skip:
    endm

_SensTrigger macro NewEchoBit, NewTrigBit, OldEchoBit, LastSensDest
    local continue,kill,skip
    
    ;Check if old sensor is still on
    btfsc SensPort,OldEchoBit ; if this is still high we need to kill it now
    bra kill
    
continue:
    bsf TRISB,NewEchoBit ; just to be absolutely sure its at input
    bsf SensPort,NewTrigBit ; set trigger, this gets turned off at next cycle
    
    movlw 0x80
    andwf SensStatus
    bra TriggerDone
    
kill:
    _SensKill OldEchoBit,LastSensDest ; this is fun, macro from macro
    bra continue
    endm
    
SensTrigger:
    clrf _SensCount ; esnure we get here again
    btfsc SensStatus,7
    bra skipR
    bsf SensStatus,7; set this first to make sure we do left Next
    _SensTrigger EchoR, TrigR, EchoL, SensLastL
    
skipR:
    
    local skipL
    btfss SensStatus,7
    bra skipL
    bcf SensStatus,7; set this first to make sure we do right Next
    _SensTrigger EchoL, TrigL, EchoR, SensLastR
    
skipL:
    ;_SensTriggerLeft
    ;_SensTriggerRight
    
TriggerDone: 
    bsf SensStatus,StatusTrig ; this set's trigger stop state we need to clean
    ; up and stop the sensor on the next cycle
    clrf SensCount
    return

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
    
    
    end