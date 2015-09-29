    
    ; BIT Absolute Macro
    MAC BITABS
    .byte $2C
    ENDM

; Game Constants
NO_ILLEGAL_OPCODES = 0
PALCOLS         = 0             ; PAL/NTSC Colours (0 = NTSC)
PALTIME         = 0             ; 50Hz/60Hz Timing (0 = 60Hz)
KERNH       = 27        ; Logo Height (28 Pixels)
TEXTHEIGHT  = 5     ; Text Height (6 Pixels)

        ; Alphabet Constants
_A      = 0
_B      = 1
_C      = 2
_D      = 3
_E      = 4
_F      = 5
_G      = 6
_H      = 7
_I      = 8
_J      = 9     
_K      = 10
_L      = 11
_M      = 12
_N      = 13
_O      = 14
_P      = 15
_Q      = 16
_R      = 17
_S      = 18
_T      = 19
_U      = 20
_V      = 21
_W      = 22
_X      = 23
_Y      = 24
_Z      = 25
_BANG   = 26
_DASH   = 27
_COLON  = 28
__  = 29   
                   
; General Game Variables
STACK       = $A6           ; overlays basic vars
CYCLE       = STACK + 1        ; Game Cycle (60Hz)
SLOWCYCLE   = CYCLE + 1
RANDOM      = SLOWCYCLE + 1        ; Random Number Seed/Value
TEMP     =   RANDOM + 1        ; Temporary Variable

COL0     =   TEMP + 1        ; Logo Light Colour
COL1     =   COL0 + 1        ; Logo Dark Colour
COLCOUNT =   COL1 + 1        ; Colour Counter

TPTR  =      COLCOUNT + 1        ; Text Pointer
CPTR  =      TPTR + 1        ; Colour Pointer
PTR0  =      CPTR + 2        ; Sprite Pointers
PTR1  =      PTR0 + 2
PTR2  =      PTR1 + 2
PTR3  =      PTR2 + 2
PTR4  =      PTR3 + 2
PTR5  =      PTR4 + 2
    
LINE  =      PTR5 + 2    
COUNT =      LINE + 1

Ttemp = COUNT + 1


; Buffer For Text Display
TEXTBUFFER      = Ttemp + 16 ;    TEXTHEIGHT*6    ; Text Display Buffer                           

LOGOS:
        ; Wipe Registers & Memory
;    CLEAN_START        

        ldx #COUNT-STACK
        lda #0
.clearvar
        sta STACK,X
        dex
        bpl .clearvar
    
MainLoop
        ; Do Vertical Sync (VSync Routine by Manuel Polik)
        lda #2                  ; VSYNC enable
        sta WSYNC 
        sta VSYNC 
        sta WSYNC  
        sta WSYNC 
        lsr                     ; VSYNC disable
        sta WSYNC  
        sta VSYNC

        ; Set Vertical Blank Timer (PAL/NTSC)
        IF PALTIME
        ldy #53                 ; (45*76)/64 = 53
        ELSE
        ldy #43                 ; (37*76)/64 = 43
        ENDIF
        sty TIM64T
    
        lda   #$80
        bit   INPT4
        bmi   .nostick
        rts
    
.nostick

        ; Update Game Cycle
        dec CYCLE
    bne SkipCounter
    dec COLCOUNT
SkipCounter

    lda CYCLE
    lsr
    bcs NoSlowCycle
    lsr
    bcs NoSlowCycle
    lsr
    bcs NoSlowCycle
    lsr
    bcs NoSlowCycle 
    dec SLOWCYCLE
NoSlowCycle

    ; Set 3 sprite copies
    lda #%00000110
    sta NUSIZ0
    sta NUSIZ1

    ; Delay P0 & P1
    lda #%00000001      
    sta VDELP0
    sta VDELP1

    ; Update Colour Tables
    ;lda COLCOUNT
    ;and #%00000111
    ;tax
    lda #$B2
    sta COL0
    lda #$B2
    sta COL1

    ; Preload SCORE TABLE Message
    lda #>Messages
    sta TPTR+1
    lda #<_ScoreTable
    sta TPTR
    jsr TextCopy
    
       ; Wait for Vertical Blank End    
WaitVblank
        lda INTIM
        bne WaitVblank
        sta VBLANK      
        sta WSYNC
    
    
    ldy #40
.skiplines1
    sta WSYNC
    dey
    bne .skiplines1
    
    ; Swap Kernels on Alternate Cycles
    lda CYCLE
    lsr
    bcs K1
    jmp Kernel2
K1
    jmp Kernel1
    
    ALIGN 256       
    
Kernel1
    sta WSYNC

    ; Sprite Positioning (Fine Tuning)
    lda #%10010000      ; [0] + 2
    sta HMP0        ; [2] + 3
    lda #%10000000      ; [5] + 2
    sta HMP1        ; [7] + 3

    ; Set Sprite Colours
    lda COL1        ; [10] + 3
    sta COLUP0      ; [13] + 3
    sta COLUP1      ; [16] + 3

    ; Set Lines To Display
    ldy #KERNH      ; [19] + 2

    ; Sprite Positioning (Coarse)
    SLEEP 8         ; [21] + 8
    sta RESP0       ; [29] + 3 = 32
    nop         ; [32] + 2 = 34
    sta RESP1       ; [34] + 3 = 37
    
    ; Display Sprites On Alternate Lines
