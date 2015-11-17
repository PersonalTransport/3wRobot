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
	    
SMOV:	   code		    0x400
SMOVE:	   CALL		    GROUND			    ; Ground echo pins to insure proper functionality of sensor
	   MOVLW	    0x05	        
	   MOVWF	    WREG			    ; Prepare WREG for sensor set up
	   BTFSC	    SMOVCON,	    2		    ; Test for use of R Sensor
	   BCF		    WREG,	    0		    ; If R sensor only is needed, clear L sensor trigger bit
	   BTFSC	    SMOVCON,	    3		    ; Test for use of L Sensor
	   BCF		    WREG,	    3		    ; If L sensor only is needed, clear R sensor trigger bit
	   MOVWF	    PORTB			    ; Set Trigger ~10 us before sense loop begins
	   MOVLW	    0x0F			    ; Default to forward motion (1 cycle)
	   BTFSS	    SMOVCON,	    0		    ; Test for R turn		(2-3 cycle)
	   BCF		    WREG,	    2
	   BTFSS	    SMOVCON,	    1		    ; Test for L turn		(4-5 cycle)
	   BCF		    WREG,	    1		    
	   MOVWF	    PORTA			    ; Begin motion		(6 cycle)
	   CLRF		    TEMPR			    ; Clear R sensor count	(7 cycle)
	   CLRF		    TEMPL			    ; Clear L sensor count	(8 cycle)
	   
	   
	   
	   
    
    
GROUND:	   BTFSC	    SMOVCON,	    2		    ; Test for use of R sensor
	   BCF		    TRISB,	    RB2		    ; Ground R. Echo
	   BTFSC	    SMOVCON,	    3		    ; Test for use of L sensor
	   BCF		    TRISB,	    RB1		    ; Ground L. Echo
	   MOVLW	    0x06
	   CALL		    GRDELAY			    ; Delay ~25 us
	   MOVLW	    0x0A			    
	   MOVWF	    TRISB			    ; Set R and L echo back to input
	   RETURN
	   
GRDELAY:   DECF	    WREG
	   BNZ		    GRDELAY
	   RETURN
	    

