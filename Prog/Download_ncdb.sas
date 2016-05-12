/**************************************************************************
 Program:  Download_ncdb.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  12/13/06
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download NCDB data files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

/** Macro Download - Start Definition **/

%macro Download( data );

  data &data (compress=no);
    set Ncdb.&data;
  run;

  proc download status=no
    inlib=Work 
    outlib=Ncdb memtype=(all);
    select &data;

  run;

%mend Download;

/** End Macro Definition **/

%Download( NCDB_LF_2000_WAS03 )
%Download( NCDB_2010_WAS03 )

/*
%Download( Ncdb_lf_2000_was )
%Download( Ncdb_lf_2000_dc )
%Download( Ncdb_1990_2000_dc )
%Download( Ncdb_1980_2000_dc )
%Download( Ncdb_1970_2000_dc )
*/
run;

endrsubmit;

signoff;
