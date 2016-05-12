/**************************************************************************
 Program:  Ncdb_2010_tables.sas
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

proc format;
  value $ucnty
    '24001'='Allegany '
    '24003'='Anne Arundel '
    '24005'='Baltimore '
    '24009'='Calvert '
    '24011'='Caroline '
    '24013'='Carroll '
    '24015'='Cecil '
    '24017'='Charles '
    '24019'='Dorchester '
    '24021'='Frederick '
    '24023'='Garrett '
    '24025'='Harford '
    '24027'='Howard '
    '24029'='Kent '
    '24031'='Montgomery '
    '24033'='Prince Georges '
    '24035'='Queen Annes '
    '24037'='St. Marys '
    '24039'='Somerset '
    '24041'='Talbot '
    '24043'='Washington '
    '24045'='Wicomico '
    '24047'='Worcester '
    '24510'='Baltimore city ';


** Summarize 2010 NCDB data by county **;

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

proc summary data=Ncdb.Ncdb_2010_md;
  where stusab = 'MD';
  by ucounty;
  var &var2010;
  output out=Ncdb_2010_md_cnty sum= ;
run;

data Table;

  merge 
    Ncdb.Ncdb_lf_2000_md_cnty (drop=_type_ rename=(_freq_=tracts_2000)) 
    Ncdb_2010_md_cnty (drop=_type_ rename=(_freq_=tracts_2010));
  by ucounty;

  trctpop_chg = trctpop1 - trctpop0;
  tothsun_chg = tothsun1 - tothsun0;
  occhu_chg = occhu1 - occhu0;
  
run;

options nodate nonumber;

%fdate()

ods rtf file="D:\DCData\Libraries\NCDB\Prog\Ncdb_2010_tables.rtf" style=Styles.Rtf_arial_9pt;

**** Population & housing unit counts ****;

proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var TRCTPOP0 TOTHSUN0 OCCHU0 TRCTPOP1 TOTHSUN1 OCCHU1 trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'Population and Housing Unit Counts - 2000 vs. 2010';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** SHR: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var SHR0D SHRWHT0N SHRBLK0N SHRAMI0N SHRASN0N SHRHIP0N SHRAPI0N SHROTH0N 
      SHR1D SHRWHT1N SHRBLK1N SHRAMI1N SHRASN1N SHRHIP1N SHRAPI1N SHROTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Percent Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** SHR: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var SHR0D SHRNHW0N SHRNHB0N SHRNHI0N SHRNHR0N SHRNHH0N SHRNHA0N SHRNHO0N SHRHSP0N  
      SHR1D SHRNHW1N SHRNHB1N SHRNHI1N SHRNHR1N SHRNHH1N SHRNHA1N SHRNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Bridging Variables (SHR) - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var shr0d minWHT0N minBLK0N minAMI0N minASN0N minHIP0N minAPI0N minOTH0N MRAPOP0N
      shr1d minWHT1N minBLK1N minAMI1N minASN1N minHIP1N minAPI1N minOTH1N MRAPOP1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Percent Population by Race';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MIN: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var shr0d minNHW0N minNHB0N minNHI0N minNHR0N minNHH0N minNHA0N minNHO0N MRANHS0N SHRHSP0N  
      shr1d minNHW1N minNHB1N minNHI1N minNHR1N minNHH1N minNHA1N minNHO1N MRANHS1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Alone Variables (MIN) + Multiracial - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by race ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var shr0d maxWHT0N maxBLK0N maxAMI0N maxASN0N maxHIP0N maxAPI0N maxOTH0N
      shr1d maxWHT1N maxBLK1N maxAMI1N maxASN1N maxHIP1N maxAPI1N maxOTH1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Percent Population by Race';
  title5 'NOTE: Percentages will not add to 100.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

**** MAX: Population by Race/Ethnicity ****;

proc tabulate data=Table format=comma8.1 noseps missing;
  class ucounty;
  var shr0d maxNHW0N maxNHB0N maxNHI0N maxNHR0N maxNHH0N maxNHA0N maxNHO0N SHRHSP0N  
      shr1d maxNHW1N maxNHB1N maxNHI1N maxNHR1N maxNHH1N maxNHA1N maxNHO1N SHRHSP1N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
    / box='Maryland by County'
  ;
  format ucounty $ucnty.;
  title2 ' ';
  title3 'NCDB Race Alone or in Combination Variables (MAX) - 2000 vs. 2010';
  title4 'Percent Population by Race/Ethnicity (NH = Non-Hispanic)';
  title5 'NOTE: Percentages will not add to 100.';
  footnote1 height=9pt "Prepared by NeighborhoodInfo DC (www.NeighborhoodInfoDC.org), &fdate..";
  footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';
run;

ods rtf close;

