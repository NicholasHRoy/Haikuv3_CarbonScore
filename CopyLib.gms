*$set lib_dir L:\Project-Gurobi\Workspace3\PDP_Other\200106_HaikuLP_PDP\lib
$set lib_dir lib

* Init
$call copy %lib_dir%\Init.gms                              Init.gms

* (0) Option Files
$call copy %lib_dir%\00_Opts\ConvertD.opt                  ConvertD.opt
$call copy %lib_dir%\00_Opts\cplex.opt                     cplex.opt
$call copy %lib_dir%\00_Opts\gamschk.opt                   gamschk.opt
$call copy %lib_dir%\00_Opts\gdx2xls.ini                   gdx2xls.ini
$call copy %lib_dir%\00_Opts\MCP_SclItrp.gck               MCP_SclItrp.gck
$call copy %lib_dir%\00_Opts\path.opt                      path.opt

* (1) DefScen
$call copy %lib_dir%\01_DefScen\DefScen.gms                DefScen.gms
$call copy %lib_dir%\01_DefScen\macros_utility.gms         macros_utility.gms
$call copy %lib_dir%\01_DefScen\DS1_Macros.gms             DS1_Macros.gms
$call copy %lib_dir%\01_DefScen\DS2_DecSetsPrm_LdData.gms  DS2_DecSetsPrm_LdData.gms
$call copy %lib_dir%\01_DefScen\DS3_General.gms            DS3_General.gms
$call copy %lib_dir%\01_DefScen\DS4_PPAR.gms               DS4_PPAR.gms
$call copy %lib_dir%\01_DefScen\DS4a_Consumption.gms       DS4a_Consumption.gms
$call copy %lib_dir%\01_DefScen\DS5_DecVarEqMdl.gms        DS5_DecVarEqMdl.gms
$call copy %lib_dir%\01_DefScen\DS6_LdInitVar.gms          DS6_LdInitVar.gms
$call copy %lib_dir%\01_DefScen\DS7_Bnds.gms               DS7_Bnds.gms
$call copy %lib_dir%\01_DefScen\DS7a_TwkACF.gms            DS7a_TwkACF.gms
$call copy %lib_dir%\01_DefScen\DS8_PolOpts_Emis.gms       DS8_PolOpts_Emis.gms
$call copy %lib_dir%\01_DefScen\DS9_PolOpts_PS.gms         DS9_PolOpts_PS.gms
$call copy %lib_dir%\01_DefScen\SetPPARMapping.gms         SetPPARMapping.gms

* (2) Model
$call copy %lib_dir%\02_Model\SolveLP.gms                  SolveLP.gms
$call copy %lib_dir%\02_Model\LPEq.gms                     LPEq.gms
$call copy %lib_dir%\02_Model\ApplySlope.gms               ApplySlope.gms
$call copy %lib_dir%\02_Model\LPPost.gms                   LPPost.gms
$call copy %lib_dir%\02_Model\Diagnostics.gms              Diagnostics.gms
$call copy %lib_dir%\02_Model\RtlPrc.gms                   RtlPrc.gms
$call copy %lib_dir%\02_Model\SolveLP_Iterate5.gms         SolveLP_Iterate5.gms
$call copy %lib_dir%\02_Model\SolveLP_CPrcIt.gms           SolveLP_CPrcIt.gms
$call copy %lib_dir%\02_Model\SolveLP_CCapIt.gms           SolveLP_CCapIt.gms

* (3) Results
$call copy %lib_dir%\03_Results\Results.gms                Results.gms
$call copy %lib_dir%\03_Results\Results_Def.gms            Results_Def.gms
$call copy %lib_dir%\03_Results\Results_CalcRes.gms        Results_CalcRes.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual.gms     Results_Key_Annual.gms
$call copy %lib_dir%\03_Results\Results_Key_SeaTB.gms      Results_Key_SeaTB.gms
$call copy %lib_dir%\03_Results\Results_E4.gms             Results_E4.gms
$call copy %lib_dir%\03_Results\Results_ChkObjRtl.gms      Results_ChkObjRtl.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual-CSP.gms Results_Key_Annual-CSP.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual-SFC.gms Results_Key_Annual-SFC.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual-IRA.gms Results_Key_Annual-IRA.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual-VA.gms  Results_Key_Annual-VA.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual_States.gms  Results_Key_Annual_States.gms
$call copy %lib_dir%\03_Results\Results_Key_Annual_NG.gms  Results_Key_Annual_NG.gms

* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
* ARCHIVE
*$call copy %lib_dir%\02_Model\LPPost2.gms                  LPPost2.gms
*$call copy %lib_dir%\02_Model\SolveLP_TCI.gms              SolveLP_TCI.gms
*$call copy %lib_dir%\02_Model\SolveLP_TCI2.gms             SolveLP_TCI2.gms
*$call copy %lib_dir%\02_Model\SolveLP_TCI3.gms             SolveLP_TCI3.gms
*$call copy %lib_dir%\02_Model\SolveLPTmp.gms               SolveLPTmp.gms

*$call copy %lib_dir%\03_Results\Results_CalcRes2.gms       Results_CalcRes2.gms
*$call copy %lib_dir%\03_Results\Results_Key2.gms           Results_Key2.gms
*$call copy %lib_dir%\03_Results\Results_ChkObjRtl2.gms     Results_ChkObjRtl2.gms

$ontext
$call copy %lib_dir%\03_Results\Results_CompScen.gms       Results_CompScen.gms
$call copy %lib_dir%\03_Results\Results_ExpCGE.gms         Results_ExpCGE.gms

$call copy %lib_dir%\02_Model\MCPEq.gms                   MCPEq.gms
$call copy %lib_dir%\MCP_DictMap.gms         MCP_DictMap.gms

$call copy %lib_dir%\MCP_SclItrp.gms         MCP_SclItrp.gms
$call copy %lib_dir%\MCPScale.gms            MCPScale.gms
$call copy %lib_dir%\Interp.gms              Interp.gms

$call copy %lib_dir%\MCP_Slv.gms             MCP_Slv.gms
$call copy %lib_dir%\MCPEq.gms               MCPEq.gms

$call copy %lib_dir%\SetPPAR.gms             SetPPAR.gms
$call copy %lib_dir%\SetPPARMapping.gms      SetPPARMapping.gms
$call copy %lib_dir%\PolOpts_Emis.gms        PolOpts_Emis.gms
$call copy %lib_dir%\PolOpts_Emis_RGGI.gms   PolOpts_Emis_RGGI.gms
$call copy %lib_dir%\PolOpts_PS.gms          PolOpts_PS.gms

$call copy %lib_dir%\Results.gms             Results.gms
$call copy %lib_dir%\Results_CheckEE2.gms    Results_CheckEE2.gms
$call copy %lib_dir%\Results_CheckMCPGen.gms Results_CheckMCPGen.gms

*$call copy %lib_dir%\Results_RGGI.gms        Results_RGGI.gms
$call copy %lib_dir%\Results_Def.gms         Results_Def.gms
$call copy %lib_dir%\KeyResults.gms          KeyResults.gms
$offtext
