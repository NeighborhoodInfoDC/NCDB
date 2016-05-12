/**************************************************************************
 Program:  Create_ncdb_views_alpha_was.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  06/15/05
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Create & register Alpha data views for NCDB files.

 Modifications:
  08/26/05  Added registration of metadata.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

rsubmit;

/** Macro Create_view - Start Definition **/

%macro Create_view( file, label );

  proc sql;
    create view Ncdb.&file._was (label="&label, Washington region (1999)") as
    select *
    from Ncdbsrc.&file
    where msapma99 = "8840"
    using libname Ncdbsrc "ncdb_public:";

  quit;

  run;
  
  x "purge [dcdata.ncdb.data]&file._was.*";
  
  %DC_update_meta_file(
    ds_lib=Ncdb,
    ds_name=&file._was,
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

%File_info( data=Ncdb.Ncdb_lf_2000_was, printobs=0, freqvars=statecd stusab )

%Create_view( Ncdb_1990_2000, %str(NCDB Long Form Data, 1990 (2000 tracts)) )
%Create_view( Ncdb_1990, %str(NCDB Long Form Data, 1990 (1990 tracts)) )

%Create_view( Ncdb_1980_2000, %str(NCDB Long Form Data, 1980 (2000 tracts)) )
%Create_view( Ncdb_1980, %str(NCDB Long Form Data, 1980 (1980 tracts)) )

%Create_view( Ncdb_1970_2000, %str(NCDB Long Form Data, 1970 (2000 tracts)) )
%Create_view( Ncdb_1970, %str(NCDB Long Form Data, 1970 (1970 tracts)) )

run;

endrsubmit;

signoff;
