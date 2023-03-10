create table "temperature"
(
    "date" date,
    "temp" decimal(12, 2)
)
;

create table "storage"
(
    "date"               date,
    "status"             varchar(128),
    "filled_gas"         decimal(12, 2),
    "gas_in_storage_twh" numeric(128),
    "injection_gwh"      numeric(128),
    "withdrawal_gwh"     numeric(128)
)
;
