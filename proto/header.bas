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


