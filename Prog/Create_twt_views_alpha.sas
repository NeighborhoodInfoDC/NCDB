/**************************************************************************
 Program:  Create_twt_views_alpha.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create & register Alpha data views for NCDB 
 tract weighting files.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

/** Macro Create_view - Start Definition **/

%macro Create_view( file, geo1, geo2, label );

  proc sql;
    create view Ncdb.&file._dc (label="&label, DC") as
    select *
    from Ncdbsrc.&file
    where substr( &geo1, 1, 2 ) = "11" or substr( &geo2, 1, 2 ) = "11"
    using libname Ncdbsrc "ncdb_public:";

  quit;

  run;

  %File_info( data=Ncdb.&file._dc )
  
  run;
  
  ***** ADD METADATA REGISTRATION HERE ******;

%mend Create_view;

/** End Macro Definition **/

run;

endrsubmit;

** Create & register views **;

rsubmit;

%Create_view( twt70_00, geo1970, geo2000, %str(Standard 1970 to 2000 tract weighting file) )
%Create_view( twt80_00, geo1980, geo2000, %str(Standard 1980 to 2000 tract weighting file) )
%Create_view( twt90_00, geo1990, geo2000, %str(Standard 1990 to 2000 tract weighting file) )

%Create_view( twt00_90, geo2000, geo1990, %str(Standard 2000 to 1990 tract weighting file) )

run;

endrsubmit;

signoff;
