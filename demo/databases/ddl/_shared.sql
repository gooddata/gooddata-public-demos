create table "countries" (
    "country"               varchar(128),
    "region"                varchar(128),
    "population"            bigint,
    "area"                  bigint,
    "pop_density"           float,
    "coast_line"            float,
    "net_migration"         float,
    "infant_mortality"      float,
    "gdp"                   bigint,
    "literacy"              float,
    "phones_per_1k"         float,
    "arable"                float,
    "crops"                 float,
    "other"                 float,
    "climate"               float,
    "birth_rate"            float,
    "death_rate"            float,
    "agriculture"           float,
    "industry"              float,
    "service"               float
)
;

create table "countries_geo_coordinates"(
    "code" VARCHAR(2),
    "latitude" float,
    "longitude" float,
    "name" varchar(128),
    "usa_state_code" VARCHAR(2),
    "usa_state_latitude" float,
    "usa_state_longitude" float,
    "usa_state" varchar(128)
)
;
