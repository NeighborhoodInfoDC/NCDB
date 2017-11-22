/**************************************************************************
 Program:  Ncdb_sum_was15.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/09/17
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create 1990 and 2000 NCDB tract and county level 
 summary files for Washington metro area (2015).

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )


**** Create summary data sets for individual years ****;

/** Macro Summary - Start Definition **/

%macro Summary( year=, data=, geosuf=, geo=, geofmt= );

  %local y;

  %if &year = 1990 %then %let y = 9;
  %else %if &year = 2000 %then %let y = 0;
  
  ** Tract-level summary data set for &year **;

  data Ncdb_sum_&year._was15_tr00;

    set Ncdb.&data (obs=max);
    
    %Regcnt( invar=&geo )

    label County = "County";

    format county $cnty15f.;
    
    NumHHMovedIn20YearsOrMore_&year = sum(YMVT079&y.,YMVT069&y.);
    NumHHMovedInLast5Years_&year = sum(YMVT098&y.,YMVT000&y.);
    /* NumHsgUnits20plusUnitStr_&year = sum(TTUNT49&y.,TTUNT50&y.); */
    NumHsgUnits2to4UnitStr_&year = sum(TTUNIT3&y.,TTUNIT4&y.);
    NumHsgUnits3plusBdrms_&year = sum(BDTOT3&y.,BDTOT4&y.,BDTOT5&y.);
    NumHsgUnitsBuilt95toMar00_&year = sum(BLTYR00&y.,BLTYR98&y.);
    NumHsgUnitsBuiltBef70_&year = sum(BLTYR69&y.,BLTYR59&y.,BLTYR49&y.,BLTYR39&y.);
    NumHsgUnitsBuiltBef50_&year = sum(BLTYR49&y.,BLTYR39&y.);
    NumHsgUnitsOtherStructure_&year = sum(TTUNITM&y.,TTUNITO&y.);
    NumHshldOtherFamily_&year = sum(MCNKID&y.,MHNKID&y.,FHNKID&y.);
    NumHshldSingleParentWKids_&year = sum(MHWKID&y.,FHWKID&y.);
    NumHshldsOnPublicAssistance_&year = sum(AVPBLA&y.D,-AVSSI&y.D);
    NumHshldsOver30PctInc_&year = sum(M39PI&y.,M49PI&y.,M50PI&y.,R39PI&y.,R49PI&y.,R50PI&y.);
    NumHshldsOver50PctInc_&year = sum(M50PI&y.,R50PI&y.);
    NumHshldsforPctInc_&year = sum(M20PI&y.,M29PI&y.,M39PI&y.,M49PI&y.,M50PI&y.,R20PI&y.,R29PI&y.,R39PI&y.,R49PI&y.,R50PI&y.);
    NumHshldsOvercrowded_&year = sum(OWNCR10&y.,OWNCR15&y.,OWNCR20&y.,RNTCR10&y.,RNTCR15&y.,RNTCR20&y.);
    NumHshldsSevOvercrowded_&year = sum(OWNCR15&y.,OWNCR20&y.,RNTCR15&y.,RNTCR20&y.);
    NumHshldsWInc100000plus_&year = sum(THY0125&y.,THY0150&y.,THY0200&y.,THY0M20&y.);
    NumHshldsWInc15000to34999_&year = sum(THY020&y.,THY025&y.,THY030&y.,THY035&y.);
    NumHshldsWInc35000to49999_&year = sum(THY040&y.,THY045&y.,THY050&y.);
    NumHshldsWInc50000to74999_&year = sum(THY060&y.,THY075&y.);
    NumHshldsWIncPlumbing_&year = sum(OCCHU&y.,-PLMBT&y.);
    NumHshldsWIncUnder15000_&year = sum(THY010&y.,THY015&y.);
    NumOwnerHsgUnits_&year = sum(OWNOCC&y.,VACFS&y.);
    NumOwnerHshldsOver30PctInc_&year = sum(M39PI&y.,M49PI&y.,M50PI&y.);
    NumOwnerHshldsforPctInc_&year = sum(M20PI&y.,M29PI&y.,M39PI&y.,M49PI&y.,M50PI&y.);
    NumRenterHsgUnits_&year = sum(RNTOCC&y.,VACRT&y.);
    NumRenterHshldsOver30PctInc_&year = sum(R39PI&y.,R49PI&y.,R50PI&y.);
    NumRenterHshldsforPctInc_&year = sum(R20PI&y.,R29PI&y.,R39PI&y.,R49PI&y.,R50PI&y.);
    NumRenterHshldsRent1000plus_&year = sum(GR01249&y.,GR01499&y.,GR01999&y.,GR02000&y.);
    NumRenterHshldsRent300to399_&year = sum(GR0349&y.,GR0399&y.);
    NumRenterHshldsRent400to499_&year = sum(GR0449&y.,GR0499&y.);
    NumRenterHshldsRent500to599_&year = sum(GR0549&y.,GR0599&y.);
    NumRenterHshldsRent600to699_&year = sum(GR0649&y.,GR0699&y.);
    NumRenterHshldsRent700to799_&year = sum(GR0749&y.,GR0799&y.);
    NumRenterHshldsRent800to999_&year = sum(GR0899&y.,GR0999&y.);
    NumRenterHshldsRentUnder300_&year = sum(GR099&y.,GR0149&y.,GR0199&y.,GR0249&y.,GR0299&y.);
    Pop16andOverEmployed_&year = sum(ARMFRM&y.,CMEPR&y.N,ARMFRF&y.,CFEPR&y.N);
    Pop16andOverYears_&year = sum(MNOPRT&y.D,FNOPRT&y.D);
    Pop16to19UnemplOutOfSchool_&year = sum(WHSGU&y.,WHSDU&y.,BHSGU&y.,BHSDU&y.,IHSGU&y.,IHSDU&y.,AHSGU&y.,AHSDU&y.,OHSGU&y.,OHSDU&y.,MHSGU&y.,MHSDU&y.);
    Pop18to64PoorEnglishLang_&year = sum(SPNENO&y.N,ASNENO&y.N,OTNENO&y.N);
    Pop25andOverWoutHS_&year = sum(EDUC8&y.,EDUC11&y.);
    Pop5to17PoorEnglishLang_&year = sum(SPNENY&y.N,ASNENY&y.N,OTNENY&y.N);
    Pop65andOverPoorEnglishLang_&year = sum(SPNENE&y.N,ASNENE&y.N,OTNENE&y.N);
    PopAsianPILangAtHome_&year = sum(YASNSP&y.,OASNSP&y.,EASNSP&y.);
    PopBelow200PctPoverty_&year = sum(POVRAT&y.D,-PVRATG2&y.);
    PopEmployedIndAgricMining_&year = sum(IND011&y.,IND021&y.);
    PopEmployedIndTransport_&year = sum(IND048&y.,IND022&y.);
    PopEmployedIndFIRE_&year = sum(IND052&y.,IND053&y.);
    PopEmployedIndProfessional_&year = sum(IND054&y.,IND055&y.,IND056&y.);
    PopEmployedIndEducational_&year = sum(IND061&y.,IND062&y.);
    PopEmployedIndArts_&year = sum(IND071&y.,IND072&y.);
    PopEmployedOccConstruction_&year = sum(OCC047&y.,OCC049&y.);
    PopEmployedOccManagement_&year = sum(OCC011&y.,OCC013&y.,OCC015&y.,OCC017&y.,OCC019&y.,OCC021&y.,OCC023&y.,OCC025&y.,OCC027&y.,OCC029&y.);
    PopEmployedOccMngmtAndProf_&year = sum(OCC1&y.,OCC2&y.);
    PopEmployedOccProduction_&year = sum(OCC051&y.,OCC053&y.);
    PopEmployedOccSales_&year = sum(OCC041&y.,OCC043&y.);
    PopEmployedOccService_&year = sum(OCC031&y.,OCC033&y.,OCC035&y.,OCC037&y.,OCC039&y.);
    PopEnglishLangAtHome_&year = sum(YENGSP&y.,OENGSP&y.,EENGSP&y.);
    PopFemale16andOverEmployed_&year = sum(ARMFRF&y.,CFEPR&y.N);
    PopMale16andOverEmployed_&year = sum(ARMFRM&y.,CMEPR&y.N);
    PopOtherLangAtHome_&year = sum(YOTHSP&y.,OOTHSP&y.,EOTHSP&y.);
    PopSpanishLangAtHome_&year = sum(YSPANSP&y.,OSPANSP&y.,ESPANSP&y.);
    /* DenHshldsforPctIncOnHsg_&year = sum(h073001,h097001); */
    PopMinorityAlone_&year = sum(shr&y.d,-minnhw&y.n);
    PopMinorityBridge_&year = sum(shr&y.d,-shrnhw&y.n);
    /*
    NumHshldFemaleHeaded_&year = sum(p010004,p010014,p010019);
    NumRenterOccHsgAge35_54_&year = sum(h014015,h014016);
    NumRenterOccHsgAge55_64_&year = sum(h014017,h014018);
    NumRenterOccHsgAge74p_&year = sum(H01402&y.,H014021);
    NumOwnerOccHsgAge35_54_&year = sum(h014005,h014006);
    NumOwnerOccHsgAge55_64_&year = sum(h014007,h014008);
    NumOwnerOccHsgAge74p_&year = sum(h01401&y.,h014011);
    NumOccupiedHsgAge15_24_&year = sum(h014013,h014003);
    NumOccupiedHsgAge25_34_&year = sum(H014014,H014004);
    NumOccupiedHsgAge35_54_&year = sum(H014015,H014016,H014005,H014006);
    NumOccupiedHsgAge55_64_&year = sum(H014017,H014018,H014007,H014008);
    NumOccupiedHsgAge65_74_&year = sum(H014019,H014009);
    NumOccupiedHsgAge74p_&year = sum(H01402&y.,H014021,H01401&y.,H014011);
    DenomPoorMarriedCoupleWKid_&year = sum(P090004,P090024);
    DenomPoorMarriedCoupleNKid_&year = sum(P090008,P090028);
    DenomPoorFemaleHeadWKid_&year = sum(P090017,P090037);
    DenomPoorMaleHeadWKid_&year = sum(P090011,P090031);
    DenomPoorOtherFamily_&year = sum(P090009,P090029);
    DenomPoorNonfamily_&year = sum(P09202&y.,P092049);
    NumRenterOccOtherFamily_&year = sum(HCT001042,HCT001048);
    NumOwnerOccOtherFamily_&year = sum(HCT001016,HCT001022);
    */
    NumOccupiedHsgUnitsMin_&year = SUM(OCCHU&y.,-TOTOCCX&y.);
    NumOwnerOccHsgUnitsMin_&year = SUM(OWNOCC&y.,-OWNOCCX&y.);
    NumRenterOccHsgUnitsMin_&year = SUM(RNTOCC&y.,-RNTOCCX&y.);
    /*
    PopAsianOtherAsian_&year = sum(PCT005018,PCT005019);
    Pop5andOverWDisability_&year = sum(P042004,P042028,P042007,P042014,P042031,P042038,P042021,P042024,P042045,P042048);
    Pop5to15WDisability_&year = sum(P042004,P042028);
    Pop16to64WDisability_&year = sum(P042007,P042014,P042031,P042038);
    Pop65andoverWDisability_&year = sum(P042021,P042024,P042045,P042048);
    Pop5andOverWDisabilityInfo_&year = sum(P042003,P042027,P042006,P042013,P04203&y.,P042037,P04202&y.,P042044);
    Pop5to15WDisabilityInfo_&year = sum(P042003,P042027);
    Pop16to64WDisabilityInfo_&year = sum(P042006,P042013,P04203&y.,P042037);
    Pop65andoverWDisabilityInfo_&year = sum(P04202&y.,P042023,P042044,P042047);
    PopSelfcareDisability_&year = sum(P041006,P041011,P041018);
    PopMentalDisability_&year = sum(P041005,P04101&y.,P041017);
    PopSensoryDisability_&year = sum(P041003,P041008,P041015);
    NumHshldsWIncompleteKitchen_&year = sum(h051004,h051007);
    */
    
    Pop25andOverWHS_&year = SUM(EDUC12&y.,EDUC15&y.,EDUC16&y.,EDUCA&y.);
    /* PopForeign_OceaniaOth_&year = sum(of PCT019088-PCT019091); */
    
    PopOtherRaceNonHispBridge_&year = shr&y.d - sum( shrnhb&y.n, shrnhw&y.n, shrhsp&y.n, shrnha&y.n );

    rename
      FAVINC&y.N=AggFamilyIncome_&year
      AVHHIN&y.N=AggHshldIncome_&year
      /* NFAVIN&y.N=AggNonFamilyIncome_&year */
      FAVINC&y.=AvgFamilyIncome_&year
      AVHHIN&y.=AvgHshldIncome_&year
      CHDPOO&y.D=ChildrenPovertyDefined_&year
      ELDPOO&y.D=ElderlyPovertyDefined_&year
      MGMKT&y.D=Females16to34_&year
      AGGRENT&y.=GrossRentSpecRenterHshlds_&year
      AREALANM=LandAreaSqMile_&year
      MGMKT&y.N=Males16to34_&year
      /* MDAGE&y.=MedianAge_&year */
      MDFAMY&y.=MedianFamilyIncome_&year
      MDGRENT&y.=MedianGrossRent_&year
      MDHHY&y.=MedianHshldIncome_&year
      MDVALHS&y.=MedianValueSpecOwnerHshlds_&year
      /* MDYRBLT&y.=MedianYearStructureBuilt_&year */
      FAVINC&y.D=NumFamilies_&year
      TOTHSUN&y.=NumHsgUnits_&year
      BDTOT&y.&y.=NumHsgUnits0Bdrms_&year
      /* TUNIT19&y.=NumHsgUnits10to19UnitStr_&year /*NumHsgUnits10to19UnitStructures*/
      BDTOT1&y.=NumHsgUnits1Bdrm_&year
      BDTOT2&y.=NumHsgUnits2Bdrms_&year
      BDTOT3&y.=NumHsgUnits3Bdrms_&year
      BDTOT4&y.=NumHsgUnits4Bdrms_&year
      BDTOT5&y.=NumHsgUnits5plusBdrms_&year
      /* TTUNIT9&y.=NumHsgUnits5To9UnitStr_&year /*NumHsgUnits5To9UnitStructures*/
      BLTYR89&y.=NumHsgUnitsBuilt80to89_&year /*NumHsgUnitsBuilt11to20YearsAgo*/
      BLTYR79&y.=NumHsgUnitsBuilt70to79_&year /*NumHsgUnitsBuilt21to30YearsAgo_&year*/
      BLTYR94&y.=NumHsgUnitsBuilt90to94_&year /*NumHsgUnitsBuilt6to10YearsAgo_&year*/
      BLTYR69&y.=NumHsgUnitsBuilt60to69_&year /*NumHsgUnitsBuilt31to40YearsAgo_&year*/
      BLTYR59&y.=NumHsgUnitsBuilt50to59_&year /*NumHsgUnitsBuilt41to50YearsAgo_&year*/
      TTUNIT2&y.=NumHsgUnitsSFamAttached_&year /*NumHsgUnitsSingleFamilyAttached_&year*/
      TTUNIT1&y.=NumHsgUnitsSFamDetached_&year /*NumHsgUnitsSingleFamilyDetached_&year*/
      /* HU2PFC&y.=NumHsgUnitsW2OrMoreHsgProb_&year /*NumHsgUnitsW2OrMoreHsgProblems_&year*/
      MCWKID&y.=NumHshldMarriedCoupleWKids_&year
      NONFAM&y.=NumHshldNonFamily_&year
      NUMHHS&y.=NumHshlds_&year
      AVFINY&y.D=NumHshldsWFinancialInc_&year
      THY0100&y.=NumHshldsWInc75000to99999_&year
      NOCAR&y.=NumHshldsWoutCar_&year
      OCCHU&y.=NumOccupiedHsgUnits_&year
      TOTOCCA&y.=NumOccupiedHsgUnitsAsianPI_&year
      TOTOCCB&y.=NumOccupiedHsgUnitsBlack_&year
      TOTOCCH&y.=NumOccupiedHsgUnitsHisp_&year
      TOTOCCI&y.=NumOccupiedHsgUnitsNativeAm_&year
      TOTOCCX&y.=NumOccupiedHsgUnitsNHWhite_&year /*NumOccupiedHsgUnitsNonHispWhite_&year*/
      TOTOCCW&y.=NumOccupiedHsgUnitsWhite_&year
      M50PI&y.=NumOwnerHshldsOver50PctInc_&year /*NumOwnerHshldsOver50PctIncOnHsg_&year*/
      OWNOCC&y.=NumOwnerOccupiedHsgUnits_&year
      OWNOCCA&y.=NumOwnerOccHsgUnitsAsianPI_&year /*NumOwnerOccupiedHsgUnitsAsianPI_&year*/
      OWNOCCB&y.=NumOwnerOccHsgUnitsBlack_&year /*NumOwnerOccupiedHsgUnitsBlack_&year*/
      OWNOCCH&y.=NumOwnerOccHsgUnitsHisp_&year /*NumOwnerOccupiedHsgUnitsHisp_&year*/
      OWNOCCI&y.=NumOwnerOccHsgUnitsNativeAm_&year /*NumOwnerOccupiedHsgUnitsNativeAm_&year*/
      OWNOCCX&y.=NumOwnerOccHsgUnitsNHWhite_&year /*NumOwnerOccupiedHsgUnitsNHWhite_&year*/
      OWNOCCW&y.=NumOwnerOccHsgUnitsWhite_&year /*NumOwnerOccupiedHsgUnitsWhite_&year*/
      GRNTNCR&y.=NumRenterHshldsNoCashRent_&year
      R50PI&y.=NumRenterHshldsOver50PctInc_&year /*NumRenterHshldsOver50PctIncOnHsg_&year*/
      RNTOCC&y.=NumRenterOccupiedHsgUnits_&year
      SPOWNOC&y.=NumSpecOwnerOccHsgUnits_&year /*NumSpecOwnerOccupiedHsgUnits_&year*/
      /* HUVA149&y.=NumSpecOwnerValue100to149_&year /*NumSpecOwnerValue100000to149999_&year*/
      /* HUVA199&y.=NumSpecOwnerValue150to199_&year /*NumSpecOwnerValue150000to199999_&year*/
      /* HUVA299&y.=NumSpecOwnerValue200to299_&year /*NumSpecOwnerValue200000to299999_&year*/
      /* HUVA399&y.=NumSpecOwnerValue300o399_&year /* NumSpecOwnerValue30000to399999 */
      /* HUVA499&y.=NumSpecOwnerValue400to499_&year /*NumSpecOwnerValue400000to499999*/
      /* HUVA099&y.=NumSpecOwnerValue50to99_&year /*NumSpecOwnerValue50000to99999*/
      /* HUVA500&y.=NumSpecOwnerValueOver500_&year /*NumSpecOwnerValueOver500000*/
      /* HUVA050&y.=NumSpecOwnerValueUnder50_&year /*NumSpecOwnerValueUnder50000*/
      RENTRTO&y.=NumSpecRenterOccHsgUnits_&year /*NumSpecRenterOccupiedHsgUnits*/
      VACHU&y.=NumVacantHsgUnits_&year
      VACRT&y.=NumVacantHsgUnitsForRent_&year
      VACFS&y.=NumVacantHsgUnitsForSale_&year
      PRSOCU&y.=PeopleInHshlds_&year
      POVRAT&y.D=PersonsPovertyDefined_&year
      HSDROP&y.D=Pop16to19Years_&year
      PERS64&y.=Pop18to64Years_&year
      EDUC16&y.=Pop25andOverWCollege_&year
      EDUCPP&y.=Pop25andOverYears_&year
      SMHSE&y.D=Pop5andOverYears_&year
      PERS517&y.=Pop5to17Years_&year
      PERS65P&y.=Pop65andOverYears_&year
      MINNHA&y.N=PopAsianPINonHispAlone_&year
      SHRNHA&y.N=PopAsianPINonHispBridge_&year
      MINNHB&y.N=PopBlackNonHispAlone_&year
      SHRNHB&y.N=PopBlackNonHispBridge_&year
      INDEMP&y.=PopCivilianEmployed_&year
      IND023&y.=PopEmployedIndConstruction_&year
      IND031&y.=PopEmployedIndManufacturing_&year
      IND042&y.=PopEmployedIndWholesale_&year
      IND044&y.=PopEmployedIndRetail_&year
      IND081&y.=PopEmployedIndOther_&year
      IND051&y.=PopEmployedIndInformation_&year
      IND092&y.=PopEmployedIndPublicAdmin_&year
      OCC045&y.=PopEmployedOccFarming_&year
      FNOPRT&y.D=PopFemale16andOverYears_&year
      FORBORN&y.=PopForeignBorn_&year
      /* FBORN10&y.=PopForeignBornArrived10Yrs_&year /*PopForeignBornArrivedLast10Yrs*/
      SHRHSP&y.N=PopHisp_&year
      UNEMPT&y.D=PopInCivLaborForce_&year
      MNOPRT&y.D=PopMale16andOverYears_&year
      MRANHS&y.N=PopMultiracialNonHisp_&year
      MINNHI&y.N=PopNativeAmNonHispAlone_&year
      SHRNHI&y.N=PopNativeAmNonHispBridge_&year
      LFRAT&y.D=PopNotInArmedForces_&year
      /*IMMGPOP=PopOfLargestImmigrantGroup_&year*/
      MINNHO&y.N=PopOtherNonHispAlone_&year
      SHRNHO&y.N=PopOtherNonHispBridge_&year
      CHDPOO&y.N=PopPoorChildren_&year
      ELDPOO&y.N=PopPoorElderly_&year
      POVRAT&y.N=PopPoorPersons_&year
      AUTO&y.=PopTravelToWorkByCar_&year
      TRVLPB&y.N=PopTravelToWorkByPubTransit_&year /*PopTravelToWorkByPublicTransit_&year*/
      TRVLOT&y.N=PopTravelToWorkByWalking_&year
      CHILD&y.N=PopUnder18Years_&year
      KIDS&y.N=PopUnder5Years_&year
      UNEMPT&y.N=PopUnemployed_&year
      MINNHW&y.N=PopWhiteNonHispAlone_&year
      SHRNHW&y.N=PopWhiteNonHispBridge_&year
      WKHOME&y.=PopWorkAtHome_&year
      WRCNTY&y.D=PopWorkers_&year
      TRVLPB&y.D=PopWorkOutsideHome_&year
      /* IMMGSRC=SrcCountryOfLargestImmigGrp_&year /*SrcCountryOfLargestImmigrantGrp_&year*/
      TRCTPOP&y.=TotPop_&year
      /* AGGTRVL&y.=TotTravelTimeToWork_&year */
      AGGVAL&y.=TotValueSpecOwnerHshlds_&year
      mhwkid&y.=NumHshldMaleSinParWKids_&year /*NumHshldMaleSingleParentWKids_&year*/
      fhwkid&y.=NumHshldFemaleSinParWKids_&year /*NumHshldFemaleSingleParentWKids_&year*/
      TTUNITM&y.=NumHsgUnitsMobileHome_&year
      TTUNITO&y.=NumHsgUnitsOthStrExcMobile_&year /*NumHsgUnitsOthStructureExcMobile_&year*/
      TOTOCCO&y.=NumOccupiedHsgUnitsOther_&year
      TOTOCCM&y.=NumOccupiedHsgUnitsMulti_&year
      OWNOCCO&y.=NumOwnerOccHsgUnitsOther_&year /*NumOwnerOccupiedHsgUnitsOther_&year*/
      OWNOCCM&y.=NumOwnerOccHsgUnitsMulti_&year /*NumOwnerOccupiedHsgUnitsMulti_&year*/
      RNTOCCW&y.=NumRenterOccHsgUnitsWhite_&year /*NumRenterOccupiedHsgUnitsWhite_&year*/
      RNTOCCB&y.=NumRenterOccHsgUnitsBlack_&year /*NumRenterOccupiedHsgUnitsBlack_&year*/
      RNTOCCA&y.=NumRenterOccHsgUnitsAsianPI_&year /*NumRenterOccupiedHsgUnitsAsianPI_&year*/
      RNTOCCI&y.=NumRenterOccHsgUnitsNatAm_&year /*NumRenterOccupiedHsgUnitsNatAm_&year*/
      RNTOCCO&y.=NumRenterOccHsgUnitsOther_&year /*NumRenterOccupiedHsgUnitsOther_&year*/
      RNTOCCH&y.=NumRenterOccHsgUnitsHisp_&year /*NumRenterOccupiedHsgUnitsHisp_&year*/
      RNTOCCM&y.=NumRenterOccHsgUnitsMulti_&year /*NumRenterOccupiedHsgUnitsMulti_&year*/
      RNTOCCX&y.=NumRenterOccHsgUnitsNHWhite_&year /*NumRenterOccupiedHsgUnitsNHWhite_&year*/
      HSDROP&y.N=NumHighSchoolDropOut_&year
      MEXIC&y.=PopHispMexican_&year
      PRICAN&y.=PopHispPuertoRican_&year
      CUBAN&y.=PopHispCuban_&year
      DOMIN&y.=PopHispDominican_&year
      COSRIC&y.=PopHispCostaRican_&year
      GUATEM&y.=PopHispGuatemalan_&year
      HONDUR&y.=PopHispHonduran_&year
      NICARAG&y.=PopHispNicaraguan_&year
      PANAMA&y.=PopHispPananamian_&year
      SALVAD&y.=PopHispElSalvadoran_&year
      OTHCAM&y.=PopHispOtherCentAmer_&year
      ARGNTN&y.=PopHispArgentinean_&year
      BOLIVA&y.=PopHispBolivian_&year
      CHILE&y.=PopHispChilean_&year
      COLOMB&y.=PopHispColombian_&year
      ECUAD&y.=PopHispEcuadorian_&year
      PERU&y.=PopHispPeruvian_&year
      OTHSAM&y.=PopHispOtherSouthAmer_&year
      OTHHISP&y.=PopHispOtherHispOrig_&year
      BLKPR&y.N=PopPoorBlack_&year
      BLKPR&y.D=PovertyDefinedBlack_&year
      INDPR&y.N=PopPoorNatAmer_&year
      INDPR&y.D=PovertyDefinedNatAmer_&year
      ASNPR&y.N=PopPoorAsianPI_&year
      ASNPR&y.D=PovertyDefinedAsianPI_&year
      OTHPR&y.N=PopPoorOther_&year
      OTHPR&y.D=PovertyDefinedOther_&year
      MRAPR&y.N=PopPoorMulti_&year
      MRAPR&y.D=PovertyDefinedMulti_&year
      HISPR&y.N=PopPoorHisp_&year
      HISPR&y.D=PovertyDefinedHisp_&year
      NHWPR&y.N=PopPoorNHWhite_&year
      NHWPR&y.D=PovertyDefinedNHWhite_&year
      
      /*** NEW (NON-DATAPLACE) VARIABLES ***/
      SMHSE&y.N = PopSameHouse5YearsAgo_&year
      shr&y.d   = PopWithRace_&year
      ffh&y.d   = NumFamiliesOwnChildren_&year
      ffh&y.n   = NumFamiliesOwnChildrenFH_&year
      phone&y.n = NumHshldPhone_&year
      car&y.    = NumHshldCar_&year
      NOCAR&y.  = NumHshldNoCar_&year
      groupq&y.n  = PopGroupQuarters_&year

    ;  
    
    format &geo &geofmt;
    
    keep
    &geo county
    
    AGGRENT&y. AGGVAL&y. AREALANM ARGNTN&y. ASNPR&y.D ASNPR&y.N
    AUTO&y. AVFINY&y.D AVHHIN&y. AVHHIN&y.N BDTOT&y.&y.
    BDTOT1&y. BDTOT2&y. BDTOT3&y. BDTOT4&y. BDTOT5&y. BLKPR&y.D
    BLKPR&y.N BLTYR59&y. BLTYR69&y. BLTYR79&y. BLTYR89&y.
    BLTYR94&y. BOLIVA&y. CHDPOO&y.D CHDPOO&y.N CHILD&y.N
    CHILE&y. COLOMB&y. COSRIC&y. CUBAN&y. DOMIN&y. ECUAD&y.
    EDUC16&y. EDUCPP&y. ELDPOO&y.D ELDPOO&y.N FAVINC&y.
    FAVINC&y.D FAVINC&y.N fhwkid&y. FNOPRT&y.D FORBORN&y.
    GRNTNCR&y. groupq&y.n GUATEM&y. HISPR&y.D HISPR&y.N HONDUR&y.
    HSDROP&y.D HSDROP&y.N IND023&y. IND031&y. IND042&y.
    IND044&y. IND051&y. IND081&y. IND092&y. INDEMP&y. INDPR&y.D
    INDPR&y.N KIDS&y.N LFRAT&y.D M50PI&y. MCWKID&y. MDFAMY&y.
    MDGRENT&y. MDHHY&y. MDVALHS&y. MEXIC&y. MGMKT&y.D MGMKT&y.N
    mhwkid&y. MINNHA&y.N MINNHB&y.N MINNHI&y.N MINNHO&y.N
    MINNHW&y.N MNOPRT&y.D MRANHS&y.N MRAPR&y.D MRAPR&y.N
    NHWPR&y.D NHWPR&y.N NICARAG&y. NOCAR&y. NONFAM&y. NUMHHS&y.
    OCC045&y. OCCHU&y. OTHCAM&y. OTHHISP&y. OTHPR&y.D OTHPR&y.N
    OTHSAM&y. OWNOCC&y. OWNOCCA&y. OWNOCCB&y. OWNOCCH&y.
    OWNOCCI&y. OWNOCCM&y. OWNOCCO&y. OWNOCCW&y. OWNOCCX&y.
    PANAMA&y. PERS517&y. PERS64&y. PERS65P&y. PERU&y. POVRAT&y.D
    POVRAT&y.N PRICAN&y. PRSOCU&y. R50PI&y. RENTRTO&y. RNTOCC&y.
    RNTOCCA&y. RNTOCCB&y. RNTOCCH&y. RNTOCCI&y. RNTOCCM&y.
    RNTOCCO&y. RNTOCCW&y. RNTOCCX&y. SALVAD&y. SHRHSP&y.N
    SHRNHA&y.N SHRNHB&y.N SHRNHI&y.N SHRNHO&y.N SHRNHW&y.N
    SMHSE&y.D SPOWNOC&y. THY0100&y. TOTHSUN&y. TOTOCCA&y.
    TOTOCCB&y. TOTOCCH&y. TOTOCCI&y. TOTOCCM&y. TOTOCCO&y.
    TOTOCCW&y. TOTOCCX&y. TRCTPOP&y. TRVLOT&y.N TRVLPB&y.D
    TRVLPB&y.N TTUNIT1&y. TTUNIT2&y. TTUNITM&y. TTUNITO&y.
    UNEMPT&y.D UNEMPT&y.N VACFS&y. VACHU&y. VACRT&y. WKHOME&y.
    WRCNTY&y.D
    SMHSE&y.N shr&y.d ffh&y.d ffh&y.n phone&y.n car&y. NOCAR&y.  

  NumHHMovedIn20YearsOrMore_&year
  NumHHMovedInLast5Years_&year
  /* NumHsgUnits20plusUnitStr_&year */
  NumHsgUnits2to4UnitStr_&year
  NumHsgUnits3plusBdrms_&year
  NumHsgUnitsBuilt95toMar00_&year
  NumHsgUnitsBuiltBef70_&year
  NumHsgUnitsBuiltBef50_&year
  NumHsgUnitsOtherStructure_&year
  NumHshldOtherFamily_&year
  NumHshldSingleParentWKids_&year
  NumHshldsOnPublicAssistance_&year
  NumHshldsOver30PctInc_&year
  NumHshldsOver50PctInc_&year
  NumHshldsforPctInc_&year
  NumHshldsOvercrowded_&year
  NumHshldsSevOvercrowded_&year
  NumHshldsWInc100000plus_&year
  NumHshldsWInc15000to34999_&year
  NumHshldsWInc35000to49999_&year
  NumHshldsWInc50000to74999_&year
  NumHshldsWIncPlumbing_&year
  NumHshldsWIncUnder15000_&year
  NumOwnerHsgUnits_&year
  NumOwnerHshldsOver30PctInc_&year
  NumOwnerHshldsforPctInc_&year
  NumRenterHsgUnits_&year
  NumRenterHshldsOver30PctInc_&year
  NumRenterHshldsforPctInc_&year
  NumRenterHshldsRent1000plus_&year
  NumRenterHshldsRent300to399_&year
  NumRenterHshldsRent400to499_&year
  NumRenterHshldsRent500to599_&year
  NumRenterHshldsRent600to699_&year
  NumRenterHshldsRent700to799_&year
  NumRenterHshldsRent800to999_&year
  NumRenterHshldsRentUnder300_&year
  Pop16andOverEmployed_&year
  Pop16andOverYears_&year
  Pop16to19UnemplOutOfSchool_&year
  Pop18to64PoorEnglishLang_&year
  Pop25andOverWoutHS_&year
  Pop5to17PoorEnglishLang_&year
  Pop65andOverPoorEnglishLang_&year
  PopAsianPILangAtHome_&year
  PopBelow200PctPoverty_&year
  PopEmployedIndAgricMining_&year
  PopEmployedIndTransport_&year
  PopEmployedIndFIRE_&year
  PopEmployedIndProfessional_&year
  PopEmployedIndEducational_&year
  PopEmployedIndArts_&year
  PopEmployedOccConstruction_&year
  PopEmployedOccManagement_&year
  PopEmployedOccMngmtAndProf_&year
  PopEmployedOccProduction_&year
  PopEmployedOccSales_&year
  PopEmployedOccService_&year
  PopEnglishLangAtHome_&year
  PopFemale16andOverEmployed_&year
  PopMale16andOverEmployed_&year
  PopOtherLangAtHome_&year
  PopSpanishLangAtHome_&year
  /* DenHshldsforPctIncOnHsg_&year */
  PopMinorityAlone_&year
  PopMinorityBridge_&year
  /* 
  NumHshldFemaleHeaded_&year 
  NumRenterOccHsgAge35_54_&year
  NumRenterOccHsgAge55_64_&year
  NumRenterOccHsgAge74p_&year
  NumOwnerOccHsgAge35_54_&year
  NumOwnerOccHsgAge55_64_&year
  NumOwnerOccHsgAge74p_&year
  NumOccupiedHsgAge15_24_&year
  NumOccupiedHsgAge25_34_&year
  NumOccupiedHsgAge35_54_&year
  NumOccupiedHsgAge55_64_&year
  NumOccupiedHsgAge65_74_&year
  NumOccupiedHsgAge74p_&year
  DenomPoorMarriedCoupleWKid_&year
  DenomPoorMarriedCoupleNKid_&year
  DenomPoorFemaleHeadWKid_&year
  DenomPoorMaleHeadWKid_&year
  DenomPoorOtherFamily_&year
  DenomPoorNonfamily_&year
  NumRenterOccOtherFamily_&year
  NumOwnerOccOtherFamily_&year
  */
  NumOccupiedHsgUnitsMin_&year
  NumOwnerOccHsgUnitsMin_&year
  NumRenterOccHsgUnitsMin_&year
  /*
  PopAsianOtherAsian_&year
  Pop5andOverWDisability_&year
  Pop5to15WDisability_&year
  Pop16to64WDisability_&year
  Pop65andoverWDisability_&year
  Pop5andOverWDisabilityInfo_&year
  Pop5to15WDisabilityInfo_&year
  Pop16to64WDisabilityInfo_&year
  Pop65andoverWDisabilityInfo_&year
  PopSelfcareDisability_&year
  PopMentalDisability_&year
  PopSensoryDisability_&year
  NumHshldsWIncompleteKitchen_&year
  */
  Pop25andOverWHS_&year
  /* PopForeign_OceaniaOth_&year */
  PopOtherRaceNonHispBridge_&year 
    ;

  run;

  proc datasets library=work memtype=(data) nolist;
    modify Ncdb_sum_&year._was15_tr00;
    label %include "&_dcdata_default_path\NCDB\Prog\Sum_var_labels.inc"; ;
  quit;

  run;
  
  ** County-level data set for &year **;

  %let Count_vars = agg: Children: elderly: females: grossrent: males: num: 
        people: persons: pop: poverty: tot: ;

  %let Prop_vars = median: ;

  proc summary data=Ncdb_sum_&year._was15_tr00;
    where put( geo2000, $cntym15f. ) ~= "";
    by county;
    var &Count_vars &Prop_vars;
    output out=Ncdb_sum_&year._was15_regcnt (drop=_type_ _freq_)
      sum(&Count_vars)= 
      mean(&Prop_vars)=;
  run;

