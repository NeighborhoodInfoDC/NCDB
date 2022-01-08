/**************************************************************************
 Program:  Ncdb_2020_all_tables.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/03/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  28
 
 Description:  Tables and charts from 2000, 2010 and 2020 NCDB data for 
 DC, MD, VA jurisdictions in Washington MSA (2020) used in the 
 2020 Census Overview for the Greater DC Region: Redistricting Data
 report (January 2022).

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( Census )

%** Urban chart colors **;

%global URBAN_COLOR_CYAN URBAN_COLOR_GOLD URBAN_COLOR_BLACK URBAN_COLOR_GRAY
        URBAN_COLOR_MAGENTA URBAN_COLOR_GREEN;

%let URBAN_COLOR_CYAN = "cx1696d2";
%let URBAN_COLOR_GOLD = "cxfdbf11";
%let URBAN_COLOR_BLACK = "cx000000";
%let URBAN_COLOR_GRAY = "cxd2d2d2";
%let URBAN_COLOR_MAGENTA = "cxec008b";
%let URBAN_COLOR_GREEN = "cx558748";

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
    ' ' = 'Total'
    '1' = 'Ward 1'
    '2' = 'Ward 2'
    '3' = 'Ward 3'
    '4' = 'Ward 4'
    '5' = 'Ward 5'
    '6' = 'Ward 6'
    '7' = 'Ward 7'
    '8' = 'Ward 8';
run;

%global lastfignumber;


/** Macro Make_output - Start Definition **/

