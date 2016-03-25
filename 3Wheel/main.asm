;------------------------------------------------------------------------------------- 
; FILE: main.asm
; DESC: Main file to test various capabilities
; DATE: 11-10-15
; AUTH: Marie Bomber 
; DEVICE: PICmicro (PIC18F1220) 
;------------------------------------------------------------------------------------- 
	    list	   p=18F1220			   ; Set processor type 
	    radix	   hex				   ; Sets the default radix for data exp. 
    
	    EXTERN	    INITIALIZE, DISABLE, TMOVE

#INCLUDE    3WheelInclude.inc
	    
BEGIN:	    code	0x000
	    GOTO	Start
	    
INTERRUPT:  code	0x018
	    CALL	DISABLE
	    RETFIE
	    
MAIN:	    code	0x100
Start:	    CALL	INITIALIZE
	    MOVLW	0x48
	    MOVWF	TMOVCON
	    CALL	TMOVE
	    BRA		Wait
	    
Wait:	    BRA		Wait
    
	    End
	    
	    

