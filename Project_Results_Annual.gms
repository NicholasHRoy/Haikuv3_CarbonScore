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
$set UI_ResVers      210611

* Name of output folder
$set UI_Res %UI_ResVers%_v3
$call mkdir %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\;

* Initialize sets, parameters by running DecScen
$if not set UI_Scen $set UI_Scen  13I_LPCal_210316_v1
$if not set UI_CTax $set UI_CTax  17
$if not set UI_GrRate $set UI_GrRate  .05
$if not set UI_COTax $set UI_COTax  17
$if not set UI_FxCap $set UI_FxCap  No

$include DefScen
* Initialize parameters added in Results by running Results_Def, which is a
* copy of parameter definition section of Results
$include Results_Def

* Subsets of sets to report results in order to reduce size of results reported
Sets
    ResYr(Yr) /Yr0, Yr1, Yr5, Yr7, Yr8, Yr9, Yr10, Yr11, Yr13, Yr15, Yr20, Yr25, Yr30/
    ResPPAR(PPAR) /Nat,NECES,PJMCES,SPPCES,TXCES,NYCES,CACES,MISOCES,SECES,WECCCES/
;

$set UI_RunResults      No

Parameters
    KeyRes(*,*,*,*,*,*,*) !! Scen,Scen,Var,Yr,PPAR,Fuel,MP
;

*UI_ScenName is the shortened name of a scenario that is used downstream. The idea is that even if UI_Scen changes, for
*example from v1 to v2, UI_ScenName will not change.

*$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log


*~*~-----------------------------------------------------------------------------

$set UI_ScenName LPCal
$set UI_Scen     13I_LPCal_210316_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-SFC.gms

$set UI_ScenName LPBLCal
$set UI_Scen     13I_LPBLCal_210316_v1
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-SFC.gms

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
$call copy Project_Results_Annual-SFC.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Project_Results_SeaTB-SFC.gms
$call copy Results_Key_Annual-SFC.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Results_Key_Annual-SFC-SFC.gms


