# megaman2600
Mega Man for the Atari 2600

Written in Batari and 6502 assembler

OK, now here is the source for those who would like to play with it, add more levels, 
program some more enemies or just use it for your own creations / inspiration or answer some questions.

Contents:

build.bat -> builds the game

collision.s bcollision.s and ecollision.s -> three copies of the same subroutine for different banks.

The 'e' version is for ElecMan
The collision subroutine checkPos (and variants) checks the playfield data directly for collision versus an x,y position

mmm.s : Music player source and song data
logo.s : Title screen code and art
header.bas : variable declarations including how to use Super Chip RAM (at least the way I did it anyway)
mm.bas : The game - you might notice that I drop into ASM in a few places because I was working around a compiler bug
                    or I just thought I could do it better or it's easier for me or executes faster in ASM.
