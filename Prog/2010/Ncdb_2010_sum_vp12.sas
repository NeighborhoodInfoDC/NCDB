/**************************************************************************
 Program:  Ncdb_2010_sum_vp12.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   S. Zhang
 Created:  12/18/12
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create all NCDB 2010 DC 2012 Voting Precinct summary level files, with
 DataPlace variable names, from block data.

 Modifications:
  13/18/12 SXZ Summary files for 2012 Voting Precincts only
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )

** Start submitting commands to remote server **;

rsubmit;

/** Change to N for testing, Y for final batch mode run **/
%let register = Y;

/** Update with information on latest file revision **/
%let revisions=%str(New file.);

%let year = 2010;
%let y    = 1;

%let sum_vars = TotPop: Pop: Num: ;


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
      out=Ncdb.Ncdb_sum_2010&geosuf 
            (label="NCDB summary, 2010, DC, &geodlbl" 
             sortedby=&geo
             drop=_type_ _freq_) 
      sum=;
    format &geo &geofmt;
  run;
  
  x "purge [dcdata.ncdb.data]Ncdb_sum_2010&geosuf..*";
  
  %File_info( data=Ncdb.Ncdb_sum_2010&geosuf, printobs=0 )
  
  %if %upcase( &register ) = Y %then %do;

    %Dc_update_meta_file(
      ds_lib=NCDB,
      ds_name=Ncdb_sum_2010&geosuf,
      creator_process=Ncdb_2010_sum_vp12.sas,
      restrictions=None,
      revisions=%str(&revisions)
    )

  %end;

  %exit_macro:

%mend Ncdb_sum_geo;

/** End Macro Definition **/


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
    TOTHSUN&y.=NumHsgUnits_&year
    OCCHU&y.=NumOccupiedHsgUnits_&year
    VACHU&y.=NumVacantHsgUnits_&year;

  keep 
    _char_ TRCTPOP&y. shr&y.d SHRHSP&y.N SHRNHA&y.N SHRNHB&y.N SHRNHI&y.N SHRNHO&y.N SHRNHW&y.N
    MINNHA&y.N MINNHB&y.N MINNHI&y.N MINNHO&y.N MINNHW&y.N MRANHS&y.N 
    PopOtherRaceNonHispBridge_&year PopMinorityAlone_&year PopMinorityBridge_&year
    CHILD&y.N TOTHSUN&y. OCCHU&y. VACHU&y. ;

run;

proc datasets library=Work memtype=(data);
  modify Ncdb_2010;
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


%Ncdb_sum_geo( geo=voterpre2012 )
/*
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
*/
run;

endrsubmit;

** End submitting commands to remote server **;

signoff;

