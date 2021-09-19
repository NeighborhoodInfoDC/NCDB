/**************************************************************************
 Program:  Create_ncdb_views_was20.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  9/19/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  32
 
 Description:  Create & register data views for NCDB 2020 metro area files.
 
 1990 and 2000 only.

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )

/** Macro Create_view - Start Definition **/

%macro Create_view( file, label );

  proc sql;
    create view Ncdb.&file._was20 (label="&label, Washington region (2020)") as
    select *, put( ucounty, $ctym20f. ) as Metro20 
      length=5 label='Metropolitan/micropolitan statistical area (2020)' 
    from Ncdb.&file
    where put( ucounty, $ctym20f. ) ~= "";
  quit;

  run;

  %File_info( data=Ncdb.&file._was20, printobs=0, freqvars=statecd stusab metro20 )

  %DC_update_meta_file(
    ds_lib=Ncdb,
    ds_name=&file._was20,
    creator_process=Create_ncdb_views_was20.sas,
    restrictions=Confidential,
    revisions=%str(New file.)
  )
  
  run;

%mend Create_view;

/** End Macro Definition **/


** Create & register views **;

%Create_view( Ncdb_lf_2000, %str(NCDB Long Form Data, 2000) )

%Create_view( Ncdb_1990_2000, %str(NCDB Long Form Data, 1990 (2000 tracts)) )

