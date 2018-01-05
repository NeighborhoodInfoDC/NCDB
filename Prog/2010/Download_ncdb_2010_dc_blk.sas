/**************************************************************************
 Program:  Download_ncdb_2010_dc_blk.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  07/21/12
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download Download_ncdb_2010_dc_blk from Alpha.

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
  select Ncdb_2010_dc_blk;

run;

endrsubmit;

signoff;
