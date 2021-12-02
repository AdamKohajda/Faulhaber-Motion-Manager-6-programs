'--------------------------------------------
'Author: Ádám Kohajda     
'Date: 2021.12.02. 
'--------------------------------------------
'Description: 
'  These funcions were made for the drive of a strip coiling machine.
'  All of these functions can be used without any change in settings or 
'  operation modes. They do this automatically. 
'
'  -   MoveRelative(targetPosition): 
'         moves to target position (actual position + targetPosition) at speed of 30 1/min
'  -   MoveRelativeAtSpeed(targetPosition,atSpeed):
'         same as MoveRelative(), but at chosen velocity
'  -   SetVelocitySlowly(targetVelocity):
'         set the targetVelocity by a very overdamped behavior to avoid the break of the strip
'  -   StopSlowly():                                                      
'         stops the movement without any rapid hitch   
'--------------------------------------------                       
#INCLUDE "MotionParameters.bi"   
#INCLUDE "MotionMacros.bi"   

#DEFINE TRUE 1
#DEFINE FALSE 0        
                     
FUNCTION MoveRelativeAtSpeed(targetPosition,atSpeed)
   DIM OpMode = MC.GetActualOpmode
   IF MC.GetActualVelocity THEN
      StopSlowly()
   END IF
   MC.SetOpmodeCSP
   DIM previousMaxSpeed=MC.GetMaxMotorSpeed
   MC.MaxMotorSpeed=atSpeed                              
   DIM ActualPosition = MC.GetActualPosition            
   MC.TargetPosition = ActualPosition + targetPosition
   'wait UNTIL position is set 
   IF targetPosition<0 THEN
      targetPosition = targetPosition*-1
   END IF
   DIM SetTime = targetPosition*1000*60/(4096*atSpeed) + 100 
   DELAY SetTime                     
   'set preveious settings back
   MC.MaxMotorSpeed=previousMaxSpeed 
   SETOBJ $6060.00 = OpMode              
END FUNCTION                                            

FUNCTION MoveRelative(targetPosition)
   DIM OpMode = MC.GetActualOpmode 
   IF MC.GetActualVelocity THEN
      StopSlowly()
   END IF
   MC.SetOpmodeCSP
   DIM previousMaxSpeed=MC.GetMaxMotorSpeed
   MC.MaxMotorSpeed=30                              
   DIM ActualPosition = MC.GetActualPosition
   MC.TargetPosition = ActualPosition + targetPosition
   'wait UNTIL position is set
   IF targetPosition<0 THEN
      targetPosition = targetPosition*-1
   END IF
   DIM SetTime = targetPosition*1000/2048 + 100 
   DELAY SetTime                                     
   'set preveious settings back
   MC.MaxMotorSpeed=previousMaxSpeed 
   SETOBJ $6060.00 = OpMode     
END FUNCTION 

FUNCTION StopSlowly()
   DIM OpMode = MC.GetActualOpmode
   MC.SetOpmodeCSV
   SETOBJ $2346.02 = TRUE 'enable setpoint filter
   SETOBJ $2346.01 =6000 ' set big TF for overdamped behavior  
   DIM actualVelocity = MC.GetActualVelocity                  
   DIM actualVelocity = MC.GetActualVelocity   
   DIM setTime= actualVelocity *5 +1500
   MC.TargetVelocity=0 
   IF setTime < 0 THEN
      DELAY (setTime*-1)       
   ELSE
      DELAY setTime
   END IF
   SETOBJ $2346.02 = FALSE 'disable setpoint filter
   SETOBJ $6060.00 = OpMode
END FUNCTION                                       

FUNCTION SetVelocitySlowly(targetVelocity)
   DIM OpMode = MC.GetActualOpmode
   MC.SetOpmodeCSV
   SETOBJ $2346.02 = TRUE 'enable setpoint filter 
   SETOBJ $2346.01 =5000 ' set big TF for overdamped behavior  
   DIM actualVelocity = MC.GetActualVelocity
   DIM setTime= (targetVelocity-actualVelocity) *5
   MC.TargetVelocity=targetVelocity 
   IF setTime < 0 THEN
      DELAY ((setTime*-1)+1500)              
   ELSE
      DELAY (setTime+1500)  
   END IF  
   SETOBJ $2346.02 = FALSE 'disable setpoint filter 
   SETOBJ $6060.00 = OpMode
END FUNCTION    
                  
    
