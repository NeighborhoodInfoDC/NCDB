/**************************************************************************
 Program:  NCDB_2010_dc_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/24/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate NCDB 2010 variables from Census 2010 
 PL94-171 block-level data.

 District of Columbia.

 Modifications:
  05/04/11 PAT Added EOR geography.
  07/21/12 PAT Added new DC geos: Ward2012, Anc2012, Psa2012.
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census )


%Ncdb_2010_blk_mac( dc )


signoff;
