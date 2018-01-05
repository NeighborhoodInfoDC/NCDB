/**************************************************************************
 Program:  Create_ncdb_views_was15.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  11/09/17
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Create & register data views for NCDB 2017 metro area files.
 
 1990 and 2000 only.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )

/** Macro Create_view - Start Definition **/

%macro Create_view( file, label );

  proc sql;
    create view Ncdb.&file._was15 (label="&label, Washington region (2015)") as
    select *, put( ucounty, $ctym15f. ) as Metro15 
      length=5 label='Metropolitan/micropolitan statistical area (2015)' 
    from Ncdb.&file
    where put( ucounty, $ctym15f. ) ~= "";
  quit;

  run;

  %File_info( data=Ncdb.&file._was15, printobs=0, freqvars=statecd stusab metro15 )

  %DC_update_meta_file(
    ds_lib=Ncdb,
    ds_name=&file._was15,
    creator_process=Create_ncdb_views_was15.sas,
    restrictions=Confidential,
    revisions=%str(New file.)
  )
  
  run;

%mend Create_view;

/** End Macro Definition **/


** Create & register views **;

%Create_view( Ncdb_lf_2000, %str(NCDB Long Form Data, 2000) )

%Create_view( Ncdb_1990_2000, %str(NCDB Long Form Data, 1990 (2000 tracts)) )

