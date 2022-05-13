/**************************************************************************
 Program:  Ncdb_2010_blk_mac.sas
 Library:  NCDB
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/28/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Autocall macro to create NCDB 2010 variables from
 Census 2010 PL94-171 data. 

 Modifications:
  05/04/11 PAT Added EOR geography.
  07/21/12 PAT Added new DC geos: Ward2012, Anc2012, Psa2012.
  08/29/12 PAT Fixed problem with frequency variables for non-DC states.
  12/17/12 PAT Moved freqvars macro var to remote session.
  03/20/17 RP Update for bridge park geography. 
  03/29/17 RP Added 65 years and older variable. 
  06/16/18 RP Update for cluster2017 geography.
  05/13/22 EB Update for ward2022 geography.
**************************************************************************/

/** Macro Ncdb_2010_blk_mac - Start Definition **/

%macro Ncdb_2010_blk_mac( state );

  %let state = %lowcase( &state );

  %local freqvars;
  
  %let freqvars = sumlev;
  
  
  data cen_vars;
    
    set Census.Census_pl_2010_&state.;
    where sumlev = "750";
    
    ** Standard geography vars **;
    
    length Ucounty $ 5 Geo2010 $ 11 GeoBlk2010 $ 15;
    
    ucounty = STATE || COUNTY;
    geo2010 = ucounty || tract;
    geoblk2010 = geo2010 || block;
    
    label
      ucounty = "Full county ID: ssccc"
      geo2010 = "Full census tract ID (2010): ssccctttttt"
      geoblk2010 = "Full census block ID (2010): sscccttttttbbbb";
    
    %**** If state=DC, add special geos ****;
    
    %if &state = dc %then %do;

      ** Check DC blocks **;
      
      if GeoBlk2010 ~= "" and put( GeoBlk2010, $blk10v. ) = "" then do;
        %err_put( msg="Invalid census block ID: " _N_= GeoBlk2010= )
      end;
      
      ** Add standard DC geographies for obs. w/valid, nonmissing blocks **;
      
      if GeoBlk2010 ~= "" and put( GeoBlk2010, $blk10v. ) ~= "" then do;
      
		%Block10_to_vp12() 

		%Block10_to_tr10( )

        %Block10_to_tr00( )

        %Block10_to_ward02( )
        
        %Block10_to_ward12( )
        
        %Block10_to_psa04(  )
        
        %Block10_to_psa12(  )

        %Block10_to_anc02( )
        
        %Block10_to_anc12( )

        %Block10_to_cluster00( )
        
        %Block10_to_cluster_tr00( )
        
        %Block10_to_zip( )
        
        %Block10_to_city( )
        
        %Block10_to_eor( )

		%Block10_to_bpk( )

		%Block10_to_cluster17( )

		%Block10_to_stantoncommons( )

		%Block10_to_ward22( )
        
      end;
      
      %let freqvars = &freqvars voterpre2012 anc2002 anc2012 city cluster2000 cluster_tr2000  
                      psa2004 psa2012 geo2000 geo2010 ward2002 ward2012 eor zip bridgepk cluster2017 stantoncommons ward2022;
      
    %end;
    
    %NCDB_2010_pl_vars()
    
    drop 
      P001: P002: P003: P004: H001: FILEID GEOCOMP CHARITER CIFSN LOGRECNO COUNTYCC COUNTYSC COUSUB COUSUBCC
      COUSUBSC PLACECC PLACESC IUC CONCIT CONCITCC CONCITSC AIANHH AIANHHFP AIANHHCC 
      AIHHTLI AITSCE AITS AITSCC TTRACT TBLKGRP ANRC ANRCCC CBSASC NECTA NECTASC NECTADIV CNECTA CBSAPCI NECTAPCI
      UA UASC UATYPE UR CD SLDU SLDL VTD VTDI RESERVE2 ZCTA5 SUBMCD SUBMCDCC SDELM SDSEC SDUNI NAME 
      FUNCSTAT GCUNI POP100 HU100 INTPTLAT INTPTLON LSADC PARTFLAG RESERVE3 UGA STATENS COUNTYNS
      COUSUBNS PLACENS CONCITNS AIANHHNS AITSNS ANRCNS SUBMCDNS CD113 CD114 CD115 SLDU2 SLDU3 SLDU4 SLDL2 SLDL3 SLDL4 
      AIANHHSC CSASC CNECTASC NMEMI RESERVED;
    
  run;

  data age_vars;
  	set census.census_sf1_2010_&state._blks;

	TRCTPOP1=P1i1;

    OLD1N = sum( P12i20, P12i21, P12i22, P12i23, P12i24, P12i25,
				 P12i44, P12i45, P12i46, P12i47, P12i48, P12i49 );

	if TRCTPOP1 > 0 then do;
      OLD1 = OLD1N/TRCTPOP1;
    end;

    label
	  OLD1N = "Persons 65+ years old"
	  OLD1 = "Proportion of persons who are 65+ years old";

	keep GeoBlk2010 OLD1N OLD1;

  run;

  proc sort data = cen_vars; by GeoBlk2010; run;
  proc sort data = age_vars; by GeoBlk2010; run;

  data NCDB_2010_&state._blk (label="NCDB, 2010, %upcase(&state), block");
   	merge cen_vars age_vars;
	by GeoBlk2010;
  run;


  %Finalize_data_set(
    data=NCDB_2010_&state._blk,
    out=NCDB_2010_&state._blk,
    outlib=NCDB,
    label="NCDB, 2010, DC, block",
    sortby=geo2010,
    /** Metadata parameters **/
    revisions=%str(&revisions),
    /** File info parameters **/
    printobs=5,
    freqvars=&freqvars
  )

  run;


%mend Ncdb_2010_blk_mac;

/** End Macro Definition **/

