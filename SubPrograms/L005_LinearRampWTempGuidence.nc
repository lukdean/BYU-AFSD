%
L005 (************************************************ Subroutine to perform linear ramp after puddle)
(Jason Glenn and Luk Dean, 2021-11-22)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs a linear ramp up while also buidling temp, using some of John Boskers code smaples for inspirations)

def REAL XFeed      = 150    (Initializing variables, feed rate for the linear ramp build)
def REAL XDistance  = 10     (Initializing variables, the distance that the linear ramp should happen in)
def REAL XSteps     = 10     (Initializing variables, the number of steps that we would like to control temp in.)

PIN0_FORCE_CONTROL.VEL     = 16.650
PIN0_FORCE_CONTROL.DEPTH   = -200
PIN0_FORCE_CONTROL.FORCE   = 15000

def REAL PD         = 0      (Initializing variables, pin depth for low temps)
def REAL PD2        = 0      (Initializing variables, pin depth for high temps)
def REAL PV         = 0      (Initializing variables, pin velocity for low temps)
def REAL PV2        = 0      (Initializing variables, pin velocity for high temps)
def REAL PinExtru   = -6.5   (Initializing variables, max pin extusion for low temps)   (Note, this cannot be higher than 7.125 or 5.7/.8 else you have to increase the 5.7 value)
def REAL PinExtru2  = -5.7   (Initializing variables, max pin extrusion for high temps) (Note, this cannot be higher than 7.125 or 5.7/.8 else you have to increase the 5.7 value)

N1 $FOR i = 1, [i < [XSteps + 1]], 1                               (Loop through number of ramps)
N2	$IF TempCtrl.Status.T < 330	(************************************************************* if less than 330 degrees)
N4		$IF 
N5			PD = [PinExtru / XSteps] * i
N6			PV = [PD - PD2] / [PinExtru / XSteps] * PinExtru * -10
N7			PIN0_FORCE_CONTROL.VEL   = PV
N8			PIN0_FORCE_CONTROL.DEPTH = PD
N9          M_P0_ARM = TRUE
N10			M62											(What for pin to depth)
N11 G91 G1 X [XDistance / XSteps] F [[XFeed / XDistance] * i]
N12			PD2 = PD
N13
N14		$IF PD = 0
N15			PD = [PinExtru / XSteps] * i						
N16			PIN0_FORCE_CONTROL.VEL = PinExtru * -10	    (alwyas equal to -65, because only for starting temps)
N17			PIN0_FORCE_CONTROL.DEPTH = PD
N19         M_P0_ARM = TRUE
N20			M62											(What for pin to depth)
N21 G91 G1 X [XDistance / XSteps] F [[XFeed / XDistance] * i]
N22
N23	$If TempCtrl.Status.T >= 330 (************************************************************ if more than 330 degrees)
N24		$IF PD > 0
N25			PD2 = [PinExtru2 / XSteps] * i
N26			PV  = [PD2 - PD] / [PinExtru2 / XSteps] * PinExtru2 * -10
N27			PIN0_FORCE_CONTROL.VEL   = PV
N28			PIN0_FORCE_CONTROL.DEPTH = PD2
N29         M_P0_ARM = TRUE
N30			M62											(What for pin to depth)
N31 G91 G1 X [XDistance / XSteps] F [[XFeed / XDistance] * i]
N32			PD2 = PD
N33
N34		$IF PD = 0
N35			PD2 = [PinExtru2 / XSteps] * i
N36			PIN0_FORCE_CONTROL.VEL   = PinExtru2 * -10 	(always equal to -57, because only for starting temps)
N37			PIN0_FORCE_CONTROL.DEPTH = PD2
N38         M_P0_ARM = TRUE
N39		    M62											(What for pin to depth)
N40 G91 G1 X [XDistance / XSteps] F [[XFeed / XDistance] * i]
N41 $ENDFOR 
N42 G90                                                     (Return to absolute positions)
N43 M02 (********************************************** Return to main program)
%