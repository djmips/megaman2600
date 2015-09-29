 set smartbranching on
 set romsize 32kSC
 set optimization speed
 rem set kernel_options pfheights

 rem set debug cyclescore
 
 rem Don't Display a Score
 rem const noscore = 1
 
 rem
 rem
 rem
 rem
 rem
 rem

 rem const pfres=24

 rem 
 rem ---------------- Variables 
 rem 
 rem 
 rem 
 rem 
 rem 
 
 dim ii = temp1
 dim jj = temp2
 dim kk = temp3
 
 dim mtick = a
 
 rem MegaMan vars
 dim tick = b
 dim jumping = c
 dim falling = d
 dim xpos = e.f
 dim xposH = e
 dim ypos = g.h
 dim yposH = g
 dim temp = i.j
 dim velocity = k.l
 dim animFrame  = m
 dim facing = n
 dim pcollision = o
 dim tempi0 = p.q
 dim tempi1 = r.s
 dim jsamp = t
 dim oxmove = u
 dim dcount = v
 dim acount = w
 dim xvel = x.y
 
 dim xoff = var0
 dim yoff = var1
 
 dim xmove = var2
 
 dim blink = var3
 dim bcnt = var4
 

 dim prevX = var5
 dim prevY = var6
 
 rem Collision variables
 dim colX = var7
 dim colY = var8
 
 dim colResult = var9
 
 dim iAmHitCtr = var10
 dim iAmInvincibleCtr = var11

 dim health = var12
 
 rem Shot variables
 
 dim shootDelay = var13
 dim shootI = var14
 
 dim cscreen = var15
 dim nscreen = var16
 dim scrollmode = var17
 dim scrollCount = var18
 dim scrollSmoothCount = var19
 
 dim nscrnptr = var20
 dim nscrnptrH = var21
 dim nlineScroll = var22

 rem BOSS vars Overlaps 
 
 dim Etick = var15
 dim Ejumping = var16
 dim Efalling = var17
 dim Expos = var18.var19
 dim ExposH = var18
 dim Eypos = var20.var21
 dim EyposH = var20
 dim Evelocity = var22.var23
 dim EanimFrame  = var24
 dim Efacing = var25
 dim Ejsamp = var26
 dim EAIfreq = var27
 dim Edcount = var28
 dim Eacount = var29
 dim Exvel = var30.var31

 rem var32 - var47 is used by the music driver

 dim EAInextUp = var32 

 dim EprevX = var33
 dim EprevY = var34
 
 dim Ejoy0left = var35
 dim Ejoy0right = var36
 dim Ejoy0fire = var37
 
 dim EwaitJump = var38
 
 dim EIsHitCtr = var39
 
 dim Ehealth = var40
 
 dim Eatick = var41
 
 dim boltPtr = var42
 dim boltPtrH = var43
 
 dim EposeCtr = var44
 
 dim EshotActive = var45
 
 dim EAskForShotCtr = var46
 
 dim ENextShot = var47

 rem var is last available

 rem Main Shot vars in Super Chip RAM (0 - 79 available)
 dim shotVelW           = $1000
 dim shotVelR           = shotVelW + 128
 dim shotXW             = shotVelW + 3
 dim shotXR             = shotXW + 128
 dim shotYW             = shotXW + 3
 dim shotYR             = shotYW + 128

 rem Enemy vars
 dim enemyXW            = shotYW + 3
 dim enemyXR            = enemyXW + 128
 dim enemyX0W           = enemyXW
 dim enemyX0R           = enemyXR
 dim enemyX1W           = enemyXW + 1
 dim enemyX1R           = enemyXR + 1

 dim enemyYW            = enemyXW + 2
 dim enemyYR            = enemyYW + 128
 dim enemyY0W           = enemyYW
 dim enemyY0R           = enemyYR
 dim enemyY1W           = enemyYW + 1
 dim enemyY1R           = enemyYR + 1

 dim enemyVelW          = enemyYW + 2
 dim enemyVelR          = enemyVelW + 128
 
 dim enemyLXboundW      = enemyVelW + 2
 dim enemyLXboundR      = enemyLXboundW + 128

 dim enemyRXboundW      = enemyLXboundW + 2
 dim enemyRXboundR      = enemyRXboundW + 128

 dim enemyFreezeCtrW   = enemyRXboundW + 2
 dim enemyFreezeCtrR   = enemyFreezeCtrW + 128
 dim enemyFreezeCtr0W  = enemyFreezeCtrW
 dim enemyFreezeCtr0R  = enemyFreezeCtrR
 dim enemyFreezeCtr1W  = enemyFreezeCtrW + 1
 dim enemyFreezeCtr1R  = enemyFreezeCtrR + 1
 
 
 rem ---------------- Game code start


 rem
 rem Main game code

GameStart

 COLUPF = $00
 AUDV0 = 0
 AUDV1 = 0
 CTRLPF = $21

 gosub Title bank3          rem call title screen

 gosub ClearPF              rem clear playfield

 gosub MusicInit bank2      rem init music driver
 
 
 rem ---------------- Initialize variables

 health = 100

 ballx = 0
 ballheight = 2
 missile0height = 3
 missile1height = 3
 
 rem was 13
 velocity = 0.0 : falling = 1 : animFrame = 0 : tick = 0 : facing = 1

 COLUBK = $0 : COLUPF = $27 : xpos = 68.0 : ypos = 12.0
 prevX = xposH
 prevY = yposH

 rem pfvline 0 1 11 on
 rem pfvline 30 1 11 on
 rem pfhline 22 3 30 on
 rem pfhline 1 5 10 on
 rem pfhline 18 7 30 on
 rem pfhline 0 10 30 on


 goto PFscreen0       
 
 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 XXXXXXXXXXXXX..................X
 X.XX..XX...XX..................X
 X.XX..XX...XX..................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end 
 playfield:
 XXXXXXXXXXXXX.....XXXXXXXXXXXXXX
 X..............................X
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXX.........X
 X..............................X
 X..............................X
 X...XXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X...X........,,................X
 X...X.......,,,................X
 X...X..........................X
 X.XXX...XXXXXXXXXXXXXXXXXXXXX..X
end
 playfield:
 X.......XX.....................X
 X.......XX.....................X
 XXXXXXXXXX........XXXXXXXXXXXXXX
 X..............................X
 X..............................X
 X..............................X
 X.....XXXXXXX..................X
 X.....XX.......XXXXXXXXXXXXXXXXX
 X.....XX.......................X
 X.....XX.......................X
 X..XXXXX.......XX..XXX.........X
end
 playfield:
 X..............XX..............X
 X..............XX..............X
 XXXXXX.........XXXXXXXX........X
 X.....XXXXX........,,XX........X
 X....................XX........X
 X...............XXX.,XXXXXXX...X
 X...............X..............X
 X...............X..............X
 X...............X..............X
 X....XXXXXX.....XXXXXXXXXXXXXXXX
 X..XXXX........................X
end
PFscreen0
 playfield:
 X..............................X
 X..............................X
 XXXXXXXXXXX....................X
 X..............................X
 X..................XXXXXXXXXXXXX
 X..............................X
 X..............................X
 XXXXXXXXXXXX...................X
 X..............................X
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end


 pfhline 0 11 31 off 

 velocity = 0.0
 jumping = 0
 jsamp = 0
 xoff = 0
 yoff = 0

 acount = 0
 dcount = 0
 
 xmove = 0
 
 bcnt = 0
 blink = 0

 shotXW[0] = 250
 shotXW[1] = 250
 shotXW[2] = 250
  
 shootI = 0
 shootDelay = 0
 
 cscreen = 0
 
 
 iAmHitCtr = 0
 iAmInvincibleCtr = 0
 
 
 scorecolor = 26
 score = 111111
 
 scrollmode = 0

 gosub InitScreen0 bank4
 
 rem ---------------- ---------------- ---------------- ---------------- 
 rem ---------------- ---------------- ---------------- ---------------- 

MainLoop

 NUSIZ0=$30
 NUSIZ1=$30

 rem ---------------- Udpdate Music
 
 if switchreset then GameStart
 
 gosub MusicUpdate bank2

 COLUP0 = $95 : COLUP1 = $95


 if !scrollmode then NormalUpdate

 gosub Scrolling 

 goto Draw
 
NormalUpdate


 on cscreen goto ScrollCheck0 ScrollCheck1 ScrollCheck2 ScrollCheck3 ScrollCheck4

DoneScrollCheck

 if scrollmode then Draw


 gosub UpdateMegaMan

 goto UpdateEnemies
DoneEnemies

Draw
 drawscreen 
 
 mtick = mtick + 1
 
 goto MainLoop


 rem ---------------- ---------------- ---------------- ---------------- 
 rem ---------------- ---------------- ---------------- ---------------- 
 
 rem ----------------------------------------------------------------------------------------

ScrollCheck0
 if ypos < 3 && xpos < 30 then  gosub InitScreen0toScreen1 bank4
 goto DoneScrollCheck

ScrollCheck1
 if ypos > 90 && ypos < 180 then  gosub InitScreen1toScreen0 bank4
 if ypos > 2 then s1cb
 if xpos > 80  || xpos < 22 then  gosub InitScreen1toScreen2 bank4
s1cb 
 goto DoneScrollCheck

ScrollCheck2
 if ypos > 90 && ypos < 180 then  gosub InitScreen2toScreen1 bank4
 if ypos < 3 && xpos > 120 then  gosub InitScreen2toScreen3 bank4
 if ypos < 3 && xpos < 22 then  gosub InitScreen2toScreen3 bank4
 goto DoneScrollCheck

