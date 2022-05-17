/**************************************************************************
 Program:  Ncdb_2010_sum_all.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/23/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Create all NCDB 2010 DC geo summary level files, with
 DataPlace variable names, from block data.

 Modifications:
  12/19/12 SXZ Updated to create summaries by 2012 Voting Precincts 
  03/28/11 PAT Added metadata registration.
  05/04/11 PAT Added EOR geography.
  09/09/12 PAT Updated for new 2010/2012 geos.
  03/26/15 PAT Udated for SAS1 server.
               Added Pop65andOverYears_2010.
  03/20/17 RP Added bridge park geography. 
  03/22/17 RP Fixed order of datasteps to correct errors when running in batch mode. 
  03/16/18 RP Added cluster 2017 geography.
  05/22/18 RP Added stanton commons geography.
  05/17/22 EB Added ward 2022 geography
**************************************************************************/

%include "\\sas1\dcdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )

/** Update with information on latest file revision **/
%let revisions = %str(Added Stanton Commons geography);

%let year = 2010;
%let y    = 1;

%let sum_vars = TotPop: Pop: Num: ;


** Create DataPlace-compatible variable names **;

data Ncdb_2010;

  set Ncdb.NCDB_2010_dc_blk;
  
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
    OLD&y.N=Pop65andOverYears_&year
    TOTHSUN&y.=NumHsgUnits_&year
    OCCHU&y.=NumOccupiedHsgUnits_&year
    VACHU&y.=NumVacantHsgUnits_&year;

  keep 
    _char_ TRCTPOP&y. shr&y.d SHRHSP&y.N SHRNHA&y.N SHRNHB&y.N SHRNHI&y.N SHRNHO&y.N SHRNHW&y.N
    MINNHA&y.N MINNHB&y.N MINNHI&y.N MINNHO&y.N MINNHW&y.N MRANHS&y.N 
    PopOtherRaceNonHispBridge_&year PopMinorityAlone_&year PopMinorityBridge_&year
    CHILD&y.N OLD&y.N TOTHSUN&y. OCCHU&y. VACHU&y. ;

run;

proc datasets library=Work memtype=(data);
  modify Ncdb_2010;
  label
    TotPop_&year = "Total population, &year"
    PopWithRace_&year = "Total population for race/ethnicity, &year"
    PopUnder18Years_&year = "Persons under 18 years old, &year"
    Pop65andOverYears_&year = "Persons 65 years old and over, &year"
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


/** Macro Ncdb_sum_geo - Start Definition **/

%macro Ncdb_sum_geo( geo= );

  %local geosuf geodlbl geofmt;

  %let geo = %upcase( &geo );

  %if %sysfunc( putc( &geo, $geoval. ) ) ~= %then %do;
    %let geosuf = %sysfunc( putc( &geo, $geosuf. ) );
    %let geodlbl = %qsysfunc( putc( &geo, $geodlbl. ) );
    %let geofmt = %sysfunc( putc( &geo, $geoafmt. ) );
  %end;
  %else %do;
    %err_mput( macro=Create_sum_geo, msg=Invalid or missing value of GEO= parameter (GEO=&geo). )
    %goto exit_macro;
  %end;
      
  %put _local_;
  
  ** Convert data to single obs. per geographic unit & year **;

  proc summary data=Ncdb_2010 nway completetypes;
    class &geo / preloadfmt;
    var &sum_vars;
    output 
      out=Ncdb_sum_2010&geosuf 
            (label="NCDB summary, 2010, DC, &geodlbl" 
             sortedby=&geo
             drop=_type_ _freq_) 
      sum=;
    format &geo &geofmt;
  run;
  
  %Finalize_data_set(
    data=Ncdb_sum_2010&geosuf,
    out=Ncdb_sum_2010&geosuf,
    outlib=NCDB,
    label="NCDB summary, 2010, DC, &geodlbl",
    sortby=&geo,
    /** Metadata parameters **/
    revisions=%str(&revisions),
    /** File info parameters **/
    printobs=0,
    freqvars=&geo
  )

  %exit_macro:

%mend Ncdb_sum_geo;

/** End Macro Definition **/

%Ncdb_sum_geo( geo=voterpre2012 )
%Ncdb_sum_geo( geo=eor )
%Ncdb_sum_geo( geo=anc2002 )
%Ncdb_sum_geo( geo=anc2012 )
%Ncdb_sum_geo( geo=city )
%Ncdb_sum_geo( geo=cluster_tr2000 )
%Ncdb_sum_geo( geo=psa2004 )
%Ncdb_sum_geo( geo=psa2012 )
%Ncdb_sum_geo( geo=geo2000 )
%Ncdb_sum_geo( geo=geo2010 )
%Ncdb_sum_geo( geo=ward2002 )
%Ncdb_sum_geo( geo=ward2012 )
%Ncdb_sum_geo( geo=zip )
%Ncdb_sum_geo( geo=bridgepk )
%Ncdb_sum_geo( geo=cluster2017 )
%Ncdb_sum_geo( geo=stantoncommons )
%Ncdb_sum_geo( geo=ward2022 )

run;


