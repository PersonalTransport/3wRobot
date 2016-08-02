# mpasm macro overview #
**note** this is not a replacement for official documentation, just a quick rundown

Macro's in mpasm work similarly to preprocessor macros in c/c++, the idea is that you write a code template, and then when you call that macro the template is filled in. This macro replacement happens prior to code execution, this can make debugging difficult. Because of this I recommend getting your code working without a macro, and using the macro to repeat a working process if you have to do it repeatedly, for example see my _sens.asm or _pwm.asm for examples of working macro's.
```assembly
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
```
In the above example, whatever I put in the variables is plain text copied into the code, if I pass things that are not actually correct values I will get errors from the compiler that point to lines that don't exist because they were created during the pre-processor phase of compilation. here is for example the correct usage of that macro.
```assembly
#define PWMCONL 0x82
#define PWMONL 0x83
#define PWMLCE 0x82

_DoPWM PWMCONL,PWMONL,PWMLCE 
```
