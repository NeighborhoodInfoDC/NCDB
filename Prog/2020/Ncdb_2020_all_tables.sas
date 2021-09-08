/**************************************************************************
 Program:  Ncdb_2020_md_tables.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/03/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  28
 
 Description:  Tables from 2000, 2010 and 2020 NCDB data for DC, MD, VA
 jurisdictions in Washington MSA (2015).

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( Census )

%global yra yrb yeara yearb var2000 var2010 var2020;

%let yra = 1;
%let yrb = 2;
%let yeara = 2010;
%let yearb = 2020;

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
  MRAPOP2N MR1POP2N MR2POP2N MR3POP2N MRANHS2N MRAHSP2N
  ADULT2N CHILD2N
  TOTHSUN2 OCCHU2 VACHU2;

proc format;
  value $ward12x
    ' ' = 'DC TOTAL'
    '1' = 'Ward 1'
    '2' = 'Ward 2'
    '3' = 'Ward 3'
    '4' = 'Ward 4'
    '5' = 'Ward 5'
    '6' = 'Ward 6'
    '7' = 'Ward 7'
    '8' = 'Ward 8';
run;


/** Macro Make_output - Start Definition **/

%macro Make_output( st=, geo=, bylabel= );

  %local geolabel;

  %let st = %lowcase( &st );
  
  %if %lowcase( &geo ) = ucounty %then %do;
    %let geolabel = County;
    %let geofmt = $cnty15f.;
  %end;
  %else %if %lowcase( &geo ) = ward2012 %then %do;
    %let geolabel = Ward;
    %let geofmt = $ward12x.;
  %end;

  ** 2000 data **;
  
  %if &st = dc %then %do;
  
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
        out_ds_name=Ncdb_2000_dc_sum_a,
        out_ds_label=,
        calc_vars=,
        calc_vars_labels=,
        keep_nonmatch=N,
        show_warnings=10,
        print_diag=Y,
        full_diag=N
      )

    proc summary data=Ncdb_2000_dc_sum_a;
      class &geo;
      var &var2000;
      output out=NCDB_2000_dc_sum (drop=_freq_) sum=;
    run;
    
  %end;
  %else %do;

    proc summary data=Ncdb.Ncdb_lf_2000_was15 (where=(lowcase(stusab)="&st."));
      class &geo;
      var &var2000;
      output out=NCDB_2000_&st._sum (drop=_freq_) sum=;
    run;
    
  %end;

  ** 2010 data **;

  proc summary data=Ncdb.Ncdb_2010_&st._blk;
    where put( ucounty, $ctym15f. ) ~= "";
    class &geo;
    var &var2010;
    output out=Ncdb_2010_&st._sum (drop= _freq_) sum= ;
  run;

  ** 2020 data **;

  proc summary data=Ncdb.Ncdb_2020_&st._blk;
    where put( ucounty, $ctym15f. ) ~= "";
    class &geo;
    var &var2020;
    output out=Ncdb_2020_&st._sum (drop=_freq_) sum= ;
  run;

  data Table;

    merge 
      Ncdb_2000_&st._sum 
      Ncdb_2010_&st._sum 
      Ncdb_2020_&st._sum;
    by _type_ &geo;

    trctpop_chg = trctpop&yrb - trctpop&yra;
    tothsun_chg = tothsun&yrb - TOTHSUN&yra;
    occhu_chg = occhu&yrb - occhu&yra;
    
   format &geo &geofmt;
    
  run;


  ***********************************************************************************************
  **** Create tables;

  options nodate nonumber;
  options orientation=landscape;

  %fdate()

  ods listing close;
  ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_&st._tables.rtf" style=Styles.Rtf_arial_9pt;

  footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

  **** Population & housing unit counts ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "Population and Housing Unit Counts - &yeara vs. &yearb";
  run;

  ********  COUNTS  ********;

  **** SHR: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
    title4 'Population by Race';
  run;

  **** SHR: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MIN: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
    title4 'Population by Race';
  run;

  **** MIN: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MAX: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
    title4 'Population by Race';
    title5 'NOTE: Subgroups will not add to total population.';
  run;

  **** MAX: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
    title5 'NOTE: Subgroups will not add to total population.';
  run;

  **** Child vs. Adult population ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "Child and Adult Population - &yeara vs. &yearb";
    title4 'Persons';
  run;


  ********    PERCENTAGES    ********;

  **** SHR: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
    title4 'Percent Population by Race';
  run;

  **** SHR: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MIN: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
    title4 'Percent Population by Race';
  run;

  **** MIN: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MAX: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
    title4 'Percent Population by Race';
    title5 'NOTE: Percentages will not add to 100.';
  run;

  **** MAX: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
    title5 'NOTE: Percentages will not add to 100.';
  run;

  **** Child vs. Adult population ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
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
      / box="%upcase(&st) by &geolabel"
    ;
    title2 ' ';
    title3 "Child and Adult Population - &yeara vs. &yearb";
    title4 'Percent Persons';
  run;
  
  ods rtf close;
  
  title1;
  footnote1;
  
  options nodate number;
  options orientation=landscape;

  ods pdf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_&st._charts.pdf" notoc nogfootnote;
  
  footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";

  ** Scatter plots **;
  
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=nhb, racelabel=Non-Hisp. Black )
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=nhw, racelabel=Non-Hisp. White )
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=hsp, racelabel=Hispanic/Latinx )
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=nha, racelabel=Non-Hisp. Asian/PI )
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=nhi, racelabel=Non-Hisp. Am. Indian )
  %Scatter_plot( st=&st, geo=&geo, geolabel=&geolabel, race=nho, racelabel=Non-Hisp. Other race )

  ods pdf close;
  ods listing;

  footnote1;
  title1 "&_library/&_program: Urban-Greater DC";