ScrollCheck3
 if ypos > 90 && ypos < 180 then  gosub InitScreen3toScreen2 bank4
 if ypos < 3 then  gosub InitScreen3toScreen4 bank4
 goto DoneScrollCheck

ScrollCheck4
  goto BossStart bank6

 rem ---------------- Udpdate Enemies
 
UpdateEnemies

 ii = mtick & 1
 if ii then on cscreen goto UpdateRobots UE_None UpdateRobots UpdateRobots UE_None
 goto DoneEnemies

UpdateRobots
 for ii = 0 to 1

 if enemyFreezeCtrR[ii] then enemyFreezeCtrW[ii] = enemyFreezeCtrR[ii] - 1 : goto goodEnemyX

 kk = enemyYR[ii] - ypos

 enemyXW[ii] = enemyXR[ii] + enemyVelR[ii]
 if kk < 16 then enemyXW[ii] = enemyXR[ii] + enemyVelR[ii]
 
 if enemyXR[ii] < enemyLXboundR[ii] then badEnemyX

 if enemyXR[ii] < enemyRXboundR[ii] then goodEnemyX

badEnemyX 
 enemyVelW[ii] = 0 - enemyVelR[ii]
 enemyXW[ii] = enemyXR[ii] + enemyVelR[ii]
 if kk < 16 then enemyXW[ii] = enemyXR[ii] + enemyVelR[ii]

goodEnemyX

 next
  
 missile0x = enemyX0R
 missile0y = enemyY0R
 
 missile1x = enemyX1R
 missile1y = enemyY1R

UE_None

 goto DoneEnemies

 rem ---------------- Udpdate MegaMan


UpdateMegaMan

 if falling then velocity = velocity + 0.16 else velocity = 0.0
 
 rem need to cap falling speed
 asm
 lda velocity
 bmi .addVelocity
end 
 if velocity > 8 then velocity = 8.0
 
addVelocity
 ypos = ypos + velocity 


 rem update xpos based on joystick
 oxmove = xmove
 
 if jumping then xvel = 0.9375 else xvel = 1.0
 rem if jumping then xvel = 1.5 else xvel = 1.6

 rem xmove = joy0left || joy0right
 asm
 lda SWCHA
 and #($40 + $80)
 eor #($40 + $80)
 sta xmove
end 


 rem if joy0up then ypos = ypos - 1.0
 rem if joy0down then ypos = ypos + 1.0


 rem *** check starting to move
 if !falling && !oxmove && xmove then acount = 9

 if !acount then fullSpeedX

 if iAmHitCtr > 10 then skipControl1
 if joy0left then xpos = xpos - 0.2 : tick = tick + 1 : facing = 0 : dcount = 0
 if joy0right then xpos = xpos + 0.2 : tick = tick + 1 : facing = 1 : dcount = 0

skipControl1

 acount = acount - 1
 
 goto checkDecel

fullSpeedX
 if iAmHitCtr > 10 then skipControl2
 if joy0left then xpos = xpos - xvel : tick = tick + 1 : facing = 0 : dcount = 10
 if joy0right then xpos = xpos + xvel : tick = tick + 1 : facing = 1 : dcount = 10
 goto checkDecel
 
skipControl2
 if iAmHitCtr < 20 then checkDecel
 if facing = 0 then xpos = xpos + 0.4
 if facing = 1 then xpos = xpos - 0.4


checkDecel
 rem *** logic to do deceleration
 if falling then dcount = 0

 if xmove || !dcount then floorcheck
 
 if facing then xpos = xpos + 0.8 else xpos = xpos - 0.4

 dcount = dcount - 1
 
 rem *** logic to check against bottom of screen and left/right walls
 
floorcheck

 rem if ypos >= 80 then ypos = 80.0 : velocity = 0.0: falling = 0

 rem left/right wall checks
 if xposH >= 128 then xposH = 128
 if xposH <= 18 then xposH = 18

 rem *** logic to check jumping
 
notcheck
 if jumping && !joy0fire then stopJumping

 if !joy0fire && !falling then jsamp = 1
 
 if !jumping && joy0fire && !falling && jsamp then falling = 1 : jumping = 1 : jsamp = 0 : velocity = -3.1
 
 goto doneStopJump

stopJumping

 jumping = 0
 
 tempi0 = -0.5

 asm
 
 ; if velocity < -0.5

 lda velocity
 bpl .doneStopJump

 sec
 lda tempi0+1
 sbc velocity+1
 lda tempi0
 sbc velocity
 bcc .doneStopJump

 ;.byte 02
 
end

 velocity = tempi0

doneStopJump


 rem *** SW collision checks
 rem collision xpos = sprite xpos - 16 

 if yposH <> prevY then moveChecks

 colX = xposH - 12
 colY = yposH
 gosub CheckPos 
 
 if colResult then doneYChecks

 colX = xposH - 7
 colY = yposH
 gosub CheckPos 

 if !colResult then falling = 1
 goto doneYChecks

moveChecks
 
 asm
 lda yposH
 bpl .moreChecks
 jmp .EndChecks
end
moreChecks

 if yposH > prevY then FootCheck

 rem Head check 
 rem 
 if yposH < 20 then doneYChecks
 colX = xposH - 12
 colY = yposH - 20
 gosub CheckPos 

 if !colResult then colX = xposH - 7 : gosub CheckPos
 
 if colResult then velocity = 0.0
 
 goto doneYChecks
 
FootCheck

 colX = xposH - 12
 colY = yposH
 gosub CheckPos 
 if colResult then stopOnPlatform

 colX = xposH - 7
 colY = yposH
 gosub CheckPos 
 if !colResult then doneYChecks

stopOnPlatform

 velocity = 0.0 : falling = 0 : yposH = yposH & %11111000 

doneYChecks

 if yposH < 5 then EndChecks
 
 if xposH = prevX then EndChecks

 if xposH > prevX then RightCheck 

 rem *** LeftCheck
 colX = xposH - 16
 colY = yposH - 5
 gosub CheckPos 
 
 if !colResult && yposH > 12 then colY = yposH - 13 :  gosub CheckPos

 rem YELLOW
 if colResult then xposH = xposH + 3 : xposH = xposH & %11111100

 goto EndChecks

 
RightCheck 

 colX = xposH - 4
 colY = yposH - 5
 gosub CheckPos 

 if !colResult && yposH > 12 then colY = yposH - 13 :  gosub CheckPos

 if colResult then xposH = xposH : xposH = xposH & %11111100

EndChecks

 prevX = xposH
 prevY = yposH

 rem *** animation frames 
 if tick > 6 then tick = 0 : animFrame = animFrame + 1 
 if animFrame > 5 then animFrame = 2
 
 if !xmove && !acount then animFrame = 0
 
 rem still animation when falling
 if falling = 1 then animFrame = 6
 
 rem do blink logic
 if blink then blinkTimer
 if xmove || jumping then bcnt = 0 else bcnt = bcnt + 1
 if bcnt > 89 then blink = 1 : bcnt = 10
 goto doneBlink
blinkTimer
 bcnt = bcnt - 1
 if bcnt then doneBlink
 blink = 0
doneBlink

 jj = 0
 kk = 250
 
 rem *** Update and display shots

 asm 
   .if 1
   
    ldx #2
 
.upddshot 
    lda shotXR,X
    cmp #250
    beq .nxtShot

    ; rem shot is active so update shot movement
 
    clc
    adc shotVelR,x
    sta shotXW,x
    cmp #3
    bcc .retireS
    cmp #156
    bcc .nxtShot

.retireS 
    ; deactivate shot
    lda #250
    sta shotXW,x
    bne .nxtShot

.nxtShot

    dex
    bpl  .upddshot
    
    .endif
end

 kk = shootI

 ballx = 0
 bally = 0
 
 if shotXR[kk] = 250 then noDisplay

 ballx = shotXR[kk]
 bally = shotYR[kk]

noDisplay
 
 shootI = shootI + 1
 if shootI = 3 then shootI = 0
 
 rem *** check shooting
 
 if shootDelay then shootDelay = shootDelay - 1 


 rem *** check shot enemy collision
 
 if collision(missile0,ball) then enemyFreezeCtr0W = 100
 if collision(missile1,ball) then enemyFreezeCtr1W = 100
 
 if iAmInvincibleCtr then iAmInvincibleCtr = iAmInvincibleCtr - 1 : goto noEnemyHit
 rem *** check player enemy collision
 jj = 1
 if collision(player0,missile0) then jj=0
 if collision(player0,missile1) then jj=0
 if collision(player1,missile0) then jj=0
 if collision(player1,missile1) then jj=0

 if jj then noEnemyHit
 iAmHitCtr = 22
 iAmInvincibleCtr = 111

 if health <= 20 then MMisDead 
 health = health - 20 : gosub UpdateHealth
 goto noEnemyHit
 
MMisDead
 health = 0 : gosub UpdateHealth
 enemyX0W = xposH+4
 enemyY0W = yposH-4
 goto Explosion bank7
 
noEnemyHit

 ii = mtick & 7

 if !iAmHitCtr then notHitted
 
 iAmHitCtr = iAmHitCtr - 1
 on ii goto MMblank MMhitFlash MMblank MMhit MMblank MMhit MMblank MMhit
 

notHitted
 if shootDelay then nAnim
   
 if joy0down goto Shoot

nAnim

 if shootDelay > 6 then ShootAnim

 ii = mtick & 2
 if iAmInvincibleCtr && ii then MMblank

 on animFrame goto MMstand0 MMstand1 MMrun1 MMrun2 MMrun3 MMrun2 MMfall

