/**************************************************************************
 Program:  Ncdb_2010_dc_tables.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/15/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Tables from 2010 and 2000 NCDB data.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( Census )

** Summarize 2010 NCDB data by ward **;

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

%let geo = ward2002;

** 2000 data **;

%Transform_geo_data(
    dat_ds_name=Ncdb.Ncdb_lf_2000_dc,
    dat_org_geo=geo2000,
    dat_count_vars=&var2000,
    dat_prop_vars=,
    wgt_ds_name=General.Wt_tr00_ward02,
    wgt_org_geo=geo2000,
    wgt_new_geo=ward2002,
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
  output out=Ncdb_2010_dc_sum sum= ;
run;

data Table;

  merge 
    Ncdb_2000_dc_sum 
    Ncdb_2010_dc_sum;
  by &geo;

  trctpop_chg = trctpop1 - trctpop0;
  tothsun_chg = tothsun1 - tothsun0;
  occhu_chg = occhu1 - occhu0;
  
run;

options nodate nonumber;

%fdate()

ods rtf file="D:\DCData\Libraries\NCDB\Prog\Ncdb_2010_dc_tables.rtf" style=Styles.Rtf_arial_9pt;

**** Population & housing unit counts ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var TRCTPOP0 TOTHSUN0 OCCHU0 TRCTPOP1 TOTHSUN1 OCCHU1 trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='Population' * (
      trctpop0='2000'
      trctpop1='2010'
    )
    pctsum<trctpop0>='% Change' * trctpop_chg=' ' * f=comma8.1
    sum='Total Housing Units' * (
      tothsun0='2000'
      tothsun1='2010'
    )
    pctsum<tothsun0>='% Change' * tothsun_chg=' ' * f=comma8.1
    sum='Occupied Housing Units' * (
      occhu0='2000'
      occhu1='2010'
    )
    pctsum<occhu0>='% Change' * occhu_chg=' ' * f=comma8.1
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'Population and Housing Unit Counts - 2000 vs. 2010';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

********  COUNTS  ********;

**** SHR: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var SHR0D SHRWHT0N SHRBLK0N SHRAMI0N SHRASN0N SHRHIP0N SHRAPI0N SHROTH0N 
      SHR1D SHRWHT1N SHRBLK1N SHRAMI1N SHRASN1N SHRHIP1N SHRAPI1N SHROTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      shrwht0n='White'
      shrblk0n='Black'
      shrami0n='Am. Indian'
      shrapi0n='Asian/PI'
      shroth0n='Other'
    )
    sum='2010' * ( 
      shrwht1n='White'
      shrblk1n='Black'
      shrami1n='Am. Indian'
      shrapi1n='Asian/PI'
      shroth1n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** SHR: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var SHR0D SHRNHW0N SHRNHB0N SHRNHI0N SHRNHR0N SHRNHH0N SHRNHA0N SHRNHO0N SHRHSP0N  
      SHR1D SHRNHW1N SHRNHB1N SHRNHI1N SHRNHR1N SHRNHH1N SHRNHA1N SHRNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      shrnhw0n='NH White'
      shrnhb0n='NH Black'
      shrnhi0n='NH Am. Indian'
      shrnha0n='NH Asian/PI'
      shrnho0n='NH Other'
      shrhsp0n='Hispanic'
    )
    sum='2010' * ( 
      shrnhw1n='NH White'
      shrnhb1n='NH Black'
      shrnhi1n='NH Am. Indian'
      shrnha1n='NH Asian/PI'
      shrnho1n='NH Other'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr0d minWHT0N minBLK0N minAMI0N minASN0N minHIP0N minAPI0N minOTH0N MRAPOP0N
      shr1d minWHT1N minBLK1N minAMI1N minASN1N minHIP1N minAPI1N minOTH1N MRAPOP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      minwht0n='White alone'
      minblk0n='Black alone'
      minami0n='Am. Indian alone'
      minapi0n='Asian/PI alone'
      minoth0n='Other alone'
      mrapop0n='Multiracial'
    )
    sum='2010' * ( 
      minwht1n='White alone'
      minblk1n='Black alone'
      minami1n='Am. Indian alone'
      minapi1n='Asian/PI alone'
      minoth1n='Other alone'
      mrapop1n='Multiracial'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr0d minNHW0N minNHB0N minNHI0N minNHR0N minNHH0N minNHA0N minNHO0N MRANHS0N SHRHSP0N  
      shr1d minNHW1N minNHB1N minNHI1N minNHR1N minNHH1N minNHA1N minNHO1N MRANHS1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      minnhw0n='NH White alone'
      minnhb0n='NH Black alone'
      minnhi0n='NH Am. Indian alone'
      minnha0n='NH Asian/PI alone'
      minnho0n='NH Other alone'
      mranhs0n='NH Multiracial'
      shrhsp0n='Hispanic'
    )
    sum='2010' * ( 
      minnhw1n='NH White alone'
      minnhb1n='NH Black alone'
      minnhi1n='NH Am. Indian alone'
      minnha1n='NH Asian/PI alone'
      minnho1n='NH Other alone'
      mranhs1n='NH Multiracial'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by race ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr0d maxWHT0N maxBLK0N maxAMI0N maxASN0N maxHIP0N maxAPI0N maxOTH0N
      shr1d maxWHT1N maxBLK1N maxAMI1N maxASN1N maxHIP1N maxAPI1N maxOTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      maxwht0n='White'
      maxblk0n='Black'
      maxami0n='Am. Indian'
      maxapi0n='Asian/PI'
      maxoth0n='Other'
    )
    sum='2010' * ( 
      maxwht1n='White'
      maxblk1n='Black'
      maxami1n='Am. Indian'
      maxapi1n='Asian/PI'
      maxoth1n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Population by Race';
  title5 'NOTE: Subgroups will not add to total population.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var shr0d maxNHW0N maxNHB0N maxNHI0N maxNHR0N maxNHH0N maxNHA0N maxNHO0N SHRHSP0N  
      shr1d maxNHW1N maxNHB1N maxNHI1N maxNHR1N maxNHH1N maxNHA1N maxNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      maxnhw0n='NH White'
      maxnhb0n='NH Black'
      maxnhi0n='NH Am. Indian'
      maxnha0n='NH Asian/PI'
      maxnho0n='NH Other'
      shrhsp0n='Hispanic'
    )
    sum='2010' * ( 
      maxnhw1n='NH White'
      maxnhb1n='NH Black'
      maxnhi1n='NH Am. Indian'
      maxnha1n='NH Asian/PI'
      maxnho1n='NH Other'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Population by Race/Ethnicity (NH = Non-Hispanic)';
  title5 'NOTE: Subgroups will not add to total population.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** Child vs. Adult population ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class &geo;
  var trctpop0 child0n adult0n trctpop1 child1n adult1n;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    sum='2000' * (
      trctpop0='Total'
      child0n='Children under 18'
      adult0n='Adults 18+'
    )
    sum='2010' * ( 
      trctpop1='Total'
      child1n='Children under 18'
      adult1n='Adults 18+'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'Child and Adult Population - 2000 vs. 2010';
  title4 'Persons';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;


********    PERCENTAGES    ********;

**** SHR: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var SHR0D SHRWHT0N SHRBLK0N SHRAMI0N SHRASN0N SHRHIP0N SHRAPI0N SHROTH0N 
      SHR1D SHRWHT1N SHRBLK1N SHRAMI1N SHRASN1N SHRHIP1N SHRAPI1N SHROTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      shrwht0n='White'
      shrblk0n='Black'
      shrami0n='Am. Indian'
      shrapi0n='Asian/PI'
      shroth0n='Other'
    )
    pctsum<shr1d>='2010' * ( 
      shrwht1n='White'
      shrblk1n='Black'
      shrami1n='Am. Indian'
      shrapi1n='Asian/PI'
      shroth1n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Percent Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** SHR: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var SHR0D SHRNHW0N SHRNHB0N SHRNHI0N SHRNHR0N SHRNHH0N SHRNHA0N SHRNHO0N SHRHSP0N  
      SHR1D SHRNHW1N SHRNHB1N SHRNHI1N SHRNHR1N SHRNHH1N SHRNHA1N SHRNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      shrnhw0n='NH White'
      shrnhb0n='NH Black'
      shrnhi0n='NH Am. Indian'
      shrnha0n='NH Asian/PI'
      shrnho0n='NH Other'
      shrhsp0n='Hispanic'
    )
    pctsum<shr1d>='2010' * ( 
      shrnhw1n='NH White'
      shrnhb1n='NH Black'
      shrnhi1n='NH Am. Indian'
      shrnha1n='NH Asian/PI'
      shrnho1n='NH Other'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr0d minWHT0N minBLK0N minAMI0N minASN0N minHIP0N minAPI0N minOTH0N MRAPOP0N
      shr1d minWHT1N minBLK1N minAMI1N minASN1N minHIP1N minAPI1N minOTH1N MRAPOP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      minwht0n='White alone'
      minblk0n='Black alone'
      minami0n='Am. Indian alone'
      minapi0n='Asian/PI alone'
      minoth0n='Other alone'
      mrapop0n='Multiracial'
    )
    pctsum<shr1d>='2010' * ( 
      minwht1n='White alone'
      minblk1n='Black alone'
      minami1n='Am. Indian alone'
      minapi1n='Asian/PI alone'
      minoth1n='Other alone'
      mrapop1n='Multiracial'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Percent Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr0d minNHW0N minNHB0N minNHI0N minNHR0N minNHH0N minNHA0N minNHO0N MRANHS0N SHRHSP0N  
      shr1d minNHW1N minNHB1N minNHI1N minNHR1N minNHH1N minNHA1N minNHO1N MRANHS1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      minnhw0n='NH White alone'
      minnhb0n='NH Black alone'
      minnhi0n='NH Am. Indian alone'
      minnha0n='NH Asian/PI alone'
      minnho0n='NH Other alone'
      mranhs0n='NH Multiracial'
      shrhsp0n='Hispanic'
    )
    pctsum<shr1d>='2010' * ( 
      minnhw1n='NH White alone'
      minnhb1n='NH Black alone'
      minnhi1n='NH Am. Indian alone'
      minnha1n='NH Asian/PI alone'
      minnho1n='NH Other alone'
      mranhs1n='NH Multiracial'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr0d maxWHT0N maxBLK0N maxAMI0N maxASN0N maxHIP0N maxAPI0N maxOTH0N
      shr1d maxWHT1N maxBLK1N maxAMI1N maxASN1N maxHIP1N maxAPI1N maxOTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      maxwht0n='White'
      maxblk0n='Black'
      maxami0n='Am. Indian'
      maxapi0n='Asian/PI'
      maxoth0n='Other'
    )
    pctsum<shr1d>='2010' * ( 
      maxwht1n='White'
      maxblk1n='Black'
      maxami1n='Am. Indian'
      maxapi1n='Asian/PI'
      maxoth1n='Other'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Percent Population by Race';
  title5 'NOTE: Percentages will not add to 100.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var shr0d maxNHW0N maxNHB0N maxNHI0N maxNHR0N maxNHH0N maxNHA0N maxNHO0N SHRHSP0N  
      shr1d maxNHW1N maxNHB1N maxNHI1N maxNHR1N maxNHH1N maxNHA1N maxNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<shr0d>='2000' * (
      maxnhw0n='NH White'
      maxnhb0n='NH Black'
      maxnhi0n='NH Am. Indian'
      maxnha0n='NH Asian/PI'
      maxnho0n='NH Other'
      shrhsp0n='Hispanic'
    )
    pctsum<shr1d>='2010' * ( 
      maxnhw1n='NH White'
      maxnhb1n='NH Black'
      maxnhi1n='NH Am. Indian'
      maxnha1n='NH Asian/PI'
      maxnho1n='NH Other'
      shrhsp1n='Hispanic'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  title5 'NOTE: Percentages will not add to 100.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** Child vs. Adult population ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class &geo;
  var trctpop0 child0n adult0n trctpop1 child1n adult1n;
  table 
    /** Rows **/
    all='\b TOTAL' &geo=' ',
    /** Columns **/
    pctsum<trctpop0>='2000' * (
      trctpop0='Total'
      child0n='Children under 18'
      adult0n='Adults 18+'
    )
    pctsum<trctpop1>='2010' * ( 
      trctpop1='Total'
      child1n='Children under 18'
      adult1n='Adults 18+'
    )
    / box='DC by Ward'
  ;
  title2 ' ';
  title3 'Child and Adult Population - 2000 vs. 2010';
  title4 'Percent Persons';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

ods rtf close;

