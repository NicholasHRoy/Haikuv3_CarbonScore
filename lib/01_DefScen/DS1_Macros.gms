$include macros_utility

* Lists of variables and equations, including characteristics. Activated via macro f.
*------------------------------------------------------------------
$macro ListVarCore(f,Eq,Eqdims,pre,post,dlm,Xdims) \
*         VarEq,                                Ndims,VarOREq,iORj,dims,loBnd,  XVE,othVEdims,Xdims)
        f(&&pre&NPCap&&post&,                   4,Var,j,',HMR,MP',0,            Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&Gen&&post&,                     6,Var,j,',HMR,MP,Sea,TB',0,     Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&Trans&&post&,                   6,Var,j,',HMRe,HMRi,Sea,TB',0,  Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&EPrcRtl&&post&,                 4,Var,j,',HMR,Sea',-INF,        Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&ECons&&post&,                   5,Var,j,',HMR,Sea,TB',-INF,     Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&gamma&&post&,                   4,Var,j,',HMR,MP',0,            Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&MCGen&&post&,                   5,Var,j,',HMR,Sea,TB',-INF,     Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&MCCap&&post&,                   5,Var,j,',RsvRg,Sea,TB',0,      Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&lambda&&post&,                  6,Var,j,',HMR,MP,Sea,TB',0,     Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&MCNoDsp&&post&,                 6,Var,j,',HMR,MP,Sea,TB',-INF,  Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwPrc&&post&,                  3,Var,j,',PPAR',0,              Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&PSPrc&&post&,                   3,Var,j,',PPAR',0,              Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&PSReq&&post&,                   3,Var,j,',PPAR',0,              Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwPrcBank&&post&,              3,Var,j,',PPAR',0,              Eq,Eqdims,Xdims)
$macro ListVarCal(f,Eq,Eqdims,pre,post,dlm,Xdims) \
        f(&&pre&CalEPrcRtl&&post&,              4,Var,j,',HMR,Sea',-INF,        Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalEPrcRtl2&&post&,              4,Var,j,',HMR,Sea',-INF,        Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalEDemCoeff&&post&,            5,Var,j,',HMR,Sea,TB',0,        Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalGen&&post&,                  4,Var,j,',HMR,Fuel',-INF,       Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalGenTot&&post&,               3,Var,j,',HMR',-INF,            Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalEmis&&post&,                 2,Var,j,'',-INF,                Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalEmisRGGI&&post&,             2,Var,j,'',-INF,                Eq,Eqdims,Xdims)
$macro ListEqCore(f,Var,Vardims,pre,post,dlm,Xdims) \
        f(&&pre&MCP_NPCap&&post&,               4,Eq,i,',HMR,MP',na,            Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_Gen&&post&,                 6,Eq,i,',HMR,MP,Sea,TB',na,     Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_Trans&&post&,               6,Eq,i,',HMRe,HMRi,Sea,TB',na,  Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_EPrcRtl&&post&,             4,Eq,i,',HMR,Sea',na,           Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_EDem&&post&,                5,Eq,i,',HMR,Sea,TB',na,        Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_gamma&&post&,               4,Eq,i,',HMR,MP',na,            Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_MCGen&&post&,               5,Eq,i,',HMR,Sea,TB',na,        Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_MCCap&&post&,               5,Eq,i,',RsvRg,Sea,TB',na,      Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_lambda&&post&,              6,Eq,i,',HMR,MP,Sea,TB',na,     Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_NoDsp&&post&,               6,Eq,i,',HMR,MP,Sea,TB',na,     Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_AlwSup_AlwPrc&&post&,       3,Eq,i,',PPAR',na,              Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_PS&&post&,                  3,Eq,i,',PPAR',na,              Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_EmisCapPS&&post&,           3,Eq,i,',PPAR',na,              Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_EmisCapBank&&post&,         3,Eq,i,',PPAR',na,              Var,Vardims,Xdims)
$macro ListEqCal(f,Var,Vardims,pre,post,dlm,Xdims) \
        f(&&pre&MCPInt_CalEPrcRtl&&post&,       4,Eq,i,',HMR,Sea',na,           Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCPInt_CalEPrcRtl&&post&,       4,Eq,i,',HMR,Sea',na,           Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_CalEDem&&post&,             5,Eq,i,',HMR,Sea,TB',na,        Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_CalGen&&post&,              4,Eq,i,',HMR,Fuel',na,          Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_CalEmis&&post&,             2,Eq,i,'',na,                   Var,Vardims,Xdims)&&dlm& \
        f(&&pre&MCP_CalEmisRGGI&&post&,         2,Eq,i,'',na,                   Var,Vardims,Xdims)