KernelLoop1
    sta WSYNC       ; [0]
    sta HMOVE       ; [0] + 3   P0A P1A P0B P1B
    lda LRow1,Y     ; [3] + 4
    sta GRP0        ; [7] + 3   - - 0 -
    lda LRow3,Y     ; [10] + 4
    sta GRP1        ; [14] + 3  0 - - 3     < 36
    lda LRow5,Y     ; [17] + 4
    sta GRP0        ; [21] + 3  0 3 5 -     < 42
    lda #0          ; [24] + 2
    sta HMP0        ; [26] + 3
    sta HMP1        ; [39] + 3  
    lda LRow7,Y     ; [32] + 4
    sta GRP1        ; [36] + 3  5 3 - 7     > 38 < 47
    lda LRow9,Y     ; [39] + 4  
    sta GRP0        ; [43] + 3  5 7 9 -     > 44 < 52 
    lda LRow11,Y        ; [46] + 4
    sta GRP1        ; [50] + 3  9 7 - 11    > 49 < 58
    sta GRP0        ; [53] + 3  9 11 - -    > 54 < 63
    SLEEP 8         ; [56] + 8
    lda LOGOColTable,Y     ; [65] + 4
    sta COLUP0      ; [68] + 3
    sta HMOVE       ; [71] + 3  = 74!   
    sta COLUP1      ; [74] + 3
    lda DRow0,Y     ; [1] + 4   P0A P1A P0B P1B 
    sta GRP0        ; [5] + 3   - - 0 -
    lda DRow2,Y     ; [8] + 4
    sta GRP1        ; [12] + 3  0 - - 2     < 34
    lda DRow4,Y     ; [15] + 4
    sta GRP0        ; [19] + 3  0 2 4 -     < 39
    lda #%10000000      ; [22] + 2
    sta HMP0        ; [24] + 3
    sta HMP1        ; [27] + 3
    lda DRow6,Y     ; [30] + 4  
    sta GRP1        ; [34] + 3  4 2 - 6     > 36 < 44
    lda DRow8,Y     ; [37] + 4
    sta GRP0        ; [41] + 3  4 6 8 -     > 41 < 50 
    lda DRow10,Y        ; [44] + 4
    sta GRP1        ; [48] + 3  8 6 - 10    > 47 < 55
    sta GRP0        ; [51] + 3  8 11 - -    > 52 < 60
    SLEEP 5         ; [54] + 5
    lda COL1        ; [59] + 3
    sta COLUP0      ; [62] + 3
    sta COLUP1      ; [65] + 3
    dey         ; [68] + 2
    bpl KernelLoop1     ; [70] + 2/3
EndKernel1
    
    jmp EndKernel

    if (>Kernel1 != >EndKernel1)
          echo "WARNING: Kernel Crosses Page Boundary!"
        endif

    ALIGN 256
    
Kernel2 
    sta WSYNC
    SLEEP 29        ; [0] + 29
    sta RESP0       ; [29] + 3 = 32
    nop             ; [32] + 2
    sta RESP1       ; [34] + 3 = 37
    
    lda #%10010000  ; [37] + 2
    sta HMP0        ; [39] + 3
    lda #%10000000  ; [42] + 2
    sta HMP1        ; [44] + 3
    
    SLEEP 13        ; [47] + 13

    ldy #KERNH      ; [60] + 2

    ; Set Sprite COlours
    lda COL1        ; [62] + 3
    sta COLUP0      ; [65] + 3
    sta COLUP1      ; [68] + 3
        
KernelLoop2
    sta HMOVE       ; [71] + 3  = 74!   
    sta COLUP1      ; [74] + 3
    lda LRow0,Y     ; [1] + 4   P0A P1A P0B P1B 
    sta GRP0        ; [5] + 3   - - 0 -
    lda LRow2,Y     ; [8] + 4
    sta GRP1        ; [12] + 3  0 - - 2     < 34
    lda LRow4,Y     ; [15] + 4
    sta GRP0        ; [19] + 3  0 2 4 -     < 39
    lda #%10000000  ; [22] + 2
    sta HMP0        ; [24] + 3
    sta HMP1        ; [27] + 3
    lda LRow6,Y     ; [30] + 4  
    sta GRP1        ; [34] + 3  4 2 - 6     > 36 < 44
    lda LRow8,Y     ; [37] + 4
    sta GRP0        ; [41] + 3  4 6 8 -     > 41 < 50 
    lda LRow10,Y    ; [44] + 4
    sta GRP1        ; [48] + 3  8 6 - 10    > 47 < 55
    sta GRP0        ; [51] + 3  8 11 - -    > 52 < 60
    lda LOGOColTable,Y     ; [54] + 3
    sta COLUP0      ; [57] + 3
    sta COLUP1      ; [60] + 3
    sta WSYNC       ; [0]
    sta HMOVE       ; [0] + 3   P0A P1A P0B P1B
    lda DRow1,Y     ; [3] + 4
    sta GRP0        ; [7] + 3   - - 0 -
    lda DRow3,Y     ; [10] + 4
    sta GRP1        ; [14] + 3  0 - - 3     < 36
    lda DRow5,Y     ; [17] + 4
    sta GRP0        ; [21] + 3  0 3 5 -     < 42
    SLEEP 4         ; [24] + 4
    
    ldx DRow11,Y    ; [28] + 4  
    lda DRow7,Y     ; [32] + 4
    sta GRP1        ; [36] + 3  5 3 - 7     > 38 < 47
    lda DRow9,Y     ; [39] + 4  
    sta GRP0        ; [43] + 3  5 7 9 -     > 44 < 52
    lda #0          ; [46] + 2
    stx GRP1        ; [48] + 3  9 7 - 11    > 49 < 58
    sta HMP0        ; [51] + 3  
    sta GRP0        ; [54] + 3  9 11 - -    > 54 < 63
    sta HMP1        ; [57] + 3
    lda COL1        ; [60] + 3
    sta COLUP0      ; [63] + 3
    dey             ; [66] + 2
    bpl KernelLoop2 ; [68] + 2/3    

