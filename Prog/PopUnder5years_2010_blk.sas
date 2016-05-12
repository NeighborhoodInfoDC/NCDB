/**************************************************************************
 Program:  PopUnder5years_2010_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  04/07/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Estimate block level population under 5 years old
 using Census 2010 and ACS 2005-09.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";

** Define libraries **;
%DCData_lib( NCDB )
%DCData_lib( ACS )

** Calculate 2000 tract totals for children < 18 in 2010 **;

%let geo = geo2010 geo2000 ward2002 cluster_tr2000 city anc2002 psa2004 zip;

data Ncdb_2010_dc_blk;

  set NCDB.Ncdb_2010_dc_blk (keep=geoblk2010 child1n &geo);
  
run;

proc sort data=Ncdb_2010_dc_blk;
  by Geo2000;

** Merge add tract totals to block data **;

data NCDB.PopUnder5years_2010_blk (label="Population under 5 years (estimated), 2010, DC, block");

  merge
    Ncdb_2010_dc_blk
    Acs.Acs_sf_2005_09_tr00
      (keep=geo2000 B01001e3 B01001e4 B01001e5
            B01001e6 B01001e27 B01001e28 B01001e29 
            B01001e30);
  by Geo2000;
  
  child_2005_09 = sum( B01001e3, B01001e4, B01001e5, B01001e6,
                     B01001e27, B01001e28, B01001e29, B01001e30 );
  
  if child_2005_09 > 0 then 
    PopUnder5years_2010 = child1n * ( sum( B01001e3, B01001e27 ) / child_2005_09 );
  else
    PopUnder5years_2010 = 0;

  label PopUnder5years_2010 = "Persons under 5 years old (estimated), 2010";
  
  keep GeoBlk2010 child1n PopUnder5years_2010 &geo;
  
  rename child1n=popunder18years_2010;

run;

%File_info( data=NCDB.PopUnder5years_2010_blk )


