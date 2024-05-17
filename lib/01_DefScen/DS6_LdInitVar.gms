
*Load initial variable and calibrator values.
*-----------------------------------------------------------------------------------------------------------------------
put dummy;

$ifthen.load %UI_Func% == Res
*Load from a solution for DictMap, SclItrp, Results. Load only calibrators for LP.
*POTENTIAL PROBLEMS DEALING WITH MISSING VARIABLES/EQUATIONS
    put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\%UI_InitVar%';
    execute_load
            ListVarCore(noFunc,noEq,none,'','',',',none),
            TotCostLP, TotCost_YrHMR, Obj, ObjInt,
            NPCapEQ, SupDemEq, RsvMrgEq, GenLeCapEq, NoDspEq
;
$endif.load

$ifthen not %UI_ScenKnl% == LPCal
    put_utility 'gdxin' / '%UI_RootDir%\..\Shared\Solutions\Calibration\%UI_InitCal%';
    execute_load
            ListVarCal(noFunc,noEq,none,'','',',',none),
            ListPrm(noFunc,noEq,none,'','',',',none),
            CalEPrcRtl, CalEPrcRtl2,CalGenEq,CalGenEq2,CalGenPPAREq,CalGenTotEq,CalEmisEq,CalEmisRGGIEq
;
$endif

putclose;