EndKernel2
    jmp EndKernel

    if (>Kernel2 != >EndKernel2)
          echo "WARNING: Kernel Crosses Page Boundary!"
        endif

;    ALIGN 256
        
EndKernel
    lda #0
    sta COLUP0
    sta COLUP1
    
    ; Clear Current Sprite Positions
        sta WSYNC               ; [0]
        sta HMCLR               ; [0] + 3

        ; Clear Sprite Data
        lda #0                  ; [3] + 2
        sta GRP0                ; [5] + 3
        sta GRP1                ; [8] + 3       
                
        ; Set Delay and Three Sprite Copies
        lda #%00000011          ; [11] + 2
        sta VDELP0              ; [13] + 3
        sta VDELP1              ; [16] + 3
        sta NUSIZ0              ; [19] + 3
        sta NUSIZ1              ; [22] + 3

        ; Set Sprite1 Offset (Wont Change Until HMOVE)
        lda #%00010000          ; [25] + 2                      
        sta HMP1                ; [27] + 3

        ; Clear Any Reflections
        sta REFP0               ; [30] + 3
        sta REFP1               ; [33] + 3

        ; Set Sprite Positions
        nop                     ; [36] + 2
        sta RESP0               ; [38] + 3 = 41 EXACT
        sta RESP1               ; [41] + 3 = 44 EXACT
    
    ; Move Sprites
    sta WSYNC       ; [0]
    sta HMOVE

    sta WSYNC
    sta WSYNC
    sta WSYNC
    sta WSYNC

    ; Display FIRE TO PLAY Message
;        lda CYCLE
;        lsr
;        lsr
;        and #%00001111
;        tax
;        lda RedFade,X
        lda #$0F
        sta COLUP0
        sta COLUP1  
    lda #>Messages
    sta TPTR+1
    lda #<_FireToPlay
    sta TPTR
    jsr TextCopy
    jsr TextDisplay



    ldy #8
.skiplines2
    sta WSYNC
    dey
    bne .skiplines2



    lda CYCLE
    lsr
    bcs iam2

    ldx #14
.setp1
    lda IAMDataTable1,X
    sta Ttemp,X
    dex
    bpl .setp1
    bmi drawiam

iam2
    ldx #14
.setp2
    lda IAMDataTable2,X
    sta Ttemp,X
    dex
    bpl .setp2

drawiam

    ;lda #$0F
    ;sta COLUPF
    ;sta COLUBK
  
    ldy #44
    jsr DisplayBitmapSubroutine

    lda #$00
    ;sta COLUBK


    ldy #12
.skiplines3
    sta WSYNC
    dey
    bne .skiplines3

    
        ; Start Vertical Blank
        lda #2
        sta WSYNC
        sta VBLANK
        
        ; Set Timer for Overscan
        IF PALTIME
        ldy #42                 ; (36*76)/64 = 42
        ELSE
        ldy #35                 ; (30*76)/64 = 35
        ENDIF
        sty TIM64T
        
        ; Finish Overscan
WaitOverscanEnd
        lda INTIM
        bne WaitOverscanEnd
        
        ; Loop To Beginning
        jmp MainLoop

;    ALIGN 256
    
TextDisplay
        ; Store Text Height
        ldy #(TEXTHEIGHT - 1)      
        sty LINE 
        ; Load First Char
        lda (PTR0),Y
        sta GRP0
        sta WSYNC               ; [0]
        jmp StartText          ; [0] + 3
TextLoop
        ; Fetch Current Line
        ldy LINE                ; [62] + 3
        SLEEP 6                 ; [65] + 6
        ; Display First 3 Chars
        lda (PTR0),Y            ; [71] + 5
        sta GRP0                ; [0] + 3       > 54
