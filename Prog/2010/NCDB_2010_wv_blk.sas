/**************************************************************************
 Program:  NCDB_2010_wv_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  08/27/12
 Version:  SAS 9.2
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate NCDB 2010 variables from Census 2010 
 PL94-171 block-level data.

 West Virginia.

 Modifications:
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census )

%let revisions = New File;

%Ncdb_2010_blk_mac( wv )



