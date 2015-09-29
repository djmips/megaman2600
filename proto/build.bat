IF DEFINED bB goto build
set bB=d:\dev\6502\2600\BB
path %path%;d:\dev\6502\2600\BB
:build
copy prolog.bas+header.bas+mm.bas megaman.bas
2600bas megaman.bas