StartText      
        lda (PTR1),Y            ; [3] + 5
        sta GRP1                ; [8] + 3       < 42
        lda (PTR2),Y            ; [11] + 5
        sta GRP0                ; [16] + 3      < 44    
        ; Prefetch Remaining 3 Chars
        lax (PTR3),Y            ; [19] + 5
        lda (PTR4),Y            ; [24] + 5
        sta TEMP                ; [29] + 3
        lda (PTR5),Y            ; [32] + 5
        tay                     ; [37] + 2
        lda TEMP                ; [39] + 3
        ; Display Remaining 3 Chars
        stx GRP1                ; [42] + 3      > 44 < 47
        sta GRP0                ; [45] + 3      > 46 < 50
        sty GRP1                ; [48] + 3      > 49 < 52
        sta GRP0                ; [51] + 3      > 52 < 55
        ; Update Counter
        dec LINE                ; [54] + 5
        bpl TextLoop        ; [59] + 2/3
        ; Clear Sprite Data
        lda #0                  ; [61] + 2      
        sta GRP0                ; [63] + 3      > 54
        sta GRP1                ; [66] + 3
        sta GRP0                ; [69] + 3
    rts

TextCopy    
        ; Store Stack Pointer
        tsx                     ; [0] + 2
        stx TEMP                ; [2] + 3
        ; Point Stack At End Of Text Buffer
        ldx #<TEXTBUFFER+((6*TEXTHEIGHT)-1) ; [5] + 2
        txs                     ; [7] + 2
        ; Create Text Pointers
        lda #>SmallFont         ; [9] + 2
        sta PTR0+1              ; [11] + 3
        sta PTR1+1              ; [14] + 3
        ; Loop Counter (12 Characters in Text String)
        ldy #11                 ; [17] + 2 = 19
CopyLoop
        ; Create Pointer To First Character
        lax (TPTR),Y        ; [0] + 5
        lda SmallR,X            ; [5] + 4
        sta PTR0                ; [9] + 3
        ; Create Pointer To Second Character
        dey                     ; [12] + 2
        lax (TPTR),Y        ; [14] + 4
        lda SmallL,X            ; [18] + 4
        sta PTR1                ; [22] + 3
        sty LINE                ; [25] + 3
        ; Create Text In Buffer
        ldy #TEXTHEIGHT-1   ; [28] + 2
CharLoop
        ; Merge Characters
        lda (PTR0),Y            ; [0] + 5
        ora (PTR1),Y            ; [5] + 5
        ; Store In Buffer
        pha                     ; [10] + 3
        dey                     ; [13] + 2
        bpl CharLoop           ; [15] + 2/3
                                ; TOTAL = 17 + 18*4 = 89 (FOR HEIGHT 5) 
        ; Repeat For Each Pair Of Characters
        ldy LINE                ; [119] + 3
        dey                     ; [122] + 2
        bpl CopyLoop        ; [124] + 2/3
                                ; TOTAL = 126 + 127*5 = 761
        ; Restore Stack
        ldx TEMP                ; [0] + 3
        txs                     ; [3] + 2 = 5

    ; Set Pointers
        lda #<TEXTBUFFER+(6*TEXTHEIGHT)     ; [0] + 2
        ldy #>TEXTBUFFER    ; [2] + 2
        ldx #11                 ; [4] + 2 = 6 
PtrLoop
        ; Pointer High
        sty PTR0,X              ; [0] + 4 
        dex                     ; [4] + 2 
        ; Pointer Low
        sec                     ; [6] + 2 
        sbc #TEXTHEIGHT     ; [8] + 2 
        sta PTR0,X              ; [10] + 4 
        dex                     ; [14] + 2 
        bpl PtrLoop            ; [16] + 2/3 
    rts

;    ALIGN 256
          
        ; Small Font Letters (Left Shifted)
SmallL
        DC.B    <L_AA, <L_BB, <L_CC, <L_DD, <L_EE, <L_FF, <L_GG, <L_HH, <L_II
        DC.B    <L_JJ, <L_KK, <L_LL, <L_MM, <L_NN, <L_OO, <L_PP, <L_QQ, <L_RR
        DC.B    <L_SS, <L_TT, <L_UU, <L_VV, <L_WW, <L_XX, <L_YY, <L_ZZ
        DC.B    <L_BANG, <L_DASH, <L_COLON, <GAP

        ; Small Font Letters (Right Shifted)
SmallR
        DC.B    <R_AA, <R_BB, <R_CC, <R_DD, <R_EE, <R_FF, <R_GG, <R_HH, <R_II
        DC.B    <R_JJ, <R_KK, <R_LL, <R_MM, <R_NN, <R_OO, <R_PP, <R_QQ, <R_RR
        DC.B    <R_SS, <R_TT, <R_UU, <R_VV, <R_WW, <R_XX, <R_YY, <R_ZZ
        DC.B    <R_BANG, <R_DASH, <R_COLON, <GAP
       
Messages
_ScoreTable
    DC.B    _S, _C, _O, _R, _E, __, _T, _A, _B, _L, _E, _COLON 
    
_FireToPlay
        DC.B    _P, _R, _E, _S, _S, __, _S, _T, _A, _R, _T, __
EndMessages 

            
    ALIGN 256


