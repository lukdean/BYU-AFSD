%
L123 (************************************************ Subroutine to perform ramp up)
(Jason Glenn and Luk Dean, 2021-11-15)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs a spindle rpm ramp down, using some of John Boskers code smaples for inspirations)

(def REAL WeldRPM                = 450 (RPM to ramp up to. If over 1200 note comment below)
DEFINE   RampNumSteps           AS 60 (Number Steps for ramping phase. If ramping top over 1200 increase steps to 120)
def REAL RampStartRPM           = 5   (RPM that the motor will turn on to before starting the Ramp. 5 is a good value)
def UINT RampStep               = 0   (Just initializing a varaible here, no need to change this)
def REAL RampPtS{ampNumSteps}         (Just initializing a varaible here, no need to change this)
def REAL FinalRPM               = 0   (Just initializing a varaible here, no need to change this)
 

N1 $IF  RampNumSteps > 0  (Catch divide by zero errors)
N2 S RampStartRPM
N3     $FOR RampStep=0, [RampNumSteps-1], 1 (Loop through Ramp steps)
N4         (Calculate new setpoints)
N5         RampPtS{RampStep} = [WeldRPM - RampStartRPM] / RampNumSteps * [RampStep+1] + RampStartRPM 
N6         M03 S RampPtS{RampStep}
N7     $ENDFOR 
N8 $ENDIF
N9 M02 (********************************************** Return to main program)
%