Shoot

 asm
 ;.if 0
 nop
 nop
 nop
 nop
end

 for ii = 0 to 2
 
 if shotXR[ii] <> 250 then ShotUsed

 rem 31 frames before MM can shoot again
 shootDelay = 13

 rem check right
 if facing then shotXW[ii] = xposH + 17 : shotYW[ii] = yposH - 8 : shotVelW[ii] = 2

 rem check left
 if !facing then shotXW[ii] = xposH - 3 : shotYW[ii] = yposH - 8 : shotVelW[ii] = 0-2  

 goto FoundShot

ShotUsed

 next

FoundShot
  
 asm
 ;.endif
end

ShootAnim

 ii = mtick & 2
 if iAmInvincibleCtr && ii then MMblank

 on animFrame goto MMstandS MMstandS MMrunS1 MMrunS2 MMrunS3 MMrunS2 MMfallS

MMstand0
 xoff = 0
 yoff = 0

 if blink then MMStandBlink
 
 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %01111100
 %01111000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255
 
MMStandBlink
 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001000
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %01111100
 %01111000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %11100000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255

MMstand1
 xoff = 0
 yoff = 0
 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %11111000
 %11110000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255

MMstandS
 xoff = 0-1
 yoff = 0
 player0:
 %11111000
 %01111000
 %00011101
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %11111000
 %11110000
 %11000000
 %11000000
 %11000000
 %11000000
 %00100000
 %11001110
 %00101111
 %11101110
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255

MMrun1
 xoff = 1
 yoff = 0
 player0:
 %00000011
 %00000001
 %00011001
 %01111011
 %01110111
 %00101111
 %00001110
 %01001101
 %01101101
 %00111011
 %00010101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %11100000
 %10000000
 %11000000
 %11000000
 %10000000
 %00000000
 %11101100
 %00001110
 %11110010
 %10100110
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto 255

MMrun2
 xoff = 1
 yoff = 0
 player0:
 %00000111
 %00000100
 %00000111
 %00000011
 %00000001
 %00000010
 %00001110
 %00001100
 %00011010
 %00011101
 %00001101
 %00000011
 %00000101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %11010000
 %00000000
 %11100000
 %00000000
 %11110000
 %10100000
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto 255

MMrun3
 xoff = 1
 yoff = 0
 player0:
 %00000000
 %00000000
 %00011000
 %11111111
 %01110111
 %00000110
 %00110011
 %00110011
 %00011101
 %00001011
 %00000101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %11110000
 %11000000
 %11100000
 %11000000
 %00000000
 %11111000
 %10011000
 %00000000
 %11110000
 %10100000
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto 255

MMrunS1
 xoff = 0
 yoff = 0
 player0:
 %00000111
 %00000011
 %00110011
 %11110111
 %11101111
 %01011110
 %00011101
 %10011010
 %11011011
 %01110111
 %00101011
 %00001100
 %00000111
 %00000010
 %00000000
 %00000000
end
 player1:
 %11000000
 %00000000
 %10000000
 %10000000
 %00000000
 %00000000
 %11000000
 %00001110
 %11101111
 %01001110
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
 %00000000
end
 goto 255

MMrunS2
 xoff = (0-2)
 yoff = 0
 player0:
 %00111000
 %00100000
 %00111000
 %00011000
 %00001000
 %00010000
 %01110110
 %01100000
 %11010111
 %11101000
 %01101111
 %00011101
 %00101101
 %00110000
 %00011101
 %00001001
 %00000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000000
 %00000000
 %00000000
 %00111000
 %10111100
 %00111000
 %00000000
 %00000000
 %10000000
 %00000000
 %00000000
 %00000000
end
 goto 255

MMrunS3
 xoff = 0
 yoff = 0
 player0:
 %00000001
 %00000001
 %00110001
 %11111111
 %11101110
 %00001101
 %00000111
 %00000110
 %00000011
 %00000111
 %00001011
 %00001100
 %00000111
 %00000010
 %00000000
 %00000000
end
 player1:
 %11100000
 %10000000
 %11000000
 %10000000
 %00000000
 %11110000
 %00110000
 %00001110
 %11101111
 %01001110
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
 %00000000
end
 goto 255

MMfall
 xoff = 1
 yoff = 1
 player0:
 %00000001
 %00000001
 %00000001
 %00000001
 %00000011
 %00000011
 %00000011
 %00000011
 %00000011
 %00000011
 %00000010
 %00000011
 %00000101
 %00000101
 %00001101
 %00011101
 %00110110
 %01100011
 %00100001
 %00000000
end
 player1:
 %10000000
 %10000000
 %10000000
 %10000000
 %00000110
 %00001110
 %10011100
 %11111100
 %11111000
 %00000000
 %11100000
 %00000000
 %00000000
 %11110000
 %10100000
 %10100100
 %00000010
 %10110011
 %00100010
 %01000000
end
 goto 255
 
MMfallS
 xoff = 0
 yoff = 1
 player0:
 %00000011
 %00000011
 %00000011
 %00000011
 %00000110
 %00000110
 %00000111
 %00000111
 %00000111
 %00000110
 %00000101
 %00000110
 %00001010
 %00001011
 %00011011
 %00111011
 %01101100
 %11000111
 %01000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00001100
 %00011100
 %00111000
 %11111000
 %11110000
 %00000000
 %11001110
 %00001111
 %00001110
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255

MMhit
 xoff = 0
 yoff = 1
 player0:
 %00000000
 %00000110
 %00000111
 %00000011
 %00000111
 %00000110
 %00000111
 %00000111
 %00000111
 %11000110
 %11000101
 %01100110
 %00111010
 %00001011
 %00001010
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %10000000
 %00011110
 %00011100
 %00111000
 %11111000
 %11110000
 %00000011
 %11000011
 %00000110
 %00001100
 %11100000
 %01000000
 %11100000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto 255

MMhitFlash

 COLUP0 = $0e : COLUP1 = $0e

 xoff = 0
 yoff = 1
 player0:
 %00000000
 %00001000
 %00001100
 %00011100
 %11011110
 %11111111
 %01111111
 %00111111
 %00111111
 %01111111
 %11111111
 %11111111
 %01111111
 %00111111
 %01111111
 %11111111
 %11001111
 %00001111
 %00011100
 %00010000
end
 player1:
 %00000000
 %00010000
 %00111000
 %01111001
 %11111110
 %11111100
 %11111000
 %11111100
 %11111110
 %11111111
 %11111100
 %11111000
 %11111100
 %11111110
 %11111000
 %11111110
 %11111111
 %01110100
 %00110010
 %00011000
end
 goto 255

MMblank

 xoff = 0
 yoff = 0
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 goto 255

255 rem done setting up sprites


PositionMegaMan

 if facing then faceright

 REFP0 = 8 : REFP1 = 8
 player1x = xpos + xoff
 player0x = player1x + 8
 player1y = ypos + yoff
 player0y = player1y 

 goto DoneAnim
 
faceright

 REFP0 = 0 : REFP1 = 0
 player0x = xpos - xoff
 player1x = player0x + 8
 player0y = ypos + yoff
 player1y = player0y

 rem set frame based on animation

DoneAnim

 return
 

 rem ---------------- Scroll subroutine

Scrolling


 if scrollmode = 1 then scrollUp
 
scrollDown

 rem draw in new line in line 11
 
 if scrollSmoothCount <> 4 then noFillDn
 
 scrollCount = scrollCount - 1

 if scrollCount then stillScrollingDn
 
 scrollmode = 0
 cscreen = nscreen
 yposH = 80
 pfhline 0 11 31 off 
 goto doneScroll

stillScrollingDn

 
 nlineScroll = nlineScroll - 4
 
 asm
line11 = $107C
 ldy nlineScroll
 ldx #0
.copyNLineDn
 lda (nscrnptr),y
 sta line11,x
 iny
 inx
 cpx #4
 bcc .copyNLineDn
end

noFillDn

 pfscroll   down
 pfscroll   down
 
 scrollSmoothCount = scrollSmoothCount - 1
 
 if !scrollSmoothCount then scrollSmoothCount = 4
 
 ypos = ypos + 2.0
 
 goto doneScroll
 
 rem --------------------
scrollUp 

 if scrollSmoothCount <> 4 then noFill
 
 scrollCount = scrollCount - 1

 if scrollCount then stillScrollingUp
 
 scrollmode = 0
 cscreen = nscreen
 pfhline 0 11 31 off 
 goto doneScroll

stillScrollingUp

 
 nlineScroll = nlineScroll + 4
 
 asm
line11 = $107C
 ldy nlineScroll
 ldx #0
.copyNLineUp
 lda (nscrnptr),y
 sta line11,x
 iny
 inx
 cpx #4
 bcc .copyNLineUp
end

noFill

 pfscroll   up
 pfscroll   up
 
 scrollSmoothCount = scrollSmoothCount - 1
 
 if !scrollSmoothCount then scrollSmoothCount = 4
 
 ypos = ypos - 2.0

doneScroll

 gosub PositionMegaMan

 return


 rem ---------------- Collision subroutine

 asm
 include Collision.s
end 

UpdateAndDisplayShots

return

 rem ---------------- Clear the Super Chip Playfield RAM

ClearPF

 asm
    ldx #$7F
    lda #0
    
clrPlayFieldSC
    sta $F000,x
    dex 
    bpl clrPlayFieldSC
 
    ; set pf
    lda #$21
    sta CTRLPF
 
end
 return

 rem ---------------- Update Health

