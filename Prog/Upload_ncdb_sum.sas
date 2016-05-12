/**************************************************************************
 Program:  Upload_ncdb_sum.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  02/20/08
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  TEMPORARY PROGRAM.
Upload all Ncdb_sum_* files to Alpha.
(Will be unnecessary after Ncdb_sum_tr00.sas and Ncdb_sum_all.sas
are finished.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

** Start submitting commands to remote server **;

rsubmit;

proc upload status=no
  inlib=Ncdb 
  outlib=Ncdb memtype=(data);
  select Ncdb_sum_: ;

run;

endrsubmit;

** End submitting commands to remote server **;

run;

signoff;
