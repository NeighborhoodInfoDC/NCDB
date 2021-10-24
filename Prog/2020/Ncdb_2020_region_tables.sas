/**************************************************************************
 Program:  Ncdb_2020_region_tables.sas
 Library:  Ncdb
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  09/13/21
 Version:  SAS 9.4
 Environment:  Windows
 GitHub issue:  28
 
 Description:  Tables from 2000, 2010 and 2020 NCDB data for DC, MD, VA, WV
 jurisdictions in Washington MSA (2020).

 Modifications:
**************************************************************************/

%include "\\sas1\DCdata\SAS\Inc\StdLocal.sas";

** Define libraries **;
%DCData_lib( Ncdb )
%DCData_lib( Census )

%global var2000 var2010 var2020;

%let var2000 = 
  TRCTPOP0 SHR0D
  SHRWHT0N SHRBLK0N SHRAMI0N SHRASN0N SHRHIP0N SHRAPI0N SHROTH0N
  SHRNHW0N SHRNHB0N SHRNHI0N SHRNHR0N SHRNHH0N SHRNHA0N SHRNHO0N SHRHSP0N NONHISP0
  MINWHT0N MINBLK0N MINAMI0N MINASN0N MINHIP0N MINAPI0N MINOTH0N
  MINNHW0N MINNHB0N MINNHI0N MINNHR0N MINNHH0N MINNHA0N MINNHO0N
  MAXWHT0N MAXBLK0N MAXAMI0N MAXASN0N MAXHIP0N MAXAPI0N MAXOTH0N
  MAXNHW0N MAXNHB0N MAXNHI0N MAXNHR0N MAXNHH0N MAXNHA0N MAXNHO0N
  MRAPOP0N MR1POP0N MR2POP0N MR3POP0N MRANHS0N MRAHSP0N
  ADULT0N CHILD0N
  TOTHSUN0 OCCHU0 VACHU0;

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

%let var2020 = 
  TRCTPOP2 SHR2D
  SHRWHT2N SHRBLK2N SHRAMI2N SHRASN2N SHRHIP2N SHRAPI2N SHROTH2N
  SHRNHW2N SHRNHB2N SHRNHI2N SHRNHR2N SHRNHH2N SHRNHA2N SHRNHO2N SHRHSP2N NONHISP2
  MINWHT2N MINBLK2N MINAMI2N MINASN2N MINHIP2N MINAPI2N MINOTH2N
  MINNHW2N MINNHB2N MINNHI2N MINNHR2N MINNHH2N MINNHA2N MINNHO2N
  MAXWHT2N MAXBLK2N MAXAMI2N MAXASN2N MAXHIP2N MAXAPI2N MAXOTH2N
  MAXNHW2N MAXNHB2N MAXNHI2N MAXNHR2N MAXNHH2N MAXNHA2N MAXNHO2N
  MRAPOP2N MR1POP2N MR2POP2N MR3POP2N MRANHS2N MRAHSP2N
  ADULT2N CHILD2N
  TOTHSUN2 OCCHU2 VACHU2;


** 2000 data **;

proc summary data=Ncdb.Ncdb_lf_2000_was20 nway;
  class ucounty;
  var &var2000;
  output out=NCDB_2000_sum (drop=_freq_) sum=;
run;

** 2010 data **;

data Ncdb_2010_blk;

  set 
    Ncdb.Ncdb_2010_dc_blk
    Ncdb.Ncdb_2010_md_blk
    Ncdb.Ncdb_2010_va_blk
    Ncdb.Ncdb_2010_wv_blk;

  where put( ucounty, $ctym20f. ) ~= "";

run;

proc summary data=Ncdb_2010_blk nway;
  class ucounty;
  var &var2010;
  output out=Ncdb_2010_sum (drop=_type_ _freq_) sum= ;
run;

** 2020 data **;

data Ncdb_2020_blk;

  set 
    Ncdb.Ncdb_2020_dc_blk
    Ncdb.Ncdb_2020_md_blk
    Ncdb.Ncdb_2020_va_blk
    Ncdb.Ncdb_2020_wv_blk;

  where put( ucounty, $ctym20f. ) ~= "";

run;

proc summary data=Ncdb_2020_blk nway;
  class ucounty;
  var &var2020;
  output out=Ncdb_2020_sum (drop=_type_ _freq_) sum= ;
run;

