$setglobal UI_vHaiku     230901_CSP!! version of model corresponds to the name of the folder
$setglobal UI_vHaikuPrev 230707_CCSRetrofitTests !! previous version of the model
$setglobal UI_RootDir    T:\Haikuv3\GAMS_161201\Scenarios\%UI_vHaiku% !! path for GAMS input
$setglobal UI_pathGAMS   T:\Haikuv3\GAMS_161201\Scenarios\Shared\Inputs !! path for GAMS input
$setglobal UI_SclInput   190709 !!}190610!!190307!!181218 !! version of spreadsheet for scale coefficients data
$setglobal UI_vInputs    231006 !! 230927, 230927, 230714 !!210212_20pct !! 191017!!}{191015!!}191010!!}191009!!}191001!!}190705!!180913 !! version of input data
$setglobal UI_LP_Tol     1E-9 !! optimality tolerance for LP
$setglobal UI_MCP_ItLim  2E9!!}0 !! MCP iterations limit
$setglobal UI_MCP_TmLim  129600 !! MCP time limit (172800sec=48hrs, 129600sec=36hrs, 86400sec=24hrs)

$setglobal UI_slpV       1
$setglobal UI_slpT       1
$setglobal UI_slpCC      25
$setglobal UI_fxDem      0 !! %UI_vHaiku%_%UI_Yrs%_BL !! [0,scenario] fix demand
$setglobal UI_fxTrans    0 !! [0,Cal] fix transmission to calibrator level or not
