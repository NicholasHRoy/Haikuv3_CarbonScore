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
$set UI_RptAllPPAR   Yes !! [Yes,No] Activate all PPARs for reporting? Yes only for running Results.gms.
$set UI_ResVers      220218

* Name of output folder
$set UI_Res %UI_ResVers%_v1_IRAReportInitialSensitivites
$call mkdir %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\;

* Initialize sets, parameters by running DecScen
$if not set UI_Scen       $set UI_Scen  18IRA_LPCal_220715_v1
$if not set UI_CTax       $set UI_CTax  17
$if not set UI_GrRate     $set UI_GrRate  .05
$if not set UI_CTaxStYr   $set UI_CTaxStYr 2022
$if not set UI_COTax      $set UI_COTax  17
$if not set UI_FxCap      $set UI_FxCap  No

$include DefScen
* Initialize parameters added in Results by running Results_Def, which is a
* copy of parameter definition section of Results
$include Results_Def

* Subsets of sets to report results in order to reduce size of results reported
Sets
    ResYr(Yr) /Yr0, Yr1, Yr2, Yr3, Yr13, Yr26/
    ResPPAR(PPAR) /Nat, RGGI9, RGGI11, RGGI12, CA/
    ResHMR(HMR)   /CO/
;



$set UI_RunResults      No

Parameters
    KeyRes(*,*,*,*,*,*,*,*,*,*,*) !! Scen,Var,Yr,PPAR,Fuel,MP,Pol
;

*UI_ScenName is the shortened name of a scenario that is used downstream. The idea is that even if UI_Scen changes, for
*example from v1 to v2, UI_ScenName will not change.

*$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log


*~*~-----------------------------------------------------------------------------
$set UI_ScenName LPCal
$set UI_Scen     6K_LPCal_220111_v5_AEORE
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_SeaTB.gms

$set UI_ScenName LPBLCal
$set UI_Scen     6K_LPBLCal_220111_v5_AEORE
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_SeaTB.gms

$set UI_ScenName LPBLCal_RPS
$set UI_Scen     6K_LPBLCal_220111_v5_AEORE_RPS
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_SeaTB.gms

$set UI_ScenName BLRE
$set UI_Scen     6K_BLRE_220111_v5_NRELRE
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_SeaTB.gms

$set UI_ScenName BLRE_RPS
$set UI_Scen     6K_BLRE_220111_v5_NRELRE_RPS
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_SeaTB.gms

*~*---------------------------------------------------------------------------------

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

*copy this file and the current version of Results_Key_SeaTB into the folder
$call copy Project_Results_SeaTB.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Project_Results_SeaTB.gms
$call copy Results_Key_SeaTB.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Results_Key_SeaTB.gms


