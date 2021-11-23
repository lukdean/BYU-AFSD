%
L006 (************************************************ Subroutine to perform Temp Correction to Transistion Temp Three)
(Jason Glenn and Luk Dean, 2021-11-22)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs a linear ramp up while also buidling temp, using some of John Boskers code smaples for inspirations)

def REAL SpindleRPM  = WeldRPM

N1 ($WHILE TempCtrl.Status.T < TransitionTemperatureThree
N2 (G1 X25.000 F150.000
N3 (G172
N4 ($ENDWHILE
N5 
N165 ($IF TempCtrl.Status.T > TransitionTemperatureThree
N166 (SpindleRPM = SpindleRPM - 35
N167 (G1 X26.000 F150.000 S SpindleRPM
N168 ($ENDIF
N9 M02 (return to main program)
%
NewValue = 1

N4  $WHILE TempCtrl.Status.T < TransitionTemperatureOne
N5      $IF [NewValue > 6000]
N6          $BREAK
N7      $ENDIF
N8      NewValue = NewValue + 1
N9  G04 0.01                          (Wait for a bit)
N10 G172                              (Sync Preprocessor) (This means dont look ahead an pre-grab values, or else the while comparison will use stale values)
N11 $ENDWHILE
N12 M02 (return to main program)
%