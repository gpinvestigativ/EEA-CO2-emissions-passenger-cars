----
-- Group analysis
----

-- 3.1 Stückzahlen
-- 3.1.1 Anzahl aller Neuzulassungen
select year, class1, sum(count) as count_group
from Classified1
group by year, class1;

-- 3.1.2 Anzahl Group Neuzulassungen SUV vs. Normal
select *
from (select *
      from (select year, class1, sum(count) as count_suv
            from Classified1
            where class1 is not null
              and class2 = 'SUV'
            group by year, class1)
               left join (select year, class1, sum(count) as count_nosuv
                          from Classified1
                          where class1 is not null
                            and class2 is null
                          group by year, class1)
                         using (year, class1))
         left join (select year, class1, sum(count) as count_group_all
                    from Classified1
                    where class1 is not null
                    group by year, class1)
                   using (year, class1);


-- 3.1.3 Anzahl aller VW Group SUV Neuzulassungen nach Fahrzeug
select sum(count) as count_all, class3, year
from Classified1
where class1 = 'VWG'
  and class3 not null
group by class3, year;

SELECT class3
     , SUM(count_all) FILTER (WHERE year =  2012) '2012'
     , SUM(count_all) FILTER (WHERE year =  2013) '2013'
     , SUM(count_all) FILTER (WHERE year =  2014) '2014'
     , SUM(count_all) FILTER (WHERE year =  2015) '2015'
     , SUM(count_all) FILTER (WHERE year =  2016) '2016'
     , SUM(count_all) FILTER (WHERE year =  2017) '2017'
     , SUM(count_all) FILTER (WHERE year =  2018) '2018'
     , SUM(count_all) FILTER (WHERE year =  2019) '2019'
FROM (select sum(count) as count_all, class3, year
      from Classified1
      where class1 = 'VWG'
        and class3 not null
      group by class3, year) cars
GROUP BY class3;

-- 3.1.4 Modellvergleiche
-- 3.1.4.1 VW Polo / VW T-Cross (Kleinwagen / Mini-SUV)
select *
from (select year, sum(count) as 'Polo'
      from Classified1
      where class3 = 'Polo'
      group by year)
         left join
     (select year, sum(count) as 'T-Cross' from Classified1 where class3 = 'T-Cross' group by year) using (year);

-- 3.1.4.2 VW Golf / VW T-Roc + VW Tiguan (Kompaktklasse / Kompakt-SUV; Tiguan ohne Allspace, Golf alle Varianten (Variant, Sportsvan))
select *
from (select year, sum(count) as 'Golf'
      from Classified1
      where class3 = 'Golf'
      group by year)
         left join
     (select year, sum(count) as 'Tiguan' from Classified1 where class3 = 'Tiguan' or class3 = 'T-Roc' group by year) using (year);

