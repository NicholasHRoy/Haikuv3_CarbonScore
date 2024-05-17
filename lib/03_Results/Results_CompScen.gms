* Compare against another scenario, %UI_RsltCmp%
*-----------------------------------------------------------------------------------------------------------------------
Parameters
        chk_ACFGen(Yr,HMR,MP,Sea,TB)
        chk_ACFRsv(Yr,HMR,MP,Sea,TB)
        chk_RsvMrg(Yr,RsvRg)
;
chk_ACFGen(Yr,HMR,MP,Sea,TB)=ACFGen(Yr,HMR,MP,Sea,TB);
chk_ACFRsv(Yr,HMR,MP,Sea,TB)=ACFRsv(Yr,HMR,MP,Sea,TB);
chk_RsvMrg(Yr,RsvRg)=RsvMrg(Yr,RsvRg);
put dummy;
put_utility 'gdxin' / '%UI_RootDir%\Output\%UI_RsltCmp%\%UI_vHaiku%_%UI_RsltCmp%';
execute_load
        ACFGen, ACFRsv, RsvMrg
;
putclose;
chk_ACFGen(Yr,HMR,MP,Sea,TB)=chk_ACFGen(Yr,HMR,MP,Sea,TB)-ACFGen(Yr,HMR,MP,Sea,TB);
chk_ACFRsv(Yr,HMR,MP,Sea,TB)=chk_ACFRsv(Yr,HMR,MP,Sea,TB)-ACFRsv(Yr,HMR,MP,Sea,TB);
chk_RsvMrg(Yr,RsvRg)        =chk_RsvMrg(Yr,RsvRg)        -RsvMrg(Yr,RsvRg);
display chk_ACFGen, chk_ACFRsv, chk_RsvMrg;

display GenFuelNat, EmisCO2Nat, EmisCO2FuelNat, EConsNat, GenNat;
