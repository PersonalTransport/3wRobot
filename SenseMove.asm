;------------------------------------------------------------------------------------- 
; FILE: TimedMove.asm
; DESC: Repository for any calls related to sensed motion of the car
; DATE: 11-16-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
	    
#include P18F1220.inc
#include 3WheelInclude.inc
	    
	    GLOBAL	    SMOVE
	    
SMOV:	    code	    0x400
SMOVE:	    CALL	    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	    BTFSC	    SMOVCON
    
    
    
    
    
    
    
    
    
    
    
    
    
    
GROUND:	   BTFSC	    SMOVCON,	    2		    ; Test for use of right sensor
	   BCF		    TRISB,	    RB2		    ; Ground R. Echo
	   BTFSC	    SMOVCON,	    3		    ; Test for use of left sensor
	   BCF		    TRISB,	    RB1		    ; Ground L. Echo
	   MOVLW	    0x06
	   CALL		    GRDELAY			    ; Delay ~25 us
	   MOVLW	    0x0A			    
	   MOVWF	    TRISB			    ; Set R and L echo back to input
	   
GRDELAY:    DECF	    WREG
	    BNZ		    GRDELAY
	    RETURN
	    