-- 3.1.4.3 BMW 1er + 2er / BMW X1 + X2 (Kompaktklasse + Kompaktvan / Kompakt-SUV; 2er alle Varianten (Active Tourer, Gran Tourer, Coupé, Gran Coupé)
select *
from (select year, sum(count) as 'X1 & X2'
      from Classified1
      where class3 = 'X1'
         or class3 = 'X2'
      group by year)
         left join
     (select year, sum(count) as '1er & 2er' from Classified1 where class3 = '1er' or class3 = '2er' group by year) using (year);

-- 3.1.4.4 BMW 5er / BMW X5 (Obere Mittelklasse / Obere Mittelklasse-SUV)
select *
from (select year, sum(count) as 'X5'
      from Classified1
      where class3 = 'X5'
      group by year)
         left join
     (select year, sum(count) as '5er' from Classified1 where class3 = '5er' group by year) using (year);

-- 3.1.4.5 Mercedes C-Klasse / Mercedes GLC (Mittelklasse, Mittelklasse-SUV; jeweils alle Varianten inkl. Coupés; GLC vorher GLK)
select *
from (select year, sum(count) as 'GLC & GLK'
      from Classified1
      where class1 = 'Daimler'
        and class2 is 'SUV'
        and (Cn LIKE '%GLC%' OR
             Cn LIKE '%GLK%')
      group by year)
         left join
     (select year, sum(count) as 'C-Klasse' from Classified1 where class3 = 'C-Klasse' group by year) using (year);

-- 3.1.4.6 Mercedes S-Klasse / Mercedes GLS (Oberklasse / Oberklasse-SUV; GLS vorher GL)
select *
from (select year, sum(count) as 'GLS'
      from Classified1
      where class1 = 'Daimler'
        and class2 is 'SUV'
        and class3 is 'GLS'
      group by year)
         left join
     (select year, sum(count) as 'S-Klasse' from Classified1 where class3 = 'S-Klasse' group by year) using (year);

-- 3.1.4.7 Audi A3, S3, RS3 / Audi Q2, SQ2, Q3, SQ3, RS Q3 (Kompaktklasse / Kompakt-SUV)
select *
from (select year, sum(count) as 'Audi A3, S3, RS3'
      from Classified1
      where class1 = 'VWG'
        and class2 is null
        and class3 is 'Audi A3,S3,RS3'
      group by year)
         left join
     (select year, sum(count) as 'Audi Q2, SQ2, Q3, SQ3, RS Q3' from Classified1 where class1='VWG' and class2 is 'SUV' and (Cn LIKE '%Q2%' OR
       Cn LIKE '%Q3%') group by year) using (year);

-- 3.2 Gewicht
-- 3.2.1 Durchschnittsgewicht Group SUV vs. Normal

select year, class1, m_group_avg_sum, m_nosuv_avg_sum, m_suv_avg_sum
from (select *
      from (select year,
                   class1,
                   sum(count)                                         as count_suv,
                   cast(SUM(m_coverage * count) as real) / SUM(count) as m_suv_avg_coverage,
                   cast(SUM(m_avg * count) as real) / SUM(count)      as m_suv_avg_sum
            from Classified1
            where class1 is not null
              and class2 = 'SUV'
            group by year, class1)
               left join (select year,
                                 class1,
                                 sum(count)                                         as count_nosuv,
                                 cast(SUM(m_coverage * count) as real) / SUM(count) as m_nosuv_avg_coverage,
                                 cast(SUM(m_avg * count) as real) / SUM(count)      as m_nosuv_avg_sum
                          from Classified1
                          where class1 is not null
                            and class2 is null
                          group by year, class1)
                         using (year, class1))
         left join (select year,
                           class1,
                           sum(count)                                         as count_all,
                           cast(SUM(m_coverage * count) as real) / SUM(count) as m_group_avg_coverage,
                           cast(SUM(m_avg * count) as real) / SUM(count)      as m_group_avg_sum
                    from Classified1
                    where class1 is not null
                    group by year, class1)
                   using (year, class1);

-- 3.2.2 Gewichtsentwicklung einzelner Fahrzeugtypen VW SUV - gestrichen

-- 3.3 Emissionen
-- 3.3.2 ø CO2 Gruppe Alle vs. SUV vs. Normal

select year, class1, enedc_all_avg_sum, enedc_nosuv_avg_sum, enedc_suv_avg_sum
from (select *
      from (select year,
                   class1,
                   sum(count)                                             as count_suv,
                   cast(SUM(enedc_coverage * count) as real) / SUM(count) as enedc_suv_avg_coverage,
                   cast(SUM(enedc_avg * count) as real) / SUM(count)      as enedc_suv_avg_sum
            from Classified1
            where class1 is not null
              and class2 = 'SUV'
            group by year, class1)
               left join (select year,
                                 class1,
                                 sum(count)                                             as count_nosuv,
                                 cast(SUM(enedc_coverage * count) as real) / SUM(count) as enedc_nosuv_avg_coverage,
                                 cast(SUM(enedc_avg * count) as real) / SUM(count)      as enedc_nosuv_avg_sum
                          from Classified1
                          where class1 is not null
                            and class2 is null
                          group by year, class1)
                         using (year, class1))
         left join (select year,
                           class1,
                           sum(count)                                             as count_all,
                           cast(SUM(enedc_coverage * count) as real) / SUM(count) as enedc_all_avg_coverage,
                           cast(SUM(enedc_avg * count) as real) / SUM(count)      as enedc_all_avg_sum
                    from Classified1
                    where class1 is not null
                    group by year, class1)
                   using (year, class1);

-- 3.4 Motorleistung
-- 3.4.1 ø Motorleistung VW Gruppe Alle vs. SUV vs. Normal

select year, class1, ep_all_avg_sum, ep_nosuv_avg_sum, ep_suv_avg_sum
from (select *
      from (select year,
                   class1,
                   sum(count)                                          as count_suv,
                   cast(SUM(ep_coverage * count) as real) / SUM(count) as ep_suv_avg_coverage,
                   cast(SUM(ep_avg * count) as real) / SUM(count)      as ep_suv_avg_sum
            from Classified1
            where class1 is not null
              and class2 = 'SUV'
            group by year, class1)
               left join (select year,
                                 class1,
                                 sum(count)                                          as count_nosuv,
                                 cast(SUM(ep_coverage * count) as real) / SUM(count) as ep_nosuv_avg_coverage,
                                 cast(SUM(ep_avg * count) as real) / SUM(count)      as ep_nosuv_avg_sum
                          from Classified1
                          where class1 is not null
                            and class2 is null
                          group by year, class1)
                         using (year, class1))
         left join (select year,
                           class1,
                           sum(count)                                          as count_all,
                           cast(SUM(ep_coverage * count) as real) / SUM(count) as ep_all_avg_coverage,
                           cast(SUM(ep_avg * count) as real) / SUM(count)      as ep_all_avg_sum
                    from Classified1
                    where class1 is not null
                    group by year, class1)
                   using (year, class1);