%mend Make_output;

/** End Macro Definition **/


/** Macro Scatter_plot - Start Definition **/

%macro Scatter_plot( st=, geo=, geolabel=, race=, racelabel= );

  %let race = %lowcase( &race );

  *** Graphics ***;

  data Scatter;

    set Table;

    %if &st ~= dc %then %do;
      where _type_ = 1;
    %end;
    
    %if &race = hsp %then %do;
    
      year = 2000;
      shr&race.n = shr&race.0n;
      shr&race. = shr&race.0n / shr0d;
      output;
      
      year = 2010;
      shr&race.n = shr&race.1n;
      shr&race. = shr&race.1n / shr1d;
      output;
      
      year = 2020;
      shr&race.n = shr&race.2n;
      shr&race. = shr&race.2n / shr2d;
      output;
      
      format shr&race. percent6.1;
      format shr&race.n comma12.0;
      
      keep _type_ &geo year shr&race.n shr&race.;
      
    %end;
    %else %do;

      year = 2000;
      min&race.n = min&race.0n;
      shr&race.n = shr&race.0n;
      max&race.n = max&race.0n;
      min&race. = min&race.0n / shr0d;
      shr&race. = shr&race.0n / shr0d;
      max&race. = max&race.0n / shr0d;
      output;
      
      year = 2010;
      min&race.n = min&race.1n;
      shr&race.n = shr&race.1n;
      max&race.n = max&race.1n;
      min&race. = min&race.1n / shr1d;
      shr&race. = shr&race.1n / shr1d;
      max&race. = max&race.1n / shr1d;
      output;
      
      year = 2020;
      min&race.n = min&race.2n;
      shr&race.n = shr&race.2n;
      max&race.n = max&race.2n;
      min&race. = min&race.2n / shr2d;
      shr&race. = shr&race.2n / shr2d;
      max&race. = max&race.2n / shr2d;
      output;
      
      format min&race. shr&race. max&race. percent6.1;
      format min&race.n shr&race.n max&race.n comma12.0;
      
      keep _type_ &geo year min&race.n shr&race.n max&race.n min&race. shr&race. max&race.;
      
    %end;
    
  run;
  
  ** Put DC total last (because total not shown for population counts) **; 
  
  proc sort data=Scatter;
    by descending _type_ &geo;
  run;
  
  
  ** Charts **;
  
  ods graphics on / width=3in height=2in;

  ods pdf columns=3 startpage=never;
  
  ** Population counts **;

  proc sgplot data=Scatter noautolegend uniform=scale;
    where _type_ = 1;
    by &geo notsorted;
    scatter x=year y=shr&race.n / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.n
        yerrorupper=max&race.n
      %end;
      markerattrs=(color=blue symbol=CircleFilled);
    series x=year y=shr&race.n / lineattrs=(color=blue pattern=2);
    xaxis display=(nolabel);
    yaxis display=(nolabel);
    label &geo = "&geolabel";
    title1 "&racelabel Population, %upcase(&st)";
  run;
  
  ods pdf columns=1 startpage=now;
  
  ** Percentage of population **;
  
  ods pdf columns=3 startpage=never;

  proc sgplot data=Scatter noautolegend uniform=scale;
    by &geo notsorted;
    scatter x=year y=shr&race. / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.
        yerrorupper=max&race.
      %end;
      markerattrs=(color=blue symbol=CircleFilled);
    series x=year y=shr&race. / lineattrs=(color=blue pattern=2);
    xaxis display=(nolabel);
    yaxis display=(nolabel);
    label &geo = "&geolabel";
    title1 "Pct. &racelabel Population, %upcase(&st)";
  run;
  
  ods pdf columns=1 startpage=now;
  
  proc datasets library=work nolist;
    delete Scatter /memtype=data;
  quit;
  
%mend Scatter_plot;

/** End Macro Definition **/


%Make_output( st=dc, geo=ward2012, bylabel=Ward )
%Make_output( st=md, geo=ucounty, bylabel=County )
%Make_output( st=va, geo=ucounty, bylabel=County )

