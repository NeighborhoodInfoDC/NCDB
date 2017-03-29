/**************************************************************************
 Program:  NCDB_2010_dc_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/24/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate NCDB 2010 variables from Census 2010 
 PL94-171 and SF1 block-level data.

 District of Columbia.

 Modifications:
  05/04/11 PAT Added EOR geography.
  07/21/12 PAT Added new DC geos: Ward2012, Anc2012, Psa2012.
  03/26/15 PAT Updated for SAS1 server.
               Added OLD1N and OLD1 from SF1 (DC only).
  03/20/17 RP Added bridge park geography. 
  03/29/17 RP Added 65 years and older variable. 
**************************************************************************/

%include "L:\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( Census, local=n )

%let revisions = Added 65 years and older variable.
;

%Ncdb_2010_blk_mac( dc )

