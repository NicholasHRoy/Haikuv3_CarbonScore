$Title Results
$OffUpper
$OnSymList
$eolcom !!
$inlinecom { }

$include CopyLib
$include Init


* User inputs
*-----------------------------------------------------------------------------------------------------------------------
$set UI_Func         Res !! [DM,SI,Slv,Res] run which function?
$set UI_SetPol       No !! [Yes,No] Run EmisPol_Opts?
$set UI_RptAllPPAR   No !! [Yes,No] Activate all PPARs for reporting? Yes only for running Results.gms.
$set UI_ResVers      230214

* Name of output folder
$set UI_Res %UI_ResVers%_v3_StatesStyle
$call mkdir %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\;

* Initialize sets, parameters by running DecScen
$if not set UI_Scen      $set UI_Scen  18IRA_LPCal_221024_v1
$if not set UI_CTax      $set UI_CTax  17
$if not set UI_GrRate    $set UI_GrRate  0
$if not set UI_COTax     $set UI_COTax  17
$if not set UI_FxGen     $set UI_FxGen 0
$if not set UI_FxCap     $set UI_FxCap  0
$if not set UI_CTaxStYr  $set  UI_CTaxStYr  2050
$if not set UI_GrowCap   $set UI_GrowCap  3000
$if not set UI_FxNukeGen $set UI_FxNukeGen  3000
$if not set  UI_GrowCapPct   $set UI_GrowCapPct  0.07 !! [0.07, 0.10]

$include DefScen
* Initialize parameters added in Results by running Results_Def, which is a
* copy of parameter definition section of Results
$include Results_Def



* Subsets of sets to report results in order to reduce size of results reported
Sets
ResYr(Yr) /Yr0, Yr1, Yr3, Yr4, Yr5, Yr6, Yr7, Yr8, Yr9, Yr10, Yr11, Yr12, Yr13, Yr14, Yr15, Yr16, Yr21, Yr26/
ResHMR(HMR) /AL, AZ, AR, CA, CO, CT, DE, FL, GA, ID, IL, IN, IA, KS, KY, LA, ME, MD, MA, MI,
                MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, OH, OK, OR, PA, RI, SC, SD, TN,
                TX, UT, VT, VA, WA, WV, WI, WY, DC/
ResPPAR(PPAR) /Nat, AL, AZ, AR, CA, CO, CT, DE, FL, GA, ID, IL, IN, IA, KS, KY, LA, ME, MD, MA, MI,
                MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, OH, OK, OR, PA, RI, SC, SD, TN,
                TX, UT, VT, VA, WA, WV, WI, WY, DC/
;

$set UI_RunResults      No

Parameters
    KeyRes(*,*,*,*,*,*,*,*) !! Scen,Scen,Var,Yr,PPAR,Fuel,MP
;

*UI_ScenName is the shortened name of a scenario that is used downstream. The idea is that even if UI_Scen changes, for
*example from v1 to v2, UI_ScenName will not change.

*$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log


*~*~-----------------------------------------------------------------------------

$onText
$set UI_ScenName LPCal_new
$set UI_Scen     18IRA_LPCal_221024_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName LPBLCal_new
$set UI_Scen     18IRA_LPBLCal_221024_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName BLAEO_new
$set UI_Scen     18IRA_BLAEO_221024_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName BLNREL_new
$set UI_Scen     18IRA_BLNREL_221024_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms
$offText

$set UI_ScenName BL_new
$set UI_Scen     18IRA_BL_221024_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName IRA_Central_new
$set UI_Scen     18IRA_BLIRA_221024_v1_Central
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName IRA_Low_new
$set UI_Scen     18IRA_BLIRA_221024_v1_Low
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

$set UI_ScenName IRA_High_new
$set UI_Scen     18IRA_BLIRA_221024_v1_High
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual_States.gms

*--------------------------------------------------------------------------------


put dummy;
put_utility 'gdxout' / '%UI_RootDir%/KeyResults/KeyRes_%UI_Res%/KeyRes_%UI_vHaiku%_%UI_Res%';
execute_unload
KeyRes
;
putclose;

$onecho > gdx2xls.ini
[settings]
sorttoc=false
freezeheader=1
valueformat=#,###.###
$offecho
execute 'gdx2xls %UI_RootDir%/KeyResults/KeyRes_%UI_Res%/KeyRes_%UI_vHaiku%_%UI_Res% @gdx2xls.ini';

*copy this file and the current version of Results_Key_Annual-SFC into the folder
$call copy Project_Results_Annual_States.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Project_Results_Annual_States.gms
$call copy Results_Key_Annual_States.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Results_Key_Annual_States.gms