UpdateHealth
 if health < 17 then score = 100000 : goto donehealth
 if health < 33 then score = 110000 : goto donehealth
 if health < 50 then score = 111000 : goto donehealth
 if health < 67 then score = 111100 : goto donehealth
 if health < 83 then score = 111110 : goto donehealth
 score = 111111
 
donehealth
 return
 
 rem --------------------------- B A N K --- 2 -------------------------------------------------

 rem ----------------
 rem ----------------

 bank 2

MusicInit
 asm
 jsr SetupElecMan
end
 return otherbank

MusicUpdate
 asm
 jsr MusicSubroutine
end 

 return otherbank

 asm
 include mmm.s
end 

 rem --------------------------- B A N K --- 3 ------------------------------------------------- 
 rem ----------------
 rem ---------------- 
 
 bank 3

Title
 asm
 lda playfieldpos
 pha
 jsr LOGOS
 pla
 sta playfieldpos
end 
 return otherbank
 
 asm
 include logo.s
end 

 rem --------------------------- B A N K --- 4 -------------------------------------------------
 rem ----------------
 rem ----------------
 
 bank 4
 
 rem ---------------- Init 0

InitScreen0
 enemyX0W = 20
 enemyY0W = 56
 enemyVelW[0] = 1
 enemyLXboundW[0] = 20
 enemyRXboundW[0] = 58
 enemyFreezeCtr0W = 0

 enemyX1W = 100
 enemyY1W = 32
 enemyVelW[1] = 0 - 1
 enemyLXboundW[1] = 94
 enemyRXboundW[1] = 138
 enemyFreezeCtr1W = 0
 goto InitScreens

 rem ---------------- Init 1 2 3 4

InitScreen2
 enemyX0W = 0
 enemyY0W = 0
 enemyVelW[0] = 1
 enemyLXboundW[0] = 22
 enemyRXboundW[0] = 106
 enemyFreezeCtr0W = 0

 enemyX1W = 120
 enemyY1W = 56
 enemyVelW[1] = 0 - 1
 enemyLXboundW[1] = 78
 enemyRXboundW[1] = 138
 enemyFreezeCtr1W = 0
 goto InitScreens


InitScreen3
 enemyX0W = 28
 enemyY0W = 24
 enemyVelW[0] = 1
 enemyLXboundW[0] = 22
 enemyRXboundW[0] = 102
 enemyFreezeCtr0W = 0

 enemyX1W = 100
 enemyY1W = 48
 enemyVelW[1] = 0 - 1
 enemyLXboundW[1] = 34
 enemyRXboundW[1] = 138
 enemyFreezeCtr1W = 0
 
InitScreens 
InitScreen1
InitScreen4
 missile0x = 0
 missile0y = 0
 missile1x = 0
 missile1y = 0
 return otherbank


 rem ---------------- 0->1
 
InitScreen0toScreen1

 scrollmode = 2
 nscreen = 1
 scrollCount = 12
 scrollSmoothCount = 4
 
 nlineScroll = 44
 
 asm
 lda #<PF_data3
 sta nscrnptr
 lda #>PF_data3
 sta nscrnptr+1
end

 goto InitScreen1


 rem ---------------- 1->0
 
InitScreen1toScreen0

 scrollmode = 1
 nscreen = 0
 scrollCount = 12
 scrollSmoothCount = 4
 
 nlineScroll = 0-4
 
 asm
 lda #<PF_data4
 sta nscrnptr
 lda #>PF_data4
 sta nscrnptr+1
end

 goto InitScreen0


 rem return
 
 rem ---------------- 1->2

InitScreen1toScreen2

 scrollmode = 2
 nscreen = 2
 scrollCount = 12
 scrollSmoothCount = 4
 nlineScroll = 44
 
 asm
 lda #<PF_data2
 sta nscrnptr
 lda #>PF_data2
 sta nscrnptr+1
end
 
 goto InitScreen2

 rem ---------------- 2->1

InitScreen2toScreen1

 scrollmode = 1
 nscreen = 1
 scrollCount = 12
 scrollSmoothCount = 4
 nlineScroll = 0-4
 
 asm
 lda #<PF_data3
 sta nscrnptr
 lda #>PF_data3
 sta nscrnptr+1
end
 
 goto InitScreen1


 rem ---------------- 2->3

InitScreen2toScreen3

 scrollmode = 2
 nscreen = 3
 scrollCount = 12
 scrollSmoothCount = 4
 nlineScroll = 44
 
 asm
 lda #<PF_data1
 sta nscrnptr
 lda #>PF_data1
 sta nscrnptr+1
end
 
 goto InitScreen3

 rem ---------------- 3->2

InitScreen3toScreen2

 scrollmode = 1
 nscreen = 2
 scrollCount = 12
 scrollSmoothCount = 4
 nlineScroll = 0-4
 
 asm
 lda #<PF_data2
 sta nscrnptr
 lda #>PF_data2
 sta nscrnptr+1
end
 
 goto InitScreen2

 rem ---------------- 3->4

InitScreen3toScreen4

 scrollmode = 2
 nscreen = 4
 scrollCount = 12
 scrollSmoothCount = 4
 nlineScroll = 44

 asm
 lda #<PF_data0
 sta nscrnptr
 lda #>PF_data0
 sta nscrnptr+1
end
 goto InitScreen4

InitScreen4toScreen3
 goto InitScreen3

 bank 5
 
Nothing5
 mtick = mtick + 1
 return
 
 bank 6
 
BossStart

 COLUPF = $00
 AUDV0 = 0
 AUDV1 = 0
 CTRLPF = $21
 
 rem gosub ClearPF bank1  rem clear playfield
 
 rem ---------------- Initialize variables

 health = 100
 Ehealth = 100

 ballx = 0
 ballheight = 2
 missile0height = 3
 missile1height = 3
 missile0x = 0
 missile0y = 0
 missile1x = 0
 missile1y = 0
 COLUBK = $0 : COLUPF = $27
 
 velocity = 0.0 : falling = 1 : animFrame = 0 : tick = 0 : facing = 1
 prevX = xposH
 prevY = yposH
 jumping = 0
 jsamp = 0
 acount = 0
 dcount = 0
 xmove = 0
 bcnt = 0
 blink = 0
 shootI = 0
 shootDelay = 0
 iAmHitCtr = 0
 iAmInvincibleCtr = 0
 rem xpos = 38.0 : 
 ypos = 80.0
 
 Evelocity = 0.0 : Efalling = 1: EanimFrame = 0: Etick = 0: Efacing = 0
 Expos = 118.0 : Eypos = 16.0
 EprevX = xposH
 EprevY = yposH
 Ejumping = 0
 Ejsamp = 0
 Eacount = 0
 Edcount = 0
 
 EposeCtr = 200
 
 EwaitJump = 0
 
 enemyXW = 40
 enemyYW = 40
 
 EshotActive = 0
 EAskForShotCtr = 0
 
 mtick = 0
 ENextShot = 255
 
 EAIfreq = 31
 EAInextUp = mtick + EAIfreq

 playfield:
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 X..............................X
 XXXXXXXXXXXXX..................X
 X.XX..XX...XX..................X
 X.XX..XX...XX..................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 pfhline 0 11 31 off 

 xoff = 0
 yoff = 0

 shotXW[0] = 250
 shotXW[1] = 250
 shotXW[2] = 250
 
 scorecolor = 26
 score = 333333
 
 rem ---------------- ---------------- ---------------- ---------------- 
 rem ---------------- ---------------- ---------------- ---------------- 

BMainLoop

 NUSIZ0=$30
 NUSIZ1=$30
 if switchreset then goto BossStart bank6
 gosub BUpdateMegaMan
 gosub BossAI
 gosub UpdateBoss bank7
 gosub BPositionSprites
 drawscreen 
 mtick = mtick + 1

 goto BMainLoop

 rem ---------------- BossAI
 
BossAI

 if !EposeCtr && mtick = ENextShot then EAskForShotCtr = 10

ENoShoot
 if mtick <> EAInextUp then AIdone

 EAInextUp = mtick + EAIfreq
 
 Ejoy0fire = 0

 rem if Efalling then AIdone

 if xposH < ExposH then AIgoLeft
 
 if xposH > ExposH then AIgoRight
 
 
AIgoLeft
 Ejoy0left = 1 : Ejoy0right = 0
 rem if ExposH < EprevX then EwaitJump = 10 : goto AIdone
 if EwaitJump then EwaitJump = EwaitJump - 1 :goto AIdone
 if yposH < EyposH then Ejoy0fire = 1 : EwaitJump = 2
 goto AIdone
 
AIgoRight
 Ejoy0left = 0 : Ejoy0right = 1
 rem if ExposH > EprevX then EwaitJump = 10 : goto AIdone
 if EwaitJump then EwaitJump = EwaitJump - 1 : goto AIdone
 if yposH < EyposH then Ejoy0fire = 1 : EwaitJump = 2
 goto AIdone

 if Ehealth > 70 then AIdone

 EAIfreq = 22
 
 if Ehealth < 30 then EAskForShotCtr = 6 : EAIfreq = 10
 
 if Ejoy0fire then  EAskForShotCtr = 10 

AIdone



 return 


 rem ---------------- Udpdate MegaMan


BUpdateMegaMan

 if falling then velocity = velocity + 0.16 else velocity = 0.0
 
 rem need to cap falling speed
 asm
 lda velocity
 bmi .BaddVelocity
end 
 if velocity > 8 then velocity = 8.0
 
