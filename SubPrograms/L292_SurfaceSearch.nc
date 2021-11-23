%
L292 (************************************************ Subroutine for Auto Surface Search)
(Jason Glenn and Samuel Merritt, 2021-11-15)
(Last modified by:  Luk Dean, 2021-11-22: Formating)
(Performs a surface search to be able to mulitple layer printing automatic no need for manual probing)

def REAL PlungePointZ           = 0.0   (mm, Plunge position Z)
def REAL ZNominalStart          = 5     (mm above surface)
def REAL SurfaceSearchForce     = 500   (N)
def REAL SurfaceSearchVelocity  = 100   (mmPM)
def REAL ZStart                 = 0     (Just initializing a variable here, no need to change this)

N1  G192 Z0                             (Clearout any previous Z shift)
N2  G00 Z [PlungePointZ + ZNominalStart]
N3  M63                                 (Zero Forge Depth Position)
N4  M05                                 (Spindle Stop)
N5  M150                                (Null Forces)
N6  G172                                (Decoder Path Synchronization)
N8  ZStart = ZAxisMotorPos (            Capture Motor Position at Start of Search)
N9    
N10 (Perform Search for Surface ***********************)
N11 FORGE_FORCE                 = SurfaceSearchForce
N12 FORGE_DEPTH                 = -ZNominalStart -5.0
N13 FORGE_VELOCITY              = SurfaceSearchVelocity
N14 G04 0.5                             (Wait for Force to be achieved)
N15 M64             
N18 G04 2.0                             (Wait for Force to settle)
N19 G172                                (Decoder Path Synchronization)
N20 
N21 (Calculation Coordinate System SHIFT ***************)
N22 ZShift = ZNominalStart - ABS[ZAxisMotorPos - ZStart]
N23 
N24 (Retract Forge to Zero *****************************)
N25 FORGE_VELOCITY = 1000
N26 M63                                 (Retract Forge)
N27 
N28 (Apply Coordinate Shift for Z only *****************)
N29 G192 Z ZShift
N30 M02
%