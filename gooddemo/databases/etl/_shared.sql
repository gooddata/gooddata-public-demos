
create table "{workspace_prefix}countries" as
select
    trim("region") as "region", trim("continent") as "continent",
    trim("country") as "gr__country",
    "population" as "f__population", "death_rate" * "population" / 1000 as "deaths",
    "pop_density", "gdp"::float as "gdp", "phones_per_1k", "death_rate",
    cg."latitude" || ';' || cg."longitude"  as "geo__country__location"
from (
    select
        ccc.*,
        case when trim("region") in ('EASTERN EUROPE', 'WESTERN EUROPE', 'BALTICS', 'C.W. OF IND. STATES') then 'EUROPE'
        when trim("region") in ('SUB-SAHARAN AFRICA', 'NORTHERN AFRICA') then 'AFRICA'
        when trim("region") in ('ASIA (EX. NEAR EAST)', 'NEAR EAST') then 'ASIA'
        else "region"
        end as "continent"
    from "countries" ccc
) x
join "countries_geo_coordinates" cg
    on lower(cg."name") = lower(trim(x."country"))
;
-- TODO - there are 24 countries filtered out by the INNER JOIN
--      - usually small countries like islands or uncertain countries like Macedonia

create table "usa_states" as
select "usa_state_code", "usa_state_latitude", "usa_state_longitude", "usa_state"
from "countries_geo_coordinates"
where "usa_state_code" is not null
;
-- TODO - use {workspace_prefix} and integrate it e.g. into COVID workspace