BaddVelocity
 ypos = ypos + velocity 


 rem update xpos based on joystick
 oxmove = xmove
 
 if jumping then xvel = 0.9375 else xvel = 1.0
 rem if jumping then xvel = 1.5 else xvel = 1.6

 rem xmove = joy0left || joy0right
 asm
 lda SWCHA
 and #($40 + $80)
 eor #($40 + $80)
 sta xmove
end 


 rem if joy0up then ypos = ypos - 1.0
 rem if joy0down then ypos = ypos + 1.0


 rem *** check starting to move
 if !falling && !oxmove && xmove then acount = 9

 if !acount then BfullSpeedX

 if iAmHitCtr > 10 then BskipControl1
 if joy0left then xpos = xpos - 0.2 : tick = tick + 1 : facing = 0 : dcount = 0
 if joy0right then xpos = xpos + 0.2 : tick = tick + 1 : facing = 1 : dcount = 0

BskipControl1

 acount = acount - 1
 
 goto BcheckDecel

BfullSpeedX
 if iAmHitCtr > 10 then BskipControl2
 if joy0left then xpos = xpos - xvel : tick = tick + 1 : facing = 0 : dcount = 10
 if joy0right then xpos = xpos + xvel : tick = tick + 1 : facing = 1 : dcount = 10
 goto BcheckDecel
 
BskipControl2
 if iAmHitCtr < 20 then BcheckDecel
 if facing = 0 then xpos = xpos + 0.4
 if facing = 1 then xpos = xpos - 0.4


BcheckDecel
 rem *** logic to do deceleration
 if falling then dcount = 0

 if xmove || !dcount then Bfloorcheck
 
 if facing then xpos = xpos + 0.8 else xpos = xpos - 0.4

 dcount = dcount - 1
 
 rem *** logic to check against bottom of screen and left/right walls
 
Bfloorcheck

 rem if ypos >= 80 then ypos = 80.0 : velocity = 0.0: falling = 0

 rem left/right wall checks
 if xposH >= 128 then xposH = 128
 if xposH <= 18 then xposH = 18

 rem *** logic to check jumping
 
Bnotcheck
 if jumping && !joy0fire then BstopJumping

 if !joy0fire && !falling then jsamp = 1
 
 if !jumping && joy0fire && !falling && jsamp then falling = 1 : jumping = 1 : jsamp = 0 : velocity = -3.3

 goto BdoneStopJump

BstopJumping

 jumping = 0
 
 tempi0 = -0.5

 asm
 
 ; if velocity < -0.5

 lda velocity
 bpl .BdoneStopJump

 sec
 lda tempi0+1
 sbc velocity+1
 lda tempi0
 sbc velocity
 bcc .BdoneStopJump

 ;.byte 02
 
end

 velocity = tempi0

BdoneStopJump


 rem *** SW collision checks
 rem collision xpos = sprite xpos - 16 

 if yposH <> prevY then BmoveChecks

 colX = xposH - 12
 colY = yposH
 gosub BCheckPos 
 
 if colResult then BdoneYChecks

 colX = xposH - 7
 colY = yposH
 gosub BCheckPos 

 if !colResult then falling = 1
 goto BdoneYChecks

BmoveChecks
 
 asm
 lda yposH
 bpl .BmoreChecks
 jmp .BEndChecks
end
BmoreChecks

 if yposH > prevY then BFootCheck

 goto BdoneYChecks
 
BFootCheck

 colX = xposH - 12
 colY = yposH
 gosub BCheckPos 
 if colResult then BstopOnPlatform

 colX = xposH - 7
 colY = yposH
 gosub BCheckPos 
 if !colResult then BdoneYChecks

BstopOnPlatform

 velocity = 0.0 : falling = 0 : yposH = yposH & %11111000 

BdoneYChecks

 if yposH < 5 then BEndChecks
 
 if xposH = prevX then BEndChecks

 if xposH > prevX then BRightCheck 

 rem *** LeftCheck
 colX = xposH - 16
 colY = yposH - 5
 gosub BCheckPos 
 
 if !colResult && yposH > 12 then colY = yposH - 13 :  gosub BCheckPos

 rem YELLOW
 if colResult then xposH = xposH + 3 : xposH = xposH & %11111100

 goto BEndChecks

 
BRightCheck 

 colX = xposH - 4
 colY = yposH - 5
 gosub BCheckPos 

 if !colResult && yposH > 12 then colY = yposH - 13 :  gosub BCheckPos

 if colResult then xposH = xposH : xposH = xposH & %11111100

BEndChecks

 prevX = xposH
 prevY = yposH

 rem *** animation frames 
 if tick > 6 then tick = 0 : animFrame = animFrame + 1 
 if animFrame > 5 then animFrame = 2
 
 if !xmove && !acount then animFrame = 0
 
 rem still animation when falling
 if falling = 1 then animFrame = 6
 
 rem do blink logic
 if blink then BblinkTimer
 if xmove || jumping then bcnt = 0 else bcnt = bcnt + 1
 if bcnt > 89 then blink = 1 : bcnt = 10
 goto BdoneBlink
BblinkTimer
 bcnt = bcnt - 1
 if bcnt then BdoneBlink
 blink = 0
BdoneBlink

 jj = 0
 kk = 250
 
 rem *** Update and display shots

 asm 
   .if 1
   
    ldx #2
 
.Bupddshot 
    lda shotXR,X
    cmp #250
    beq .BnxtShot

    ; rem shot is active so update shot movement
 
    clc
    adc shotVelR,x
    sta shotXW,x
    cmp #3
    bcc .BretireS
    cmp #156
    bcc .BnxtShot

.BretireS 
    ; deactivate shot
    lda #250
    sta shotXW,x
    bne .BnxtShot

.BnxtShot

    dex
    bpl  .Bupddshot
    
    .endif
end

 kk = shootI

 ballx = 0
 bally = 0
 
 if shotXR[kk] = 250 then BnoDisplay

 ballx = shotXR[kk]
 bally = shotYR[kk]

BnoDisplay
 
 shootI = shootI + 1
 if shootI = 3 then shootI = 0
 
 rem *** check shooting
 
 if shootDelay then shootDelay = shootDelay - 1 


 rem *** check shot enemy collision
 
 if iAmInvincibleCtr then iAmInvincibleCtr = iAmInvincibleCtr - 1 : goto BnoEnemyHit

 if xpos >= Expos then ii = xpos - Expos else ii = Expos - xpos
 if ypos >= Eypos then jj = ypos - Eypos else jj = Eypos - ypos

 if ii < 16 && jj < 16 then BEnemyHit

 rem *** check player enemy collision
 jj = 1
 if collision(player0,missile0) then jj=0
 if collision(player0,missile1) then jj=0
 if collision(player1,missile0) then jj=0
 if collision(player1,missile1) then jj=0

 if jj then BnoEnemyHit

BEnemyHit
 iAmHitCtr = 22
 iAmInvincibleCtr = 111

 if health <= 20 then BMMisDead 
 health = health - 20 : gosub BUpdateHealth
 goto BnoEnemyHit
 
BMMisDead
 health = 0 : gosub BUpdateHealth
 enemyX0W = xposH+4
 enemyY0W = yposH-4
 goto Explosion bank7
 rem score = 0
 
BnoEnemyHit

 ii = mtick & 7

 if !iAmHitCtr then BnotHitted
 
 iAmHitCtr = iAmHitCtr - 1
 on ii goto BMMblank BMMhitFlash BMMblank BMMhit BMMblank BMMhit BMMblank BMMhit
 

BnotHitted
 if shootDelay then BnAnim
   
 if joy0down && !EposeCtr then BShoot

BnAnim

 if shootDelay > 6 then BShootAnim

 ii = mtick & 2
 if iAmInvincibleCtr && ii then BMMblank

 ii = mtick & 1
 if !ii then BDoneSprite

 rem MegaMan colours 
 COLUP0 = $95 : COLUP1 = $95
 on animFrame goto BMMstand0 BMMstand1 BMMrun1 BMMrun2 BMMrun3 BMMrun2 BMMfall

BShoot

 enemyX0W = xpos
 enemyY0W = ypos
 
 asm
 ;.if 0
 nop
 nop
 nop
 nop
end

 for ii = 0 to 2
 
 if shotXR[ii] <> 250 then BShotUsed

 rem 31 frames before MM can shoot again
 shootDelay = 13

 rem check right
 if facing then shotXW[ii] = xposH + 17 : shotYW[ii] = yposH - 8 : shotVelW[ii] = 2

 rem check left
 if !facing then shotXW[ii] = xposH - 3 : shotYW[ii] = yposH - 8 : shotVelW[ii] = 0-2  

 goto BFoundShot

BShotUsed

 next

BFoundShot
  
 asm
 ;.endif
end

BShootAnim

 ii = mtick & 2
 if iAmInvincibleCtr && ii then BMMblank

 ii = mtick & 1
 if !ii then BDoneSprite

 rem MegaMan colours 
 COLUP0 = $95 : COLUP1 = $95
 on animFrame goto BMMstandS BMMstandS BMMrunS1 BMMrunS2 BMMrunS3 BMMrunS2 BMMfallS

BMMstand0
 xoff = 0
 yoff = 0

 if blink then BMMStandBlink

 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %01111100
 %01111000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite
 
BMMStandBlink
 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001000
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %01111100
 %01111000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %11100000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite

BMMstand1
 xoff = 0
 yoff = 0
 player0:
 %01111100
 %00111100
 %00001110
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %11111000
 %11110000
 %11100000
 %11000000
 %11011000
 %11001000
 %00111000
 %11010000
 %00100000
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite

