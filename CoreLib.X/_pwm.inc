;Internal include for the pulse width modulation portion of the
;core library.
#ifndef ___PWM_INC__
#define ___PWM_INC__

;we need to ensure that core is included first so that our memory
;lines up properly.
#include _core.inc

; okay now we can define our internal pwm variables
.pwmData udata PwmMemoryStart
PWMCOUNT res 1 ; count of the internal PWM cycles, this goes to 50 and resets
PWMONL res 1 ; count of how many PWM cycles left should be on to reach desired PWM
PWMONR res 1 ; count of how many PWM cycles right should be on to reach desired PWM

 
;Port settings for PWM
PWMPORT	equ PORTA
PWMRIN	equ RA0
PWMRCE	equ RA1
PWMLIN	equ RA2
PWMLCE	equ RA3
	
#endif ;___PWM_INC__