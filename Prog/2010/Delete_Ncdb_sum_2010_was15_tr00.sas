/**************************************************************************
 Program:  Delete_Ncdb_sum_2010_was15_tr00.sas
 Library:  NCDB
 Project:  DC Data Warehouse
 Author:   P. Tatian
 Created:  12/30/04
 Version:  SAS 8.2
 Environment:  Windows with SAS/Connect
 
 Description:  Delete incorrectly named file Ncdb.Ncdb_sum_2010_was15_tr00 
 from L: drive and metadata system.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

%DCData_lib( NCDB )

/** Macro DC_delete_meta_file - Start Definition **/

%macro DC_delete_meta_file( 
         ds_lib= ,
         ds_name= ,
);

  %Delete_metadata_file(  
         ds_lib=&ds_lib,
         ds_name=&ds_name,
         meta_lib=_metadat,
         meta_pre=meta
  )

%mend DC_delete_meta_file;

/** End Macro Definition **/

run;


** Delete file from L: drive **;

proc datasets library=Ncdb memtype=(data);
  delete Ncdb_sum_2010_was15_tr00;
quit;


** Delete files from metadata system **;

%DC_delete_meta_file( ds_lib=NCDB, ds_name=Ncdb_sum_2010_was15_tr00 )

run;

