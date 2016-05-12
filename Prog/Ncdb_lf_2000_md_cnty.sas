/**************************************************************************
 Program:  Ncdb_lf_2000_md_cnty.sas
 Library:  Ncdb
 Project:  NeighborhoodInfo DC
 Author:   P. Tatian
 Created:  03/15/11
 Version:  SAS 9.1
 Environment:  Windows
 
 Description:  Compile 2000 NCDB data for MD counties.

 Modifications:
**************************************************************************/

%include "K:\Metro\PTatian\DCData\SAS\Inc\Stdhead.sas";
%include "K:\Metro\PTatian\DCData\SAS\Inc\AlphaSignon.sas" /nosource2;

** Define libraries **;
%DCData_lib( Ncdb )

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

%syslput var2000=&var2000;

** Start submitting commands to remote server **;

rsubmit;

libname ncdbpub 'ncdb_public:';

proc summary data=ncdbpub.Ncdb_lf_2000;
  where stusab = 'MD';
  by ucounty;
  var &var2000;
  output out=Ncdb_lf_2000_md_cnty sum= ;
run;

proc download status=no
  inlib=work 
  outlib=Ncdb memtype=(data);
  select Ncdb_lf_2000_md_cnty;
run;

endrsubmit;

** End submitting commands to remote server **;

run;

%File_info( data=Ncdb.Ncdb_lf_2000_md_cnty, printobs=0 )

