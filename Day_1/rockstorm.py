#!/usr/bin/python

# System and pygame modules
import sys, pygame
import os
from math import sin,cos,radians
import random
# To do:
# Draw rocks on both side of the screen if they're across it


pygame.init()

screen = pygame.display.set_mode((640,480))
pygame.display.set_caption("Rockstorm")

# Make an rock shape. This is basically a polygon with randomised vertices

rockShape = []
for i in range(0,10):
    r = radians(36*i)
    rockShape.append( ( 8*cos(r)+2*random.random()-1,8*sin(r)+2*random.random()-1))

rocks = []
for a in range(0,5):
    r = radians(random.randint(0,359))
    rocks.append([ random.randint(0,639), random.randint(0,479),
                       2*cos(r), 2*sin(r), 4, random.randint(0,359)])

ship = [ (-8,-8) , (12,0), (-8,8), (0,0)]
def translate(seq, (x,y)):
    output = []
    for p in seq:
        output.append((p[0]+x,p[1]+y))
    return output

def rotate(seq, degrees):
    output = []
    r = radians(-degrees)
    for p in seq:   
        output.append((p[0]*cos(r)-p[1]*sin(r),p[0]*sin(r)+p[1]*cos(r)))
    return output

def scale(seq, amount):
    output = []
    for p in seq:   
        output.append((p[0]*amount,p[1]*amount))
    return output

(shipx,shipy) = (-1,256) # Shipx= -1 is a special value which means
                         # the ship is waiting to spawn
(shipdx,shipdy) = (0,0)

bullets = []

def clip((x,y)):
    if(x>=640): x -= 640
    elif(x<0): x+= 640
    if(y>=480): y -= 480
    elif(y<0): y += 480
    return (x,y)

clock= pygame.time.Clock()

def collision((x1,y1),(x2,y2),minDistance):
    xdist = abs(x1-x2)
    if(xdist > 320): xdist = 640-xdist
    ydist = abs(y1-y2)
    if(ydist > 320): ydist = 480-ydist
    return (xdist*xdist+ydist*ydist) < minDistance*minDistance
    

dir = 0
fireTimeout = 0
timeout = 0
lives = 4
pause = False
while lives > -1:
    screen.fill((0,0,0))

    # Draw section
    for a in rocks:
        pygame.draw.polygon(screen, (0,255,0), translate(rotate(scale(rockShape,a[4]),a[5]),(a[0],a[1])),1)
    for b in bullets:
        pygame.draw.circle(screen, (255,255,0), (int(b[0]),int(b[1])),4,1)

    if(shipx >= 0):
        polyseq = rotate(ship,dir)
        polyseq = translate(polyseq,(shipx,shipy))
        pygame.draw.polygon(screen, (255,255,255), polyseq, 1)

    for l in range(1,lives):
        polyseq = translate(ship,(16*l,16))
        pygame.draw.polygon(screen, (255,255,255), polyseq, 1)    


    # Animation section
        
    if not pause:
        for a in rocks:
            a[0] += a[2]
            a[1] += a[3]
            (a[0],a[1]) = clip((a[0],a[1]))
        for b in bullets:
            b[0] += b[2]
            b[1] += b[3]
            (b[0],b[1]) = clip((b[0],b[1]))
            b[4] -= 1
            if(b[4]<=0):
                bullets.remove(b)
        if(shipx >= 0):
            shipx += shipdx
            shipy += shipdy

    # Input processing
    keys = pygame.key.get_pressed()

    if(keys[pygame.K_p]):
        pause = True
    if(keys[pygame.K_o]):
        pause = False

    if(not pause):
      if(keys[pygame.K_q] or keys[pygame.K_ESCAPE]):
        lives = -1

      if(shipx >= 0 and timeout<=0 and lives > 0):           

        if(keys[pygame.K_LEFT]):
            dir += 4
        if(keys[pygame.K_RIGHT]):
            dir -= 4
        if(keys[pygame.K_SPACE] and fireTimeout<=0):
            bullets.append([shipx,shipy,shipdx+4*cos(radians(dir)),shipdy-4*sin(radians(dir)),100])
            fireTimeout = 50
        if(keys[pygame.K_UP]): # Thrust!
            shipdx += 0.5*cos(radians(dir))
            shipdy -= 0.5*sin(radians(dir))

        if(fireTimeout > 0): fireTimeout -= 1
    
        (shipx,shipy) = clip((shipx,shipy))

      else:
        if(timeout > 0):
            timeout -= 1
        else:
            place = True
            # Check we have some space to place the ship in
            for a in rocks:
                if(collision((320,256),(a[0],a[1]), a[4]*8+64)):
                    place = False
            if(place):
                shipx=320 # Place it
                shipy = 256
                shipdx =0
                shipdy = 0
                lives -= 1

    # Finally, collisions
    # Ship / rock
    for a in rocks:
        if(shipx >=0 and collision((shipx,shipy),(a[0],a[1]), a[4]*8+16)):
            shipx = -1
            timeout = 100
        # bullet / rock
        for b in bullets:
            if(collision((b[0],b[1]),(a[0],a[1]), a[4]*8+4)):
                if(a[4] > 1):
                    r1 = radians(random.randint(0,359))                
                    r2 = radians(random.randint(0,359))
                    rocks.append([a[0],a[1], a[2]+cos(r1),a[3]+sin(r1),a[4]/2,random.randint(0,359)])
                    rocks.append([a[0],a[1], a[2]+cos(r2),a[3]+sin(r2),a[4]/2,random.randint(0,359)])
                rocks.remove(a)
                bullets.remove(b)
                
    # End loop and do pygame loop admin
    pygame.event.pump()
    pygame.display.flip()
    clock.tick(50)
