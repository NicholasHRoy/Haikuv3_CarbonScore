*-------------------------------------------------------------------------------------------------------------
* SLOPES
* Cost coefficients that increase in Gen, NPCap, or Trans add nice convexity to the model.
VOMSlpDen=smax((HMR,MP,Sea,TB),NPCap0(HMR,MP)*AF('Yr0',HMR,MP,Sea,TB)*Hrs(Sea,Tb));
VOMSlp=%UI_slpV%/VOMSlpDen;
VOM(Yr,HMR,MP) = VOMCoeff(Yr,HMR,MP)+sum((Sea,TB),Gen.L(Yr,HMR,MP,Sea,TB))*VOMSlp

$exit

FOMSlpDen=smax((HMR,MP),NPCap0(HMR,MP));
FOMSlp=0{2*1E-3/FOMSlpDen};
FOM(Yr,HMR,MP)=FOMCoeff(Yr,HMR,MP)+NPCap.L(Yr,HMR,MP)*FOMSlp;

TransCostSlpDen=smax((HMRe,HMRi,Sea,TB),TransCap0(HMRe,HMRi)*Hrs(Sea,Tb));
TransCostSlp=%UI_slpT%/TransCostSlpDen;
TransCost(HMRe,HMR) = TransCost(HMRe,HMR) + Trans.L(HMRe,HMR)*TransCostSlp;

TransCap(Yr,HMRe,HMRi,Sea)=smax(TB,Trans.L(Yr,HMRe,HMRi,Sea,TB)/Hrs(Sea,TB))
        +max(1,0.2*sum(MP,NPCap.L(Yr,HMRe,MP)))$HMRei(HMRe,HMRi);

CapCostSlp(MP)=0;
CapCostSlp('New Solar')=%UI_slpCC%/30;
CapCostSlp('New Wind')=%UI_slpCC%/30;
CapCost(Yr,HMR,MP)=CapCostCoeff(Yr,HMR,MP)+NPCap.L(Yr,HMR,MP)*CapCostSlp;
