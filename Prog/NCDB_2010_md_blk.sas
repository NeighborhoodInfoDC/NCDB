/**************************************************************************
 Program:  NCDB_2010_md_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/24/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate NCDB 2010 variables from Census 2010 
 PL94-171 block-level data.

 Maryland.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census )


%Ncdb_2010_blk_mac( md )


signoff;
