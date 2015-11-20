;------------------------------------------------------------------------------------- 
; FILE: TimedMove.asm
; DESC: Repository for any calls related to timed motion of the car
; DATE: 11-10-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 

	    
#include P18F1220.inc
#include 3WheelInclude.inc

	    GLOBAL	    TMOVE, DISABLE
	    
TMOV:	    code	    0x200
TMOVE:	    MOVLW	    0xF8
	    ANDWF	    TMOVCON,	    0		    ; Duration bits copied from MOVECON
	    MOVWF	    TEMPR			    ; Moved into a temporary registry
	    RRNCF	    TEMPR
	    RRNCF	    TEMPR
	    RRNCF	    TEMPR			    ; Rotated into correct position
	    INCF	    TEMPR			    ; Incriment to reflect min .1 sec move
	    MOVLW	    0x9D			    ; .157 tics ~ .1 sec, converts tics to 
	    MULWF	    TEMPR			    ; desired duration (48 microsecond variance)
	    INCF	    PRODL			    ; Add 1 to result to account for timer roll over
	    SETF	    TMR3L
	    SETF	    TMR3H			    ; Set timers to prepare for subtraction
	    MOVF	    PRODH,	    0
	    SUBWF	    TMR3H			    ; Subtract high byte of multiplication from low byte of timer
	    MOVF	    PRODL,	    0
	    SUBWF	    TMR3L			    ; Subtract low byte of multiplication from high byte of timer
	    BTFSS 	    TMOVCON,	    0
	    MOVLW	    0x0F			    ; Prepare PORTA to move Forward
	    BTFSC	    TMOVCON,	    0
	    MOVLW	    0x0A			    ; Prepare PORTA to reverse
	    MOVWF	    PORTA
	    BTFSC	    TMOVCON,	    1		    ; Test for R turn
	    CALL	    RRTEST
	    BTFSC	    TMOVCON,	    2		    ; Test for L turn
	    CALL	    LRTEST
	    BSF		    T0CON,	    TMR0ON	    ; Start timer
	    RETURN
	    
RRTEST:	    BTFSS	    TMOVCON,	    2		    ; If L Turn = TRUE, reverse direction of R wheel for rotate
	    BCF		    PORTA,	    RA3
	    BTFSC	    TMOVCON,	    2		    ; If L Turn = FALSE, disable R wheel for R turn
	    BCF		    PORTA,	    RA2
	    RETURN
	    
LRTEST:	    BTFSS	    TMOVCON,	    1		    ; If R Turn = True, skip
	    BCF		    PORTA,	    RA1		    ; Else, disable L wheel for L turn. 
	    RETURN
	    
DISABLE:    BCF		    INTCON,	    TMR0IF	    ; Remove interrupt flag
	    CLRF	    PORTA			    ; Stop all motion
	    BCF		    T0CON,	    TMR0ON	    ; Turn off timer
	    INCF	    TCOUNT			    ; Increment counter for timed motion to allow for stages.   
	    RETFIE
	    
	    End