LRow0
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow1
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %11100000
                                .byte   %11110000
                                .byte   %01111000
                                .byte   %00111100
                                .byte   %00011110
                                .byte   %00001110
                                .byte   %00000110
                                .byte   %00000010
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow2
                                .byte   %00000000
                                .byte   %00100000
                                .byte   %01110000
                                .byte   %01111100
                                .byte   %01111111
                                .byte   %00011111
                                .byte   %00000111
                                .byte   %00000011
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000010
                                .byte   %00000011
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000010
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow3
                                .byte   %00000000
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %10000000
                                .byte   %11000000
                                .byte   %11100000
                                .byte   %01100000
                                .byte   %00110000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00010000
                                .byte   %00011000
                                .byte   %10011110
                                .byte   %11011110
                                .byte   %11011110
                                .byte   %01000111
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow4
                                .byte   %00000000
                                .byte   %11000111
                                .byte   %11100111
                                .byte   %00100000
                                .byte   %00100000
                                .byte   %00110000
                                .byte   %00010000
                                .byte   %00010000
                                .byte   %00011000
                                .byte   %00001000
                                .byte   %00001000
                                .byte   %00001100
                                .byte   %00000100
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %01111100
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000010
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow5
                                .byte   %00000000
                                .byte   %11100000
                                .byte   %11110000
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00001000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000110
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11110000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00011111
                                .byte   %00001000
                                .byte   %00001111
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

;EndLRow5
;    if (>LRow0 != >EndLRow5)
;          echo "WARNING: Logo Data Crosses Page Boundary!"
;        endif   

;    ALIGN 256


LRow6
                                .byte   %00000000
                                .byte   %00001111
                                .byte   %00001111
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %00110000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %00000111
                                .byte   %00000110
                                .byte   %00111110
                                .byte   %00110000
                                .byte   %00100000
                                .byte   %10000000
                                .byte   %01000001
                                .byte   %11000001
                                .byte   %01000010
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow7
                                .byte   %00000000
                                .byte   %11100111
                                .byte   %11101111
                                .byte   %00001100
                                .byte   %00001000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00010000
                                .byte   %00110000
                                .byte   %00110000
                                .byte   %00110000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01000000
                                .byte   %11000000
                                .byte   %11000000
                                .byte   %01000000
                                .byte   %11111011
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %10000010
                                .byte   %10000110
                                .byte   %00000100
                                .byte   %00001100
                                .byte   %00011000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

     ALIGN 256                                
LRow8
                                .byte   %00000000
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000111
                                .byte   %00001111
                                .byte   %00001111
                                .byte   %00011100
                                .byte   %00010000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %01100111
                                .byte   %11111111
                                .byte   %00011111
                                .byte   %00011110
                                .byte   %00111100
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01100000
                                .byte   %01000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

                                .byte   0,0,0,0

LRow9
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000111
                                .byte   %00011111
                                .byte   %01111111
                                .byte   %11111100
                                .byte   %11110000
                                .byte   %11000000
                                .byte   %00000000
                                .byte   %00000111
                                .byte   %00001100
                                .byte   %01111000
                                .byte   %11110000
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow10
                                .byte   %00000000
                                .byte   %01111111
                                .byte   %11111111
                                .byte   %11110000
                                .byte   %11000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
LRow11
                                .byte   %00000000
                                .byte   %11100000
                                .byte   %11000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
   
;EndLRow11
;    if (>LRow6 != >EndLRow11)
;          echo "WARNING: Logo Data Crosses Page Boundary!"
;        endif
    
;    ALIGN 256


DRow0
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00111100
                                .byte   %00011110
                                .byte   %00001111
                                .byte   %00000111
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
DRow1
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %10000001
                                .byte   %11000001
                                .byte   %11100001
                                .byte   %11110001
                                .byte   %01111001
                                .byte   %00111101
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00000111
                                .byte   %00000011
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
DRow2
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %11110000
                                .byte   %11111000
                                .byte   %11111110
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %00000000
                                .byte   %00111000
                                .byte   %00011100
                                .byte   %00001110
                                .byte   %00000111
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
DRow3
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00011111
                                .byte   %10011111
                                .byte   %11001111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00000011
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00110001
                                .byte   %00111000
                                .byte   %00111110
                                .byte   %10111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111110
                                .byte   %00111110
                                .byte   %00011110
DRow4
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11001111
                                .byte   %11001111
                                .byte   %11000111
                                .byte   %11100011
                                .byte   %11100011
                                .byte   %11100001
                                .byte   %11110000
                                .byte   %11110000
                                .byte   %11110000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %00000000
                                .byte   %11111001
                                .byte   %11111001
                                .byte   %11111101
                                .byte   %01111100
                                .byte   %01111110
                                .byte   %11111110
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %00011111
                                .byte   %00001111
 align 256
DRow5
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111000
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %01111110
                                .byte   %01111110
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00000000
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11110000
                                .byte   %11110000
                                .byte   %11110000
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %01111000
                                .byte   %10111000
                                .byte   %10111111