$macro ListVar(f,Eq,Eqdims,pre,post,dlm,Xdims) \
        ListVarCore(f,Eq,Eqdims,pre,post,dlm,Xdims)&&dlm& ListVarCal(f,Eq,Eqdims,pre,post,dlm,Xdims)
$macro ListEq(f,Var,Vardims,pre,post,dlm,Xdims) \
        ListEqCore(f,Var,Vardims,pre,post,dlm,Xdims)&&dlm& ListEqCal(f,Var,Vardims,pre,post,dlm,Xdims)

$macro ListVarEq(f,pre,post,dlm) \
        ListVar(f,noEq,none,pre,post,dlm,Xdims)&&dlm& ListEq(f,noVar,none,pre,post,dlm,Xdims)

$macro ListVarXEq(f,pre,post,dlm) \
        ListVar(f,MCP_NPCap,',HMR,MP',pre,'XMCP_NPCap',dlm,Xdims) \
        ListVar(f,MCP_Gen,',HMR,MP,Sea,TB',pre,'XMCP_Gen',dlm,Xdims) \
        ListVar(f,MCP_Trans,',HMRe,HMRi,Sea,TB',pre,'XMCP_Trans',dlm,Xdims) \
        ListVar(f,MCP_EPrcRtl,',HMR,Sea',pre,'XMCP_EPrcRtl',dlm,Xdims)

$macro ListVarBndItrp(f,Eq,Eqdims,pre,post,dlm,Xdims) \
        f(&&pre&NPCap&&post&,                   4,Var,j,',HMR,MP',0,                    Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&Gen&&post&,                     6,Var,j,',HMR,MP,Sea,TB',0,             Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&Trans&&post&,                   6,Var,j,',HMRe,HMRi,Sea,TB',0,          Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&gamma&&post&,                   4,Var,j,',HMR,MP',0,                    Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&MCCap&&post&,                   5,Var,j,',RsvRg,Sea,TB',0,              Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&lambda&&post&,                  6,Var,j,',HMR,MP,Sea,TB',0,             Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwIss&&post&,                  4,Var,j,',PPAR,Trc',0,                  Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwPrc&&post&,                  3,Var,j,',PPAR',0,                      Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwAlc&&post&,                  5,Var,j,',PPAR,HMR,AA',0,               Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&PSReq&&post&,                   3,Var,j,',PPAR',0,                      Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&AlwPrcBank&&post&,              3,Var,j,',PPAR',0,                      Eq,Eqdims,Xdims)

$macro ListPrm(f,Eq,Eqdims,pre,post,dlm,Xdims) \
        f(&&pre&CalNPCap&&post&,                4,Var,j,',HMR,MP',0,                    Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalTrans&&post&,                6,Var,j,',HMRe,HMRi,Sea,TB',0,          Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&TransCap&&post&,                6,Var,j,',HMRe,HMRi,Sea',0,             Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalACFGen&&post&,               6,Var,j,',HMR,MP,Sea,TB',0,             Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalACFRsv&&post&,               6,Var,j,',HMR,MP,Sea,TB',0,             Eq,Eqdims,Xdims)&&dlm& \
        f(&&pre&CalRsvMrg&&post&,               3,Var,j,',RsvRg',0,                     Eq,Eqdims,Xdims)

$macro ListPrmEq(f,Eq,Eqdims,pre,post,dlm,Xdims) \
        SimYrWgt, SimYrWgtKnl, VOMCoeff, VOMSlp, FOMCoeff, FOMSlp, CapCost, CapCostSlp, \
        OpNPCapRat, ACFGen, ACFRsv, RsvMrg, Hrs, FCo, FCiRef, HR, RsvMrg, ERo, TransCostCoeff, TransCostSlp, \
        map_EmisPol_YPHM, map_OBA_YPHM, map_PS_YPHM, map_PS_YPH, \
        EDemElast, AAEEYrInit, AAEEYrFnl, EEExpExo, EECostYr1, EEPDMult, EESvSeaTb, \
        ERevRef, EConsRef, GenAEOSeaFuel, EmisAEO, \
        PSReq, PSCredit, PSPrcRef, NetFrgnImpCHP, AlwIssPrc, AlwPrcRef, AlwAlcPct, EmisCap, EmisCapPS

