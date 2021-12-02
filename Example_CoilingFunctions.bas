'--------------------------------------------
'Author:   Ádám Kohajda
'Date:     2021.12.02.           
'--------------------------------------------
'Description:  Example program for using CoilingFunctions
'--------------------------------------------
#INCLUDE "MotionParameters.bi"   'right mouse click opens the file
#INCLUDE "MotionMacros.bi"   'right mouse click opens the file
#INCLUDE "MotionFunctions.bi"    
#INCLUDE "CoilingFunctions.bas" 
                               
#DEFINE TRUE 1
#DEFINE FALSE 0  
   
Enable()
SetVelocitySlowly(200)
SetVelocitySlowly(20)
SetVelocitySlowly(50)  
StopSlowly()   
DELAY 1000 
                            
MoveRelative(1024)
DELAY 500 
MoveRelativeAtSpeed(-4096,100)
DELAY 500 

MC.Shutdown  
