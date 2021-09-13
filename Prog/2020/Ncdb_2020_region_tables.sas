/**************************************************************************
 Program:  Ncdb_2020_region_tables.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/13/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  28
 
 Description:  Tables from 2000, 2010 and 2020 NCDB data for DC, MD, VA, WV
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
  TOTHSUN0 OCCHU0 VACHU0;

%let var2010 = 
  TRCTPOP1 SHR1D
  TOTHSUN1 OCCHU1 VACHU1;

%let var2020 = 
  TRCTPOP2 SHR2D
  TOTHSUN2 OCCHU2 VACHU2;


** 2000 data **;

proc summary data=Ncdb.Ncdb_lf_2000_was15 nway;
  class ucounty;
  var &var2000;
  output out=NCDB_2000_sum (drop=_freq_) sum=;
run;

** 2010 data **;

data Ncdb_2010_blk;

  set 
    Ncdb.Ncdb_2010_dc_blk
    Ncdb.Ncdb_2010_md_blk
    Ncdb.Ncdb_2010_va_blk
    Ncdb.Ncdb_2010_wv_blk;

  where put( ucounty, $ctym15f. ) ~= "";

run;

proc summary data=Ncdb_2010_blk nway;
  class ucounty;
  var &var2010;
  output out=Ncdb_2010_sum (drop=_type_ _freq_) sum= ;
run;

** 2020 data **;

data Ncdb_2020_blk;

  set 
    Ncdb.Ncdb_2020_dc_blk
    Ncdb.Ncdb_2020_md_blk
    Ncdb.Ncdb_2020_va_blk
    Ncdb.Ncdb_2020_wv_blk;

  where put( ucounty, $ctym15f. ) ~= "";

run;

proc summary data=Ncdb_2020_blk nway;
  class ucounty;
  var &var2020;
  output out=Ncdb_2020_sum (drop=_type_ _freq_) sum= ;
run;

data Table;

  merge 
    Ncdb_2000_sum 
    Ncdb_2010_sum 
    Ncdb_2020_sum;
  by ucounty;

  trctpop_chg = trctpop&yrb - trctpop&yra;
  tothsun_chg = tothsun&yrb - TOTHSUN&yra;
  occhu_chg = occhu&yrb - occhu&yra;
  
 format ucounty $cnty15f.;
  
run;

** Make tables **;

options nodate nonumber;
options orientation=portrait;

%fdate()

ods listing close;
ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_region_tables.rtf" style=Styles.Rtf_arial_9pt;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var TRCTPOP&yra TOTHSUN&yra OCCHU&yra TRCTPOP&yrb TOTHSUN&yrb OCCHU&yrb trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
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
  title3 "Population, Housing Unit, and Household Counts - &yeara vs. &yearb";
run;


proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var TRCTPOP0 TRCTPOP&yra TOTHSUN0 TOTHSUN&yra OCCHU0 OCCHU&yra TRCTPOP&yrb TOTHSUN&yrb OCCHU&yrb trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Population' * ( TRCTPOP0="2000" TRCTPOP&yra="&yeara" TRCTPOP&yrb="&yearb" )
    colpctsum='% Population' * f=comma8.1 * ( TRCTPOP0="2000" TRCTPOP&yra="&yeara" TRCTPOP&yrb="&yearb" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Housing Units' * ( TOTHSUN0="2000" TOTHSUN&yra="&yeara" TOTHSUN&yrb="&yearb" )
    colpctsum='% Housing Units' * f=comma8.1 * ( TOTHSUN0="2000" TOTHSUN&yra="&yeara" TOTHSUN&yrb="&yearb" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Households' * ( OCCHU0="2000" OCCHU&yra="&yeara" OCCHU&yrb="&yearb" )
    colpctsum='% Households' * f=comma8.1 * ( OCCHU0="2000" OCCHU&yra="&yeara" OCCHU&yrb="&yearb" )
  ;
  title2 ' ';
  title3 "Population, Housing Unit, and Household Distribution by Jurisdiction - 2000 to 2020";
run;


ods rtf close;
ods listing;

title2;
footnote1;

