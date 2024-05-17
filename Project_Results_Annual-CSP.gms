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
$set UI_ResVers      240207
$set UI_USD          2019

* Name of output folder
$set UI_Res %UI_ResVers%_v9_CSP_31CSP_EVEmisAdj-psfin
$call mkdir %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\;

* Initialize sets, parameters by running DecScen
$if not set UI_Scen         $set UI_Scen  31CSP_LPCal_231006_v5
$if not set UI_InitVar      $set UI_InitVar %UI_vHaiku%_%UI_Scen%
$if not set UI_CTax         $set UI_CTax  17
$if not set UI_GrRate       $set UI_GrRate  0
$if not set UI_COTax        $set UI_COTax  17
$if not set UI_FxGen        $set UI_FxGen 0
$if not set UI_FxCap        $set UI_FxCap  0
$if not set UI_CTaxStYr     $set UI_CTaxStYr  2050
$if not set UI_GrowCap      $set UI_GrowCap  3000
$if not set UI_FxNukeGen    $set UI_FxNukeGen  3000
$if not set UI_GrowCapPct   $set UI_GrowCapPct  0.07 !! [0.07, 0.10]


$include DefScen
* Initialize parameters added in Results by running Results_Def, which is a
* copy of parameter definition section of Results
$include Results_Def

* Subsets of sets to report results in order to reduce size of results reported
Sets
*ResYr(Yr) /Yr0, Yr1, Yr2, Yr3, Yr4, Yr5, Yr6, Yr9, Yr11, Yr16, Yr21, Yr26, Yr31/
*ResYr(Yr) /Yr0, Yr1, Yr3, Yr4, Yr5, Yr6, Yr7, Yr8, Yr9, Yr10, Yr11, Yr12, Yr13, Yr14, Yr15, Yr16, Yr21, Yr26/
ResYr(Yr) /Yr0, Yr1, Yr2, Yr3, Yr4, Yr5, Yr6, Yr7, Yr8, Yr9,
        Yr10, Yr11, Yr12, Yr13, Yr14, Yr15, Yr16, Yr17, Yr18, Yr19,
        Yr20, Yr21, Yr22, Yr23, Yr24, Yr25, Yr26, Yr27, Yr28, Yr29,
        Yr30, Yr31/
ResPPAR(PPAR) /Nat, RGGI11, ESC, WSC, MTN, PAC, NEG, SAL, WNC, ENC, MAL/
ResHMR(HMR) /AL, AZ, AR, CA, CO, CT, DE, FL, GA, ID, IL, IN, IA, KS, KY, LA, ME, MD, MA, MI,
                MN, MS, MO, MT, NE, NV, NH, NJ, NM, NY, NC, ND, OH, OK, OR, PA, RI, SC, SD, TN,
                TX, UT, VT, VA, WA, WV, WI, WY, DC/
;

$set UI_RunResults      No

Parameters
    KeyRes(*,*,*,*,*,*,*) !! Scen,Scen,Var,Yr,ResRegion,Fuel,MP
;

*UI_ScenName is the shortened name of a scenario that is used downstream. The idea is that even if UI_Scen changes, for
*example from v1 to v2, UI_ScenName will not change.

*$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log

Parameter
Emis0AEO(YrFull,HMR,Sector,AEOscen)
Emis0CSP(YrFull,HMR,Sector,AEOscen);

$call gdxxrw.exe "Emis0CSP.xlsx" par=Emis0AEO rdim=4 rng=Emis0AEO!A2:E32641 Output="Emis0AEO.gdx"
$gdxin "Emis0AEO.gdx"
$load Emis0AEO
$gdxin

$call gdxxrw.exe "Emis0CSP.xlsx" par=Emis0CSP rdim=4 rng=Emis0CSP!A2:E32641 Output="Emis0CSP.gdx"
$gdxin "Emis0CSP.gdx"
$load Emis0CSP
$gdxin

*~*~-----------------------------------------------------------------------------

$setglobal UI_CSP       CSP

$setglobal UI_Demand    noIRA

$set UI_ScenName CSP2022
$set UI_Scen     31CSP_BL_231006_v9_CSP_DemnoIRA_NGBL2023
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2022_oldNG
$set UI_Scen     31CSP_BL_231006_v5_CSP_DemnoIRA_NGBL2022
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName GN_noIRA
$set UI_Scen     31CSP_BLCSAPR_231006_v9_CSP_DemnoIRA_NGBL2023_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$setglobal UI_Demand    ref2023

$set UI_ScenName CSP2023
$set UI_Scen     31CSP_CSP_231006_v9_CSP_Demref2023_NGBLIRA2023_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2023_oldNG
$set UI_Scen     31CSP_BLIRA_231006_v5_CSP_Demref2023_NGBL2022_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2023_CCS
$set UI_Scen     31CSP_CSP_231006_v9_CSP_Demref2023_NGBLIRA2023_CCSNo
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2023_noGN
$set UI_Scen     31CSP_BLIRA_231006_v9_CSP_Demref2023_NGBLIRA2023_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$setglobal UI_Demand    lowogs

$set UI_ScenName CSP2022_HighFGPrc
$set UI_Scen     31CSP_BL_231006_v9_CSP_DemnoIRA_NGHigh2023
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2023_HighFGPrc
$set UI_Scen     31CSP_CSP_231006_v9_CSP_Demlowogs_NGHigh2023_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$setglobal UI_Demand    highogs

$set UI_ScenName CSP2023_LowFGPrc
$set UI_Scen     31CSP_CSP_231006_v9_CSP_Demhighogs_NGLow2023_CCSYes
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

$set UI_ScenName CSP2022_LowFGPrc
$set UI_Scen     31CSP_BL_231006_v9_CSP_DemnoIRA_NGLow2023
$if %UI_RunResults% == Yes $call gams Results     --UI_Scen=%UI_Scen% o=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.lst lo=2 lf=%UI_RootDir%\Output\%UI_Scen%\Res_%UI_Scen%.log
$if not %UI_Scen% == NA $include Results_Key_Annual-CSP.gms

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
$call copy Project_Results_Annual-CSP.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Project_Results_Annual-CSP.gms
$call copy Results_Key_Annual-CSP.gms %UI_RootDir%\KeyResults\KeyRes_%UI_Res%\Results_Key_Annual-CSP.gms


