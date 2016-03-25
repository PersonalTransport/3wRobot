;------------------------------------------------------------------------------------- 
; FILE: DisableManagement.asm
; DESC: Organize disables for all calls
; DATE: 12-28-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
    
 	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
	    
#include P18F1220.inc
#include 3WheelInclude.inc
	    
	    EXTERN	TDISABLE, LOOKAGAIN, SLEFT, SRIGHT	    
	    
INTERRUPT:  code	0x018
	    BTFSC	INTCON,		TMR0IF		    ; Check if interrupt came from Timed move
	    CALL	TDISABLE
	    BTFSC	PIR1,		TMR2IF		    ; Check if interrupt came from sensor searching too long
	    CALL	LOOKAGAIN
	    BTFSC	INTCON3,	INT1IF		    ; Check if interrupt came from left sensor
	    CALL	SLEFT
	    BTFSC	INTCON3,	INT2IF		    ; Check if interrupt came from right sensor
	    CALL	SRIGHT
	    RETFIE

