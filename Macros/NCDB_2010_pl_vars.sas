/**************************************************************************
 Program:  NCDB_2010_pl_vars.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  02/12/22
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  
 
 Description:  Autocall macro to create 2010 NCDB variables from
 Census PL data.

 Modifications:
**************************************************************************/

/** Macro NCDB_2010_pl_vars - Start Definition **/

%macro NCDB_2010_pl_vars(  );

    ******  NCDB Variables ******;
    
    ** Total population **;

    TRCTPOP1 = P0010001;
    SHR1D = P0010001;
    
    ** Bridged race population counts (SHR) **;

    SHRWHT1N = sum( P0010003, P0010012, P0010015, P0010033 );

    SHRBLK1N = sum( P0010004, P0010011, P0010016, P0010017, P0010018, P0010019,
    P0010027, P0010028, P0010029, P0010030, P0010037, P0010038,
    P0010039, P0010040, P0010041, P0010042, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010058, P0010059,
    P0010060, P0010061, P0010064, P0010065, P0010066, P0010067,
    P0010069, P0010071 );
    
    SHRAMI1N = sum( P0010005, P0010022 );
    
    SHRASN1N = sum( P0010006, P0010013, P0010020, P0010023, P0010024, P0010031,
    P0010034, P0010035, P0010043, P0010044, P0010046, P0010054,
    P0010055, P0010057, P0010062, P0010068 );

    SHRHIP1N = sum( P0010007, P0010014, P0010021, P0010025, P0010032, P0010036,
    P0010045, P0010056 );

    SHRAPI1N = SHRASN1N + SHRHIP1N;

    SHROTH1N = P0010008;
    
    ** Non-Hispanic bridged race counts (SHRNH) **;

    SHRNHW1N = sum( P0020005, P0020014, P0020017, P0020035 );

    SHRNHB1N = sum( P0020006, P0020013, P0020018, P0020019, P0020020, P0020021,
    P0020029, P0020030, P0020031, P0020032, P0020039, P0020040,
    P0020041, P0020042, P0020043, P0020044, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020060, P0020061,
    P0020062, P0020063, P0020066, P0020067, P0020068, P0020069,
    P0020071, P0020073 );

    SHRNHI1N = sum( P0020007, P0020024 );

    SHRNHR1N = sum( P0020008, P0020015, P0020022, P0020025, P0020026, P0020033,
    P0020036, P0020037, P0020045, P0020046, P0020048, P0020056,
    P0020057, P0020059, P0020064, P0020070 );

    SHRNHH1N = sum( P0020009, P0020016, P0020023, P0020027, P0020034, P0020038,
    P0020047, P0020058 );

    SHRNHA1N = SHRNHR1N + SHRNHH1N;

    SHRNHO1N = P0020010;

    SHRHSP1N = P0020002;

    NONHISP1 = P0020003;
    
    ** Single race alone counts (MIN) **;

    MINWHT1N = P0010003;

    MINBLK1N = P0010004;

    MINAMI1N = P0010005;

    MINASN1N = P0010006;

    MINHIP1N = P0010007;

    MINAPI1N = MINASN1N + MINHIP1N;

    MINOTH1N = P0010008;
    
    ** Non-Hispanic single race alone counts (MINNH) **;

    MINNHW1N = P0020005;

    MINNHB1N = P0020006;

    MINNHI1N = P0020007;

    MINNHR1N = P0020008;

    MINNHH1N = P0020009;

    MINNHA1N = MINNHR1N + MINNHH1N;

    MINNHO1N = P0020010;
    
    ** Single race or in combination counts (MAX) **;

    MAXWHT1N = sum( P0010003, P0010011, P0010012, P0010013, P0010014, P0010015,
    P0010027, P0010028, P0010029, P0010030, P0010031, P0010032,
    P0010033, P0010034, P0010035, P0010036, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010054, P0010055,
    P0010056, P0010057, P0010064, P0010065, P0010066, P0010067,
    P0010068, P0010071 );

    MAXBLK1N = sum( P0010004, P0010011, P0010016, P0010017, P0010018, P0010019,
    P0010027, P0010028, P0010029, P0010030, P0010037, P0010038,
    P0010039, P0010040, P0010041, P0010042, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010058, P0010059,
    P0010060, P0010061, P0010064, P0010065, P0010066, P0010067,
    P0010069, P0010071 );

    MAXAMI1N = sum( P0010005, P0010012, P0010016, P0010020, P0010021, P0010022,
    P0010027, P0010031, P0010032, P0010033, P0010037, P0010038,
    P0010039, P0010043, P0010044, P0010045, P0010048, P0010049,
    P0010050, P0010054, P0010055, P0010056, P0010058, P0010059,
    P0010060, P0010062, P0010064, P0010065, P0010066, P0010068,
    P0010069, P0010071 );

    MAXASN1N = sum( P0010006, P0010013, P0010017, P0010020, P0010023, P0010024,
    P0010028, P0010031, P0010034, P0010035, P0010037, P0010040,
    P0010041, P0010043, P0010044, P0010046, P0010048, P0010051,
    P0010052, P0010054, P0010055, P0010057, P0010058, P0010059,
    P0010061, P0010062, P0010064, P0010065, P0010067, P0010068,
    P0010069, P0010071 );

    MAXHIP1N = sum( P0010007, P0010014, P0010018, P0010021, P0010023, P0010025,
    P0010029, P0010032, P0010034, P0010036, P0010038, P0010040,
    P0010042, P0010043, P0010045, P0010046, P0010049, P0010051,
    P0010053, P0010054, P0010056, P0010057, P0010058, P0010060,
    P0010061, P0010062, P0010064, P0010066, P0010067, P0010068,
    P0010069, P0010071 );

    MAXAPI1N = sum( P0010006, P0010007, P0010013, P0010014, P0010017, P0010018,
    P0010020, P0010021, P0010023, P0010024, P0010025, P0010028,
    P0010029, P0010031, P0010032, P0010034, P0010035, P0010036,
    P0010037, P0010038, P0010040, P0010041, P0010042, P0010043,
    P0010044, P0010045, P0010046, P0010048, P0010049, P0010051,
    P0010052, P0010053, P0010054, P0010055, P0010056, P0010057,
    P0010058, P0010059, P0010060, P0010061, P0010062, P0010064,
    P0010065, P0010066, P0010067, P0010068, P0010069, P0010071 );

    MAXOTH1N = sum( P0010008, P0010015, P0010019, P0010022, P0010024, P0010025,
    P0010030, P0010033, P0010035, P0010036, P0010039, P0010041,
    P0010042, P0010044, P0010045, P0010046, P0010050, P0010052,
    P0010053, P0010055, P0010056, P0010057, P0010059, P0010060,
    P0010061, P0010062, P0010065, P0010066, P0010067, P0010068,
    P0010069, P0010071 );

    ** Non-Hispanic single race or in combination counts (MAX) **;

    MAXNHW1N = sum( P0020005, P0020013, P0020014, P0020015, P0020016, P0020017,
    P0020029, P0020030, P0020031, P0020032, P0020033, P0020034,
    P0020035, P0020036, P0020037, P0020038, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020056, P0020057,
    P0020058, P0020059, P0020066, P0020067, P0020068, P0020069,
    P0020070, P0020073 );

    MAXNHB1N = sum( P0020006, P0020013, P0020018, P0020019, P0020020, P0020021,
    P0020029, P0020030, P0020031, P0020032, P0020039, P0020040,
    P0020041, P0020042, P0020043, P0020044, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020060, P0020061,
    P0020062, P0020063, P0020066, P0020067, P0020068, P0020069,
    P0020071, P0020073 );

    MAXNHI1N = sum( P0020007, P0020014, P0020018, P0020022, P0020023, P0020024,
    P0020029, P0020033, P0020034, P0020035, P0020039, P0020040,
    P0020041, P0020045, P0020046, P0020047, P0020050, P0020051,
    P0020052, P0020056, P0020057, P0020058, P0020060, P0020061,
    P0020062, P0020064, P0020066, P0020067, P0020068, P0020070,
    P0020071, P0020073 );

    MAXNHR1N = sum( P0020008, P0020015, P0020019, P0020022, P0020025, P0020026,
    P0020030, P0020033, P0020036, P0020037, P0020039, P0020042,
    P0020043, P0020045, P0020046, P0020048, P0020050, P0020053,
    P0020054, P0020056, P0020057, P0020059, P0020060, P0020061,
    P0020063, P0020064, P0020066, P0020067, P0020069, P0020070,
    P0020071, P0020073 );

    MAXNHH1N = sum( P0020009, P0020016, P0020020, P0020023, P0020025, P0020027,
    P0020031, P0020034, P0020036, P0020038, P0020040, P0020042,
    P0020044, P0020045, P0020047, P0020048, P0020051, P0020053,
    P0020055, P0020056, P0020058, P0020059, P0020060, P0020062,
    P0020063, P0020064, P0020066, P0020068, P0020069, P0020070,
    P0020071, P0020073 );

    MAXNHA1N = sum( P0020008, P0020009, P0020015, P0020016, P0020019, P0020020,
    P0020022, P0020023, P0020025, P0020026, P0020027, P0020030,
    P0020031, P0020033, P0020034, P0020036, P0020037, P0020038,
    P0020039, P0020040, P0020042, P0020043, P0020044, P0020045,
    P0020046, P0020047, P0020048, P0020050, P0020051, P0020053,
    P0020054, P0020055, P0020056, P0020057, P0020058, P0020059,
    P0020060, P0020061, P0020062, P0020063, P0020064, P0020066,
    P0020067, P0020068, P0020069, P0020070, P0020071, P0020073 );

    MAXNHO1N = sum( P0020010, P0020017, P0020021, P0020024, P0020026, P0020027,
    P0020032, P0020035, P0020037, P0020038, P0020041, P0020043,
    P0020044, P0020046, P0020047, P0020048, P0020052, P0020054,
    P0020055, P0020057, P0020058, P0020059, P0020061, P0020062,
    P0020063, P0020064, P0020067, P0020068, P0020069, P0020070,
    P0020071, P0020073 );
    
    ** Asian/Pacific Islander counts **;
    
    SHRAPI1N = SHRASN1N + SHRHIP1N;
    MINAPI1N = MINASN1N + MINHIP1N;
    SHRNHA1N = SHRNHR1N + SHRNHH1N;
    MINNHA1N = MINNHR1N + MINNHH1N;
    
    ** Multi-racial counts **;

    MRAPOP1N = P0010009;

    MR1POP1N = P0010002;

    MR2POP1N = P0010010;

    MR3POP1N = sum( P0010026, P0010047, P0010063, P0010070 );

    MRANHS1N = P0020011;

    MRAHSP1N = MRAPOP1N - MRANHS1N;
    
    ** Race/ethnicity proportions **;

    if shr1d > 0 then do;
      SHRWHT1 = SHRWHT1N/SHR1D;
      SHRBLK1 = SHRBLK1N/SHR1D;
      SHRNHW1 = SHRNHW1N/SHR1D;
      SHRNHB1 = SHRNHB1N/SHR1D;
      SHRNHI1 = SHRNHI1N/SHR1D;
      SHRNHR1 = SHRNHR1N/SHR1D;
      SHRNHH1 = SHRNHH1N/SHR1D;
      SHRNHA1 = SHRNHA1N/SHR1D;
      SHRNHO1 = SHRNHO1N/SHR1D;
      SHRHSP1 = SHRHSP1N/SHR1D;
    end;
    
    label
      TRCTPOP1 = "Total population, 2010"
      SHR1D = "Total population for race/ethnicity, 2010"
      SHRWHT1N = "Total White population, 2010"
      SHRWHT1 = "Prop. White population, 2010"
      MINWHT1N = "White alone population, 2010"
      MAXWHT1N = "Persons choosing White alone or in combination with other races, 2010"
      SHRBLK1N = "Total Black/Afr. Am. population, 2010"
      SHRBLK1 = "Prop. Black/Afr. Am. population, 2010"
      MINBLK1N = "Black/Afr. Am. alone population, 2010"
      MAXBLK1N = "Persons choosing Black/Afr. Am. alone or in combination with other races, 2010"
      SHRAMI1N = "Total Am. Indian/AK Native population, 2010"
      MINAMI1N = "Am. Indian/AK Native alone population, 2010"
      MAXAMI1N = "Persons choosing Am. Indian/AK Native alone or in combination with other races, 2010"
      SHRASN1N = "Total Asian population, 2010"
      MINASN1N = "Asian alone population, 2010"
      MAXASN1N = "Persons choosing Asian alone or in combination with other races, 2010"
      SHRHIP1N = "Total Native HI and other Pac. Isl. population, 2010"
      MINHIP1N = "Native HI and other Pac. Isl. alone population, 2010"
      MAXHIP1N = "Persons choosing Native HI and other Pac. Isl. alone or in combination with other races, 2010"
      SHRAPI1N = "Total Asian, Native HI and other Pac. Isl. population, 2010"
      MINAPI1N = "Asian, Native HI and other Pac. Isl. alone population, 2010"
      MAXAPI1N = "Persons choosing Asian, Native HI and other Pac. Isl. alone or in combination with other races, 2010"
      SHROTH1N = "Total other race population, 2010"
      MINOTH1N = "Other race alone population, 2010"
      MAXOTH1N = "Persons choosing other race alone or in combination with other races, 2010"
      MRAPOP1N = "Multiracial population, 2010"
      MR1POP1N = "Population selecting one race, 2010"
      MR2POP1N = "Population selecting two races, 2010"
      MR3POP1N = "Population selecting three+ races, 2010"
      NONHISP1 = "Persons not of Hisp./Latino origin, 2010"
      SHRNHW1N = "Total non-Hisp./Latino White population, 2010"
      SHRNHW1 = "Prop. non-Hisp./Latino White population, 2010"
      MINNHW1N = "Non-Hisp./Latino White alone population, 2010"
      MAXNHW1N = "Persons choosing non-Hisp./Latino White alone or in combination with other races, 2010"
      SHRNHB1N = "Total non-Hisp./Latino Black/Afr. Am. population, 2010"
      SHRNHB1 = "Prop. non-Hisp./Latino Black/Afr. Am. population, 2010"
      MINNHB1N = "Non-Hisp./Latino Black/Afr. Am. alone population, 2010"
      MAXNHB1N = "Persons choosing non-Hisp./Latino Black/Afr. Am. alone or in combination with other races, 2010"
      SHRNHI1N = "Total non-Hisp./Latino Am. Indian/AK Native population, 2010"
      SHRNHI1 = "Prop. non-Hisp./Latino Am. Indian/AK Native population, 2010"
      MINNHI1N = "Non-Hisp./Latino Am. Indian/AK Native alone population, 2010"
      MAXNHI1N = "Persons choosing non-Hisp./Latino Am. Indian/AK Native alone or in combination with other races, 2010"
      SHRNHR1N = "Total non-Hisp./Latino Asian population, 2010"
      SHRNHR1 = "Prop. non-Hisp./Latino Asian population, 2010"
      MINNHR1N = "Non-Hisp./Latino Asian alone population, 2010"
      MAXNHR1N = "Persons choosing non-Hisp./Latino Asian alone or in combination with other races, 2010"
      SHRNHH1N = "Total non-Hisp./Latino Native HI and other Pac. Isl. population, 2010"
      SHRNHH1 = "Prop. non-Hisp./Latino Native HI and other Pac. Isl. population, 2010"
      MINNHH1N = "Non-Hisp./Latino Native HI and other Pac. Isl. alone population, 2010"
      MAXNHH1N = "Persons choosing non-Hisp./Latino Native HI and other Pac. Isl. alone or in combination with other races, 2010"
      SHRNHA1N = "Total non-Hisp./Latino Asian, Native HI and other Pac. Isl. population, 2010"
      SHRNHA1 = "Prop. non-Hisp./Latino Asian or Native HI and other Pac. Isl. population, 2010"
      MINNHA1N = "Non-Hisp./Latino Asian, Native HI and other Pac. Isl. alone population, 2010"
      MAXNHA1N = "Persons choosing non-Hisp./Latino Asian, Native HI and other Pac. Isl. alone or in combination with other races, 2010"
      SHRNHO1N = "Total non-Hisp./Latino other race population, 2010"
      SHRNHO1 = "Prop. non-Hisp./Latino other race population, 2010"
      MINNHO1N = "Non-Hisp./Latino other race alone population, 2010"
      MAXNHO1N = "Persons choosing non-Hisp./Latino other race alone or in combination with other races, 2010"
      MRANHS1N = "Non-Hisp./Latino multiracial population, 2010"
      SHRHSP1N = "Total Hisp./Latino population, 2010"
      SHRHSP1 = "Prop. Hisp./Latino population, 2010"
      MRAHSP1N = "Hisp./Latino multiracial population, 2010";

    ** Age counts and proportions **;

    ADULT1N = P0030001;
    CHILD1N = TRCTPOP1 - ADULT1N;

    if TRCTPOP1 > 0 then do;
      ADULT1 = ADULT1N/TRCTPOP1;
      CHILD1 = CHILD1N/TRCTPOP1;
    end;

    label
      ADULT1N = "Adults 18+ years old, 2010"
      ADULT1 = "Prop. of persons who are adults 18+ years old, 2010"
      CHILD1N = "Children under 18 years old, 2010"
      CHILD1 = "Prop. of persons who are children under 18 years old, 2010";

    ** Housing **;

    TOTHSUN1 = H0010001;
    OCCHU1 = H0010002;
    VACHU1 = H0010003;

    label
      TOTHSUN1 = "Total housing units, 2010"
      OCCHU1 = "Total occupied housing units, 2010"
      VACHU1 = "Total vacant housing units, 2010";

%mend NCDB_2010_pl_vars;

/** End Macro Definition **/

