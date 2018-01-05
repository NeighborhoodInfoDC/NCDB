/**************************************************************************
 Program:  Ncdb_2010_sum_was15.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/22/17
 Version:  SAS 9.2
 Environment:  Local Windows session (desktop)
 
 Description:  Create 2010 NCDB tract and county level summary files
for Washington metro area (2015).

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )

%let year = 2010;
%let y = 1;

** Tract-level summary data set for &year **;

data Ncdb_sum_&year._was15_tr10;

  set Ncdb.Ncdb_2010_was15;
  
  %Regcnt( invar=Geo2010 )

  label County = "County";

  format county $cnty15f.;
  
  PopMinorityAlone_&year = sum(shr&y.d,-minnhw&y.n);
  PopMinorityBridge_&year = sum(shr&y.d,-shrnhw&y.n);
  
  PopOtherRaceNonHispBridge_&year = shr&y.d - sum( shrnhb&y.n, shrnhw&y.n, shrhsp&y.n, shrnha&y.n );

  rename
    TRCTPOP&y.=TotPop_&year
    shr&y.d   = PopWithRace_&year
    MINNHW&y.N=PopWhiteNonHispAlone_&year
    SHRNHW&y.N=PopWhiteNonHispBridge_&year
    MINNHA&y.N=PopAsianPINonHispAlone_&year
    SHRNHA&y.N=PopAsianPINonHispBridge_&year
    MINNHB&y.N=PopBlackNonHispAlone_&year
    SHRNHB&y.N=PopBlackNonHispBridge_&year
    SHRHSP&y.N=PopHisp_&year
    MRANHS&y.N=PopMultiracialNonHisp_&year
    MINNHI&y.N=PopNativeAmNonHispAlone_&year
    SHRNHI&y.N=PopNativeAmNonHispBridge_&year
    MINNHO&y.N=PopOtherNonHispAlone_&year
    SHRNHO&y.N=PopOtherNonHispBridge_&year
    CHILD&y.N=PopUnder18Years_&year
    TOTHSUN&y.=NumHsgUnits_&year
    OCCHU&y.=NumOccupiedHsgUnits_&year
    VACHU&y.=NumVacantHsgUnits_&year;

  keep 
    Geo2010 county TRCTPOP&y. shr&y.d SHRHSP&y.N SHRNHA&y.N SHRNHB&y.N SHRNHI&y.N SHRNHO&y.N SHRNHW&y.N
    MINNHA&y.N MINNHB&y.N MINNHI&y.N MINNHO&y.N MINNHW&y.N MRANHS&y.N 
    PopOtherRaceNonHispBridge_&year PopMinorityAlone_&year PopMinorityBridge_&year
    CHILD&y.N TOTHSUN&y. OCCHU&y. VACHU&y. ;

run;

proc datasets library=Work memtype=(data);
  modify Ncdb_sum_&year._was15_tr10;
  label
    TotPop_&year = "Total population, &year"
    PopWithRace_&year = "Total population for race/ethnicity, &year"
    PopUnder18Years_&year = "Persons under 18 years old, &year"
    PopBlackNonHispAlone_&year = "Non-Hispanic Black/African American alone population, &year"
    PopWhiteNonHispAlone_&year = "Non-Hispanic White alone population, &year"
    PopAsianPINonHispAlone_&year = "Non-Hispanic Asian, Hawaiian and Pacific Islander alone pop., &year"
    PopNativeAmNonHispAlone_&year = "Non-Hispanic American Indian/Alaska Native alone population, &year"
    PopOtherNonHispAlone_&year = "Non-Hispanic other race alone population, &year"
    PopHisp_&year = "Hispanic/Latino population, &year"
    PopMultiracialNonHisp_&year = "Non-Hispanic multiracial population, &year"
    PopBlackNonHispBridge_&year = "Non-Hispanic Black/African American population, &year"
    PopWhiteNonHispBridge_&year = "Non-Hispanic White population, &year"
    PopAsianPINonHispBridge_&year = "Non-Hispanic Asian, Hawaiian and other Pacific Islander pop., &year"
    PopNativeAmNonHispBridge_&year = "Non-Hispanic American Indian/Alaska Native population, &year"
    PopOtherNonHispBridge_&year = "Non-Hispanic other race population, &year"
    PopOtherRaceNonHispBridge_&year = "Non-Hispanic persons other than white, black, or Asian/PI, &year"
    PopMinorityAlone_&year = "Minority pop, that is those who are not non-Hispanic white alone, &year"
    PopMinorityBridge_&year = "Minority pop, those who are not non-Hisp white (1990 race def), &year"
    NumHsgUnits_&year = "Total housing units, &year"
    NumOccupiedHsgUnits_&year = "Occupied housing units, &year"
    NumVacantHsgUnits_&year = "Vacant housing units, &year";
quit;

%Finalize_data_set( 
  /** Finalize data set parameters **/
  data=Ncdb_sum_&year._was15_tr10,
  out=Ncdb_sum_&year._was15_tr10,
  outlib=NCDB,
  label="NCDB summary, 2010, Washington region (2015), Census tract (2010)",
  sortby=Geo2010,
  /** Metadata parameters **/
  restrictions=None,
  revisions=%str(New file.),
  /** File info parameters **/
  contents=Y,
  printobs=0,
  freqvars=county
)

** County-level data set for &year **;

%let Count_vars = num: pop: tot: ;

proc summary data=Ncdb_sum_&year._was15_tr10;
  where put( county, $cntym15f. ) ~= "";
  by county;
  var &Count_vars;
  output out=Ncdb_sum_&year._was15_regcnt (drop=_type_ _freq_)
    sum(&Count_vars)=;
run;

%Finalize_data_set( 
  /** Finalize data set parameters **/
  data=Ncdb_sum_&year._was15_regcnt,
  out=Ncdb_sum_&year._was15_regcnt,
  outlib=NCDB,
  label="NCDB summary, 2010, Washington region (2015), County",
  sortby=county,
  /** Metadata parameters **/
  restrictions=None,
  revisions=%str(New file.),
  /** File info parameters **/
  contents=Y,
  printobs=0,
  freqvars=county
)

