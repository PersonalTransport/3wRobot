;Internal include for the sonic sensor portion of the
;core library.
#ifndef ___SENS_INC__
#define ___SENS_INC__

;we need to ensure that core is included first so that our memory
;lines up properly.
#include _core.inc

; okay now we can define our internal sens variables
    cblock SensMemoryStart
	SensStatus ; internal register used to track the sensor state and last sensor
	SensCount ; internal count of echo cycles as sensor is being read
    endc

; These define which bit of SensStatus does what.
; I realize this could have been done with a count up and down, but
; that would have required comparing with literals, by checking these bits
; I use less cycles for state comparison.
StatusTrig equ 0
StatusSkip equ 1
StatusCount equ 2
StatusDone equ 3

;change this if you want different OUTPUT pins to be used.
SensPort equ PORTB
TrigL equ RB0
EchoL equ RB1
TrigR equ RB2
EchoR equ RB3    
    
#endif ;___SENS_INC__