BMMstandS
 xoff = 0-1
 yoff = 0
 player0:
 %11111000
 %01111000
 %00011101
 %00001111
 %00110111
 %00100111
 %00110110
 %00011101
 %00001010
 %00000011
 %00001011
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %11111000
 %11110000
 %11000000
 %11000000
 %11000000
 %11000000
 %00100000
 %11001110
 %00101111
 %11101110
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite

BMMrun1
 xoff = 1
 yoff = 0
 player0:
 %00000011
 %00000001
 %00011001
 %01111011
 %01110111
 %00101111
 %00001110
 %01001101
 %01101101
 %00111011
 %00010101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %11100000
 %10000000
 %11000000
 %11000000
 %10000000
 %00000000
 %11101100
 %00001110
 %11110010
 %10100110
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto BDoneSprite

BMMrun2
 xoff = 1
 yoff = 0
 player0:
 %00000111
 %00000100
 %00000111
 %00000011
 %00000001
 %00000010
 %00001110
 %00001100
 %00011010
 %00011101
 %00001101
 %00000011
 %00000101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %11010000
 %00000000
 %11100000
 %00000000
 %11110000
 %10100000
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto BDoneSprite

BMMrun3
 xoff = 1
 yoff = 0
 player0:
 %00000000
 %00000000
 %00011000
 %11111111
 %01110111
 %00000110
 %00110011
 %00110011
 %00011101
 %00001011
 %00000101
 %00000110
 %00000011
 %00000001
 %00000000
 %00000000
end
 player1:
 %11110000
 %11000000
 %11100000
 %11000000
 %00000000
 %11111000
 %10011000
 %00000000
 %11110000
 %10100000
 %10100000
 %00000000
 %10110000
 %00100000
 %01000000
 %00000000
end
 goto BDoneSprite

BMMrunS1
 xoff = 0
 yoff = 0
 player0:
 %00000111
 %00000011
 %00110011
 %11110111
 %11101111
 %01011110
 %00011101
 %10011010
 %11011011
 %01110111
 %00101011
 %00001100
 %00000111
 %00000010
 %00000000
 %00000000
end
 player1:
 %11000000
 %00000000
 %10000000
 %10000000
 %00000000
 %00000000
 %11000000
 %00001110
 %11101111
 %01001110
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
 %00000000
end
 goto BDoneSprite

BMMrunS2
 xoff = (0-2)
 yoff = 0
 player0:
 %00111000
 %00100000
 %00111000
 %00011000
 %00001000
 %00010000
 %01110110
 %01100000
 %11010111
 %11101000
 %01101111
 %00011101
 %00101101
 %00110000
 %00011101
 %00001001
 %00000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000000
 %00000000
 %00000000
 %00111000
 %10111100
 %00111000
 %00000000
 %00000000
 %10000000
 %00000000
 %00000000
 %00000000
end
 goto BDoneSprite

BMMrunS3
 xoff = 0
 yoff = 0
 player0:
 %00000001
 %00000001
 %00110001
 %11111111
 %11101110
 %00001101
 %00000111
 %00000110
 %00000011
 %00000111
 %00001011
 %00001100
 %00000111
 %00000010
 %00000000
 %00000000
end
 player1:
 %11100000
 %10000000
 %11000000
 %10000000
 %00000000
 %11110000
 %00110000
 %00001110
 %11101111
 %01001110
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
 %00000000
end
 goto BDoneSprite

BMMfall
 xoff = 1
 yoff = 1
 player0:
 %00000001
 %00000001
 %00000001
 %00000001
 %00000011
 %00000011
 %00000011
 %00000011
 %00000011
 %00000011
 %00000010
 %00000011
 %00000101
 %00000101
 %00001101
 %00011101
 %00110110
 %01100011
 %00100001
 %00000000
end
 player1:
 %10000000
 %10000000
 %10000000
 %10000000
 %00000110
 %00001110
 %10011100
 %11111100
 %11111000
 %00000000
 %11100000
 %00000000
 %00000000
 %11110000
 %10100000
 %10100100
 %00000010
 %10110011
 %00100010
 %01000000
end
 goto BDoneSprite
 
BMMfallS
 xoff = 0
 yoff = 1
 player0:
 %00000011
 %00000011
 %00000011
 %00000011
 %00000110
 %00000110
 %00000111
 %00000111
 %00000111
 %00000110
 %00000101
 %00000110
 %00001010
 %00001011
 %00011011
 %00111011
 %01101100
 %11000111
 %01000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %00000000
 %00001100
 %00011100
 %00111000
 %11111000
 %11110000
 %00000000
 %11001110
 %00001111
 %00001110
 %11100000
 %01000000
 %01000000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite

BMMhit
 COLUP0 = $96 : COLUP1 = $96
 xoff = 0
 yoff = 1
 player0:
 %00000000
 %00000110
 %00000111
 %00000011
 %00000111
 %00000110
 %00000111
 %00000111
 %00000111
 %11000110
 %11000101
 %01100110
 %00111010
 %00001011
 %00001010
 %00001001
 %00001100
 %00000111
 %00000010
 %00000000
end
 player1:
 %00000000
 %00000000
 %00000000
 %10000000
 %00011110
 %00011100
 %00111000
 %11111000
 %11110000
 %00000011
 %11000011
 %00000110
 %00001100
 %11100000
 %01000000
 %11100000
 %00000000
 %01100000
 %01000000
 %10000000
end
 goto BDoneSprite

BMMhitFlash

 COLUP0 = $0e : COLUP1 = $0e

 xoff = 0
 yoff = 1
 player0:
 %00000000
 %00001000
 %00001100
 %00011100
 %11011110
 %11111111
 %01111111
 %00111111
 %00111111
 %01111111
 %11111111
 %11111111
 %01111111
 %00111111
 %01111111
 %11111111
 %11001111
 %00001111
 %00011100
 %00010000
end
 player1:
 %00000000
 %00010000
 %00111000
 %01111001
 %11111110
 %11111100
 %11111000
 %11111100
 %11111110
 %11111111
 %11111100
 %11111000
 %11111100
 %11111110
 %11111000
 %11111110
 %11111111
 %01110100
 %00110010
 %00011000
end
 goto BDoneSprite

BMMblank

 xoff = 0
 yoff = 0
 player0:
 %00000000
end
 player1:
 %00000000
end
 goto BDoneSprite

BDoneSprite  rem done setting up sprites

 return
 
 rem ---------------
 rem ---------------
  

 rem done setting up sprites

BPositionSprites

 ii = mtick & 1
 if ii then BPositionMegaMan

 rem PositionSprites

 if Efacing then BEfaceright

 REFP0 = 8 : REFP1 = 8
 player1x = Expos + xoff
 player0x = player1x + 8
 player1y = Eypos + yoff
 player0y = player1y 

 goto BDonePos
 
BEfaceright

 REFP0 = 0 : REFP1 = 0
 player0x = Expos - xoff
 player1x = player0x + 8
 player0y = Eypos + yoff
 player1y = player0y

 rem set frame based on animation
 goto BDonePos


BPositionMegaMan

 if facing then Bfaceright

 REFP0 = 8 : REFP1 = 8
 player1x = xpos + xoff
 player0x = player1x + 8
 player1y = ypos + yoff
 player0y = player1y 

 goto BDonePos
 
Bfaceright

 REFP0 = 0 : REFP1 = 0
 player0x = xpos - xoff
 player1x = player0x + 8
 player0y = ypos + yoff
 player1y = player0y

BDonePos

 rem set frame based on animation
 return
 
 
 rem ---------------- Collision subroutine

 asm
 include BCollision.s
end 

BUpdateAndDisplayShots

 return


 rem ---------------- Update Health
BUpdateHealth

 asm
 lda score
 and #$22
 sta ii
 lda score+1
 and #$22
 sta jj
 lda score+2
 and #$22
 sta kk
end

 if health = 0 then Bdonehealth

 ii = ii + $10

 if health < 15 then Bdonehealth
 ii = ii + $01
 if health < 34 then Bdonehealth
 jj = jj + $10
 if health < 50 then Bdonehealth
 jj = jj + $01
 if health < 83 then Bdonehealth
 kk = kk + $10
 if health < 83 then Bdonehealth
 kk = kk + $01

Bdonehealth

 asm
 lda ii
 sta score
 lda jj
 sta score+1
 lda kk
 sta score+2
end

 return
 

 bank 7

 rem ---------------- Udpdate Boss


UpdateBoss

 if EposeCtr then EposeCtr = EposeCtr - 1

 if Efalling then Evelocity = Evelocity + 0.16 else Evelocity = 0.0
 
 rem need to cap falling speed
 asm
 lda Evelocity
 bmi .EaddVelocity
end 
 if Evelocity > 8 then Evelocity = 8.0
 
EaddVelocity
 Eypos = Eypos + Evelocity 


 if EposeCtr || EAskForShotCtr then Efloorcheck
 
 if Ejumping then Exvel = 0.44 else Exvel = 0.5

 rem xmove = joy0left || joy0right
 rem sta xmove

EfullSpeedX
 if EIsHitCtr > 10 then EskipControl2
 if Ejoy0left then Expos = Expos - Exvel : Etick = Etick + 1 : Efacing = 0 : Edcount = 10
 if Ejoy0right then Expos = Expos + Exvel : Etick = Etick + 1 : Efacing = 1 : Edcount = 10
 goto EcheckDecel
 
EskipControl2
 if EIsHitCtr < 5 then EcheckDecel
 if Efacing = 0 then Expos = Expos + 1.0
 if Efacing = 1 then Expos = Expos - 1.0