%mend Summary;

/** End Macro Definition **/


%Summary( year=1990, data=Ncdb_1990_2000_was15, geosuf=tr00, geo=Geo2000, geofmt=$geo00a. )
%Summary( year=2000, data=Ncdb_lf_2000_was15, geosuf=tr00, geo=Geo2000, geofmt=$geo00a. )



**** Combine all years and create final data sets ****;

/** Macro Combine - Start Definition **/

%macro Combine( geo=, years= );

  %local geolbl geosuf i v;
  
  %if %upcase( &geo ) = GEO2000 %then %do;
    %let geolbl =  Census tract (2000);
    %let geosuf = tr00;
  %end;
  %else %if %upcase( &geo ) = COUNTY %then %do;
    %let geolbl =  County;
    %let geosuf = regcnt;
  %end;

  ** Combine all for years for %upcase(&geo) **;

  data Ncdb_sum_was15_&geosuf;

    merge 
    
      %let i = 1;
      %let v = %scan( &years, &i, %str( ) );

      %do %until ( &v = );

        Ncdb_sum_&v._was15_&geosuf  

        %let i = %eval( &i + 1 );
        %let v = %scan( &years, &i, %str( ) );

      %end;
    
    ;
    
    by &geo;
    
    drop 
      NumHHMovedIn20YearsOrMore_1990
      NumHHMovedInLast5Years_1990
      NumHsgUnitsBuilt95toMar00_1990
      NumHshldsforPctInc_1990
      NumHshldsOver30PctInc_1990 
      NumHshldsOver50PctInc_1990  
      NumHshldsOvercrowded_1990
      NumHshldsSevOvercrowded_1990
      NumHshldsWInc100000plus_1990
      NumHshldsWInc15000to34999_1990
      NumHshldsWInc35000to49999_1990
      NumHshldsWInc50000to74999_1990
      NumHshldsWIncUnder15000_1990
      NumOwnerHshldsforPctInc_1990 
      NumOwnerHshldsOver30PctInc_1990 
      NumOwnerHshldsOver50PctInc_1990 
      NumRenterHshldsforPctInc_1990
      NumRenterHshldsOver30PctInc_1990
      NumRenterHshldsOver50PctInc_1990
      NumRenterHshldsRent1000plus_1990
      NumRenterHshldsRent300to399_1990
      NumRenterHshldsRent400to499_1990
      NumRenterHshldsRent500to599_1990
      NumRenterHshldsRent600to699_1990
      NumRenterHshldsRent700to799_1990
      NumRenterHshldsRent800to999_1990
      NumRenterHshldsRentUnder300_1990
      PopEmployedIndAgricMining_1990
      PopEmployedIndArts_1990 
      PopEmployedIndEducational_1990  
      PopEmployedIndFIRE_1990
      PopEmployedIndProfessional_1990
      PopEmployedIndTransport_1990
      PopEmployedOccConstruction_1990
      PopEmployedOccManagement_1990
      PopEmployedOccProduction_1990
      PopEmployedOccSales_1990 
      PopEmployedOccService_1990  
      PopWhiteNonHispAlone_1990;

  run;

  %Finalize_data_set( 
    /** Finalize data set parameters **/
    data=Ncdb_sum_was15_&geosuf,
    out=Ncdb_sum_was15_&geosuf,
    outlib=Ncdb,
    label="NCDB summary, Washington region (2015), &geolbl",
    sortby=&geo,
    /** Metadata parameters **/
    restrictions=None,
    revisions=%str(New file.),
    /** File info parameters **/
    printobs=0,
    freqvars=county
  )

%mend Combine;

/** End Macro Definition **/


%Combine( geo=Geo2000, years=1990 2000 )
%Combine( geo=County, years=1990 2000 )