;EndDRow5
;    if (>DRow0 != >EndDRow5)
;          echo "WARNING: Logo Data Crosses Page Boundary!"
;        endif
    
;    ALIGN 256


DRow6
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000111
                                .byte   %00001111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %00111111
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %00000000
                                .byte   %10011111
                                .byte   %10111111
                                .byte   %00111110
                                .byte   %00111110
                                .byte   %00111110
                                .byte   %10111101
                                .byte   %10111101
                                .byte   %00111100
                                .byte   %00111100
                                .byte   %10011111
DRow7
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11110011
                                .byte   %11110111
                                .byte   %11100111
                                .byte   %11000111
                                .byte   %11001111
                                .byte   %10001111
                                .byte   %00001111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00000000
                                .byte   %11111110
                                .byte   %01111100
                                .byte   %01111101
                                .byte   %01111001
                                .byte   %11110011
                                .byte   %11110011
                                .byte   %11100111
                                .byte   %00000111
                                .byte   %00001111
                                .byte   %11001111
DRow8
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11111100
                                .byte   %11111100
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %11110000
                                .byte   %11100001
                                .byte   %11100111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111100
                                .byte   %11110000
                                .byte   %11000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11100000
                                .byte   %11100001
                                .byte   %11000011
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %10011111
                                .byte   %00011110
                                .byte   %00111100
                                .byte   %11111000
                                .byte   %11110000

                                .byte   0,0,0,0

DRow9
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000111
                                .byte   %00011111
                                .byte   %01111111
                                .byte   %11111101
                                .byte   %11111001
                                .byte   %11000011
                                .byte   %00000111
                                .byte   %00001111
                                .byte   %00011111
                                .byte   %00111111
                                .byte   %01111110
                                .byte   %00000000
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %11100000
                                .byte   %11000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
DRow10
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00011111
                                .byte   %01111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111110
                                .byte   %11111100
                                .byte   %11111000
                                .byte   %11110000
                                .byte   %11100000
                                .byte   %11000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
DRow11
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11110000
                                .byte   %11100000
                                .byte   %11000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
  
;EndDRow11
;    if (>DRow6 != >EndDRow11)
;          echo "WARNING: Logo Data Crosses Page Boundary!"
;        endif   

    ALIGN 256

SmallFont
    ; Left Characters
L_VV
        DC.B    %01000000
        DC.B    %01000000
        DC.B    %10100000
L_XX
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %01000000
        DC.B    %10100000   
L_WW
        DC.B    %10100000
        DC.B    %11100000
        DC.B    %10100000
L_AA
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11100000
        DC.B    %10100000
L_CC
        DC.B    %01000000
        DC.B    %10100000
        DC.B    %10000000
        DC.B    %10100000
L_JJ
        DC.B    %01000000
        DC.B    %10100000
        DC.B    %00100000
        DC.B    %00100000
        DC.B    %00100000   
L_FF
        DC.B    %10000000
        DC.B    %10000000
        DC.B    %11000000
        DC.B    %10000000   
L_EE
        DC.B    %11100000
        DC.B    %10000000
        DC.B    %11000000
        DC.B    %10000000
L_II
        DC.B    %11100000
        DC.B    %01000000
        DC.B    %01000000
        DC.B    %01000000
L_LL
        DC.B    %11100000
        DC.B    %10000000
        DC.B    %10000000
L_PP
        DC.B    %10000000
        DC.B    %10000000
        DC.B    %11000000
        DC.B    %10100000
L_BB
        DC.B    %11000000
    DC.B    %10100000
    DC.B    %11000000
    DC.B    %10100000
L_DD
    DC.B    %11000000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11000000
L_YY
        DC.B    %01000000
        DC.B    %01000000
        DC.B    %01000000   
        
; ALIGN 256
L_HH
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11100000
L_KK
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11000000
L_MM
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11100000
L_NN
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
L_UU
        DC.B    %11100000
        DC.B    %10100000
        DC.B    %10100000
L_RR
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %11000000
        DC.B    %10100000
L_SS
        DC.B    %11000000
        DC.B    %00100000
        DC.B    %01000000
        DC.B    %10000000
L_GG
        DC.B    %01100000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10000000
L_QQ
        DC.B    %01100000           
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
L_OO
        DC.B    %01000000
        DC.B    %10100000
        DC.B    %10100000
        DC.B    %10100000
L_TT
        DC.B    %01000000
        DC.B    %01000000
        DC.B    %01000000
        DC.B    %01000000
L_ZZ
        DC.B    %11100000
        DC.B    %10000000
        DC.B    %01000000
        DC.B    %00100000
        DC.B    %11100000
L_BANG
    DC.B    %01000000
    DC.B    %00000000
    DC.B    %01000000
    DC.B    %01000000
    DC.B    %01000000
L_COLON
    DC.B    %00000000
    DC.B    %01000000
    DC.B    %00000000
    DC.B    %01000000   
L_DASH
    DC.B    %00000000
    DC.B    %00000000
    DC.B    %11100000
    DC.B    %00000000
    DC.B    %00000000
    
    ; Right Characters
R_VV
        DC.B    %00000100
        DC.B    %00000100
        DC.B    %00001010
