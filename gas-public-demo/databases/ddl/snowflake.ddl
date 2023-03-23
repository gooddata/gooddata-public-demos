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
    "gas_in_storage_twh" decimal(12, 2),
    "injection_gwh"      decimal(12, 2),
    "withdrawal_gwh"     decimal(12, 2)
)
;