%macro Make_output( st=, geo=, appendix= );

  %local geolabel;

  %let st = %lowcase( &st );
  
  %if %lowcase( &geo ) = ucounty %then %do;
    %let geolabel = County;
    %let geofmt = $cnty20f.;
  %end;
  %else %if %lowcase( &geo ) = ward2012 %then %do;
    %let geolabel = Ward;
    %let geofmt = $ward12x.;
  %end;

  ** 2000 data **;
  
  %if &st = dc %then %do;
  
    data Ncdb_lf_2000_dc;

      set Ncdb.Ncdb_lf_2000_was20 (where=(statecd='11'));
      
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

    proc summary data=Ncdb.Ncdb_lf_2000_was20 (where=(lowcase(stusab)="&st."));
      class &geo;
      var &var2000;
      output out=NCDB_2000_&st._sum (drop=_freq_) sum=;
    run;
    
  %end;

  ** 2010 data **;

  proc summary data=Ncdb.Ncdb_2010_&st._blk;
    where put( ucounty, $ctym20f. ) ~= "";
    class &geo;
    var &var2010;
    output out=Ncdb_2010_&st._sum (drop= _freq_) sum= ;
  run;

  ** 2020 data **;

  proc summary data=Ncdb.Ncdb_2020_&st._blk;
    where put( ucounty, $ctym20f. ) ~= "";
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
  options orientation=portrait;

  %fdate()

  ods listing close;
  ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_&st._tables.rtf" style=Styles.Rtf_lato_9pt;

  footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

  **** Population & housing unit counts ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
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
      sum='Households' * (
        OCCHU&yra="&yeara"
        OCCHU&yrb="&yearb"
      )
      pctsum<OCCHU&yra>='% Change' * occhu_chg=' ' * f=comma8.1
    ;
    title2 ' ';
    title3 "Population and Housing Unit Counts - &yeara vs. &yearb - %upcase(&st) by &geolabel";
  run;

  ********  COUNTS  ********;

  **** SHR: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var SHR&yra.D SHRWHT&yra.N SHRBLK&yra.N SHRAMI&yra.N SHRASN&yra.N SHRHIP&yra.N SHRAPI&yra.N SHROTH&yra.N 
        SHR&yrb.D SHRWHT&yrb.N SHRBLK&yrb.N SHRAMI&yrb.N SHRASN&yrb.N SHRHIP&yrb.N SHRAPI&yrb.N SHROTH&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        shrami&yra.n='Am. Indian & AK\~Native'
        shrapi&yra.n='Asian & PI'
        shrblk&yra.n='Black'
        shroth&yra.n='Some Other Race'
        shrwht&yra.n='White'
      )
      sum="&yearb" * ( 
        shrami&yrb.n='Am. Indian & AK\~Native'
        shrapi&yrb.n='Asian & PI'
        shrblk&yrb.n='Black'
        shroth&yrb.n='Some Other Race'
        shrwht&yrb.n='White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race';
  run;

  **** SHR: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var SHR&yra.D SHRNHW&yra.N SHRNHB&yra.N SHRNHI&yra.N SHRNHR&yra.N SHRNHH&yra.N SHRNHA&yra.N SHRNHO&yra.N SHRHSP&yra.N  
        SHR&yrb.D SHRNHW&yrb.N SHRNHB&yrb.N SHRNHI&yrb.N SHRNHR&yrb.N SHRNHH&yrb.N SHRNHA&yrb.N SHRNHO&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        shrnhi&yra.n='NH Am. Indian & AK\~Native'
        shrnha&yra.n='NH Asian & PI'
        shrnhb&yra.n='NH Black'
        shrnho&yra.n='NH Some Other Race'
        shrnhw&yra.n='NH White'
      )
      sum="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        shrnhi&yrb.n='NH Am. Indian & AK\~Native'
        shrnha&yrb.n='NH Asian & PI'
        shrnhb&yrb.n='NH Black'
        shrnho&yrb.n='NH Some Other Race'
        shrnhw&yrb.n='NH White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MIN: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d minWHT&yra.N minBLK&yra.N minAMI&yra.N minASN&yra.N minHIP&yra.N minAPI&yra.N minOTH&yra.N MRAPOP&yra.N
        shr&yrb.d minWHT&yrb.N minBLK&yrb.N minAMI&yrb.N minASN&yrb.N minHIP&yrb.N minAPI&yrb.N minOTH&yrb.N MRAPOP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        minami&yra.n='Am. Indian & AK\~Native alone'
        minapi&yra.n='Asian & PI alone'
        minblk&yra.n='Black alone'
        mrapop&yra.n='Multiracial'
        minoth&yra.n='Some Other Race alone'
        minwht&yra.n='White alone'
      )
      sum="&yearb" * ( 
        minami&yrb.n='Am. Indian & AK\~Native alone'
        minapi&yrb.n='Asian & PI alone'
        minblk&yrb.n='Black alone'
        mrapop&yrb.n='Multiracial'
        minoth&yrb.n='Some Other Race alone'
        minwht&yrb.n='White alone'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race';
  run;

  **** MIN: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d minNHW&yra.N minNHB&yra.N minNHI&yra.N minNHR&yra.N minNHH&yra.N minNHA&yra.N minNHO&yra.N MRANHS&yra.N SHRHSP&yra.N  
        shr&yrb.d minNHW&yrb.N minNHB&yrb.N minNHI&yrb.N minNHR&yrb.N minNHH&yrb.N minNHA&yrb.N minNHO&yrb.N MRANHS&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        minnhi&yra.n='NH Am. Indian & AK\~Native alone'
        minnha&yra.n='NH Asian & PI alone'
        minnhb&yra.n='NH Black alone'
        mranhs&yra.n='NH Multiracial'
        minnho&yra.n='NH Some Other Race alone'
        minnhw&yra.n='NH White alone'
      )
      sum="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        minnhi&yrb.n='NH Am. Indian & AK\~Native alone'
        minnha&yrb.n='NH Asian & PI alone'
        minnhb&yrb.n='NH Black alone'
        mranhs&yrb.n='NH Multiracial'
        minnho&yrb.n='NH Some Other Race alone'
        minnhw&yrb.n='NH White alone'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MAX: Population by race ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d maxWHT&yra.N maxBLK&yra.N maxAMI&yra.N maxASN&yra.N maxHIP&yra.N maxAPI&yra.N maxOTH&yra.N
        shr&yrb.d maxWHT&yrb.N maxBLK&yrb.N maxAMI&yrb.N maxASN&yrb.N maxHIP&yrb.N maxAPI&yrb.N maxOTH&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        maxami&yra.n='Am. Indian & AK\~Native'
        maxapi&yra.n='Asian & PI'
        maxblk&yra.n='Black'
        maxoth&yra.n='Some Other Race'
        maxwht&yra.n='White'
      )
      sum="&yearb" * ( 
        maxami&yrb.n='Am. Indian & AK\~Native'
        maxapi&yrb.n='Asian & PI'
        maxblk&yrb.n='Black'
        maxoth&yrb.n='Some Other Race'
        maxwht&yrb.n='White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race';
    title5 'NOTE: Subgroups will not add to total population.';
  run;

  **** MAX: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d maxNHW&yra.N maxNHB&yra.N maxNHI&yra.N maxNHR&yra.N maxNHH&yra.N maxNHA&yra.N maxNHO&yra.N SHRHSP&yra.N  
        shr&yrb.d maxNHW&yrb.N maxNHB&yrb.N maxNHI&yrb.N maxNHR&yrb.N maxNHH&yrb.N maxNHA&yrb.N maxNHO&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      sum="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        maxnhi&yra.n='NH Am. Indian & AK\~Native'
        maxnha&yra.n='NH Asian & PI'
        maxnhb&yra.n='NH Black'
        maxnho&yra.n='NH Some Other Race'
        maxnhw&yra.n='NH White'
      )
      sum="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        maxnhi&yrb.n='NH Am. Indian & AK\~Native'
        maxnha&yrb.n='NH Asian & PI'
        maxnhb&yrb.n='NH Black'
        maxnho&yrb.n='NH Some Other Race'
        maxnhw&yrb.n='NH White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
    title5 'NOTE: Subgroups will not add to total population.';
  run;

  **** Child vs. Adult population ****;

  proc tabulate data=Table format=comma10.0 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
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
    ;
    title2 ' ';
    title3 "Child and Adult Population - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Persons';
  run;


  ********    PERCENTAGES    ********;

  **** SHR: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var SHR&yra.D SHRWHT&yra.N SHRBLK&yra.N SHRAMI&yra.N SHRASN&yra.N SHRHIP&yra.N SHRAPI&yra.N SHROTH&yra.N 
        SHR&yrb.D SHRWHT&yrb.N SHRBLK&yrb.N SHRAMI&yrb.N SHRASN&yrb.N SHRHIP&yrb.N SHRAPI&yrb.N SHROTH&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        shrami&yra.n='Am. Indian & AK\~Native'
        shrapi&yra.n='Asian & PI'
        shrblk&yra.n='Black'
        shroth&yra.n='Some Other Race'
        shrwht&yra.n='White'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        shrami&yrb.n='Am. Indian & AK\~Native'
        shrapi&yrb.n='Asian & PI'
        shrblk&yrb.n='Black'
        shroth&yrb.n='Some Other Race'
        shrwht&yrb.n='White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race';
  run;

  **** SHR: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var SHR&yra.D SHRNHW&yra.N SHRNHB&yra.N SHRNHI&yra.N SHRNHR&yra.N SHRNHH&yra.N SHRNHA&yra.N SHRNHO&yra.N SHRHSP&yra.N  
        SHR&yrb.D SHRNHW&yrb.N SHRNHB&yrb.N SHRNHI&yrb.N SHRNHR&yrb.N SHRNHH&yrb.N SHRNHA&yrb.N SHRNHO&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        shrnhi&yra.n='NH Am. Indian & AK\~Native'
        shrnha&yra.n='NH Asian & PI'
        shrnhb&yra.n='NH Black'
        shrnho&yra.n='NH Some Other Race'
        shrnhw&yra.n='NH White'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        shrnhi&yrb.n='NH Am. Indian & AK\~Native'
        shrnha&yrb.n='NH Asian & PI'
        shrnhb&yrb.n='NH Black'
        shrnho&yrb.n='NH Some Other Race'
        shrnhw&yrb.n='NH White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Bridging Variables (SHR) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MIN: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d minWHT&yra.N minBLK&yra.N minAMI&yra.N minASN&yra.N minHIP&yra.N minAPI&yra.N minOTH&yra.N MRAPOP&yra.N
        shr&yrb.d minWHT&yrb.N minBLK&yrb.N minAMI&yrb.N minASN&yrb.N minHIP&yrb.N minAPI&yrb.N minOTH&yrb.N MRAPOP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        minami&yra.n='Am. Indian & AK\~Native alone'
        minapi&yra.n='Asian & PI alone'
        minblk&yra.n='Black alone'
        mrapop&yra.n='Multiracial'
        minoth&yra.n='Some Other Race alone'
        minwht&yra.n='White alone'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        minami&yrb.n='Am. Indian & AK\~Native alone'
        minapi&yrb.n='Asian & PI alone'
        minblk&yrb.n='Black alone'
        mrapop&yrb.n='Multiracial'
        minoth&yrb.n='Some Other Race alone'
        minwht&yrb.n='White alone'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race';
  run;

  **** MIN: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d minNHW&yra.N minNHB&yra.N minNHI&yra.N minNHR&yra.N minNHH&yra.N minNHA&yra.N minNHO&yra.N MRANHS&yra.N SHRHSP&yra.N  
        shr&yrb.d minNHW&yrb.N minNHB&yrb.N minNHI&yrb.N minNHR&yrb.N minNHH&yrb.N minNHA&yrb.N minNHO&yrb.N MRANHS&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        minnhi&yra.n='NH Am. Indian & AK\~Native alone'
        minnha&yra.n='NH Asian & PI alone'
        minnhb&yra.n='NH Black alone'
        mranhs&yra.n='NH Multiracial'
        minnho&yra.n='NH Some Other Race alone'
        minnhw&yra.n='NH White alone'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        minnhi&yrb.n='NH Am. Indian & AK\~Native alone'
        minnha&yrb.n='NH Asian & PI alone'
        minnhb&yrb.n='NH Black alone'
        mranhs&yrb.n='NH Multiracial'
        minnho&yrb.n='NH Some Other Race alone'
        minnhw&yrb.n='NH White alone'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone Variables (MIN) + Multiracial - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  run;

  **** MAX: Population by race ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d maxWHT&yra.N maxBLK&yra.N maxAMI&yra.N maxASN&yra.N maxHIP&yra.N maxAPI&yra.N maxOTH&yra.N
        shr&yrb.d maxWHT&yrb.N maxBLK&yrb.N maxAMI&yrb.N maxASN&yrb.N maxHIP&yrb.N maxAPI&yrb.N maxOTH&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        maxami&yra.n='Am. Indian & AK\~Native'
        maxapi&yra.n='Asian & PI'
        maxblk&yra.n='Black'
        maxoth&yra.n='Some Other Race'
        maxwht&yra.n='White'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        maxami&yrb.n='Am. Indian & AK\~Native'
        maxapi&yrb.n='Asian & PI'
        maxblk&yrb.n='Black'
        maxoth&yrb.n='Some Other Race'
        maxwht&yrb.n='White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race';
    title5 'NOTE: Percentages will not add to 100.';
  run;

  **** MAX: Population by Race/Ethnicity ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
    var shr&yra.d maxNHW&yra.N maxNHB&yra.N maxNHI&yra.N maxNHR&yra.N maxNHH&yra.N maxNHA&yra.N maxNHO&yra.N SHRHSP&yra.N  
        shr&yrb.d maxNHW&yrb.N maxNHB&yrb.N maxNHI&yrb.N maxNHR&yrb.N maxNHH&yrb.N maxNHA&yrb.N maxNHO&yrb.N SHRHSP&yrb.N;
    table 
      /** Rows **/
      all='\b TOTAL' &geo=' ',
      /** Columns **/
      pctsum<shr&yra.d>="&yeara" * (
        shrhsp&yra.n='Hispanic/Latinx'
        maxnhi&yra.n='NH Am. Indian & AK\~Native'
        maxnha&yra.n='NH Asian & PI'
        maxnhb&yra.n='NH Black'
        maxnho&yra.n='NH Some Other Race'
        maxnhw&yra.n='NH White'
      )
      pctsum<shr&yrb.d>="&yearb" * ( 
        shrhsp&yrb.n='Hispanic/Latinx'
        maxnhi&yrb.n='NH Am. Indian & AK\~Native'
        maxnha&yrb.n='NH Asian & PI'
        maxnhb&yrb.n='NH Black'
        maxnho&yrb.n='NH Some Other Race'
        maxnhw&yrb.n='NH White'
      )
    ;
    title2 ' ';
    title3 "NCDB Race Alone or in Combination Variables (MAX) - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
    title5 'NOTE: Percentages will not add to 100.';
  run;

  **** Child vs. Adult population ****;

  proc tabulate data=Table format=comma8.1 noseps missing;
    where _type_ = 1;
    class &geo /order=formatted;
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
    ;
    title2 ' ';
    title3 "Child and Adult Population - &yeara vs. &yearb - %upcase(&st) by &geolabel";
    title4 'Percent Persons';
  run;
  
  ods rtf close;
  
  
  ***********************************************************************************************
  **** Create charts;
  
  %let lastfignumber = 0;
  
  title1;
  footnote1;
  
  options nodate nonumber nocenter nobyline;
  options orientation=portrait leftmargin=0.5in rightmargin=0.5in topmargin=0.5in bottommargin=0.5in;
  
  proc template;
   define style mystyle;
   parent=styles.Pearl;
      class graphwalls / 
            frameborder=off;
      class graphbackground / 
            color=white;
   end;
  run;

  ods pdf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_&st._charts.pdf" style=mystyle notoc nogfootnote;

  ** Sort data by formatted value. Put DC total last (because total not shown for population counts) **; 
  
  proc sql noprint;
    create table Table_sorted as
    select * from Table
    order by _type_ desc, put( &geo, &geofmt );
  quit;
  
  ** Bar charts **;
  
  data BarChart;
  
    set Table_sorted;
    
    %if &st ~= dc %then %do;
      where _type_ = 1;
    %end;

    fignum = _n_ + &lastfignumber;
    
    length age $40;
      
    year = 2000;
    
    age = 'Adults 18 and older';
    pop = adult0n;
    output;

    age = 'Children younger than 18';
    pop = child0n;
    output;
    
    year = 2010;
    
    age = 'Adults 18 and older';
    pop = adult1n;
    output;

    age = 'Children younger than 18';
    pop = child1n;
    output;
    
    year = 2020;
    
    age = 'Adults 18 and older';
    pop = adult2n;
    output;

    age = 'Children younger than 18';
    pop = child2n;
    output;
    
    keep _type_ fignum &geo year age pop;
    
  run;
  
  ods graphics on / width=2.5in height=2in border=off;

  ods pdf columns=3 startpage=never;

  proc sgplot data=BarChart pctlevel=group;
    by fignum &geo notsorted;
    styleattrs datacolors=(&URBAN_COLOR_CYAN &URBAN_COLOR_GOLD);
    vbar year / group=age groupdisplay=stack freq=pop stat=percent nooutline seglabel seglabelattrs=(color=black family="Lato");
    xaxis display=(nolabel) valueattrs=(color=black family="Lato");
    yaxis display=none /*display=(nolabel) valueattrs=(color=black family="Lato")*/;
    keylegend / noborder position=topleft location=outside title="";
    label &geo = "&geolabel" age="Age";
    title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";
    %if &st = dc %then %do;
      title2 justify=left color=black font="Lato" height=10pt "Adult and Child Populations, #BYVAL2, %upcase(&st), 2000–20";
    %end;
    %else %do;
      title2 justify=left color=black font="Lato" height=10pt "Adult and Child Populations, #BYVAL2, 2000–20";
    %end;
  run;
  
  ** Update figure count **;
  
  proc sql noprint;
    select max(fignum) into :lastfignumber from BarChart;
  quit;
  
    ods pdf columns=1 startpage=now;
    ods pdf columns=3 startpage=never;

  ** Scatter plots **;

  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=hsp, racelabel=Hispanic/Latinx )
  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=nhi, racelabel=Non-Hispanic/Latinx American Indian & Alaska Native )
  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=nha, racelabel=Non-Hispanic/Latinx Asian & Pacific Islander )
  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=nhb, racelabel=Non-Hispanic/Latinx Black )
  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=nho, racelabel=Non-Hispanic/Latinx Some Other Race )
  %Scatter_plot( appendix=&appendix, st=&st, geo=&geo, geolabel=&geolabel, geofmt=&geofmt, race=nhw, racelabel=Non-Hispanic/Latinx White )

  ods pdf close;
  ods listing;

  footnote1;
  title1 "&_library/&_program: Urban-Greater DC";

  proc datasets library=Work nolist;
    delete Table Table_sorted /memtype=data;
  quit;

