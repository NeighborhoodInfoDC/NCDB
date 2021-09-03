/**************************************************************************
 Program:  Ncdb_2020_dc_tables.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/03/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  28
 
 Description:  Tables from 2000, 2010 and 2020 NCDB data.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( Census )

%let yra = 1;
%let yrb = 2;
%let yeara = 2010;
%let yearb = 2020;


***********************************************************************************************
**** Summarize NCDB data by ward;

%let var2000 = 
  TRCTPOP0 SHR0D
  SHRWHT0N SHRBLK0N SHRAMI0N SHRASN0N SHRHIP0N SHRAPI0N SHROTH0N
  SHRNHW0N SHRNHB0N SHRNHI0N SHRNHR0N SHRNHH0N SHRNHA0N SHRNHO0N SHRHSP0N NONHISP0
  MINWHT0N MINBLK0N MINAMI0N MINASN0N MINHIP0N MINAPI0N MINOTH0N
  MINNHW0N MINNHB0N MINNHI0N MINNHR0N MINNHH0N MINNHA0N MINNHO0N
  MAXWHT0N MAXBLK0N MAXAMI0N MAXASN0N MAXHIP0N MAXAPI0N MAXOTH0N
  MAXNHW0N MAXNHB0N MAXNHI0N MAXNHR0N MAXNHH0N MAXNHA0N MAXNHO0N
  MRAPOP0N MR1POP0N MR2POP0N MR3POP0N MRANHS0N MRAHSP0N
  ADULT0N CHILD0N
  TOTHSUN0 OCCHU0 VACHU0;

%let var2010 = 
  TRCTPOP1 SHR1D
  SHRWHT1N SHRBLK1N SHRAMI1N SHRASN1N SHRHIP1N SHRAPI1N SHROTH1N
  SHRNHW1N SHRNHB1N SHRNHI1N SHRNHR1N SHRNHH1N SHRNHA1N SHRNHO1N SHRHSP1N NONHISP1
  MINWHT1N MINBLK1N MINAMI1N MINASN1N MINHIP1N MINAPI1N MINOTH1N
  MINNHW1N MINNHB1N MINNHI1N MINNHR1N MINNHH1N MINNHA1N MINNHO1N
  MAXWHT1N MAXBLK1N MAXAMI1N MAXASN1N MAXHIP1N MAXAPI1N MAXOTH1N
  MAXNHW1N MAXNHB1N MAXNHI1N MAXNHR1N MAXNHH1N MAXNHA1N MAXNHO1N
  MRAPOP1N MR1POP1N MR2POP1N MR3POP1N MRANHS1N MRAHSP1N
  ADULT1N CHILD1N
  TOTHSUN1 OCCHU1 VACHU1;

%let var2020 = 
  TRCTPOP2 SHR2D
  SHRWHT2N SHRBLK2N SHRAMI2N SHRASN2N SHRHIP2N SHRAPI2N SHROTH2N
  SHRNHW2N SHRNHB2N SHRNHI2N SHRNHR2N SHRNHH2N SHRNHA2N SHRNHO2N SHRHSP2N NONHISP2
  MINWHT2N MINBLK2N MINAMI2N MINASN2N MINHIP2N MINAPI2N MINOTH2N
  MINNHW2N MINNHB2N MINNHI2N MINNHR2N MINNHH2N MINNHA2N MINNHO2N
  MAXWHT2N MAXBLK2N MAXAMI2N MAXASN2N MAXHIP2N MAXAPI2N MAXOTH2N
  MAXNHW2N MAXNHB2N MAXNHI2N MAXNHR2N MAXNHH2N MAXNHA2N MAXNHO2N
  MRAPOP2N MR2POP2N MR2POP2N MR3POP2N MRANHS2N MRAHSP2N
  ADULT2N CHILD2N
  TOTHSUN2 OCCHU2 VACHU2;

%let geo = ward2012;

** 2000 data **;

data Ncdb_lf_2000_dc;

  set Ncdb.Ncdb_lf_2000_was15 (where=(statecd='11'));
  
run;

%Transform_geo_data(
    /***dat_ds_name=Ncdb.Ncdb_lf_2000_dc,***/
    dat_ds_name=Ncdb_lf_2000_dc,
    dat_org_geo=geo2000,
    dat_count_vars=&var2000,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_ward12,
    wgt_org_geo=geo2000,
    wgt_new_geo=ward2012,
    wgt_id_vars=,
    wgt_wgt_var=popwt,
    out_ds_name=Ncdb_2000_dc_sum,
    out_ds_label=,
    calc_vars=,
    calc_vars_labels=,
    keep_nonmatch=N,
    show_warnings=10,
    print_diag=Y,
    full_diag=N
  )