EcheckDecel
 rem *** logic to do deceleration
 if Efalling then Edcount = 0

 if !Edcount then Efloorcheck
 
 if Efacing then Expos = Expos + 0.8 else Expos = Expos - 0.4

 Edcount = Edcount - 1
 
 rem *** logic to check against bottom of screen and left/right walls
 
Efloorcheck

 rem if Eypos >= 80 then Eypos = 80.0 : Evelocity = 0.0: Efalling = 0

 rem left/right wall checks
 if ExposH >= 128 then ExposH = 128
 if ExposH <= 18 then ExposH = 18

 rem *** logic to check jumping
 
Enotcheck
 if Ejumping && !Ejoy0fire then EstopJumping

 if Ejoy0fire && !Efalling then Efalling = 1 : Ejumping = 1 : Evelocity = -2.8

 if !Ejumping then EstopJumping
 
 goto EdoneStopJump

EstopJumping

 Ejumping = 0
 
 tempi0 = -0.5

 asm
 
 ; if velocity < -0.5

 lda Evelocity
 bpl .EdoneStopJump

 sec
 lda tempi0+1
 sbc Evelocity+1
 lda tempi0
 sbc Evelocity
 bcc .EdoneStopJump

 ;.byte 02
 
end

 Evelocity = tempi0

EdoneStopJump


 rem *** SW collision checks
 rem collision Expos = sprite Expos - 16 

 if EyposH <> EprevY then EmoveChecks

 colX = ExposH - 12
 colY = EyposH
 gosub ECheckPos 
 
 if colResult then EdoneYChecks

 colX = ExposH - 7
 colY = EyposH
 gosub ECheckPos 

 if !colResult then Efalling = 1
 goto EdoneYChecks

EmoveChecks

 asm
 lda EyposH
 bpl .EmoreChecks
 jmp .EEndChecks
end
EmoreChecks

 if EyposH > EprevY then EFootCheck

 goto EdoneYChecks
 
EFootCheck

 colX = ExposH - 12
 colY = EyposH
 gosub ECheckPos
 if colResult then EstopOnPlatform

 colX = ExposH - 7
 colY = EyposH
 gosub ECheckPos
 if !colResult then EdoneYChecks

EstopOnPlatform

 Evelocity = 0.0 : Efalling = 0 : EyposH = EyposH & %11111000

EdoneYChecks

 if EyposH < 5 then EEndChecks
 
 if ExposH = EprevX then EEndChecks

 if ExposH > EprevX then ERightCheck 

 rem *** LeftCheck
 colX = ExposH - 16
 colY = EyposH - 5
 gosub ECheckPos 
 
 if !colResult && EyposH > 12 then colY = EyposH - 13 :  gosub ECheckPos

 rem YELLOW
 if colResult then ExposH = ExposH + 3 : ExposH = ExposH & %11111100

 goto EEndChecks

 
ERightCheck 

 colX = ExposH - 4
 colY = EyposH - 5
 gosub ECheckPos 

 if !colResult && EyposH > 12 then colY = EyposH - 13 :  gosub ECheckPos

 if colResult then ExposH = ExposH : ExposH = ExposH & %11111100

EEndChecks

 EprevX = ExposH
 EprevY = EyposH


 rem *** getting hit by MM shots
 
 
 rem *** check shot enemy collision
 
 jj = 1
 if collision(player0,ball) then jj=0
 if collision(player0,ball) then jj=0
 if collision(player1,ball) then jj=0
 if collision(player1,ball) then jj=0

 if jj then EnoEnemyHit

EEnemyHit
 EIsHitCtr = 10

 if Ehealth <= 20 then EMisDead 
 Ehealth = Ehealth - 5 : gosub EUpdateHealth thisbank
 goto EnoEnemyHit
 
EMisDead
 Ehealth = 0 : gosub EUpdateHealth thisbank
 
EnoEnemyHit


 if !EIsHitCtr then EnotHitted

 ii = mtick & 1
 if ii then EDoneSprite

 Eatick = Eatick + 1

 ii = Eatick & 7
  
 EIsHitCtr = EIsHitCtr - 1
 COLUP0 = $45 : COLUP1 = $45
 
 if EposeCtr && EposeCtr < 140 then goto EMstand1
 
 on ii goto EMblank EMhitFlash EMblank EMstand0 EMblank EMstand0 EMblank EMstand0

EnotHitted
 rem *** animation frames 
 if Etick > 6 then Etick = 0 : EanimFrame = EanimFrame + 1 
 if EanimFrame > 3 then EanimFrame = 2
 
 rem still animation when falling
 if Efalling = 1 then EanimFrame = 4
 
 ii = mtick & 7


EnAnim

 ii = mtick & 1
 if ii then EDoneSprite

 rem Elecman colours 
 COLUP0 = $45 : COLUP1 = $45

 if EposeCtr && EposeCtr < 90 then goto EMstand1
 
 if EAskForShotCtr then EAskForShotCtr = EAskForShotCtr - 1 :goto EShootingAnim

 on EanimFrame goto EMstand0 EMstand1 EMrun1 EMrun2 EMfall

EShootingAnim
 
 if EAskForShotCtr < 4  && !EshotActive then gosub EShoot thisbank

 if EAskForShotCtr < 5 then goto EMhandsDown

 goto EMhandsUp


EShoot

 if Efacing then EshotSetRight
 
 enemyX0W = Expos - 8
 enemyY0W = Eypos - 20
 enemyVelW = 0-2
 
 goto EshotSet
 
EshotSetRight 

 enemyX0W = Expos + 20
 enemyY0W = Eypos - 20
 enemyVelW = 2
 
EshotSet 
 EshotActive = 1
 return thisbank


EMstand0

 xoff = 0
 yoff = 0

 rem if blink then EMStandBlink
 
 player0:
 %01111100
 %00111100
 %00011000
 %00000000
 %00000000
 %00000011
 %01110111
 %11110000
 %11100000
 %11100011
 %11000000
 %00000111
 %00011000
 %00100011
 %11001110
 %00011111
 %00011100
 %00111100
 %00111001
 %00110111
 %00111001
 %00100010
 %00000000
end
 player1:
 %00111110
 %00111000
 %00110000
 %00000000
 %00000000
 %10000000
 %11001100
 %00011110
 %11001110
 %00000110
 %00000110
 %11100110
 %00010000
 %11001000
 %00101110
 %11100000
 %10000000
 %10000000
 %11100000
 %11110000
 %00110000
 %00010000
 %00000000 
end
 goto EDoneSprite


EMstand1
 xoff = 0
 yoff = 0
 player0:
 %00000000
 %11111000
 %01111000
 %00110000
 %00000000
 %00000011
 %00000111
 %01110000
 %11111000
 %11111011
 %11011000
 %00000111
 %00011000
 %00100011
 %11001110
 %00011111
 %00011100
 %00111100
 %00111001
 %00110111
 %00111001
 %00100010
 %00000000
end
 player1:
 %00001111
 %00011110
 %00011100
 %00000000
 %00000000
 %10000000
 %11000000
 %00000000
 %11000000
 %00000000
 %00000000
 %11100000
 %00010000
 %11000000
 %00101000
 %11101100
 %10001100
 %10000110
 %11100111
 %11110011
 %00110011
 %00010000
 %00000000
end
 goto EDoneSprite

 rem up
EMhandsUp
 xoff = 1
 yoff = 0
 player0:
 %01111100
 %00111100
 %00011000
 %00000000
 %00000000
 %00000011
 %00000111
 %00001000
 %00000000
 %00010011
 %00010000
 %00110000
 %01100000
 %01100011
 %11001110
 %11011111
 %11011100
 %11011100
 %00011001
 %00010111
 %11011001
 %11010010
 %11100000
 %01100000
end
 player1:
 %00001111
 %00001110
 %00001100
 %00000000
 %00000000
 %10000000
 %11000000
 %00000000
 %11000000
 %00000000
 %00000000
 %00010000
 %00011000
 %11001000
 %00101100
 %11101100
 %10000110
 %10000110
 %11100000
 %11110000
 %00110110
 %00010100
 %00000100
 %00011000
end
 goto EDoneSprite

 rem down
EMhandsDown
 xoff = 1
 yoff = 0
 player0:
 %00000000
 %11100000
 %11100000
 %01000000
 %00000000
 %00001110
 %00011111
 %01100011
 %00000000
 %00000111
 %00111111
 %11111110
 %11110000
 %10000000
 %00111111
 %00110010
 %11110010
 %11100111
 %11011111
 %11100100
 %10001000
end 
 player1:
 %11110000
 %11100000
 %01110000
 %00011000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000010
 %10001111
 %00111111
 %01111100
 %10110000
 %10000000
 %00000000
 %00000000
 %10000000
 %11000000
 %11000000
 %01000000
end
 goto EDoneSprite
                                
EMrun1
 xoff = 1
 yoff = 0
 player0:
 %00000000
 %11000000
 %11100000
 %11110000
 %00110001
 %00000011
 %01000000
 %11100000
 %11110001
 %11100000
 %01000011
 %00001100
 %00010001
 %01100111
 %00001111
 %00001110
 %00011110
 %00011100
 %00011011
 %00011100
 %00010001
end
 player1:
 %00011100
 %01111100
 %01110000
 %00111000
 %11000000
 %11100000
 %00000000
 %01101100
 %10011110
 %00001110
 %11100100
 %00000000
 %11100100
 %00010111
 %11110000
 %01000000
 %01000000
 %11110000
 %11111000
 %10011000
 %00001000 
end
 goto EDoneSprite

