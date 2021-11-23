%
L001 (************************************************ Subroutine to Initialize Forge)
(Arnold Jason Glenn, 2021)
(Last modified by:  Jason Glen, 2021)
(Performs all of the forge initialization phases for the beginning of code)
FORGE_VELOCITY_MMPM = 100             
N1 M63                          (Forge Offset to Zero, reseting the forge incase that wasnt done at the end of the last users weld)
N2 M60                          (Cancel Forge Motion)
N3 G91                          (Enter Relative Coordinates)
N4 G01 PN 1 F500                (De-contact rod for force zero by moving 1mm up)
N5 M150                         (Null forces)
N6 G04 1                        (Wait for null)
N7 G01 PN -1 F500               (Return to original position)
N8 G90                          (Exit Relative Coordinates)
N9 G01 PN PinStartLoc  F500     (This is zero depth for pin axis)
N10 G01 X0 F1000                (Traverse to start point)
N11 M02 (********************************************** Return to main program)
%
