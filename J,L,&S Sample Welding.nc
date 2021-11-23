N1 %
N2 (Jason Glenn, Luk Dean, & Samuel Merritt 2021-11-15)
N3 (Last modified by:  Luk Dean  Date:  2021-11-19 )
N4 (Create 150mm long, 24mm wide, 1mm high layer of AFSD in AA7050)
N5 (End X Position is 3204, 3050 is good starting point for 6in weld)
N6 
N7 (->->->Variables Section<-<-<-)
N8 def REAL PinStartLoc = -123.627         (Starting Pin Location, needs to be updated every reload)
def Real TransitionTemperatrueOne = 235
def Real TransitionTemperatrueTwo = 350
def Real TransitionTemperatrueThree = 365

def Real Weld RPM = 450                    (RPM TO RAMP UP TO)

N24 (other Variables)
N25 S_MIN = 80                             (RPM) (MAX SPINDLE SPEED)
N26 S_MAX = 600                            (RPM) (MAX SPINDLE SPEED)

N78 (->->-> Start of Main Program <-<-<-) (->->-> Start of Main Program <-<-<-) (->->-> Start of Main Program <-<-<-) 
N79 G90 G159=7 D0                          (Absolute CNC movements) (Choose AFSD WCS) (Tool diameter Zero)             
N80 G01 Z37.5 F500                         (Moving to safe vertical distance above anvil)
N81 
N82 LL001 (Subprogram for Forge Initialization/ Forge Warm-up)
N83 
N84 G01 Z10. F500
N85 G01 Z1.0 F100                         (APROACH SURFACE OF MATERIAL)
N86 M87                                   (START DATA LOGGING)
N87 
N88 LL123 (Subprogram for Spindle Ramp Up)

N90 LL002   (Subprogram for Shoulder Temp. Building, no extrusion)
N114 LL003  (Subprogram for Puddle Temp. Building, with extrusion)
LL004       (Subprogram for temp. building to transition temperature two)
N138 LL005  (Subprogram for Linear Ramp with Temp Guidence)
LL006       (Subprogram for Transition Three)

(TEMP. CONTROL WELD SETTINGS ****************************************************************************************************************)
N28 (Setup Force Control for Z-axis)
N29 FORGE_VELOCITY_MMPM = 6
N30 FORGE_DEPTH_MM      = -2.0
N31 FORGE_FORCE_N       = 10000
N32 
N33 (set up parameters for RPM-based Temperature control)
N34 TempCtrl.Cmd.RestoreDefaults = 1
N35 G4 0.1
N36 TempCtrl.Cmd.TuningClear = 1
N37 G4 0.1
N38 (setttings for tuning & temp ctrl)
N39 TempCtrl.Parameters.SpindleMode = 1   (rpm mode)
N40 TempCtrl.Parameters.TemperatureSource = 1 (tc#3 for lord microstrain)
N41 (tuning settings)
N42 TempCtrl.Parameters.TuningTimeDelayEst = 1
N43 TempCtrl.Cmd.TuningAutoFaultRecovery = 1 (but need good theta est!)
N44 TempCtrl.Parameters.TuningRule = 3    (Medium Gains)
N45 ( 1 is servo (gentle) gains)
N46 ( 2 is regulator (aggressive) gains)
N47 ( 3 is medium gains (default for FSW))
N48 TempCtrl.Parameters.TuningSetpoint = 375
N49 (temp ctrl settings)
N50 TempCtrl.Cmd.PIDSetpoint = 375
N51 TempCtrl.Cmd.PIDEnable = 0
N52 TempCtrl.Cmd.PID_Kp = 12.88
N53 TempCtrl.Cmd.PID_Ki = 0
N54 TempCtrl.Cmd.PID_Kd = 2.88
N55 TempCtrl.Cmd.PID2Enable = 1
N56 TempCtrl.Cmd.PID2_TriggerBand = 5
N57 TempCtrl.Cmd.PID2_Kp = 12.88
N58 TempCtrl.Cmd.PID2_Ki = 2.88
N59 TempCtrl.Cmd.PID2_Kd = 2.88

N169 
N170 (TEMP. CONTROL WELD)   (TEMP. CONTROL WELD)   (TEMP. CONTROL WELD)   (TEMP. CONTROL WELD)   (TEMP. CONTROL WELD)   (TEMP. CONTROL WELD)
N171 TempCtrl.Cmd.TuningEnable  = 0 
N172 TempCtrl.Cmd.PIDEnable     = 1   (turn temp control "on" until turned off)
N173 
N174 G01 X35 F150
N175 
N176 TempCtrl.Cmd.TuningEnable  = 0
N177 TempCtrl.Cmd.PIDEnable     = 0   (turn temp control "off")
N178 
N179 
N180 
N181 M_P0_ARM = TRUE (Next forge command applies to pin)
N182 M60 (Cancel Forge)                                   (Stop extruding)
N183 PIN0_FORCE_CONTROL.Enable  = OFF
N184 FORGE_VELOCITY_MMPM        = 2
N185 FORGE_FORCE_N              = 500
N186 
N187 G91 
N188 G01 X26 F150                                         (Linear extension to remove pucker at the end of weld)
N189 G90
N190 
N191 G04 3                                                (Pause to equalize pressures)
N192 M89                                                  (DATALOGGING OFF)
N193 G01 Z5 F500                                          (Extract Tool)
N194 
N195 LL321   (Subprogram for Spindle Ramp Down)

N196 M5 (STOP SPINDLE)
N197 G01 Z75 F500
N198 FORGE_VELOCITY_MMPM = 100
N199 M63
N200 G01 X0 F2000
N201 M30                                                         (End Program)
N202 %