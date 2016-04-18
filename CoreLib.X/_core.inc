#ifndef ___CORE_INC__ ; note three _ because this is internal
#define ___CORE_INC__

    ; make sure we include this as internal only
#define __CORE_SKIP_PUBLIC ; this should never be included by public user
    ;now we can include core.inc for memory location settings
    ;we must insure this comes first in order to get MemoryStart to line up properly
#include core.inc

    ; here we define the things needed everywhere in internal.
._coreData udata_ovr MemoryStart
_PWMCount res 1  ;used to track how often a pwm cycle should run
_SensCount res 1 ;used to track when the sensors should trigger
;    endc
    ;Increment memory start, if you add more variables above;
    ;YOU MUST UPDATE THIS to represent that count
MemoryStart +=2 
    

    ; now this is where things get interesting
    ;since we split off and have separate includes for pwm and sense
    ;I cannot know which one gets included first so I must make 
    ;two variables to controll the memory start for each, there may be some gaps.
    ;the key is if you edit the _pwm.inc to use more memory you must push back
    ;the start of the sens memory
    variable PwmMemoryStart = MemoryStart
    ; PWM will start where we left off above
    ; Sens will start 10 more past that to allow for internal varialbes needed by PWM
    variable SensMemoryStart = PwmMemoryStart + 10
    
#endif ;___CORE_INC__


