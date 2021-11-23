%
L004 (************************************************ Subroutine to perform Temp Correction to Transistion Temp Two)
(Jason Glenn and Luk Dean, 2021-11-22)
(Last modified by:  Luk Dean, 2021-11-19)
(Performs a linear ramp up while also buidling temp, using some of John Boskers code smaples for inspirations)

def REAL SpindleRPM                = WeldRPM

N1  $IF TempCtrl.Status.T > TransitionTemperatureTwo
N2      SpindleRPM = SpindleRPM - 50
N3      M03 S SpindleRPM
N4  $ENDIF
N5  $IF TempCtrl.Status.T < TransitionTemperatureTwo
N6      SpindleRPM = SpindleRPM + 50
N7      M03 S SpindleRPM
N8  $ENDIF
N9 M02 (********************************************** Return to main program)
%

(alternate)
%
N1  $WHILE TempCtrl.Status.T < TransitionTemperatureTwo
N2      $IF [NewValue > 6000]
N3          $BREAK
N4      $ENDIF
N5      NewValue = NewValue + 1
N6      G04 0.01                          (Wait for a bit)
N7     G172                              (Sync Preprocessor) (This means dont look ahead an pre-grab values, or else the while comparison will use stale values)
N8 $ENDWHILE
N9 M02 (return to main program)
%