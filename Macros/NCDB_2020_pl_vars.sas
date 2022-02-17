/**************************************************************************
 Program:  NCDB_2020_pl_vars.sas
 Library:  NCDB
 Project:  Urban-Greater DC
 Author:   P. Tatian
 Created:  02/12/22
 Version:  SAS 9.4
 Environment:  Local Windows session (desktop)
 GitHub issue:  
 
 Description:  Autocall macro to create 2020 NCDB variables from
 Census PL data.

 Modifications:
**************************************************************************/

/** Macro NCDB_2020_pl_vars - Start Definition **/

%macro NCDB_2020_pl_vars(  );

    ******  NCDB Variables ******;
    
    ** Total population **;

    TRCTPOP2 = P0010001;
    SHR2D = P0010001;
    
    ** Bridged race population counts (SHR) **;

    SHRWHT2N = sum( P0010003, P0010012, P0010015, P0010033 );

    SHRBLK2N = sum( P0010004, P0010011, P0010016, P0010017, P0010018, P0010019,
    P0010027, P0010028, P0010029, P0010030, P0010037, P0010038,
    P0010039, P0010040, P0010041, P0010042, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010058, P0010059,
    P0010060, P0010061, P0010064, P0010065, P0010066, P0010067,
    P0010069, P0010071 );
    
    SHRAMI2N = sum( P0010005, P0010022 );
    
    SHRASN2N = sum( P0010006, P0010013, P0010020, P0010023, P0010024, P0010031,
    P0010034, P0010035, P0010043, P0010044, P0010046, P0010054,
    P0010055, P0010057, P0010062, P0010068 );

    SHRHIP2N = sum( P0010007, P0010014, P0010021, P0010025, P0010032, P0010036,
    P0010045, P0010056 );

    SHRAPI2N = SHRASN2N + SHRHIP2N;

    SHROTH2N = P0010008;
    
    ** Non-Hispanic bridged race counts (SHRNH) **;

    SHRNHW2N = sum( P0020005, P0020014, P0020017, P0020035 );

    SHRNHB2N = sum( P0020006, P0020013, P0020018, P0020019, P0020020, P0020021,
    P0020029, P0020030, P0020031, P0020032, P0020039, P0020040,
    P0020041, P0020042, P0020043, P0020044, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020060, P0020061,
    P0020062, P0020063, P0020066, P0020067, P0020068, P0020069,
    P0020071, P0020073 );

    SHRNHI2N = sum( P0020007, P0020024 );

    SHRNHR2N = sum( P0020008, P0020015, P0020022, P0020025, P0020026, P0020033,
    P0020036, P0020037, P0020045, P0020046, P0020048, P0020056,
    P0020057, P0020059, P0020064, P0020070 );

    SHRNHH2N = sum( P0020009, P0020016, P0020023, P0020027, P0020034, P0020038,
    P0020047, P0020058 );

    SHRNHA2N = SHRNHR2N + SHRNHH2N;

    SHRNHO2N = P0020010;

    SHRHSP2N = P0020002;

    NONHISP2 = P0020003;
    
    ** Single race alone counts (MIN) **;

    MINWHT2N = P0010003;

    MINBLK2N = P0010004;

    MINAMI2N = P0010005;

    MINASN2N = P0010006;

    MINHIP2N = P0010007;

    MINAPI2N = MINASN2N + MINHIP2N;

    MINOTH2N = P0010008;
    
    ** Non-Hispanic single race alone counts (MINNH) **;

    MINNHW2N = P0020005;

    MINNHB2N = P0020006;

    MINNHI2N = P0020007;

    MINNHR2N = P0020008;

    MINNHH2N = P0020009;

    MINNHA2N = MINNHR2N + MINNHH2N;

    MINNHO2N = P0020010;
    
    ** Single race or in combination counts (MAX) **;

    MAXWHT2N = sum( P0010003, P0010011, P0010012, P0010013, P0010014, P0010015,
    P0010027, P0010028, P0010029, P0010030, P0010031, P0010032,
    P0010033, P0010034, P0010035, P0010036, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010054, P0010055,
    P0010056, P0010057, P0010064, P0010065, P0010066, P0010067,
    P0010068, P0010071 );

    MAXBLK2N = sum( P0010004, P0010011, P0010016, P0010017, P0010018, P0010019,
    P0010027, P0010028, P0010029, P0010030, P0010037, P0010038,
    P0010039, P0010040, P0010041, P0010042, P0010048, P0010049,
    P0010050, P0010051, P0010052, P0010053, P0010058, P0010059,
    P0010060, P0010061, P0010064, P0010065, P0010066, P0010067,
    P0010069, P0010071 );

    MAXAMI2N = sum( P0010005, P0010012, P0010016, P0010020, P0010021, P0010022,
    P0010027, P0010031, P0010032, P0010033, P0010037, P0010038,
    P0010039, P0010043, P0010044, P0010045, P0010048, P0010049,
    P0010050, P0010054, P0010055, P0010056, P0010058, P0010059,
    P0010060, P0010062, P0010064, P0010065, P0010066, P0010068,
    P0010069, P0010071 );

    MAXASN2N = sum( P0010006, P0010013, P0010017, P0010020, P0010023, P0010024,
    P0010028, P0010031, P0010034, P0010035, P0010037, P0010040,
    P0010041, P0010043, P0010044, P0010046, P0010048, P0010051,
    P0010052, P0010054, P0010055, P0010057, P0010058, P0010059,
    P0010061, P0010062, P0010064, P0010065, P0010067, P0010068,
    P0010069, P0010071 );

    MAXHIP2N = sum( P0010007, P0010014, P0010018, P0010021, P0010023, P0010025,
    P0010029, P0010032, P0010034, P0010036, P0010038, P0010040,
    P0010042, P0010043, P0010045, P0010046, P0010049, P0010051,
    P0010053, P0010054, P0010056, P0010057, P0010058, P0010060,
    P0010061, P0010062, P0010064, P0010066, P0010067, P0010068,
    P0010069, P0010071 );

    MAXAPI2N = sum( P0010006, P0010007, P0010013, P0010014, P0010017, P0010018,
    P0010020, P0010021, P0010023, P0010024, P0010025, P0010028,
    P0010029, P0010031, P0010032, P0010034, P0010035, P0010036,
    P0010037, P0010038, P0010040, P0010041, P0010042, P0010043,
    P0010044, P0010045, P0010046, P0010048, P0010049, P0010051,
    P0010052, P0010053, P0010054, P0010055, P0010056, P0010057,
    P0010058, P0010059, P0010060, P0010061, P0010062, P0010064,
    P0010065, P0010066, P0010067, P0010068, P0010069, P0010071 );

    MAXOTH2N = sum( P0010008, P0010015, P0010019, P0010022, P0010024, P0010025,
    P0010030, P0010033, P0010035, P0010036, P0010039, P0010041,
    P0010042, P0010044, P0010045, P0010046, P0010050, P0010052,
    P0010053, P0010055, P0010056, P0010057, P0010059, P0010060,
    P0010061, P0010062, P0010065, P0010066, P0010067, P0010068,
    P0010069, P0010071 );

    ** Non-Hispanic single race or in combination counts (MAX) **;

    MAXNHW2N = sum( P0020005, P0020013, P0020014, P0020015, P0020016, P0020017,
    P0020029, P0020030, P0020031, P0020032, P0020033, P0020034,
    P0020035, P0020036, P0020037, P0020038, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020056, P0020057,
    P0020058, P0020059, P0020066, P0020067, P0020068, P0020069,
    P0020070, P0020073 );

    MAXNHB2N = sum( P0020006, P0020013, P0020018, P0020019, P0020020, P0020021,
    P0020029, P0020030, P0020031, P0020032, P0020039, P0020040,
    P0020041, P0020042, P0020043, P0020044, P0020050, P0020051,
    P0020052, P0020053, P0020054, P0020055, P0020060, P0020061,
    P0020062, P0020063, P0020066, P0020067, P0020068, P0020069,
    P0020071, P0020073 );

    MAXNHI2N = sum( P0020007, P0020014, P0020018, P0020022, P0020023, P0020024,
    P0020029, P0020033, P0020034, P0020035, P0020039, P0020040,
    P0020041, P0020045, P0020046, P0020047, P0020050, P0020051,
    P0020052, P0020056, P0020057, P0020058, P0020060, P0020061,
    P0020062, P0020064, P0020066, P0020067, P0020068, P0020070,
    P0020071, P0020073 );

    MAXNHR2N = sum( P0020008, P0020015, P0020019, P0020022, P0020025, P0020026,
    P0020030, P0020033, P0020036, P0020037, P0020039, P0020042,
    P0020043, P0020045, P0020046, P0020048, P0020050, P0020053,
    P0020054, P0020056, P0020057, P0020059, P0020060, P0020061,
    P0020063, P0020064, P0020066, P0020067, P0020069, P0020070,
    P0020071, P0020073 );

    MAXNHH2N = sum( P0020009, P0020016, P0020020, P0020023, P0020025, P0020027,
    P0020031, P0020034, P0020036, P0020038, P0020040, P0020042,
    P0020044, P0020045, P0020047, P0020048, P0020051, P0020053,
    P0020055, P0020056, P0020058, P0020059, P0020060, P0020062,
    P0020063, P0020064, P0020066, P0020068, P0020069, P0020070,
    P0020071, P0020073 );

    MAXNHA2N = sum( P0020008, P0020009, P0020015, P0020016, P0020019, P0020020,
    P0020022, P0020023, P0020025, P0020026, P0020027, P0020030,
    P0020031, P0020033, P0020034, P0020036, P0020037, P0020038,
    P0020039, P0020040, P0020042, P0020043, P0020044, P0020045,
    P0020046, P0020047, P0020048, P0020050, P0020051, P0020053,
    P0020054, P0020055, P0020056, P0020057, P0020058, P0020059,
    P0020060, P0020061, P0020062, P0020063, P0020064, P0020066,
    P0020067, P0020068, P0020069, P0020070, P0020071, P0020073 );

    MAXNHO2N = sum( P0020010, P0020017, P0020021, P0020024, P0020026, P0020027,
    P0020032, P0020035, P0020037, P0020038, P0020041, P0020043,
    P0020044, P0020046, P0020047, P0020048, P0020052, P0020054,
    P0020055, P0020057, P0020058, P0020059, P0020061, P0020062,
    P0020063, P0020064, P0020067, P0020068, P0020069, P0020070,
    P0020071, P0020073 );
    
    ** Asian/Pacific Islander counts **;
    
    SHRAPI2N = SHRASN2N + SHRHIP2N;
    MINAPI2N = MINASN2N + MINHIP2N;
    SHRNHA2N = SHRNHR2N + SHRNHH2N;
    MINNHA2N = MINNHR2N + MINNHH2N;
    
    ** Multi-racial counts **;

    MRAPOP2N = P0010009;

    MR1POP2N = P0010002;

    MR2POP2N = P0010010;

    MR3POP2N = sum( P0010026, P0010047, P0010063, P0010070 );

    MRANHS2N = P0020011;

    MRAHSP2N = MRAPOP2N - MRANHS2N;
    
    ** Race/ethnicity proportions **;

    if SHR2D > 0 then do;
      SHRWHT2 = SHRWHT2N/SHR2D;
      SHRBLK2 = SHRBLK2N/SHR2D;
      SHRNHW2 = SHRNHW2N/SHR2D;
      SHRNHB2 = SHRNHB2N/SHR2D;
      SHRNHI2 = SHRNHI2N/SHR2D;
      SHRNHR2 = SHRNHR2N/SHR2D;
      SHRNHH2 = SHRNHH2N/SHR2D;
      SHRNHA2 = SHRNHA2N/SHR2D;
      SHRNHO2 = SHRNHO2N/SHR2D;
      SHRHSP2 = SHRHSP2N/SHR2D;
    end;
    
    label
      TRCTPOP2 = "Total population, 2020"
      SHR2D = "Total population for race/ethnicity, 2020"
      SHRWHT2N = "Total White population, 2020"
      SHRWHT2 = "Prop. White population, 2020"
      MINWHT2N = "White alone population, 2020"
      MAXWHT2N = "Persons choosing White alone or in combination with other races, 2020"
      SHRBLK2N = "Total Black/Afr. Am. population, 2020"
      SHRBLK2 = "Prop. Black/Afr. Am. population, 2020"
      MINBLK2N = "Black/Afr. Am. alone population, 2020"
      MAXBLK2N = "Persons choosing Black/Afr. Am. alone or in combination with other races, 2020"
      SHRAMI2N = "Total Am. Indian/AK Native population, 2020"
      MINAMI2N = "Am. Indian/AK Native alone population, 2020"
      MAXAMI2N = "Persons choosing Am. Indian/AK Native alone or in combination with other races, 2020"
      SHRASN2N = "Total Asian population, 2020"
      MINASN2N = "Asian alone population, 2020"
      MAXASN2N = "Persons choosing Asian alone or in combination with other races, 2020"
      SHRHIP2N = "Total Native HI and other Pac. Isl. population, 2020"
      MINHIP2N = "Native HI and other Pac. Isl. alone population, 2020"
      MAXHIP2N = "Persons choosing Native HI and other Pac. Isl. alone or in combination with other races, 2020"
      SHRAPI2N = "Total Asian, Native HI and other Pac. Isl. population, 2020"
      MINAPI2N = "Asian, Native HI and other Pac. Isl. alone population, 2020"
      MAXAPI2N = "Persons choosing Asian, Native HI and other Pac. Isl. alone or in combination with other races, 2020"
      SHROTH2N = "Total other race population, 2020"
      MINOTH2N = "Other race alone population, 2020"
      MAXOTH2N = "Persons choosing other race alone or in combination with other races, 2020"
      MRAPOP2N = "Multiracial population, 2020"
      MR1POP2N = "Population selecting one race, 2020"
      MR2POP2N = "Population selecting two races, 2020"
      MR3POP2N = "Population selecting three+ races, 2020"
      NONHISP2 = "Persons not of Hisp./Latino origin, 2020"
      SHRNHW2N = "Total non-Hisp./Latino White population, 2020"
      SHRNHW2 = "Prop. non-Hisp./Latino White population, 2020"
      MINNHW2N = "Non-Hisp./Latino White alone population, 2020"
      MAXNHW2N = "Persons choosing non-Hisp./Latino White alone or in combination with other races, 2020"
      SHRNHB2N = "Total non-Hisp./Latino Black/Afr. Am. population, 2020"
      SHRNHB2 = "Prop. non-Hisp./Latino Black/Afr. Am. population, 2020"
      MINNHB2N = "Non-Hisp./Latino Black/Afr. Am. alone population, 2020"
      MAXNHB2N = "Persons choosing non-Hisp./Latino Black/Afr. Am. alone or in combination with other races, 2020"
      SHRNHI2N = "Total non-Hisp./Latino Am. Indian/AK Native population, 2020"
      SHRNHI2 = "Prop. non-Hisp./Latino Am. Indian/AK Native population, 2020"
      MINNHI2N = "Non-Hisp./Latino Am. Indian/AK Native alone population, 2020"
      MAXNHI2N = "Persons choosing non-Hisp./Latino Am. Indian/AK Native alone or in combination with other races, 2020"
      SHRNHR2N = "Total non-Hisp./Latino Asian population, 2020"
      SHRNHR2 = "Prop. non-Hisp./Latino Asian population, 2020"
      MINNHR2N = "Non-Hisp./Latino Asian alone population, 2020"
      MAXNHR2N = "Persons choosing non-Hisp./Latino Asian alone or in combination with other races, 2020"
      SHRNHH2N = "Total non-Hisp./Latino Native HI and other Pac. Isl. population, 2020"
      SHRNHH2 = "Prop. non-Hisp./Latino Native HI and other Pac. Isl. population, 2020"
      MINNHH2N = "Non-Hisp./Latino Native HI and other Pac. Isl. alone population, 2020"
      MAXNHH2N = "Persons choosing non-Hisp./Latino Native HI and other Pac. Isl. alone or in combination with other races, 2020"
      SHRNHA2N = "Total non-Hisp./Latino Asian, Native HI and other Pac. Isl. population, 2020"
      SHRNHA2 = "Prop. non-Hisp./Latino Asian or Native HI and other Pac. Isl. population, 2020"
      MINNHA2N = "Non-Hisp./Latino Asian, Native HI and other Pac. Isl. alone population, 2020"
      MAXNHA2N = "Persons choosing non-Hisp./Latino Asian, Native HI and other Pac. Isl. alone or in combination with other races, 2020"
      SHRNHO2N = "Total non-Hisp./Latino other race population, 2020"
      SHRNHO2 = "Prop. non-Hisp./Latino other race population, 2020"
      MINNHO2N = "Non-Hisp./Latino other race alone population, 2020"
      MAXNHO2N = "Persons choosing non-Hisp./Latino other race alone or in combination with other races, 2020"
      MRANHS2N = "Non-Hisp./Latino multiracial population, 2020"
      SHRHSP2N = "Total Hisp./Latino population, 2020"
      SHRHSP2 = "Prop. Hisp./Latino population, 2020"
      MRAHSP2N = "Hisp./Latino multiracial population, 2020";

    ** Age counts and proportions **;

    ADULT2N = P0030001;
    CHILD2N = TRCTPOP2 - ADULT2N;

    if TRCTPOP2 > 0 then do;
      ADULT2 = ADULT2N/TRCTPOP2;
      CHILD2 = CHILD2N/TRCTPOP2;
    end;

    label
      ADULT2N = "Adults 18+ years old, 2020"
      ADULT2 = "Prop. of persons who are adults 18+ years old, 2020"
      CHILD2N = "Children under 18 years old, 2020"
      CHILD2 = "Prop. of persons who are children under 18 years old, 2020";

    ** Housing **;

    TOTHSUN2 = H0010001;
    OCCHU2 = H0010002;
    VACHU2 = H0010003;

    label
      TOTHSUN2 = "Total housing units, 2020"
      OCCHU2 = "Total occupied housing units, 2020"
      VACHU2 = "Total vacant housing units, 2020";

%mend NCDB_2020_pl_vars;

/** End Macro Definition **/

