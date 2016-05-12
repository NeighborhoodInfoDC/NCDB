/**************************************************************************
 Program:  Was03_cnty_2000_2010.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/29/12
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Compare county data for 2000 and 2010 for Washington
metro area (2003 def).

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( Ncdb )

%let vars = trctpop: adult0n adult1n child0n child1n tothsun:
            shrnhb0n shrnhb1n shrnhw0n shrnhw1n shrhsp0n shrhsp1n shrnha0n shrnha1n;

data Was03_2000_2010;

  set 
    Ncdb.Ncdb_lf_2000_was03
    Ncdb.Ncdb_2010_was03;
  
  format ucounty $cnty03f.;
  
  keep ucounty &vars;

run;

proc summary data=Was03_2000_2010;
  class ucounty;
  var &vars;
  output sum= out=Was03_cnty_2000_2010 (drop=_freq_);
run;

proc print data=Was03_cnty_2000_2010;
  id ucounty;
run;

filename fexport "D:\DCData\Libraries\NCDB\Prog\Was03_cnty_2000_2010.csv" lrecl=2000;

proc export data=Was03_cnty_2000_2010
    outfile=fexport
    dbms=csv replace;

run;

filename fexport clear;

