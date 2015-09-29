
;    processor 6502
;    include vcs.h
;    include macro.h

;-------------------------Constants Below---------------------------------



    ;--BeatLengthSong bits

BEAT_BITS   =   %11110000
SONG_BITS   =   %00001111

    ;--SoundEffects bits

SFXCOUNTER_BITS     =       %00011111

    ;--song constants

SONG_ELECMAN        =       0
SONG_PRESTAGE       =       1
SONG_STAGESELECT    =       2

    ;--MUSIC CONSTANTS FOLLOW:

SLUR_BIT    =   %10000000
LENGTH_BITS =   %01100000
NOTE_BITS   =   %00011111



RESTFLAG    =   0

    ;--Tempos available:
TEMPO450    =       0       ;450 BPM
TEMPO225    =       %00000001
TEMPO150    =       %00000010
TEMPO112    =       %00000011   ;112.5 BPM
TEMPO90     =       %00000100
TEMPO75     =       %00000101
TEMPO64     =       %00000110   ;64.2857142857143 BPM
TEMPO56     =       %00000111       ;56.25
TEMPO50     =   %00001000
TEMPO45     =   %00001001
TEMPO41     =   %00001010   ;40.9090909...
TEMPO37     =   %00001011   ;37.5
TEMPO35     =   %00001100   ;34.615384...
TEMPO32     =   %00001101   ;32.142857...
TEMPO30     =   %00001110
TEMPO28     =   %00001111   ;28.125


SLUR            =       %10000000
VOLUMECHANGE    =       %00000000
INDEXCHANGE     =       %00010000

THIRTYSECOND    =       %00000000
SIXTEENTH       =       %00100000
EIGHTH          =       %01000000
QUARTER         =       %01100000


V0      =   %00000000
V1      =   %00000001
V2      =   %00000010
V3      =   %00000011
V4      =   %00000100
V5      =   %00000101
V6      =   %00000110
V7      =   %00000111
V8      =   %00001000
V9      =   %00001001
V10     =   %00001010
V11     =   %00001011
V12     =   %00001100
V13     =   %00001101
V14     =   %00001110
V15     =   %00001111


;-------------------------COLOR CONSTANTS (NTSC)--------------------------

GRAY        =   $00
GOLD        =   $10
ORANGE      =   $20
BURNTORANGE =   $30
RED     =   $40
PURPLE      =   $50
PURPLEBLUE  =   $60
MBLUE        =   $70
MBLUE2       =   $80
LIGHTBLUE   =   $90
TURQUOISE   =   $A0
GREEN       =   $B0
BROWNGREEN  =   $C0
TANGREEN    =   $D0
TAN     =   $E0
BROWN       =   $F0

;--------------------------TIA CONSTANTS----------------------------------

    ;--NUSIZx CONSTANTS
    ;   player:
ONECOPYNORMAL       =   $00
TWOCOPIESCLOSE      =   $01
TWOCOPIESMED        =   $02
THREECOPIESCLOSE    =   $03
TWOCOPIESWIDE       =   $04
ONECOPYDOUBLE       =   $05
THREECOPIESMED      =   $06
ONECOPYQUAD     =   $07
    ;   missile:
SINGLEWIDTHMISSILE  =   $00
DOUBLEWIDTHMISSILE  =   $10
QUADWIDTHMISSILE    =   $20
OCTWIDTHMISSILE     =   $30

    ;---CTRLPF CONSTANTS
    ;   playfield:
REFLECTEDPF     =   %00000001
SCOREPF         =   %00000010
PRIORITYPF      =   %00000100
    ;   ball:
SINGLEWIDTHBALL     =   SINGLEWIDTHMISSILE
DOUBLEWIDTHBALL     =   DOUBLEWIDTHMISSILE
QUADWIDTHBALL       =   QUADWIDTHMISSILE
OCTWIDTHBALL        =   OCTWIDTHMISSILE

    ;---HMxx CONSTANTS
