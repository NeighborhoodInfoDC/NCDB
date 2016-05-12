/**************************************************************************
 Program:  Download_twt.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  10/04/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Download tract weighting files for DC.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

/** Macro Download - Start Definition **/

%macro Download( data );

  data &data;

    set Ncdb.&data;
    
  run;

  proc download status=no
    inlib=work 
    outlib=Ncdb memtype=(data);
    select &data;

  run;

%mend Download;

/** End Macro Definition **/

%Download( twt70_00_dc )
%Download( twt80_00_dc )
%Download( twt90_00_dc )
%Download( twt00_90_dc )

run;

endrsubmit;

%file_info( data=Ncdb.twt90_00_dc )

signoff;