data Table;

  merge 
    Ncdb_2000_sum 
    Ncdb_2010_sum 
    Ncdb_2020_sum;
  by ucounty;
  
  retain Metro20 '47900';

  trctpop_chg = trctpop2 - trctpop1;
  tothsun_chg = tothsun2 - TOTHSUN1;
  occhu_chg = occhu2 - occhu1;
  
 format ucounty $cnty20f.;
  
run;

** Format data for race summary tables by year **;

data RaceSummary;

  set Table;
  
  array shr0a{*} 
    SHR0D SHRNHB0N SHRNHW0N SHRHSP0N SHRNHA0N SHRNHI0N SHRNHO0N MRANHS0N;

  array shr1a{*} 
    SHR1D SHRNHB1N SHRNHW1N SHRHSP1N SHRNHA1N SHRNHI1N SHRNHO1N MRANHS1N;

  array shr2a{*} 
    SHR2D SHRNHB2N SHRNHW2N SHRHSP2N SHRNHA2N SHRNHI2N SHRNHO2N MRANHS2N;

  array shr_a{*} 
    SHRD SHRNHBN SHRNHWN SHRHSPN SHRNHAN SHRNHIN SHRNHON MRANHSN;

  year = 2000;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr0a{i};
  end;
  
  output;
  
  year = 2010;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr1a{i};
  end;
  
  output;
  
  year = 2020;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr2a{i};
  end;
  
  output;
  
  keep year ucounty SHRD SHRNHBN SHRNHWN SHRHSPN SHRNHAN SHRNHIN SHRNHON MRANHSN;
  
run;


** Format data for child and adult pop summary tables by year **;

data AgeSummary;

  set Table;
  
  array shr0a{*} 
    TRCTPOP0 ADULT0N CHILD0N;

  array shr1a{*} 
    TRCTPOP1 ADULT1N CHILD1N;

  array shr2a{*} 
    TRCTPOP2 ADULT2N CHILD2N;

  array shr_a{*} 
    TRCTPOP ADULTN CHILDN;

  year = 2000;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr0a{i};
  end;
  
  output;
  
  year = 2010;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr1a{i};
  end;
  
  output;
  
  year = 2020;
    
  do i = 1 to dim( shr_a );
    shr_a{i} = shr2a{i};
  end;
  
  output;
  
  keep year ucounty TRCTPOP ADULTN CHILDN;
  
run;


** Make tables **;

options nodate nonumber;
options orientation=portrait;

%fdate()

ods listing close;
ods rtf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_region_tables.rtf" style=Styles.Rtf_arial_9pt;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";
footnote2 height=9pt j=r '{Page}\~{\field{\*\fldinst{\pard\b\i0\chcbpat8\qc\f1\fs19\cf1{PAGE }\cf0\chcbpat0}}}';

title2 ' ';


title3 "Population by Race/Ethnicity, Washington, DC MSA - 2000 to 2020";

proc tabulate data=RaceSummary format=comma10.0 noseps missing;
  class year ucounty;
  var SHRD SHRNHBN SHRNHWN SHRHSPN SHRNHAN SHRNHIN SHRNHON MRANHSN;
  table 
    /** Pages **/
    all='Washington, DC MSA' ucounty=' ',
    /** Rows **/
    SHRD='\b TOTAL' SHRNHWN='NH White' SHRNHBN='NH Black' SHRHSPN='Hispanic/Latinx' SHRNHAN='NH Asian/PI' 
    SHRNHIN='NH Am. Indian' SHRNHON='NH Other Race' MRANHSN='\line NH Multiracial',
    /** Columns **/
    sum='Population' * year=' '
    pctsum<SHRD>='% Population' * f=comma8.1 * year=' '
    / condense
  ;
run;


title3 "Child and Adult Population, Washington, DC MSA - 2000 to 2020";

proc tabulate data=AgeSummary format=comma10.0 noseps missing;
  class year ucounty;
  var TRCTPOP ADULTN CHILDN;
  table 
    /** Pages **/
    all='Washington, DC MSA' ucounty=' ',
    /** Rows **/
    TRCTPOP='\b TOTAL' CHILDN='Children under 18' ADULTN='Adults 18+',
    /** Columns **/
    sum='Population' * year=' '
    pctsum<TRCTPOP>='% Population' * f=comma8.1 * year=' '
    / condense
  ;
run;


title3 "Population, Housing Unit, and Household Counts - 2010 vs. 2020";

proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var TRCTPOP1 TOTHSUN1 OCCHU1 TRCTPOP2 TOTHSUN2 OCCHU2 trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Population' * (
      TRCTPOP1="2010"
      TRCTPOP2="2020"
    )
    pctsum<TRCTPOP1>='% Change' * trctpop_chg=' ' * f=comma8.1

    sum='Total Housing Units' * (
      TOTHSUN1="2010"
      TOTHSUN2="2020"
    )
    pctsum<TOTHSUN1>='% Change' * tothsun_chg=' ' * f=comma8.1

    sum='Households' * (
      OCCHU1="2010"
      OCCHU2="2020"
    )
    pctsum<OCCHU1>='% Change' * occhu_chg=' ' * f=comma8.1
  ;
run;


title3 "Population, Housing Unit, and Household Distribution by Jurisdiction - 2000 to 2020";

proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var TRCTPOP0 TRCTPOP1 TOTHSUN0 TOTHSUN1 OCCHU0 OCCHU1 TRCTPOP2 TOTHSUN2 OCCHU2 trctpop_chg tothsun_chg occhu_chg;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Population' * ( TRCTPOP0="2000" TRCTPOP1="2010" TRCTPOP2="2020" )
    colpctsum='% Population' * f=comma8.1 * ( TRCTPOP0="2000" TRCTPOP1="2010" TRCTPOP2="2020" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Housing Units' * ( TOTHSUN0="2000" TOTHSUN1="2010" TOTHSUN2="2020" )
    colpctsum='% Housing Units' * f=comma8.1 * ( TOTHSUN0="2000" TOTHSUN1="2010" TOTHSUN2="2020" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Households' * ( OCCHU0="2000" OCCHU1="2010" OCCHU2="2020" )
    colpctsum='% Households' * f=comma8.1 * ( OCCHU0="2000" OCCHU1="2010" OCCHU2="2020" )
  ;
run;


title3 "Population by Race/Ethnicity Distribution by Jurisdiction - 2000 to 2020";

proc tabulate data=Table format=comma10.0 noseps missing;
  class ucounty;
  var SHRNHB0N SHRNHB1N SHRNHB2N SHRNHW0N SHRNHW1N SHRNHW2N SHRHSP0N SHRHSP1N SHRHSP2N SHRNHA0N SHRNHA1N SHRNHA2N;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='NH White Population' * ( SHRNHW0N="2000" SHRNHW1N="2010" SHRNHW2N="2020" )
    colpctsum='% NH White Population' * f=comma8.1 * ( SHRNHW0N="2000" SHRNHW1N="2010" SHRNHW2N="2020" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='NH Black Population' * ( SHRNHB0N="2000" SHRNHB1N="2010" SHRNHB2N="2020" )
    colpctsum='% NH Black Population' * f=comma8.1 * ( SHRNHB0N="2000" SHRNHB1N="2010" SHRNHB2N="2020" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='Hispanic/Latinx Population' * ( SHRHSP0N="2000" SHRHSP1N="2010" SHRHSP2N="2020" )
    colpctsum='% Hispanic/Latinx Population' * f=comma8.1 * ( SHRHSP0N="2000" SHRHSP1N="2010" SHRHSP2N="2020" )
  ;
  table 
    /** Rows **/
    all='\b TOTAL' ucounty=' ',
    /** Columns **/
    sum='NH Asian/PI Population' * ( SHRNHA0N="2000" SHRNHA1N="2010" SHRNHA2N="2020" )
    colpctsum='% NH Asian/PI Population' * f=comma8.1 * ( SHRNHA0N="2000" SHRNHA1N="2010" SHRNHA2N="2020" )
  ;
run;


ods rtf close;
ods listing;

title2;
footnote1;


** Scatter plots **;

/** Macro Scatter_plot - Start Definition **/

%macro Scatter_plot( st=, geo=, geolabel=, race=, racelabel=, pagebreak=y );

  %let race = %lowcase( &race );

  *** Graphics ***;

  data Scatter;

    set Table_sum;

    %if &st ~= dc %then %do;
      where _type_ = 1;
    %end;
    
    %if &race = hsp %then %do;
    
      year = 2000;
      shr&race.n = shr&race.0n;
      shr&race. = shr&race.0n / shr0d;
      output;
      
      year = 2010;
      shr&race.n = shr&race.1n;
      shr&race. = shr&race.1n / shr1d;
      output;
      
      year = 2020;
      shr&race.n = shr&race.2n;
      shr&race. = shr&race.2n / shr2d;
      output;
      
      format shr&race. percent6.1;
      format shr&race.n comma12.0;
      
      keep _type_ &geo year shr&race.n shr&race.;
      
    %end;
    %else %do;

      year = 2000;
      min&race.n = min&race.0n;
      shr&race.n = shr&race.0n;
      max&race.n = max&race.0n;
      min&race. = min&race.0n / shr0d;
      shr&race. = shr&race.0n / shr0d;
      max&race. = max&race.0n / shr0d;
      output;
      
      year = 2010;
      min&race.n = min&race.1n;
      shr&race.n = shr&race.1n;
      max&race.n = max&race.1n;
      min&race. = min&race.1n / shr1d;
      shr&race. = shr&race.1n / shr1d;
      max&race. = max&race.1n / shr1d;
      output;
      
      year = 2020;
      min&race.n = min&race.2n;
      shr&race.n = shr&race.2n;
      max&race.n = max&race.2n;
      min&race. = min&race.2n / shr2d;
      shr&race. = shr&race.2n / shr2d;
      max&race. = max&race.2n / shr2d;
      output;
      
      format min&race. shr&race. max&race. percent6.1;
      format min&race.n shr&race.n max&race.n comma12.0;
      
      keep _type_ &geo year min&race.n shr&race.n max&race.n min&race. shr&race. max&race.;
      
    %end;
    
  run;
  
  ** Put DC total last (because total not shown for population counts) **; 
  
  proc sort data=Scatter;
    by descending _type_ &geo;
  run;
  
  
  ** Charts **;
  
  ** Population counts **;

  proc sgplot data=Scatter noautolegend uniform=scale;
    scatter x=year y=shr&race.n / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.n
        yerrorupper=max&race.n
      %end;
      markerattrs=(color=blue symbol=CircleFilled);
    series x=year y=shr&race.n / lineattrs=(color=blue pattern=2);
    xaxis display=(nolabel);
    yaxis display=(nolabel) min=0 max=3000000;
    label &geo = "&geolabel";
    %if %length( &st ) > 0 %then %do;
      title1 "&racelabel Population, %upcase(&st)";
    %end;
    %else %do;
      title1 "&racelabel Population";
    %end;    
    title2 "Greater DC Region";
  run;
  
  %if %mparam_is_yes( &pagebreak ) %then %do;
    ods pdf columns=1 startpage=now;
    ods pdf columns=3 startpage=never;
  %end;

  ** Percentage of population **;
  
  proc sgplot data=Scatter noautolegend uniform=scale;
    scatter x=year y=shr&race. / 
      %if &race ~= hsp %then %do;
        yerrorlower=min&race.
        yerrorupper=max&race.
      %end;
      markerattrs=(color=blue symbol=CircleFilled);
    series x=year y=shr&race. / lineattrs=(color=blue pattern=2);
    xaxis display=(nolabel);
    yaxis display=(nolabel) min=0 max=0.6;
    label &geo = "&geolabel";
    %if %length( &st ) > 0 %then %do;
      title1 "Pct. &racelabel Population, %upcase(&st)";
    %end;
    %else %do;
      title1 "Pct. &racelabel Population";
    %end;    
    title2 "Greater DC Region";
  run;
  
  %if %mparam_is_yes( &pagebreak ) %then %do;
    ods pdf columns=1 startpage=now;
    ods pdf columns=3 startpage=never;
  %end;

  proc datasets library=work nolist;
    delete Scatter /memtype=data;
  quit;
  
%mend Scatter_plot;

proc summary data=Table nway;
  class Metro20;
  var &var2000 &var2010 &var2020;
  output out=Table_sum sum=;
run;

options nodate number;
options orientation=portrait;

ods listing close;
ods pdf file="&_dcdata_default_path\NCDB\Prog\2020\Ncdb_2020_region_charts.pdf" notoc nogfootnote;

footnote1 height=9pt "Prepared by Urban-Greater DC (greaterdc.urban.org), &fdate..";

  ods graphics on / width=2.666667in height=2in;

  ods pdf columns=3 startpage=never;
  


%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=nhw, racelabel=Non-Hisp. White, pagebreak=n )
%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=nhb, racelabel=Non-Hisp. Black, pagebreak=n )
%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=hsp, racelabel=Hispanic/Latinx, pagebreak=n )
%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=nha, racelabel=Non-Hisp. Asian/PI, pagebreak=n )
%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=nhi, racelabel=Non-Hisp. Am. Indian, pagebreak=n )
%Scatter_plot( st=, geo=metro20, geolabel=MSA, race=nho, racelabel=Non-Hisp. Other race, pagebreak=n )

ods pdf close;
ods listing;

footnote1;
title1 "&_library/&_program: Urban-Greater DC";