LEFTSEVEN       =   $70
LEFTSIX         =   $60
LEFTFIVE        =   $50
LEFTFOUR        =   $40
LEFTTHREE       =   $30
LEFTTWO         =   $20
LEFTONE         =   $10
NOMOVEMENT      =   $00
RIGHTONE        =   $F0
RIGHTTWO        =   $E0
RIGHTTHREE      =   $D0
RIGHTFOUR       =   $C0
RIGHTFIVE       =   $B0
RIGHTSIX        =   $A0
RIGHTSEVEN      =   $90
RIGHTEIGHT      =   $80

    ;---AUDCx CONSTANTS (P Slocum's naming convention)
SAWSOUND        =   1
ENGINESOUND     =   3
SQUARESOUND     =   4
BASSSOUND       =   6
PITFALLSOUND        =   7
NOISESOUND      =   8
LEADSOUND       =   12
BUZZSOUND       =   15

    ;---SWCHA CONSTANTS (JOYSTICK)
J0RIGHT     =   %10000000
J0LEFT      =   %01000000
J0DOWN      =   %00100000
J0UP        =   %00010000
J1RIGHT     =   %00001000
J1LEFT      =   %00000100
J1DOWN      =   %00000010
J1UP        =   %00000001

    ;---SWCHB CONSTANTS (CONSOLE SWITCHES)
P1DIFF      =   %10000000
P0DIFF      =   %01000000
BWCOLOR     =   %00001000
SELECT      =   %00000010
RESET       =   %00000001

;-------------------------End Constants-----------------------------------

;---Macros

    MAC FILLER
        REPEAT {1}
        .byte {2}
        REPEND
    ENDM
    


;--------Variables To Follow-------------

SongIndexC0 = $c4
SongIndexC1 = SongIndexC0+1
LengthVolumeC0 = SongIndexC1+1
LengthVolumeC1 = LengthVolumeC0+1
BeatLengthSong = LengthVolumeC1+1         ;song number is bottom 4 bits
SoundEffects = BeatLengthSong+1       ;this is completely unnecessary for the music driver, just use if you want.
MiscPtr = SoundEffects+1
Temp = MiscPtr+2                ;need 8 temp vars + 2 temp ptrs.  Maybe could consolidate down to 8, or maybe 6.
AUDVTemp = Temp+2
AUDCTemp = AUDVTemp
AUDFTemp = AUDCTemp+2
NoteData = AUDFTemp+2


;---End Variables

;    seg Bank0

;Start

;--Some Initial Setup

SetupElecMan
;    CLEAN_START
    ldx #var47-SongIndexC0
    lda #0
.clearvar1
    sta SongIndexC0,X
    dex
    bpl .clearvar1

    ldx #SONG_ELECMAN
    jmp NewSongSubroutine

;    jsr MusicSubroutine


;****************************************************************************

;----------------------------------------------------------------------------
;----------------------Begin Functions---------------------------------------
;----------------------------------------------------------------------------

;----------------------------------------------------------------------------

MusicSubroutine
    ;--play music constantly in channel 0 (unless music-off bit is set, then
    ;   set AUDV0 to zero constantly)
    ;--play music in channel 1 unless a sound effect is playing (same music-off bit stuff here)

    ;---music data format:
    ;byte: xxxxxxxx
    ;bits: 76543210
    ;   bit7    =   articulate bit (0=articulate, 1=slur)
    ;   bit6-5  =   note length bits.  %00=32nd, %01=16th, %10=8th, %11=quarter
    ;   bit4-0  =   note value.  index into lookup table (or something similar) - *not* an AUDxx value!
    ;
    ;special cases: 
    ;       note value of 31 (%xxx11111) is a rest (volume zero)
    ;       articulated 32nd notes (not possible with the music driver) indicate non-note codes:
    ;           %0000xxxx   =   new volume (bits3-0 is new volume)
    ;           %0001xxxx   =   new index (new index value in next byte)
    ;


    ldx #1              ;index into which channel
MusicLoop
    ;--first get song number into Y
    lda BeatLengthSong
    and #SONG_BITS
    tay
    lda #$FF
    sta Temp+1              ;new note flag
    ;--special case:
    cmp SongIndexC0,X       ;is song index #$FF?  Then get a new note immediately, song is just beginning:
    beq NewNote
    lda BeatLengthSong
    sec
    sbc #$10
    bmi BeatHasEnded
    ;--else beat has not ended
    sta BeatLengthSong
    bpl BeatHasNotEnded
BeatHasEnded
    ;--beat has ended
    lda BeatLengthSong
    and #<~(BEAT_BITS)
    ora TempoTable,Y
    sta BeatLengthSong
    lda LengthVolumeC0,X
    sec
    sbc #$10
    bmi NewNote
    ;--no new note, but need to read note to set AUDFx/AUDCx
    sta LengthVolumeC0,X        ;update note length
BeatHasNotEnded
    lda #0
    sta Temp+1                  ;reset new note flag
    .byte $2C                   ;skip next opcode
NewNote
    ;--note has ended, time for a new note!
    inc SongIndexC0,X           ;increment song index
    tya
    asl                         ;this will clear carry  - as long as SONG_BITS is not all 8 bits!
    sta Temp                    ;save song number * 2
    txa                         ;take channel
    adc Temp                    ;Song*2 + channel
    asl                         ;whole thing times two
    tay
    lda SongPtrTable,Y
    sta MiscPtr
    lda SongPtrTable+1,Y
    sta MiscPtr+1               ;now MiscPtr is pointing at correct song
    ldy SongIndexC0,X               ;Y holds note index
GetNewNote
    lda (MiscPtr),Y             ;<-new note
    ;--process new note
    and #%11100000              ;check for special case
    bne RegularNote
    ;--special case (volume change or index change)
    lda (MiscPtr),Y
    and #%00010000              ;which special case?
    beq NewVolume
    ;--else new index (in following byte)
    iny                         ;new index in following byte
    lda (MiscPtr),Y             ;get new index
    sta SongIndexC0,X           ;save new index
    tay                         ;put new index in Y
    jmp GetNewNote              ;and get the next note
NewVolume                       ;new volume is bottom four bits of special case byte
    lda LengthVolumeC0,X
    and #$F0                    ;save note length, clear volume
    ora (MiscPtr),Y             ;top four bits are clear if it is volume
    sta LengthVolumeC0,X
    inc SongIndexC0,X
    iny                         ;move index to new note
    jmp GetNewNote
RegularNote
NoChangeInNote
    lda (MiscPtr),Y             ;get note
    sta NoteData,X              ;save it
    and #%00011111              ;get note index
    tay
    lda AUDCTable,Y
    sta AUDCTemp,X
    lda AUDFTable,Y
    sta AUDFTemp,X              ;get and save new distortion# and frequency
    ;--only reset length if this is a new note!
    lda Temp+1                  ;new note flag
    beq NoChangeInNoteLength
    lda NoteData,X              ;get note data
    and #%01100000
    lsr
    lsr
    lsr
    lsr
    lsr
    tay                         ;get note length lookup into Y
    lda LengthVolumeC0,X        ;length part of this is zero already!
    ora LengthLookupTable,Y
    sta LengthVolumeC0,X
NoChangeInNoteLength
    dex
    bmi DoneWithMusicLoop
    jmp MusicLoop
DoneWithMusicLoop

    ldx #1
PlayMusicLoop
    txa
    beq NoInitialSFXCheck
    lda SoundEffects
    and #SFXCOUNTER_BITS
    bne SoundEffectPlayingDoNotTouchC1
NoInitialSFXCheck
    lda AUDFTemp,X
    sta AUDF0,X
    lda AUDCTemp,X
    sta AUDC0,X 
    cmp #RESTFLAG
    beq RestVolume
    ;--regular volume routine
    lda LengthVolumeC0,X
    and #$0F
    sta AUDVTemp,X
    lda NoteData,X
    and #SLUR_BIT
    bne NoArticulation
    ;--else articulate the note
    lda LengthVolumeC0,X
    lsr
    lsr
    lsr
    lsr
    tay             ;get length into Y
    lda AUDVTemp,X
    sec
    sbc ArticulationTable,Y
    bcs SetVolume
    lda #0              ;no negative volumes!
SetVolume
    sta AUDVTemp,X
NoArticulation
    ;--SFX?  If a sound effect is playing, we will only reach this point for C0
    lda SoundEffects
    and #SFXCOUNTER_BITS
    beq NoSoundEffectPlaying
    ;--sound effect is playing, cut volume in half
    lsr AUDVTemp,X
NoSoundEffectPlaying
    lda AUDVTemp,X
    .byte $2C
RestVolume
    lda #0
    sta AUDV0,X
SoundEffectPlayingDoNotTouchC1
    dex
    bpl PlayMusicLoop

    rts

;----------------------------------------------------------------------------

NewSongSubroutine
    ;--X holds new song number in high two bits (bits 6 and7)
    ;--first set song number in BeatLengthSong variable
    stx Temp
    lda BeatLengthSong
    and #<(~SONG_BITS)
    ora Temp
    sta BeatLengthSong
    ;--now reset all variables
    lda #$FF
    sta SongIndexC0
    sta SongIndexC1
    lda #0
    sta LengthVolumeC0
    sta LengthVolumeC1

    rts



;****************************************************************************


;----------------------------------------------------------------------------
;-------------------------Data Below-----------------------------------------
;----------------------------------------------------------------------------

SongPtrTable
    .word ElecManC0,ElecManC1,PreStageC0,PreStageC1




TempoTable
    .byte TEMPO150<<4,TEMPO150<<4,TEMPO112<<4


ArticulationTable
    .byte 6,1,0,0,0,0,0,0

LengthLookupTable
    .byte $00,$10,$30,$70

AUDFTable
    .byte 7,11,13,14,15,16,17,18    ;BEC#CBA#AG#
    .byte 19,20,22,23,24,26,27,29   ;GF#FED#DC#C
    .byte 31,11,14,15,16,17,18,19   ;BAFED#DC#C
    .byte 20,22,23,26,31,6,7,00 ;BA#AGE
AUDCTable
    .byte 4,4,4,4,4,4,4,4
    .byte 4,4,4,4,4,4,4,4
    .byte 4,12,12,12,12,12,12,12
    .byte 12,12,12,12,12,6,6,00

    ;--NOTE CONSTANTS
B6      =       0
E6      =       1
Cs6     =       2
C6      =       3
B5      =       4
As5     =       5
A5      =       6
Gs5     =       7
G5      =       8
Fs5     =       9
F5      =       10
E5      =       11
Ds5     =       12
D5      =       13
Cs5     =       14
C5      =       15
B4      =       16
A4      =       17
F4      =       18
E4      =       19
Ds4     =       20
D4      =       21
Cs4     =       22
C4      =       23
B3      =       24
As3     =       25
A3      =       26
G3      =       27
E3      =       28
D3      =       29
B2      =       30


REST    =       31

;--songs:

ElecManC0
    .byte SIXTEENTH|REST
    .byte VOLUMECHANGE|6

    .byte SLUR|SIXTEENTH|B4
    .byte SLUR|SIXTEENTH|Cs5
    .byte SLUR|SIXTEENTH|Ds5

ElecManRepeatC0
    .byte EIGHTH|E5
    .byte EIGHTH|REST
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte QUARTER|Gs5
    .byte SLUR|SIXTEENTH|B6
    .byte SLUR|SIXTEENTH|E6
    .byte SLUR|SIXTEENTH|B5
    .byte SLUR|SIXTEENTH|A5

    .byte QUARTER|E6
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte QUARTER|Gs5
    .byte SLUR|SIXTEENTH|B6
    .byte SLUR|SIXTEENTH|E6
    .byte SLUR|SIXTEENTH|B5
    .byte SLUR|SIXTEENTH|A5

    .byte QUARTER|Cs6
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|QUARTER|Fs5

    .byte SLUR|QUARTER|E5
    .byte SLUR|QUARTER|E5
    .byte SLUR|QUARTER|E5
    .byte QUARTER|E5

    .byte SLUR|QUARTER|E5
    .byte SLUR|EIGHTH|E5
    .byte SLUR|QUARTER|Ds5
    .byte SLUR|EIGHTH|Cs5
    .byte SLUR|EIGHTH|B4
    .byte EIGHTH|B5

    .byte QUARTER|REST
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte QUARTER|Gs5
    .byte SLUR|SIXTEENTH|B6
    .byte SLUR|SIXTEENTH|E6
    .byte SLUR|SIXTEENTH|B5
    .byte SLUR|SIXTEENTH|A5

    .byte QUARTER|E6
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte QUARTER|Gs5
    .byte SLUR|SIXTEENTH|B6
    .byte SLUR|SIXTEENTH|E6
    .byte SLUR|SIXTEENTH|B5
    .byte SLUR|SIXTEENTH|A5

    .byte QUARTER|Cs6
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Fs5
    .byte SLUR|EIGHTH|Fs5

    .byte SLUR|QUARTER|A5
    .byte SLUR|EIGHTH|A5
    .byte SLUR|EIGHTH|Gs5
    .byte SLUR|QUARTER|Gs5
    .byte SLUR|QUARTER|Fs5

    .byte SLUR|QUARTER|E5
    .byte SLUR|QUARTER|E5
    .byte SLUR|QUARTER|E5
    .byte QUARTER|E5

    .byte EIGHTH|REST
    .byte SLUR|EIGHTH|B4
    .byte EIGHTH|B5
    .byte EIGHTH|REST
    .byte QUARTER|REST
    .byte QUARTER|REST

    .byte VOLUMECHANGE|V3

    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5

    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5

    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5
    .byte EIGHTH|E5

    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5
    .byte EIGHTH|D5

    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5

    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5
    .byte EIGHTH|F5



    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5
    .byte EIGHTH|G5

    .byte VOLUMECHANGE|V6
    .byte SLUR|QUARTER|G5

    .byte SIXTEENTH|B5
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|REST
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|REST
    .byte SIXTEENTH|B5
    .byte SIXTEENTH|B5
    .byte EIGHTH|REST
    .byte QUARTER|REST




    .byte INDEXCHANGE,ElecManRepeatC0-ElecManC0

ElecManC1
    .byte SIXTEENTH|REST
    .byte VOLUMECHANGE|V5

    .byte SIXTEENTH|B3
    .byte SIXTEENTH|B3
    .byte SIXTEENTH|B3

ElecManRepeatC1
    .byte VOLUMECHANGE|V5
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|E4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|D4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|Cs4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|C4

    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|B3


    .byte VOLUMECHANGE|V7


    .byte SLUR|QUARTER|E3
    .byte SLUR|SIXTEENTH|E3
    .byte SLUR|THIRTYSECOND|E3
    .byte SLUR|THIRTYSECOND|D3
    .byte SLUR|THIRTYSECOND|E3
    .byte SLUR|THIRTYSECOND|G3
    .byte SLUR|THIRTYSECOND|A3
    .byte SLUR|THIRTYSECOND|As3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|QUARTER|E4
    .byte SLUR|EIGHTH|D4

    .byte SLUR|QUARTER|D4
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|Cs4
    .byte SLUR|EIGHTH|B3
    .byte SLUR|EIGHTH|A3

    .byte SLUR|QUARTER|B3
    .byte SLUR|EIGHTH|E3
    .byte SLUR|EIGHTH|A3
    .byte SLUR|EIGHTH|B3
    .byte SLUR|QUARTER|E4
    .byte SLUR|EIGHTH|D4

    .byte SLUR|QUARTER|D4
    .byte SLUR|QUARTER|D4
    .byte SLUR|QUARTER|D4
    .byte SLUR|QUARTER|D4

    .byte SLUR|QUARTER|D4
    .byte SLUR|THIRTYSECOND|D3
    .byte SLUR|THIRTYSECOND|E3
    .byte SLUR|THIRTYSECOND|G3
    .byte SLUR|THIRTYSECOND|A3
    .byte SLUR|THIRTYSECOND|As3
    .byte SLUR|THIRTYSECOND|B3
    .byte SLUR|THIRTYSECOND|C4
    .byte SLUR|THIRTYSECOND|Cs4
    .byte SLUR|EIGHTH|D4
    .byte SLUR|EIGHTH|B4
    .byte SLUR|QUARTER|B4

    .byte SLUR|QUARTER|A4
    .byte SLUR|EIGHTH|A4
    .byte SLUR|QUARTER|F4
    .byte SLUR|EIGHTH|F4
    .byte SLUR|QUARTER|D4

    .byte SLUR|QUARTER|Ds4
    .byte SLUR|EIGHTH|Ds4
    .byte SLUR|QUARTER|F4
    .byte SLUR|EIGHTH|F4
    .byte SLUR|QUARTER|Ds4

    .byte SIXTEENTH|E4
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|REST
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|REST
    .byte SIXTEENTH|E4
    .byte SIXTEENTH|E4
    .byte EIGHTH|REST
    .byte QUARTER|REST

    .byte INDEXCHANGE,ElecManRepeatC1-ElecManC1

PreStageC0
PreStageC1
    .byte QUARTER|REST
    .byte INDEXCHANGE,0