** 2010 data **;

proc summary data=Ncdb.Ncdb_2010_dc_blk nway;
  class &geo;
  var &var2010;
  output out=Ncdb_2010_dc_sum (drop=_type_ _freq_) sum= ;
run;

** 2020 data **;

proc summary data=Ncdb.Ncdb_2020_dc_blk nway;
  class &geo;
  var &var2020;
  output out=Ncdb_2020_dc_sum (drop=_type_ _freq_) sum= ;
run;

data Table;

  merge 
    Ncdb_2000_dc_sum 
    Ncdb_2010_dc_sum 
    Ncdb_2020_dc_sum;
  by &geo;

  trctpop_chg = trctpop&yrb - trctpop&yra;
  tothsun_chg = tothsun&yrb - TOTHSUN&yra;
  occhu_chg = occhu&yrb - occhu&yra;
  
run;


***********************************************************************************************
**** Create tables;

options nodate nonumber;
options orientation=landscape;

%fdate()

ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_dc_tables.rtf" style=Styles.Rtf_arial_9pt;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

**** Population & housing unit counts ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var TRCTPOP&yra TOTHSUN&yra OCCHU&yra TRCTPOP&yrb TOTHSUN&yrb OCCHU&yrb trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='Population' * (
      TRCTPOP&yra="&yeara"
      TRCTPOP&yrb="&yearb"
    )
    pctsum<TRCTPOP&yra>='% Change' * trctpop_chg=' ' * f=comma8.1
    sum='Total Housing Units' * (
      TOTHSUN&yra="&yeara"
      TOTHSUN&yrb="&yearb"
    )
    pctsum<TOTHSUN&yra>='% Change' * tothsun_chg=' ' * f=comma8.1
    sum='Occupied Housing Units' * (
      OCCHU&yra="&yeara"
      OCCHU&yrb="&yearb"
    )
    pctsum<OCCHU&yra>='% Change' * occhu_chg=' ' * f=comma8.1
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "Population and Housing Unit Counts - &yeara vs. &yearb";
run;

********  COUNTS  ********;

