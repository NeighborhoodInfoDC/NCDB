/**************************************************************************
 Program:  Create_ncdb_views_alpha_was03.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/12
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create & register Alpha data views for NCDB files.
 
 NOTE: 1980 FILES TEMPORARILY OMITTED.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

/** Macro Create_view - Start Definition **/

%macro Create_view( file, label );

  proc sql;
    create view Ncdb.&file._was03 (label="&label, Washington region (2003)") as
    select *, put( ucounty, $ctym03f. ) as METRO03 
      length=5 label='Metropolitan/micropolitan statistical area (2003)' 
    from Ncdbsrc.&file
    where put( ucounty, $ctym03f. ) ~= ""
    using libname Ncdbsrc "ncdb_public:";

  quit;

  run;
  
  x "purge [dcdata.ncdb.data]&file._was03.*";

  %DC_update_meta_file(
    ds_lib=Ncdb,
    ds_name=&file._was03,
    creator_process=Create_ncdb_views_alpha.sas,
    restrictions=Confidential,
    revisions=%str(New file.)
  )
  
  run;

%mend Create_view;

/** End Macro Definition **/

run;

endrsubmit;

** Create & register views **;

rsubmit;

%Create_view( Ncdb_lf_2000, %str(NCDB Long Form Data, 2000) )

%File_info( data=Ncdb.Ncdb_lf_2000_was03, printobs=0, freqvars=statecd stusab metro03 )

%Create_view( Ncdb_1990_2000, %str(NCDB Long Form Data, 1990 (2000 tracts)) )
%Create_view( Ncdb_1990, %str(NCDB Long Form Data, 1990 (1990 tracts)) )

/*** TEMPORARILY OMIT 1980 BECAUSE OF DATA ISSUES ***
%Create_view( Ncdb_1980_2000, %str(NCDB Long Form Data, 1980 (2000 tracts)) )
%Create_view( Ncdb_1980, %str(NCDB Long Form Data, 1980 (1980 tracts)) )
***************/

%Create_view( Ncdb_1970_2000, %str(NCDB Long Form Data, 1970 (2000 tracts)) )
%Create_view( Ncdb_1970, %str(NCDB Long Form Data, 1970 (1970 tracts)) )

run;

endrsubmit;

signoff;
