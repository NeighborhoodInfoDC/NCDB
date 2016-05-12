/**************************************************************************
 Program:  Download_ncdb_sum.sas
 Library:  Vital
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/19/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download all NCDB summary files from Alpha.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

proc download status=no
  inlib=Ncdb 
  outlib=Ncdb memtype=(data);
  select ncdb_sum_:;

run;

endrsubmit;

signoff;