R_XX
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00000100
        DC.B    %00001010
R_WW
        DC.B    %00001010
        DC.B    %00001110
        DC.B    %00001010
R_AA
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001110
        DC.B    %00001010
R_CC
        DC.B    %00000100
        DC.B    %00001010
        DC.B    %00001000
        DC.B    %00001010
R_JJ
        DC.B    %00000100
        DC.B    %00001010
        DC.B    %00000010
        DC.B    %00000010
        DC.B    %00000010   
R_FF
        DC.B    %00001000
        DC.B    %00001000
        DC.B    %00001100
        DC.B    %00001000   
R_EE
        DC.B    %00001110
        DC.B    %00001000
        DC.B    %00001100
        DC.B    %00001000
R_II
        DC.B    %00001110
        DC.B    %00000100
        DC.B    %00000100
        DC.B    %00000100
R_LL
        DC.B    %00001110
        DC.B    %00001000
        DC.B    %00001000
R_PP
        DC.B    %00001000
        DC.B    %00001000
        DC.B    %00001100
        DC.B    %00001010
R_BB
        DC.B    %00001100
    DC.B    %00001010
    DC.B    %00001100
    DC.B    %00001010
R_DD
    DC.B    %00001100
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001100
R_YY
        DC.B    %00000100
        DC.B    %00000100
        DC.B    %00000100   
R_HH
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001110
R_KK
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001100
R_MM
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001110
R_NN
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
R_UU
        DC.B    %00001110
        DC.B    %00001010
        DC.B    %00001010
R_RR
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001100
        DC.B    %00001010
R_SS
        DC.B    %00001100
        DC.B    %00000010
        DC.B    %00000100
        DC.B    %00001000
R_GG
        DC.B    %00000110
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001000
R_QQ
        DC.B    %00000110           
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
R_OO
        DC.B    %00000100
        DC.B    %00001010
        DC.B    %00001010
        DC.B    %00001010
R_TT
        DC.B    %00000100
        DC.B    %00000100
        DC.B    %00000100
        DC.B    %00000100
R_ZZ
        DC.B    %00001110
        DC.B    %00001000
        DC.B    %00000100
        DC.B    %00000010
        DC.B    %00001110   
R_BANG
    DC.B    %00000100
    DC.B    %00000000
    DC.B    %00000100
    DC.B    %00000100
    DC.B    %00000100
R_COLON
    DC.B    %00000000
    DC.B    %00000100
    DC.B    %00000000
    DC.B    %00000100   
R_DASH
    DC.B    %00000000
    DC.B    %00000000
    DC.B    %00001110
    DC.B    %00000000
    DC.B    %00000000   
GAP
        DC.B    %00000000
        DC.B    %00000000
        DC.B    %00000000
        DC.B    %00000000
        DC.B    %00000000
EndSmallFont
    
;    if (>SmallFont != >EndSmallFont)
;          echo "WARNING: Font Data Crosses Page Boundary!"
;        endif

;---------------------------------------------------------
;---------------------------------------------------------


;-------------------------Constants Below---------------------------------

THREECOPIESCLOSE    =   $03
GRAY          =       $00
BLUE2         =       $d0
LEVEL0BACKGROUNDCOLOR   =   BLUE2+10
RED           =       $40
BROWNGREEN    =       $C0
WHITE          = $0F
REFLECTEDPF     =   %00000001

NOMOVEMENT      =   $00
RIGHTONE        =   $F0

;---------------------------------------------------------

    align 256


DisplayBitmapSubroutine
    ;       7 pointers and 1 variable must be set upon entering (Temp through Temp+11 to graphics,
    ;                           Temp+12 through Temp+13 to PF color
    ;                           Temp+14 is players color)
    ;       Y must be set (height of bitmap)
    ;       will position sprites, set NUSIZx, VDELPx, CTRLPF, display bitmap,
    ;       then reset NUSIZx, VDELPx, CTRLPF, GRP0, and GRP1 to zero, then return.
    lda #THREECOPIESCLOSE
    sta WSYNC
    sta NUSIZ0
    sta NUSIZ1          ;+8  6
    lda #REFLECTEDPF
    sta CTRLPF          ;+5 11
    lda #64         ;+2 13
    sec             ;+2 15
DivideLoopBitmap
    sbc #15
    bcs DivideLoopBitmap    ;+4/5   19/24/...
    sta RESP0           ;+3 23
    sta RESP1           ;+3 26
    sta WSYNC
    lda #RIGHTONE
    sta HMP0
    lda #NOMOVEMENT
    sta HMP1            ;+10    10
    lda #$80
    sta HMM0
    sta HMM1
    sta HMBL            ;+11    21
    lda Ttemp+14
    sta COLUP0
    sta COLUP1          ;+9 30
    SLEEP 40            ;+40    40
    sta HMOVE
    sta WSYNC           ;+6 76
    lda #1
    sta VDELP0
    sta VDELP1          ;+8  8
    lda #0
    sta GRP0
    sta GRP1
    sta GRP0            ;+11    19


    SLEEP 34            ;+34    53
    sty TEMP            ;+3 56  doubling up with this variable
    lda #%11111100
    sta PF2             ;+5 61
