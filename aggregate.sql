-- aggregation script, rerun if table "all" is updated
-- "all" should be filled with all datasets, missing columns in older datasets should be null, column "year" according to dataset year
drop table if exists Aggregated1_debug;
drop table if exists Aggregated2_debug;
drop table if exists Aggregated2;
drop table if exists Aggregated3;
drop table if exists avg_m;
drop table if exists avg_ep;
drop table if exists avg_enedc;

-- debugging table with a lot of group concats
create table "Aggregated1_debug"
(
    year                              integer,
    Country                           text,
    Mk                                text,
    Cn                                text,
    Ft                                text,
    count                             integer,
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
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into main."Aggregated1_debug"
SELECT year,
       Country,
       Mk,
       Cn,
       Ft,
       SUM(r) as 'count',
       group_concat(DISTINCT MMS),
       group_concat(DISTINCT Mp),
       group_concat(DISTINCT Mh),
       group_concat(DISTINCT Man),
       group_concat("m (kg)"),
       group_concat("Enedc (g/km)"),
       group_concat("Ewltp (g/km)"),
       group_concat("ec (cm3)"),
       group_concat("ep (KW)"),
       group_concat("Ernedc (g/km)"),
       group_concat("Erwltp (g/km)")
from 'all'
where true
group by year, Mk, Cn, Ft, Country
order by year asc, count desc;

Update Aggregated1_debug
set Mk = '°°'
WHERE Mk is null;
Update Aggregated1_debug
set Cn = '°°'
WHERE Cn is null;
Update Aggregated1_debug
set Ft = '°°'
WHERE Ft is null;

create table "avg_enedc"
(
    year           integer,
    Country        text,
    Mk             text,
    Cn             text,
    Ft             text,
    enedc_avgcount integer,
    enedc_avg      numeric,
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into main."avg_enedc"
SELECT year,
       Country,
       Mk,
       Cn,
       Ft,
       SUM(r)                                         as 'enedc_avgcount',
       cast(SUM("Enedc (g/km)" * r) as real) / SUM(r) as enedc_avg
from 'all'
WHERE "Enedc (g/km)" IS NOT NULL
group by year, Mk, Cn, Ft, Country
order by year asc, enedc_avgcount desc;

Update avg_enedc
set Mk = '°°'
WHERE Mk is null;
Update avg_enedc
set Cn = '°°'
WHERE Cn is null;
Update avg_enedc
set Ft = '°°'
WHERE Ft is null;


create table "avg_ep"
(
    year        integer,
    Country     text,
    Mk          text,
    Cn          text,
    Ft          text,
    ep_avgcount integer,
    ep_avg      numeric,
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into main."avg_ep"
SELECT year, Country, Mk, Cn, Ft, SUM(r) as 'ep_avgcount', cast(SUM("ep (KW)" * r) as real) / SUM(r) as ep_avg
from 'all'
WHERE "ep (KW)" IS NOT NULL
group by year, Mk, Cn, Ft, Country
order by year asc, ep_avgcount desc;

Update avg_ep
set Mk = '°°'
WHERE Mk is null;
Update avg_ep
set Cn = '°°'
WHERE Cn is null;
Update avg_ep
set Ft = '°°'
WHERE Ft is null;


create table "avg_m"
(
    year       integer,
    Country    text,
    Mk         text,
    Cn         text,
    Ft         text,
    m_avgcount integer,
    m_avg      numeric,
    PRIMARY KEY (year, Country, Mk, Cn, Ft)
);

insert into main."avg_m"
SELECT year, Country, Mk, Cn, Ft, SUM(r) as 'm_avgcount', cast(SUM("m (kg)" * r) as real) / SUM(r) as m_avg
from 'all'
WHERE "m (kg)" IS NOT NULL
group by year, Mk, Cn, Ft, Country
order by year asc, m_avgcount desc;

Update avg_m
set Mk = '°°'
WHERE Mk is null;
Update avg_m
set Cn = '°°'
WHERE Cn is null;
Update avg_m
set Ft = '°°'
WHERE Ft is null;

create table "Aggregated2_debug"
(
    year                              integer,
    Country                           text,
    Mk                                text,
    Cn                                text,
    Ft                                text,
    count                             integer,
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

insert into Aggregated2_debug
select *, cast(m_avgcount as real) / cast(count as real) as m_coverage
from (
         select *, cast(ep_avgcount as real) / cast(count as real) as ep_coverage
         from (
                  select *, cast(enedc_avgcount as real) / cast(count as real) as enedc_coverage
                  from Aggregated1_debug
                           left join avg_enedc USING (year, Country, Mk, Cn, Ft)
              )
                  left join avg_ep USING (year, Country, Mk, Cn, Ft)
     )
         left join avg_m USING (year, Country, Mk, Cn, Ft);


create table "Aggregated2"
(
    year           integer,
    Country        text,
    Mk             text,
    Cn             text,
    Ft             text,
    count          integer,
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

insert into Aggregated2
select year,
       Country,
       Mk,
       Cn,
       Ft,
       count,
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

