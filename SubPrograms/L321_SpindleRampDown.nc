%
L321 (************************************************ Subroutine to perform ramp down)
(Jason Glenn and Luk Dean, 2021-11-15)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs a spindle rpm ramp up, using some of John Boskers code smaples for inspirations)

N1 $IF  RampNumSteps > 0  (Catch divide by zero errors)
N2 RampStartRPM = 200 (TempCtrl.Status.CurrentCmd)
N3     $FOR RampStep=0, [RampNumSteps-1], 1 (Loop through Ramp steps)
N4         (Calculate new setpoints)
N5         RampPtS{RampStep} = RampStartRPM-[[RampStartRPM - FinalRPM]/RampNumSteps * [RampStep+1]] 
N6         M03 S RampPtS{RampStep}
N7     $ENDFOR 
N8 $ENDIF
N9 M02 (********************************************** Return to main program)
%