* Functions activated via argument f in the lists immediately above.
*------------------------------------------------------------------
$macro noFunc(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims)            VarEq
$macro DecSet_DM(VarEq,Ndims,VarOrEq,iORj,dims,loBnd,XVE,othVEdims,Xdims)         Set VarEq(iORj,Yr&&dims);
$macro DecSet_ijsub(VarEq,Ndims,VarOrEq,iORj,dims,loBnd,XVE,othVEdims,Xdims)      Set VarEq(iORj);
$macro DecParamYr(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims)        Parameter VarEq(Yr&&dims);
$macro DecParamYrFull(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims)    Parameter VarEq(YrFull&&dims);
$macro Rnd6DecYr(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims)         VarEq(Yr&&dims)=round(VarEq(Yr&&dims),6);
$macro Rnd6DecYrFull(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims)     VarEq(YrFull&&dims)=round(VarEq(YrFull&&dims),6);

$macro DefSet_ijsub(VarEq,Ndims,VarOrEq,iORj,dims,loBnd,XVE,othVEdims,Xdims)      Set VarEq(iORj);

* Initialize variables levels, with or withot perturbation, variable and equation scales, and parameters.
$macro InitVarLvl(Var,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        Var.L(Yr&&dims)=Var&Full(Yr&&dims);
$macro InitVarLvlPrt(Var,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        Var.L(Yr&&dims)=Var.L(Yr&&dims)*uniform(0.99,1.01);
$macro InitVarEqScl(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        VarEq.scale(Yr&&dims)=VarEq&SclFull(Yr&&dims);
$macro InitVarBnds(Var,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        Var.lo(Yr&&dims)=loBnd; \
                Var.up(Yr&&dims)=+INF;
$macro InitPrm(Prm,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        Prm(Yr&&dims)=Prm&Full(Yr&&dims);

* Calculate scale diagnostics: levels then min/max/avg over variables and equations.
$macro VarLvl(Var,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) SclDiag_Lvl_&Var(Yr&&dims)= \
        round(Var.L(Yr&&dims)/Var.scale(Yr&&dims),6);
$macro EqLvl(Eq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) SclDiag_Lvl_&Eq(Yr&&dims)= \
        round((Eq.L(Yr&&dims)-Eq.lo(Yr&&dims))/Eq.scale(Yr&&dims),6);
$macro LvlVarEqMin(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) SclDiag_&VarOREq('VarEq','Lvl','Min')= \
        smin((Yr&&dims),abs(SclDiag_Lvl_&VarEq(Yr&&dims))+1e15$(SclDiag_Lvl_&VarEq(Yr&&dims)=0));
$macro LvlVarEqMax(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) SclDiag_&VarOREq('VarEq','Lvl','Max')= \
        smax((Yr&&dims),abs(SclDiag_Lvl_&VarEq(Yr&&dims)));
$macro LvlVarEqAvg(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) SclDiag_&VarOREq('VarEq','Lvl','Avg')= \
        10**( sum((Yr&&dims), log10(abs(SclDiag_Lvl_&VarEq(Yr&&dims))+1$(SclDiag_Lvl_&VarEq(Yr&&dims)=0)) ) \
                /max(1, sum((Yr&&dims),1$(SclDiag_Lvl_&VarEq(Yr&&dims)<>0)) ) );

* Interpolate and extrapolate levels and scales of variables and equations.
$macro ItrpVarEqLvl(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        VarEq&Full(YrFull&&dims)$(year_range(SimYrFull(YrFull),x0,x1))= \
                linear_interpolation(SimYrFull(YrFull),VarEq.L(Yr-1&&dims),VarEq.L(Yr&&dims),x1,x0);
$macro ItrpVarEqLvlBnd(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        VarEq&Full(YrFull&&dims)$(year_range(SimYrFull(YrFull),x0,x1))= max(0, \
                linear_interpolation(SimYrFull(YrFull),VarEq.L(Yr-1&&dims),VarEq.L(Yr&&dims),x1,x0) );
$macro ItrpVarEqScl(VarEq,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        VarEq&SclFull(YrFull&&dims)$(year_range(SimYrFull(YrFull),x0,x1))= \
                linear_interpolation(SimYrFull(YrFull),VarEq.scale(Yr-1&&dims),VarEq.scale(Yr&&dims),x1,x0);
$macro ItrpPrm(Prm,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        Prm&Full(YrFull&&dims)$(year_range(SimYrFull(YrFull),x0,x1))= \
                linear_interpolation(SimYrFull(YrFull),Prm(Yr-1&&dims),Prm(Yr&&dims),x1,x0);
$macro ExtrpVarEqPrm(VarEqPrm,Ndims,VarOREq,iORj,dims,loBnd,XVE,othVEdims,Xdims) \
        VarEqPrm(YrFull&&dims)$(SimYrFull(YrFull)>SimYrLast)=sum(YrFulldup,VarEqPrm(YrFulldup&&dims)$(SimYrFull(YrFulldup)=SimYrLast));
