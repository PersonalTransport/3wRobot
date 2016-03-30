;Internal include for the pulse width modulation portion of the
;core library.
#ifndef ___PWM_INC__
#define ___PWM_INC__

;we need to ensure that core is included first so that our memory
;lines up properly.
#include _core.inc

; okay now we can define our internal pwm variables
cblock PwmMemoryStart
    
endc

#endif ;___PWM_INC__