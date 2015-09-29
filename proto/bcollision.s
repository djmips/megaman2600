; Player Collision
;


; Typical screen data

;PF_data1
;    .byte %10001100, %00000000, %00000000, %10000000
;    .byte %10001100, %00000000, %00000000, %10000000
;    .byte %10001100, %00000000, %00000000, %10000000
;    .byte %11111111, %00000011, %00000000, %10000000
;    .byte %10000000, %00000000, %00000000, %10000000
;    .byte %10000000, %00000000, %01111111, %11111111
;    .byte %10000000, %00000000, %00000000, %10000000
;    .byte %11111111, %00000011, %00000000, %10000000
;    .byte %10000000, %00000000, %00000000, %10000000
;    .byte %10000000, %00000000, %00000000, %10000000
;    .byte %11111111, %11111111, %11111111, %11111111

; 12 - 128 Measured X
; 10 -  80 Measured Y

; 

; Input colX, colY     (0-128) 
; Input prevX, prevY   (0-128)
; 

; Calculate going up, going down, going left, going right
;
;

.BBitTblOffset
 .byte 0
 .byte 8
 .byte 0
 .byte 8

.BBitCheck
 .byte %10000000
 .byte %01000000
 .byte %00100000 
 .byte %00010000
 .byte %00001000
 .byte %00000100
 .byte %00000010
 .byte %00000001 

.BBitCheckFlip
 .byte %00000001 
 .byte %00000010
 .byte %00000100
 .byte %00001000
 .byte %00010000
 .byte %00100000 
 .byte %01000000
 .byte %10000000

    nop
    nop
    nop
    nop
    
.BCheckPos
    lda colY
    lsr ;/2
    and #%11111100
    sta temp1

    ldx colX
    txa
    lsr ;/2
    lsr ;/4
    tax
    lsr ;/8
    lsr ;/16
    lsr ;/32

    ; 0 1 2 3
    tay
    
    txa
    and #7
    clc
    adc .BBitTblOffset,y
    tax

    tya
    adc temp1
    tay

    lda playfield,y
    and .BBitCheck,x
    sta colResult
    rts
    