/**************************************************************************
 Program:  Ncdb_2020_blk_mac.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/03/21
 Version:  SAS 9.4
 Environment:  Windows
 
 Description:  Autocall macro to create NCDB variables from
 Census 2020 PL94-171 data. 

 Modifications:

**************************************************************************/

/** Macro Ncdb_2020_blk_mac - Start Definition **/

%macro Ncdb_2020_blk_mac( state );

  %let state = %lowcase( &state );

  %local freqvars;
  
  %let freqvars = sumlev;
  
  
  data cen_vars;
    
    set Census.Census_pl_2020_&state.;
    where sumlev = "750";
    
    ** Standard geography vars **;
    
    length Ucounty $ 5 Geo2020 $ 11 GeoBlk2020 $ 15;
    
    ucounty = STATE || COUNTY;
    geo2020 = ucounty || tract;
    geoblk2020 = geo2020 || block;
    
    label
      ucounty = "Full county ID: ssccc"
      geo2020 = "Full census tract ID (2020): ssccctttttt"
      geoblk2020 = "Full census block ID (2020): sscccttttttbbbb";
    
    %**** If state=DC, add special geos ****;
    
    %if &state = dc %then %do;
    
      /****** TEMPORARY CODE REMOVED 2/5/22 ******
      
      length Ward2012 $ 1;
  
      Ward2012 = left( compress( SLDU18, "0" ) );
  
      label Ward2012 = "Ward (2012)";
  
      format Ward2012 $ward12a.;
      
      %let freqvars = &freqvars Ward2012;
      
      /****************************/

      ** Check DC blocks **;
      
      if GeoBlk2020 ~= "" and put( GeoBlk2020, $blk20v. ) = "" then do;
        %err_put( msg="Invalid census block ID: " _N_= GeoBlk2020= )
      end;
      
      ** Add standard DC geographies for obs. w/valid, nonmissing blocks **;
      
      if GeoBlk2020 ~= "" and put( GeoBlk2020, $blk20v. ) ~= "" then do;
      
        %Block20_to_vp12() 

        %Block20_to_tr20( )

        %Block20_to_tr10( )

        %Block20_to_tr00( )

        %Block20_to_ward02( )
        
        %Block20_to_ward12( )
        
        %Block20_to_psa04(  )
        
        %Block20_to_psa12(  )

        %Block20_to_anc02( )
        
        %Block20_to_anc12( )

        %Block20_to_cluster00( )
        
        %Block20_to_cluster_tr00( )
        
        %Block20_to_zip( )
        
        %Block20_to_city( )
        
        %Block20_to_eor( )

        %Block20_to_bpk( )

        %Block20_to_cluster17( )

        %Block20_to_stantoncommons( )
        
      end;
      else do;
      
        %warn_put( msg="Missing or invalid block ID" _n_= GeoBlk2020= )
        
      end;
      
      %let freqvars = &freqvars voterpre2012 anc2012 city cluster2017 psa2012 geo2020 ward2012 eor zip;
      
    %end;
    
    %NCDB_2020_pl_vars()

    drop 
      P001: P002: P003: P004: H001: FILEID GEOCOMP CHARITER CIFSN LOGRECNO COUNTYCC COUSUB COUSUBCC
      PLACECC CONCIT CONCITCC AIANHH AIANHHFP AIANHHCC 
      AIHHTLI AITS AITSCC TTRACT TBLKGRP ANRC ANRCCC NECTA NECTADIV CNECTA CBSAPCI NECTAPCI
      UA UATYPE UR VTD VTDI SUBMCD SUBMCDCC SDELM SDSEC SDUNI NAME 
      FUNCSTAT GCUNI POP100 HU100 INTPTLAT INTPTLON LSADC PARTFLAG UGA STATENS COUNTYNS
      COUSUBNS PLACENS CONCITNS AIANHHNS AITSNS ANRCNS SUBMCDNS 
      NMEMI;
    
  run;
  
  %MACRO SKIP;

  data age_vars;
      set census.census_sf1_2020_&state._blks;

    TRCTPOP1=P1i1;

    OLD2N = sum( P12i20, P12i21, P12i22, P12i23, P12i24, P12i25,
                 P12i44, P12i45, P12i46, P12i47, P12i48, P12i49 );

    if TRCTPOP1 > 0 then do;
      OLD1 = OLD2N/TRCTPOP1;
    end;

    label
      OLD2N = "Persons 65+ years old"
      OLD1 = "Proportion of persons who are 65+ years old";

    keep GeoBlk2020 OLD2N OLD1;

  run;

  proc sort data = cen_vars; by GeoBlk2020; run;
  proc sort data = age_vars; by GeoBlk2020; run;

  data NCDB_2020_&state._blk (label="NCDB, 2020, %upcase(&state), block");
       merge cen_vars age_vars;
    by GeoBlk2020;
  run;
  
  %MEND SKIP;
  
  
  ** TEMPORARY CODE BECAUSE NO AGE_VARS DATA YET **;
  
  DATA NCDB_2020_&state._blk;
  
    SET CEN_VARS;
    
  RUN;


  %Finalize_data_set(
    data=NCDB_2020_&state._blk,
    out=NCDB_2020_&state._blk,
    outlib=NCDB,
    label="NCDB, 2020, %upcase(&state), block",
    sortby=geo2020,
    /** Metadata parameters **/
    revisions=%str(&revisions),
    /** File info parameters **/
    printobs=10,
    printvars=_character_,
    freqvars=&freqvars
  )

  run;


%mend Ncdb_2020_blk_mac;

/** End Macro Definition **/