DisplayBitmapLoop
    ldy TEMP         ;+3 64
    ;lda (Ttemp+12),Y
    ;sta COLUPF          ;+8 72
    nop
    nop
    nop
    nop
    lda (Ttemp),Y
    sta GRP0            ;+8  4
    lda (Ttemp+2),Y
    sta GRP1            ;+8 12
    lda (Ttemp+4),Y
    sta GRP0            ;+8 20
    lax (Ttemp+6),Y          ;+5 25
    lda (Ttemp+8),Y
    sta Ttemp+14         ;+8 33
    lda (Ttemp+10),Y         ;+5 38
    ldy Ttemp+14         ;+3 41

    stx GRP1            ;+3 44
    sty GRP0
    sta GRP1
    sta GRP0            ;+9 53
    dec TEMP         ;+5 58
    bpl DisplayBitmapLoop   ;+3 61
                    ;   60
    lda #0
    sta PF2         ;+5 65
    sta VDELP0
    sta VDELP1          ;+6 71
    sta NUSIZ0
    sta NUSIZ1          ;+6  1
    sta GRP0
    sta GRP1            ;+6  7
    sta CTRLPF          ;+3 10
Ret4
    rts             ;+6 16

IAMDataTable1
    .word SPRITE1_0,SPRITE1_1,SPRITE1_2,SPRITE1_3,SPRITE1_4,SPRITE1_5,TitleColorData
    .byte $5e

IAMDataTable2
    .word SPRITE2_0,SPRITE2_1,SPRITE2_2,SPRITE2_3,SPRITE2_4,SPRITE2_5,TitleColorData
    .byte $53
        
TitleColorData:        
         
;    ALIGN 256
    
SPRITE1_0
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
    ALIGN 256
    
SPRITE1_1
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %00000001
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %11100001
                                .byte   %11100001
                                .byte   %11100001
                                .byte   %11100001
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %00011000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
SPRITE1_2
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %10010101
                                .byte   %11011111
                                .byte   %10011111
                                .byte   %01010101
                                .byte   %10001110
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %11110011
                                .byte   %11110011
                                .byte   %11110011
                                .byte   %11110011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000000
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %01100011
                                .byte   %01100011
                                .byte   %00011100
                                .byte   %00011100
                                .byte   %00011100
SPRITE1_3
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01000100
                                .byte   %00111000
                                .byte   %01010100
                                .byte   %01111100
                                .byte   %01010100
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %11111000
                                .byte   %00000000
                                .byte   %01100001
                                .byte   %01100001
                                .byte   %01100001
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %01101101
                                .byte   %00011110
                                .byte   %00011110
                                .byte   %00011110
SPRITE1_4
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01100111
                                .byte   %01100111
                                .byte   %01100111
                                .byte   %01100111
                                .byte   %00000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

SPRITE1_5
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %01100000
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

        ALIGN 256
        

SPRITE2_0
                                .byte   %01111100
                                .byte   %01111100
                                .byte   %01111110
                                .byte   %11111110
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %01111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00000111
                                .byte   %00000111
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
SPRITE2_1
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %00000011
                                .byte   %11111011
                                .byte   %11111011
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00111111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00011111
                                .byte   %00001111
                                .byte   %00001111
                                .byte   %00001111
                                .byte   %00001111
                                .byte   %00000110
                                .byte   %00000110
                                .byte   %00000111
                                .byte   %00000011
                                .byte   %00000011
SPRITE2_2
                                .byte   %11110011
                                .byte   %11111011
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %01111100
                                .byte   %00111100
                                .byte   %00111100
SPRITE2_3
                                .byte   %00001100
                                .byte   %10001110
                                .byte   %11001111
                                .byte   %11101111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111001
                                .byte   %11111001
                                .byte   %11111100
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %01111111
                                .byte   %01111110
                                .byte   %00111110
                                .byte   %00111110
SPRITE2_4
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %10000000
                                .byte   %11100000
                                .byte   %11110000
                                .byte   %11111000
                                .byte   %11111100
                                .byte   %11111110
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11111111
                                .byte   %11101111
                                .byte   %01101111
                                .byte   %00000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %10000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000

 align 256

SPRITE2_5
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %11000000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11100000
                                .byte   %11110000
                                .byte   %11111000
                                .byte   %11111100
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %11111110
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000
                                .byte   %00000000        

; END

LOGOColTable:


;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F
;                                .byte   $0F        
                                .byte   $A8
                                .byte   $0F
                                .byte   $A8

                            ; last visible Bottom
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $A8
                                .byte   $B4
                                .byte   $A8
                                .byte   $B2
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $0F
                                .byte   $A8
                                .byte   $A8
                                .byte   $B2
                                .byte   $0F
                                .byte   $52
                                .byte   $0F
                                .byte   $52
                            ; first visible top
                                .byte   $40

                                .byte   $0F
                                .byte   $52
                                .byte   $0F
                                .byte   $52
                                .byte   $52
                                .byte   $52
                                .byte   $44   