**** SHR: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var SHR&yra.D SHRWHT&yra.N SHRBLK&yra.N SHRAMI&yra.N SHRASN&yra.N SHRHIP&yra.N SHRAPI&yra.N SHROTH&yra.N 
      SHR&yrb.D SHRWHT&yrb.N SHRBLK&yrb.N SHRAMI&yrb.N SHRASN&yrb.N SHRHIP&yrb.N SHRAPI&yrb.N SHROTH&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      shrwht&yra.n='White'
      shrblk&yra.n='Black'
      shrami&yra.n='Am. Indian'
      shrapi&yra.n='Asian/PI'
      shroth&yra.n='Other'
    )
    sum="&yearb" * ( 
      shrwht&yrb.n='White'
      shrblk&yrb.n='Black'
      shrami&yrb.n='Am. Indian'
      shrapi&yrb.n='Asian/PI'
      shroth&yrb.n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
  title4 'Population by Race';
run;

**** SHR: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var SHR&yra.D SHRNHW&yra.N SHRNHB&yra.N SHRNHI&yra.N SHRNHR&yra.N SHRNHH&yra.N SHRNHA&yra.N SHRNHO&yra.N SHRHSP&yra.N  
      SHR&yrb.D SHRNHW&yrb.N SHRNHB&yrb.N SHRNHI&yrb.N SHRNHR&yrb.N SHRNHH&yrb.N SHRNHA&yrb.N SHRNHO&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      shrnhw&yra.n='NH White'
      shrnhb&yra.n='NH Black'
      shrnhi&yra.n='NH Am. Indian'
      shrnha&yra.n='NH Asian/PI'
      shrnho&yra.n='NH Other'
      shrhsp&yra.n='Hispanic'
    )
    sum="&yearb" * ( 
      shrnhw&yrb.n='NH White'
      shrnhb&yrb.n='NH Black'
      shrnhi&yrb.n='NH Am. Indian'
      shrnha&yrb.n='NH Asian/PI'
      shrnho&yrb.n='NH Other'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
run;

**** MIN: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr&yra.d minWHT&yra.N minBLK&yra.N minAMI&yra.N minASN&yra.N minHIP&yra.N minAPI&yra.N minOTH&yra.N MRAPOP&yra.N
      shr&yrb.d minWHT&yrb.N minBLK&yrb.N minAMI&yrb.N minASN&yrb.N minHIP&yrb.N minAPI&yrb.N minOTH&yrb.N MRAPOP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      minwht&yra.n='White alone'
      minblk&yra.n='Black alone'
      minami&yra.n='Am. Indian alone'
      minapi&yra.n='Asian/PI alone'
      minoth&yra.n='Other alone'
      mrapop&yra.n='Multiracial'
    )
    sum="&yearb" * ( 
      minwht&yrb.n='White alone'
      minblk&yrb.n='Black alone'
      minami&yrb.n='Am. Indian alone'
      minapi&yrb.n='Asian/PI alone'
      minoth&yrb.n='Other alone'
      mrapop&yrb.n='Multiracial'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
  title4 'Population by Race';
run;

**** MIN: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr&yra.d minNHW&yra.N minNHB&yra.N minNHI&yra.N minNHR&yra.N minNHH&yra.N minNHA&yra.N minNHO&yra.N MRANHS&yra.N SHRHSP&yra.N  
      shr&yrb.d minNHW&yrb.N minNHB&yrb.N minNHI&yrb.N minNHR&yrb.N minNHH&yrb.N minNHA&yrb.N minNHO&yrb.N MRANHS&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      minnhw&yra.n='NH White alone'
      minnhb&yra.n='NH Black alone'
      minnhi&yra.n='NH Am. Indian alone'
      minnha&yra.n='NH Asian/PI alone'
      minnho&yra.n='NH Other alone'
      mranhs&yra.n='NH Multiracial'
      shrhsp&yra.n='Hispanic'
    )
    sum="&yearb" * ( 
      minnhw&yrb.n='NH White alone'
      minnhb&yrb.n='NH Black alone'
      minnhi&yrb.n='NH Am. Indian alone'
      minnha&yrb.n='NH Asian/PI alone'
      minnho&yrb.n='NH Other alone'
      mranhs&yrb.n='NH Multiracial'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
run;

**** MAX: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr&yra.d maxWHT&yra.N maxBLK&yra.N maxAMI&yra.N maxASN&yra.N maxHIP&yra.N maxAPI&yra.N maxOTH&yra.N
      shr&yrb.d maxWHT&yrb.N maxBLK&yrb.N maxAMI&yrb.N maxASN&yrb.N maxHIP&yrb.N maxAPI&yrb.N maxOTH&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      maxwht&yra.n='White'
      maxblk&yra.n='Black'
      maxami&yra.n='Am. Indian'
      maxapi&yra.n='Asian/PI'
      maxoth&yra.n='Other'
    )
    sum="&yearb" * ( 
      maxwht&yrb.n='White'
      maxblk&yrb.n='Black'
      maxami&yrb.n='Am. Indian'
      maxapi&yrb.n='Asian/PI'
      maxoth&yrb.n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
  title4 'Population by Race';
  title5 'NOTE: Subgroups will not add to total population.';
run;

**** MAX: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr&yra.d maxNHW&yra.N maxNHB&yra.N maxNHI&yra.N maxNHR&yra.N maxNHH&yra.N maxNHA&yra.N maxNHO&yra.N SHRHSP&yra.N  
      shr&yrb.d maxNHW&yrb.N maxNHB&yrb.N maxNHI&yrb.N maxNHR&yrb.N maxNHH&yrb.N maxNHA&yrb.N maxNHO&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      maxnhw&yra.n='NH White'
      maxnhb&yra.n='NH Black'
      maxnhi&yra.n='NH Am. Indian'
      maxnha&yra.n='NH Asian/PI'
      maxnho&yra.n='NH Other'
      shrhsp&yra.n='Hispanic'
    )
    sum="&yearb" * ( 
      maxnhw&yrb.n='NH White'
      maxnhb&yrb.n='NH Black'
      maxnhi&yrb.n='NH Am. Indian'
      maxnha&yrb.n='NH Asian/PI'
      maxnho&yrb.n='NH Other'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  title5 'NOTE: Subgroups will not add to total population.';
run;

**** Child vs. Adult population ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var TRCTPOP&yra child&yra.n adult&yra.n TRCTPOP&yrb child&yrb.n adult&yrb.n;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum="&yeara" * (
      TRCTPOP&yra='Total'
      child&yra.n='Children under 18'
      adult&yra.n='Adults 18+'
    )
    sum="&yearb" * ( 
      TRCTPOP&yrb='Total'
      child&yrb.n='Children under 18'
      adult&yrb.n='Adults 18+'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "Child and Adult Population - &yeara vs. &yearb";
  title4 'Persons';
run;


********    PERCENTAGES    ********;

**** SHR: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var SHR&yra.D SHRWHT&yra.N SHRBLK&yra.N SHRAMI&yra.N SHRASN&yra.N SHRHIP&yra.N SHRAPI&yra.N SHROTH&yra.N 
      SHR&yrb.D SHRWHT&yrb.N SHRBLK&yrb.N SHRAMI&yrb.N SHRASN&yrb.N SHRHIP&yrb.N SHRAPI&yrb.N SHROTH&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      shrwht&yra.n='White'
      shrblk&yra.n='Black'
      shrami&yra.n='Am. Indian'
      shrapi&yra.n='Asian/PI'
      shroth&yra.n='Other'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      shrwht&yrb.n='White'
      shrblk&yrb.n='Black'
      shrami&yrb.n='Am. Indian'
      shrapi&yrb.n='Asian/PI'
      shroth&yrb.n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
  title4 'Percent Population by Race';
run;

**** SHR: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var SHR&yra.D SHRNHW&yra.N SHRNHB&yra.N SHRNHI&yra.N SHRNHR&yra.N SHRNHH&yra.N SHRNHA&yra.N SHRNHO&yra.N SHRHSP&yra.N  
      SHR&yrb.D SHRNHW&yrb.N SHRNHB&yrb.N SHRNHI&yrb.N SHRNHR&yrb.N SHRNHH&yrb.N SHRNHA&yrb.N SHRNHO&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      shrnhw&yra.n='NH White'
      shrnhb&yra.n='NH Black'
      shrnhi&yra.n='NH Am. Indian'
      shrnha&yra.n='NH Asian/PI'
      shrnho&yra.n='NH Other'
      shrhsp&yra.n='Hispanic'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      shrnhw&yrb.n='NH White'
      shrnhb&yrb.n='NH Black'
      shrnhi&yrb.n='NH Am. Indian'
      shrnha&yrb.n='NH Asian/PI'
      shrnho&yrb.n='NH Other'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
run;

**** MIN: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr&yra.d minWHT&yra.N minBLK&yra.N minAMI&yra.N minASN&yra.N minHIP&yra.N minAPI&yra.N minOTH&yra.N MRAPOP&yra.N
      shr&yrb.d minWHT&yrb.N minBLK&yrb.N minAMI&yrb.N minASN&yrb.N minHIP&yrb.N minAPI&yrb.N minOTH&yrb.N MRAPOP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      minwht&yra.n='White alone'
      minblk&yra.n='Black alone'
      minami&yra.n='Am. Indian alone'
      minapi&yra.n='Asian/PI alone'
      minoth&yra.n='Other alone'
      mrapop&yra.n='Multiracial'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      minwht&yrb.n='White alone'
      minblk&yrb.n='Black alone'
      minami&yrb.n='Am. Indian alone'
      minapi&yrb.n='Asian/PI alone'
      minoth&yrb.n='Other alone'
      mrapop&yrb.n='Multiracial'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
  title4 'Percent Population by Race';
run;

**** MIN: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr&yra.d minNHW&yra.N minNHB&yra.N minNHI&yra.N minNHR&yra.N minNHH&yra.N minNHA&yra.N minNHO&yra.N MRANHS&yra.N SHRHSP&yra.N  
      shr&yrb.d minNHW&yrb.N minNHB&yrb.N minNHI&yrb.N minNHR&yrb.N minNHH&yrb.N minNHA&yrb.N minNHO&yrb.N MRANHS&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      minnhw&yra.n='NH White alone'
      minnhb&yra.n='NH Black alone'
      minnhi&yra.n='NH Am. Indian alone'
      minnha&yra.n='NH Asian/PI alone'
      minnho&yra.n='NH Other alone'
      mranhs&yra.n='NH Multiracial'
      shrhsp&yra.n='Hispanic'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      minnhw&yrb.n='NH White alone'
      minnhb&yrb.n='NH Black alone'
      minnhi&yrb.n='NH Am. Indian alone'
      minnha&yrb.n='NH Asian/PI alone'
      minnho&yrb.n='NH Other alone'
      mranhs&yrb.n='NH Multiracial'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
run;

**** MAX: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr&yra.d maxWHT&yra.N maxBLK&yra.N maxAMI&yra.N maxASN&yra.N maxHIP&yra.N maxAPI&yra.N maxOTH&yra.N
      shr&yrb.d maxWHT&yrb.N maxBLK&yrb.N maxAMI&yrb.N maxASN&yrb.N maxHIP&yrb.N maxAPI&yrb.N maxOTH&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      maxwht&yra.n='White'
      maxblk&yra.n='Black'
      maxami&yra.n='Am. Indian'
      maxapi&yra.n='Asian/PI'
      maxoth&yra.n='Other'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      maxwht&yrb.n='White'
      maxblk&yrb.n='Black'
      maxami&yrb.n='Am. Indian'
      maxapi&yrb.n='Asian/PI'
      maxoth&yrb.n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
  title4 'Percent Population by Race';
  title5 'NOTE: Percentages will not add to 100.';
run;

**** MAX: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr&yra.d maxNHW&yra.N maxNHB&yra.N maxNHI&yra.N maxNHR&yra.N maxNHH&yra.N maxNHA&yra.N maxNHO&yra.N SHRHSP&yra.N  
      shr&yrb.d maxNHW&yrb.N maxNHB&yrb.N maxNHI&yrb.N maxNHR&yrb.N maxNHH&yrb.N maxNHA&yrb.N maxNHO&yrb.N SHRHSP&yrb.N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr&yra.d>="&yeara" * (
      maxnhw&yra.n='NH White'
      maxnhb&yra.n='NH Black'
      maxnhi&yra.n='NH Am. Indian'
      maxnha&yra.n='NH Asian/PI'
      maxnho&yra.n='NH Other'
      shrhsp&yra.n='Hispanic'
    )
    pctsum<shr&yrb.d>="&yearb" * ( 
      maxnhw&yrb.n='NH White'
      maxnhb&yrb.n='NH Black'
      maxnhi&yrb.n='NH Am. Indian'
      maxnha&yrb.n='NH Asian/PI'
      maxnho&yrb.n='NH Other'
      shrhsp&yrb.n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  title5 'NOTE: Percentages will not add to 100.';
run;

**** Child vs. Adult population ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var TRCTPOP&yra child&yra.n adult&yra.n TRCTPOP&yrb child&yrb.n adult&yrb.n;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<TRCTPOP&yra>="&yeara" * (
      TRCTPOP&yra='Total'
      child&yra.n='Children under 18'
      adult&yra.n='Adults 18+'
    )
    pctsum<TRCTPOP&yrb>="&yearb" * ( 
      TRCTPOP&yrb='Total'
      child&yrb.n='Children under 18'
      adult&yrb.n='Adults 18+'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 "Child and Adult Population - &yeara vs. &yearb";
  title4 'Percent Persons';
run;

ods rtf close;

