-- classify the aggregated tables
-- class1 is meant to classify into manufacturer pools
-- class2 is meant to classify into cartype groups (SUV, NORMAL, usw)
-- class3 is meant to classify into specific car models

drop table if exists Classified1_debug;

create table "Classified1_debug"
(
    year                              integer,
    Country                           text,
    Mk                                text,
    Cn                                text,
    Ft                                text,
    count                             integer,
    class1                            text,
    class2                            text,
    class3                            text,
    "group_concat(DISTINCT MMS)"      text,
    "group_concat(DISTINCT Mp)"       text,
    "group_concat(DISTINCT Mh)"       text,
    "group_concat(DISTINCT Man)"      text,
    "group_concat(""m (kg)"")"        text,
    "group_concat(""Enedc (g/km)"")"  text,
    "group_concat(""Ewltp (g/km)"")"  text,
    "group_concat(""ec (cm3)"")"      text,
    "group_concat(""ep (KW)"")"       text,
    "group_concat(""Ernedc (g/km)"")" text,
    "group_concat(""Erwltp (g/km)"")" text,
    enedc_avgcount                    integer,
    enedc_avg                         numeric,
    enedc_coverage                    float,
    ep_avgcount                       integer,
    ep_avg                            numeric,
    ep_coverage                       float,
    m_avgcount                        integer,
    m_avg                             numeric,
    m_coverage                        float,
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into Classified1_debug
select year,
       Country,
       Mk,
       Cn,
       Ft,
       count,
       null,
       null,
       null,
       "group_concat(DISTINCT MMS)",
       "group_concat(DISTINCT Mp)",
       "group_concat(DISTINCT Mh)",
       "group_concat(DISTINCT Man)",
       "group_concat(""m (kg)"")",
       "group_concat(""Enedc (g/km)"")",
       "group_concat(""Ewltp (g/km)"")",
       "group_concat(""ec (cm3)"")",
       "group_concat(""ep (KW)"")",
       "group_concat(""Ernedc (g/km)"")",
       "group_concat(""Erwltp (g/km)"")",
       enedc_avgcount,
       enedc_avg,
       enedc_coverage,
       ep_avgcount,
       ep_avg,
       ep_coverage,
       m_avgcount,
       m_avg,
       m_coverage
from Aggregated2_debug;


-----
-- VW Group
-----
-- it is fascinating how many different ways there are to describe the manufacturer... including obvious spelling mistakes like "porche" instead of "porsche"
update Classified1_debug
set class1 = 'VWG'
WHERE Mk LIKE '%Skoda%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Skoda%'
   OR Mk LIKE '%ŠKODA%'
   OR "group_concat(DISTINCT MMS)" LIKE '%ŠKODA%'
   OR Mk LIKE '%KODA%'
   OR "group_concat(DISTINCT MMS)" LIKE '%KODA%'
   OR Mk LIKE '%Porsche%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Porsche%'
   OR Mk LIKE '%Porche%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Porche%'
   OR Mk LIKE '%Porshce%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Porshce%'
   OR Mk LIKE '%Audi%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Audi%'
   OR Mk LIKE '%A.U.D.I.%'
   OR "group_concat(DISTINCT MMS)" LIKE '%A.U.D.I.%'
   OR Mk LIKE '%Seat%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Seat%'
   OR Mk LIKE '%Jetta%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Jetta%'
   OR Mk LIKE '%Bentley%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Bentley%'
   OR Mk LIKE '%Lamborghini%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Lamborghini%'
   OR Mk LIKE '%QUATTRO%'
   OR "group_concat(DISTINCT MMS)" LIKE '%QUATTRO%'
   OR Mk LIKE '%VW%'
   OR Mk LIKE '%Volkswagen%'
   OR "group_concat(DISTINCT MMS)" LIKE '%Volkswagen%';

update Classified1_debug
set class2 = 'SUV'
WHERE (Cn LIKE '%Tiguan%' OR
       Cn LIKE '%Touareg%' OR
       Cn LIKE '%Atlas%' OR
       Cn LIKE '%T-Cross%' OR
       Cn LIKE '%TCROSS%' OR
       Cn LIKE '%T-Roc%' OR
       Cn LIKE '%TROC%' OR
       Cn LIKE '%Tharu%' OR
       Cn LIKE '%Tarek%' OR
       Cn LIKE '%VS5%' OR
       Cn LIKE '%VS7%' OR
       Cn LIKE '%Q2%' OR
       Cn LIKE '%Q3%' OR
       Cn LIKE '%Q4%' OR
       Cn LIKE '%Q5%' OR
       Cn LIKE '%Q7%' OR
       Cn LIKE '%Q8%' OR
       Cn LIKE '%Arona%' OR
       Cn LIKE '%Ateca%' OR
       Cn LIKE '%Tarraco%' OR
       Cn LIKE '%Kamiq%' OR
       Cn LIKE '%Karoq%' OR
       Cn LIKE '%Kodiaq%' OR
       Cn LIKE '%Bentayga%' OR
       Cn LIKE '%Urus%' OR
       Cn LIKE '%Cayenne%' OR
       Cn LIKE '%Macan%')
  and class1 is 'VWG';

-- model groups
update Classified1_debug
set class3 = 'Tiguan'
where Cn LIKE '%Tiguan%'
  and Cn not like '%space%'
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Touareg'
where (Cn LIKE '%Touareg%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Atlas'
where (Cn LIKE '%Atlas%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'T-Cross'
where (Cn LIKE '%T-Cross%' OR Cn like '%TCROSS%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'T-Roc'
where (Cn LIKE '%T-Roc%' OR Cn like '%TROC%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Tharu'
where (Cn LIKE '%Tharu%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Tarek'
where (Cn LIKE '%Tarek%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'VS5'
where (Cn LIKE '%VS5%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'VS57'
where (Cn LIKE '%VS7%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Q2'
where (Cn LIKE '%Q2%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Q3'
where (Cn LIKE '%Q3%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Q5'
where (Cn LIKE '%Q5%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Q7'
where (Cn LIKE '%Q7%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Q8'
where (Cn LIKE '%Q8%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Arona'
where (Cn LIKE '%Arona%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Ateca'
where (Cn LIKE '%Ateca%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Tarraco'
where (Cn LIKE '%Tarraco%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Kamiq'
where (Cn LIKE '%Kamiq%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Karoq'
where (Cn LIKE '%Karoq%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Kodiaq'
where (Cn LIKE '%Kodiaq%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Bentayga'
where (Cn LIKE '%Bentayga%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Urus'
where (Cn LIKE '%Urus%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Cayenne'
where (Cn LIKE '%Cayenne%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Macan'
where (Cn LIKE '%Macan%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Golf'
where (Cn LIKE '%Golf%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Polo'
where (Cn LIKE '%Polo%')
  and class1 is 'VWG';

update Classified1_debug
set class3 = 'Audi A3,S3,RS3'
where class1 = 'VWG'
  and class2 is null
  and (Cn LIKE '%A3%' OR
       Cn LIKE '%S3%')
and Cn not like '%Jetta%'
and Cn not like '%911TA%';

-----
-- Mercedes Group
-----
update Classified1_debug
set class1 = 'Daimler'
WHERE (Mk LIKE '%Daimler%' OR "group_concat(DISTINCT MMS)" LIKE '%Daimler%' OR
       Mk LIKE '%Mercedes%' OR "group_concat(DISTINCT MMS)" LIKE '%Mercedes%' OR
       Mk LIKE '%Smart%' OR "group_concat(DISTINCT MMS)" LIKE '%Smart%')
  and class1 is null;

-- SUV, first group https://de.wikipedia.org/wiki/Mercedes-Benz-Pkw#Gel%C3%A4ndewagen/SUV/Pick-ups
update Classified1_debug
set class2 = 'SUV'
where (Cn LIKE '%GLA%' OR
       Cn LIKE '%GLB%' OR
       Cn LIKE '%GLC%' OR
       Cn LIKE '%GLE%' OR
       Cn LIKE '%GLS%' OR
       Cn LIKE '%GLK%')
  and class1 is 'Daimler'
  and class2 is not 'SUV';

-- SUV, second group, G Class https://de.wikipedia.org/wiki/Mercedes-Benz_G-Klasse
update Classified1_debug
set class2 = 'SUV'
where (Cn LIKE '%230 G%' OR
       Cn LIKE '%290 G%' OR
       Cn LIKE '%230G%' OR
       Cn LIKE '%290G%' OR
       Cn LIKE '%250G%' OR
       Cn LIKE '%250 G%' OR
       Cn LIKE '%300 G%' OR
       Cn LIKE '%300G%' OR
       Cn LIKE '%G2%' OR
       Cn LIKE '%G 2%' OR
       Cn LIKE '%G3%' OR
       Cn LIKE '%G 3%' OR
       Cn LIKE '%G400%' OR
       Cn LIKE '%G 400%' OR
       Cn LIKE '%G5%' OR
       Cn LIKE '%G 5%' OR
       Cn LIKE '%G6%' OR
       Cn LIKE '%G 6%' OR
       Cn LIKE '%200 G%' OR
       Cn LIKE '%200G%' OR
       Cn LIKE '%500 G%' OR
       Cn LIKE '%500G%')
  and class1 is 'Daimler'
  and class2 is not 'SUV'
  and Cn not like 'E 220%'
  and Cn not like 'SL63%'
  and Cn not like 'SL 500%'
  and Cn not like 'A 45%'
  and Cn not like 'A45%';

-- SUV, third group https://de.wikipedia.org/wiki/Mercedes-Benz_Baureihe_470 & https://de.wikipedia.org/wiki/Mercedes-Benz_GL & https://de.wikipedia.org/wiki/Mercedes-Benz_M-Klasse

update Classified1_debug
set class2 = 'SUV'
where (Cn LIKE '%X250%' OR
       Cn LIKE '%GL350%' OR
       Cn LIKE '%GL 350%' OR
       Cn LIKE '%GL63%' OR
       Cn LIKE '%GL 63%' OR
       Cn LIKE '%GL450%' OR
       Cn LIKE '%GL 450%' OR
       Cn LIKE '%GL500%' OR
       Cn LIKE '%GL 500%' OR
       Cn LIKE '%GL 500%' OR
       Cn LIKE '%ML 3%' OR
       Cn LIKE '%ML3%' OR
       Cn LIKE '%ML4%' OR
       Cn LIKE '%ML 4%' OR
       Cn LIKE '%ML5%' OR
       Cn LIKE '%ML 5%' OR
       Cn LIKE '%ML25%' OR
       Cn LIKE '%ML 25%' OR
       Cn LIKE '%ML63%' OR
       Cn LIKE '%ML 63%' OR
       Cn LIKE '%ML28%' OR
       Cn LIKE '%ML 28%' OR
       Cn LIKE '%X 16%')
  and class1 is 'Daimler'
  and class2 is not 'SUV';

-- model groups
update Classified1_debug
set class3 = 'GLS', class2 = 'SUV'
where class1 = 'Daimler'
  and (Cn LIKE '%GLS%' OR
       Cn LIKE '%GL3%' OR
       Cn LIKE '%GL 3%' OR
       Cn LIKE '%GL4%' OR
       Cn LIKE '%GL 4%' OR
       Cn LIKE '%GL5%' OR
       Cn LIKE '%GL 5%' OR
       Cn LIKE '%GL63%' OR
       Cn LIKE '%GL 63%');

update Classified1_debug
set class3 = 'S-Klasse'
where class1 = 'Daimler'
  and class2 is null
  and (Cn LIKE '%S2_0%' OR
       Cn LIKE '%S 2_0%' OR
       Cn LIKE '%S3_0%' OR
       Cn LIKE '%S 3_0%' OR
       Cn LIKE '%S4_0%' OR
       Cn LIKE '%S 4_0%' OR
       Cn LIKE '%S5_0%' OR
       Cn LIKE '%S 5_0%' OR
       Cn LIKE '%S6_0%' OR
       Cn LIKE '%S 6_0%' OR
       Cn LIKE '%S63%' OR
       Cn LIKE '%S 63%' OR
       Cn LIKE '%S65%' OR
       Cn LIKE '%S 65%' OR
       Cn LIKE '%CL500%' OR
       Cn LIKE '%CL 500%' OR
       Cn LIKE '%CL600%' OR
       Cn LIKE '%CL 600%' OR
       Cn LIKE '%Maybach 57%' OR
       Cn LIKE '%Maybach57%' OR
       Cn LIKE '%Maybach 62%' OR
       Cn LIKE '%Maybach62%' OR
       Cn LIKE '%CL63%' OR
       Cn LIKE '%CL 63%' OR
       Cn LIKE '%CL65%' OR
       Cn LIKE '%CL 65%');

update Classified1_debug
set class3 = 'C-Klasse'
where class1 = 'Daimler'
  and class2 is null
  and (Cn LIKE '%C160%' OR
       Cn LIKE '%C 160%' OR
       Cn LIKE '%C 180%' OR
       Cn LIKE '%C180%' OR
       Cn LIKE '%C 200%' OR
       Cn LIKE '%C200%' OR
       Cn LIKE '%C 220%' OR
       Cn LIKE '%C220%' OR
       Cn LIKE '%C 230%' OR
       Cn LIKE '%C230%' OR
       Cn LIKE '%C 250%' OR
       Cn LIKE '%C250%' OR
       Cn LIKE '%C 280%' OR
       Cn LIKE '%C280%' OR
       Cn LIKE '%C 300%' OR
       Cn LIKE '%C300%' OR
       Cn LIKE '%C 320%' OR
       Cn LIKE '%C320%' OR
       Cn LIKE '%C 350%' OR
       Cn LIKE '%C350%' OR
       Cn LIKE '%C 400%' OR
       Cn LIKE '%C400%' OR
       Cn LIKE '%C 450%' OR
       Cn LIKE '%C450%' OR
       Cn LIKE '%C 43%' OR
       Cn LIKE '%C43%' OR
       Cn LIKE '%C 63%' OR
       Cn LIKE '%C63%')
  and Cn not like '%SLC%'
  and Cn not like '%CLC%';

-----
-- BMW Group
-----
update Classified1_debug
set class1 = 'BMW'
WHERE (Mk LIKE '%BMW%' OR "group_concat(DISTINCT MMS)" LIKE '%BMW%' OR
       Mk LIKE '%Mini%' OR "group_concat(DISTINCT MMS)" LIKE '%Mini%')
  and class1 is null;

-- SUV https://de.wikipedia.org/wiki/BMW#Zeitleiste_der_Nachkriegsmodelle
update Classified1_debug
set class2 = 'SUV'
where (Cn LIKE '%X1%' OR
       Cn LIKE '%X2%' OR
       Cn LIKE '%X3%' OR
       Cn LIKE '%X4%' OR
       Cn LIKE '%X5%' OR
       Cn LIKE '%X6%' OR
       Cn LIKE '%X7%' OR
       Cn LIKE '%X 1%' OR
       Cn LIKE '%X 2%' OR
       Cn LIKE '%X 3%' OR
       Cn LIKE '%X 4%' OR
       Cn LIKE '%X 5%' OR
       Cn LIKE '%X 6%' OR
       Cn LIKE '%X 7%' OR
       Cn LIKE '%country%')
  and Cn not like 'SPX%'
  and class1 is 'BMW'
  and class2 is not 'SUV';

-- model groups
-- https://de.wikipedia.org/wiki/BMW_2er
update Classified1_debug
set class3 = '2er'
where class1 = 'BMW'
  and class2 is null
  and (Cn LIKE '%2er%' OR
       Cn LIKE '%F22%' OR
       Cn LIKE '%F23%' OR
       Cn LIKE '%F44%' OR
       Cn LIKE '%F45%' OR
       Cn LIKE '%F46%' OR
       Cn LIKE '%F87%' OR
       Cn LIKE '%21_i%' OR
       Cn LIKE '%22_i%' OR
       Cn LIKE '%23_i%' OR
       Cn LIKE '%225x%' OR
       Cn LIKE '%21_d%' OR
       Cn LIKE '%220d%' OR
       Cn LIKE '%M2%' OR
       Cn LIKE '%M23%' OR
       Cn LIKE '%F23%')
  and Mk not like '%Mini%';

-- https://de.wikipedia.org/wiki/BMW_1er
update Classified1_debug
set class3 = '1er'
where class1 = 'BMW'
  and class2 is null
  and class3 is null
  and (Cn LIKE '%1er%' OR
       Cn LIKE '%F20%' OR
       Cn LIKE '%F40%' OR
       Cn LIKE '%F52%' OR
       Cn LIKE '%1__i%' OR
       Cn LIKE '%1__d%' OR
       Cn LIKE '%MCoup%' OR
       Cn LIKE '%M Coup%' OR
       Cn LIKE '%E87%')
  and Mk not like '%Mini%';

update Classified1_debug
set class3 = 'X1'
where class1 = 'BMW'
  and class2 is 'SUV'
  and (Cn LIKE '%X1%' OR
       Cn LIKE '%X 1%')
  and Mk not like '%Mini%';

update Classified1_debug
set class3 = 'X2'
where class1 = 'BMW'
  and class2 is 'SUV'
  and (Cn LIKE '%X2%' OR
       Cn LIKE '%X 2%')
  and Mk not like '%Mini%';

update Classified1_debug
set class3 = 'X5'
where class1 = 'BMW'
  and class2 is 'SUV'
  and (Cn LIKE '%X5%' OR
       Cn LIKE '%X 5%')
  and Mk not like '%Mini%';

update Classified1_debug
set class3 = '5er'
where class1 = 'BMW'
  and class2 is null
  and (Cn LIKE '%E60%' OR
       Cn LIKE '%G30%' OR
       Cn LIKE '%G30%' OR
       Cn LIKE '%52_i%' OR
       Cn LIKE '%52_d%' OR
       Cn LIKE '%53_i%' OR
       Cn LIKE '%53_d%' OR
       Cn LIKE '%54_i%' OR
       Cn LIKE '%54_d%' OR
       Cn LIKE '%55_i%' OR
       Cn LIKE '%55_d%' OR
       Cn LIKE '%M5%' OR
       Cn LIKE '%F10%')
  and Mk not like '%Mini%';

----
-- classified 1 without debug columns
----
drop table if exists Classified1;
create table "Classified1"
(
    year           integer,
    Country        text,
    Mk             text,
    Cn             text,
    Ft             text,
    count          integer,
    class1         text,
    class2         text,
    class3         text,
    enedc_avgcount integer,
    enedc_avg      numeric,
    enedc_coverage float,
    ep_avgcount    integer,
    ep_avg         numeric,
    ep_coverage    float,
    m_avgcount     integer,
    m_avg          numeric,
    m_coverage     float,
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into Classified1
select year,
       Country,
       Mk,
       Cn,
       Ft,
       count,
       class1,
       class2,
       class3,
       enedc_avgcount,
       enedc_avg,
       enedc_coverage,
       ep_avgcount,
       ep_avg,
       ep_coverage,
       m_avgcount,
       m_avg,
       m_coverage
from Classified1_debug;