EMrun2
 xoff = 1
 yoff = 0
 player0:
 %00001110
 %00011110
 %00011110
 %00001100
 %00000001
 %00000000
 %00011000
 %11111101
 %11111100
 %11001000
 %01000011
 %00001101
 %00010011
 %01101111
 %00001110
 %00011110
 %00011100
 %00011011
 %00011100
 %00010001
 %00000000
end
 player1:
 %00000000
 %10000000
 %11000000
 %00000000
 %11000000
 %00000000
 %01100000
 %10000110
 %00000110
 %00000110
 %11100100
 %00010000
 %11110100
 %11110111
 %01000000
 %01000000
 %11110000
 %11111000
 %10011000
 %00001000
 %00000000
end
 goto EDoneSprite

EMfall
 xoff = 1
 yoff = 1
 player0:
 %00000110
 %00000110
 %00001110
 %00001110
 %00001110
 %00001110
 %00001100
 %00000000
 %00000000
 %00000001
 %00000011
 %11000100
 %11100000
 %11100001
 %11100000
 %01100011
 %01001100
 %00010001
 %01100111
 %00001111
 %00001110
 %00011110
 %00011100
 %00011011
 %00011100
 %00010001 
end
 player1:
 %00000000 
 %00000000
 %00000000
 %00000000
 %00000110
 %00001110
 %00011100
 %00011100
 %00000110
 %11000110
 %11100000
 %00000000
 %01100000
 %10000000
 %00000000
 %11110000
 %00001000
 %11100000
 %00010100
 %11110110
 %01000110
 %01000011
 %11110011
 %11111001
 %10011000
 %00001000 
end
 goto EDoneSprite

EMhitFlash

 COLUP0 = $0e : COLUP1 = $0e

 xoff = 0
 yoff = 1
 player0:
 %00000000
 %00001000
 %00001100
 %00011100
 %11011110
 %11111111
 %01111111
 %00111111
 %00111111
 %01111111
 %11111111
 %11111111
 %01111111
 %00111111
 %01111111
 %11111111
 %11001111
 %00001111
 %00011100
 %00010000
end
 player1:
 %00000000
 %00010000
 %00111000
 %01111001
 %11111110
 %11111100
 %11111000
 %11111100
 %11111110
 %11111111
 %11111100
 %11111000
 %11111100
 %11111110
 %11111000
 %11111110
 %11111111
 %01110100
 %00110010
 %00011000
end
 goto EDoneSprite

EMblank

 xoff = 0
 yoff = 0
 player0:
 %00000000
end
 player1:
 %00000000
end

EDoneSprite


 if !EshotActive then DoneBoss
 

 enemyX0W = enemyX0R + enemyVelR

 if enemyX0R < 3 then retireBolt
 if enemyX0R > 156 then retireBolt
 
 goto EUpdateBolt
 
retireBolt
 EshotActive = 0
 missile0x = 0
 missile0y = 0
 missile1x = 0
 missile1y = 0
 goto DoneBoss

EUpdateBolt

 asm
 lda mtick
 and #8
 bne .boltFrame2

.boltFrame1
 lda mtick
 and #1
 bne .doBolt1

 lda #<.Ebolt0
 sta boltPtr
 lda #>.Ebolt0
 sta boltPtr+1
 bne .setBoltPos
 
.doBolt1
 lda #<.Ebolt1
 sta boltPtr
 lda #>.Ebolt1
 sta boltPtr+1
 bne .setBoltPos

.boltFrame2
 lda mtick
 and #1
 bne .doBolt3

 lda #<.Ebolt2
 sta boltPtr
 lda #>.Ebolt2
 sta boltPtr+1
 jmp .setBoltPos
 
.doBolt3
 lda #<.Ebolt3
 sta boltPtr
 lda #>.Ebolt3
 sta boltPtr+1

.setBoltPos 
 
 ldy #$00
 lda (boltPtr),y
 adc enemyX0R
 sta missile0x
 iny
 lda (boltPtr),y
 adc enemyY0R
 sta missile0y
 iny
 lda (boltPtr),y
 sta NUSIZ0
 iny
 lda (boltPtr),y
 sta missile0height
 iny
 lda (boltPtr),y
 adc enemyX0R
 sta missile1x
 iny
 lda (boltPtr),y
 adc enemyY0R
 sta missile1y
 iny
 lda (boltPtr),y
 sta NUSIZ1
 iny
 lda (boltPtr),y
 sta missile1height
end 
  
  
DoneBoss

 return otherbank

 asm
.Ebolt0
 .byte 0, 0
 .byte $30      ; 8 wide
 .byte 1        ; 2 high

 .byte 8, 14
 .byte $00      ; 1 wide
 .byte 14        ; 8 high
 
.Ebolt1
 .byte 8, 14
 .byte $30
 .byte 1

 .byte 16, 14
 .byte $00
 .byte 14

.Ebolt2
 .byte 0, 14
 .byte $30
 .byte 1

 .byte 8, 14
 .byte $00
 .byte 14

.Ebolt3
 .byte 8, 0
 .byte $30      ; 8 wide
 .byte 1        ; 2 high

 .byte 16, 14
 .byte $00      ; 1 wide
 .byte 14        ; 8 high
 
end 
  
 rem ---------------- Update Health

EUpdateHealth

 asm
 lda score
 and #$11
 sta ii
 lda score+1
 and #$11
 sta jj
 lda score+2
 and #$11
 sta kk
end

 if Ehealth = 0 then doneEhealth

 ii = ii + $20

 if Ehealth < 15 then doneEhealth
 ii = ii + $02
 if Ehealth < 34 then doneEhealth
 jj = jj + $20
 if Ehealth < 50 then doneEhealth
 jj = jj + $02
 if Ehealth < 83 then doneEhealth
 kk = kk + $20
 if Ehealth < 83 then doneEhealth
 kk = kk + $02

doneEhealth
 asm
 lda ii
 sta score
 lda jj
 sta score+1
 lda kk
 sta score+2
end

 return thisbank
 
 rem ------------------ Done Update Boss

 dim bxposL = b
 dim bxposH = bxposL + 6
 dim byposL = bxposH + 6
 dim byposH = byposL + 6

 dim bxvelL = var0
 dim bxvelH = bxvelL + 6
 dim byvelL = bxvelH + 6
 dim byvelH = byvelL + 6 
 
 dim bcountdown = byvelH + 6
 dim bexcountL = bcountdown + 1
 dim bexcountH = bexcountL + 1
 
 

Explosion

 rem setup sprites and velocities
 
 missile0y = 0
 missile1y = 0
 bally = 0
 
 player0:
 %00111100
 %01111110
 %11111111
 %11111111
 %01111110
 %00111100
end
 player1:
 %00111100
 %01111110
 %11111111
 %11111111
 %01111110
 %00111100
end
 

 asm
 ldx #5
.BInitLoop 
 lda .BinitialxL,x
 sta bxposL,x
 lda .BinitialxH,x
 clc
 adc enemyX0R
 sta bxposH,x
 
 lda .BinitialyL,x
 sta byposL,x
 lda .BinitialyH,x
 clc
 adc enemyY0R
 sta byposH,x
 
 lda .BinitialxvL,x
 sta bxvelL,x
 lda .BinitialxvH,x
 sta bxvelH,x
 
 lda .BinitialyvL,x
 sta byvelL,x
 lda .BinitialyvH,x
 sta byvelH,x
 
 dex
 bpl .BInitLoop 
end

 mtick = 0
 bcountdown = 20
 bexcountL = $60
 bexcountH = 0
 
explodeLoop

 mtick = mtick + 1
 if mtick > 2 then mtick = 0

 rem move sprites

 if bcountdown then bcountdown = bcountdown - 1 : goto bdrawsprites
 
 asm
 ldx #5
.BupdateVelocites 
 lda bxposL,x
 clc
 adc bxvelL,x
 sta bxposL,x
 
 lda bxposH,x
 adc bxvelH,x
 sta bxposH,x
 
 lda byposL,x
 clc
 adc byvelL,x
 sta byposL,x
 
 lda byposH,x
 adc byvelH,x
 sta byposH,x
 dex
 bpl .BupdateVelocites
end

 rem draw sprites
bdrawsprites
 if mtick = 0 then player0x = bxposH[0] : player0y = byposH[0] : player1x = bxposH[1] : player1y = byposH[1]
 if mtick = 1 then player0x = bxposH[2] : player0y = byposH[2] : player1x = bxposH[3] : player1y = byposH[3]
 if mtick = 2 then player0x = bxposH[4] : player0y = byposH[4] : player1x = bxposH[5] : player1y = byposH[5]

 rem MegaMan colours 
 COLUP0 = $95 : COLUP1 = $95

 asm
 dec bexcountL
 bne .nobexh
 dec bexcountH
 bmi .ResetGame
.nobexh
end

 drawscreen

 goto explodeLoop

ResetGame
 pop
 goto GameStart bank1
 
 
 asm
.BinitialxL
    .byte $00,$00,$00,$00,$00,$00
.BinitialxH
    .byte $00,$00,$00,$00,$00,$00
.BinitialyL
    .byte $00,$00,$00,$00,$00,$00
.BinitialyH
    .byte $00,$00,$00,$00,$00,$00
.BinitialxvL
    .byte $4C,$4C,$00,$00,$B4,$B4
.BinitialxvH
    .byte $ff,$ff,$00,$00,$00,$00
.BinitialyvL
    .byte $4C,$B4,$00,$00,$4C,$B4
.BinitialyvH
    .byte $ff,$00,$ff,$01,$ff,$00
end

 asm
 include ECollision.s
end 
