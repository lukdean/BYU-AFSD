%
L003 (************************************************ Subroutine for puddle building temp)
(Jason Glenn and Luk Dean, 2021-11-15)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs operations to make puddle building in the intiation of the weld)
(Note:  This code is ment to controll the puddle build up of an AFSD deposit.  1mm deep of a 25mm diameter tool requires 5.7mm of rod extrusion to fill the area.  When I extrude that ammount of rod, usually the temperature does not increase much.  If I want the tool temperature to increase then I need to over extrude material into that area [for example 6.5mm of rod estrusion].  At the start of this code, the shoulder of the tool is in contact with the base plate and and will start lifting up.  It has to move up about 1.2 mm and will do so at 12mm/m so it will take 6 seconds untill the shoulder is in the right position to start the linear weld. This code breaks up the 6 seconds into 5 1.2s steps so that I can swap between over extruding or extruding the right ammount to controll the heat output.) 

(Dwell With Pin Extrusion)
(Setup Force Control for Pin)
PIN0_FORCE_CONTROL.FORCE   = 15000
PIN0_FORCE_CONTROL.Enable  = ON
FORGE_VELOCITY_MMPM        = 12.23
FORGE_DEPTH_MM             = -2.0
FORGE_FORCE_N              = 15100

def REAL PD         = 0      (Initializing variables, pin depth for low temps)
def REAL PD2        = 0      (Initializing variables, pin depth for high temps)
def REAL PV         = 0      (Initializing variables, pin velocity for low temps)
def REAL PV2        = 0      (Initializing variables, pin velocity for high temps)
def REAL PinExtru   = -6.5   (Initializing variables, max pin extusion for low temps)   (Note, this cannot be higher than 7.125 or 5.7/.8 else you have to increase the 5.7 value)
def REAL PinExtru2  = -5.7   (Initializing variables, max pin extrusion for high temps) (Note, this cannot be higher than 7.125 or 5.7/.8 else you have to increase the 5.7 value)

N1 $FOR i = 1, [i < 1], 1                               (Loop through number of ramps)
N2	$IF TempCtrl.Status.T < 330	(************************************************************* if less than 330 degrees)
N4		$IF 
N5			PD = [PinExtru / 5] * i
N6			PV = [PD - PD2] / [PinExtru / 5] * PinExtru * -10
N7			PIN0_FORCE_CONTROL.VEL   = PV
N8			PIN0_FORCE_CONTROL.DEPTH = PD
N9          M_P0_ARM = TRUE
N10			M62											(What for pin to depth)
N11			PD2 = PD
N12
N13		$IF PD = 0
N14			PD = [PinExtru / 5] * i						
N15			PIN0_FORCE_CONTROL.VEL = PinExtru * -10	    (alwyas equal to -65, because only for starting temps)
N16			PIN0_FORCE_CONTROL.DEPTH = PD
N17         M_P0_ARM = TRUE
N18			M62											(What for pin to depth)
N19	$If TempCtrl.Status.T >= 330 (************************************************************ if more than 330 degrees)
N20		$IF PD > 0
N21			PD2 = [PinExtru2 / 5] * i
N22			PV  = [PD2 - PD] / [PinExtru2 / 5] * PinExtru2 * -10
N23			PIN0_FORCE_CONTROL.VEL   = PV
N24			PIN0_FORCE_CONTROL.DEPTH = PD2
N25         M_P0_ARM = TRUE
N26			M62											(What for pin to depth)
N27			PD2 = PD
N28
N29		$IF PD = 0
N30			PD2 = [PinExtru2 / 5] * i
N31			PIN0_FORCE_CONTROL.VEL   = PinExtru2 * -10 	(always equal to -57, because only for starting temps)
N32			PIN0_FORCE_CONTROL.DEPTH = PD2
N33         M_P0_ARM = TRUE
N34		    M62											(What for pin to depth)
N35 $ENDFOR 
N36 M63                                  (Bring Forge to 0 posiion) (What does this do?/ Why is this here?)
N37 FORGE_VELOCITY_MMPM = 0              (What is this for?)
N38 M02 (return to main program)
%