%mend Make_output;

/** End Macro Definition **/


/** Macro Scatter_plot - Start Definition **/

%macro Scatter_plot( appendix=, st=, geo=, geolabel=, geofmt=, race=, racelabel= );

  %let race = %lowcase( &race );

  ** Population counts **;

  data Scatter_count;

    set Table_sorted;
    
    where _type_ = 1;

    fignum = _n_ + &lastfignumber;

    %if &race = hsp %then %do;
    
      year = 2000;
      shr&race.n = shr&race.0n;
      output;
      
      year = 2010;
      shr&race.n = shr&race.1n;
      output;
      
      year = 2020;
      shr&race.n = shr&race.2n;
      output;
      
      format shr&race.n comma12.0;
      
      keep _type_ fignum &geo year shr&race.n;
      
    %end;
    %else %do;

      year = 2000;
      min&race.n = min&race.0n;
      shr&race.n = shr&race.0n;
      max&race.n = max&race.0n;
      output;
      
      year = 2010;
      min&race.n = min&race.1n;
      shr&race.n = shr&race.1n;
      max&race.n = max&race.1n;
      output;
      
      year = 2020;
      min&race.n = min&race.2n;
      shr&race.n = shr&race.2n;
      max&race.n = max&race.2n;
      output;
      
      format min&race.n shr&race.n max&race.n comma12.0;
      
      keep _type_ fignum &geo year min&race.n shr&race.n max&race.n;
      
    %end;
    
  run;
  
  proc sgplot data=Scatter_count noautolegend uniform=scale;
    by fignum &geo notsorted;
    scatter x=year y=shr&race.n / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.n
        yerrorupper=max&race.n
        errorbarattrs=(color=black thickness=1)
      %end;
      markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled) 
      /*datalabel datalabelattrs=(color=black family="Lato")*/;
    series x=year y=shr&race.n / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
    xaxis display=(nolabel) valueattrs=(color=black family="Lato");
    yaxis display=(nolabel) valueattrs=(color=black family="Lato") min=0;
    label &geo = "&geolabel";
    title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";
    %if &st = dc %then %do;
      title2 justify=left color=black font="Lato" height=10pt "&racelabel Population, #BYVAL2, %upcase(&st), 2000–20";
    %end;
    %else %do;
      title2 justify=left color=black font="Lato" height=10pt "&racelabel Population, #BYVAL2, 2000–20";
    %end;
  run;
  
  ** Update figure count **;
  
  proc sql noprint;
    select max(fignum) into :lastfignumber from Scatter_count;
  quit;
  
  %if &st ~= wv %then %do;
    ods pdf columns=1 startpage=now;
    ods pdf columns=3 startpage=never;
  %end;

  ** Percentage of population **;
  
  data Scatter_pct;

    set Table_sorted;
    
    %if &st ~= dc %then %do;
      where _type_ = 1;
    %end;
    
    fignum = _n_ + &lastfignumber;

    %if &race = hsp %then %do;
    
      year = 2000;
      shr&race. = shr&race.0n / shr0d;
      output;
      
      year = 2010;
      shr&race. = shr&race.1n / shr1d;
      output;
      
      year = 2020;
      shr&race. = shr&race.2n / shr2d;
      output;
      
      format shr&race. percent6.1;
      
      keep _type_ fignum &geo year shr&race.;
      
    %end;
    %else %do;

      year = 2000;
      min&race. = min&race.0n / shr0d;
      shr&race. = shr&race.0n / shr0d;
      max&race. = max&race.0n / shr0d;
      output;
      
      year = 2010;
      min&race. = min&race.1n / shr1d;
      shr&race. = shr&race.1n / shr1d;
      max&race. = max&race.1n / shr1d;
      output;
      
      year = 2020;
      min&race. = min&race.2n / shr2d;
      shr&race. = shr&race.2n / shr2d;
      max&race. = max&race.2n / shr2d;
      output;
      
      format min&race. shr&race. max&race. percent6.1;
      
      keep _type_ fignum &geo year min&race. shr&race. max&race.;
      
    %end;
    
  run;
  
  proc sgplot data=Scatter_pct noautolegend uniform=scale;
    by fignum &geo notsorted;
    scatter x=year y=shr&race. / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.
        yerrorupper=max&race.
        errorbarattrs=(color=black thickness=1)
      %end;
      markerattrs=(color=&URBAN_COLOR_CYAN symbol=CircleFilled) 
      /*datalabel datalabelattrs=(color=black family="Lato")*/;
    series x=year y=shr&race. / lineattrs=(color=&URBAN_COLOR_CYAN pattern=2);
    xaxis display=(nolabel) valueattrs=(color=black family="Lato");
    yaxis display=(nolabel) valueattrs=(color=black family="Lato") min=0;
    label &geo = "&geolabel";
    title1 justify=left color=&URBAN_COLOR_CYAN font="Lato" height=9pt "FIGURE %upcase(&appendix).#BYVAL1";
    %if &st = dc %then %do;
      title2 justify=left color=black font="Lato" height=10pt "Percentage &racelabel Population, #BYVAL2, %upcase(&st), 2000–20";
    %end;
    %else %do;
      title2 justify=left color=black font="Lato" height=10pt "Percentage &racelabel Population, #BYVAL2, 2000–20";
    %end;
  run;
  
  ** Update figure count **;
  
  proc sql noprint;
    select max(fignum) into :lastfignumber from Scatter_pct;
  quit;
  
  %if &st ~= wv %then %do;
    ods pdf columns=1 startpage=now;
    ods pdf columns=3 startpage=never;
  %end;

  proc datasets library=work nolist;
    delete Scatter Scatter_count Scatter_pct /memtype=data;
  quit;
  
%mend Scatter_plot;

/** End Macro Definition **/

%Make_output( st=dc, geo=ward2012, appendix=A )
%Make_output( st=md, geo=ucounty, appendix=B )
%Make_output( st=va, geo=ucounty, appendix=C )
%Make_output( st=wv, geo=ucounty, appendix=D )
