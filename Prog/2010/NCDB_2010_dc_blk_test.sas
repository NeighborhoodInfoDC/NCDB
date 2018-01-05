/**************************************************************************
 Program:  NCDB_2010_dc_blk.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/22/11
 Version:  SAS 9.1
 Environment:  Windows with SAS/Connect
 
 Description:  Calculate NCDB 2010 variables from Census 2010 
 PL94-171 block-level data.

 TEST VERSION WITH DUMMY DATA.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
***%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( NCDB )

%let var2010 = 
  TRCTPOP1 SHR1D
  SHRWHT1N SHRBLK1N SHRAMI1N SHRASN1N SHRHIP1N SHRAPI1N SHROTH1N
  SHRNHW1N SHRNHB1N SHRNHI1N SHRNHR1N SHRNHH1N SHRNHA1N SHRNHO1N SHRHSP1N NONHISP1
  MINWHT1N MINBLK1N MINAMI1N MINASN1N MINHIP1N MINAPI1N MINOTH1N
  MINNHW1N MINNHB1N MINNHI1N MINNHR1N MINNHH1N MINNHA1N MINNHO1N
  MAXWHT1N MAXBLK1N MAXAMI1N MAXASN1N MAXHIP1N MAXAPI1N MAXOTH1N
  MAXNHW1N MAXNHB1N MAXNHI1N MAXNHR1N MAXNHH1N MAXNHA1N MAXNHO1N
  MRAPOP1N MR1POP1N MR2POP1N MR3POP1N MRANHS1N MRAHSP1N
  ADULT1N CHILD1N
  TOTHSUN1 OCCHU1 VACHU1;

data Ncdb.NCDB_2010_dc_blk;

  set General.GeoBlk2010 (keep=GeoBlk2010);
  
    ** Check blocks **;
    
    if GeoBlk2010 ~= "" and put( GeoBlk2010, $blk10v. ) = "" then do;
      %err_put( msg="Invalid census block ID: " _N_= GeoBlk2010= )
    end;

    ** Add standard geographies for obs. w/valid, nonmissing blocks **;
    
    if GeoBlk2010 ~= "" and put( GeoBlk2010, $blk10v. ) ~= "" then do;
    
      %Block10_to_tr10( )

      %Block10_to_tr00( )

      %Block10_to_ward02( )
      
      %Block10_to_psa04(  )
      
      %Block10_to_anc02( )
      
      %Block10_to_cluster00( )
      
      %Block10_to_cluster_tr00( )
      
      %Block10_to_zip( )
      
      %Block10_to_city( )
      
    end;
    
    array a{*} &var2010;
    
    do i = 1 to dim( a );
      a{ i } = 100000 / 6507;
    end;
    
    drop i;
  
run;

%File_info( data=Ncdb.NCDB_2010_dc_blk, freqvars=anc2002 city cluster2000 cluster_tr2000 psa2004 geo2000 geo2010 ward2002 zip )

***signoff;
