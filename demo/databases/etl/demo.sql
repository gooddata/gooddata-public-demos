----------------------------
-- Populate GEO location of US state as label to customers table
----------------------------

alter table "customers" add "geo__state__location" varchar(64)
;

UPDATE "customers" c
SET "geo__state__location" = cg."usa_state_latitude" || ';' || cg."usa_state_longitude",
    "state" = cg."usa_state"
    FROM "usa_states" cg
WHERE lower(c."state") = lower(cg."usa_state_code")
;

----------------------------
-- Update state with long name
----------------------------

update "customers" set "state" = x."usa_state"
    from "usa_states" x
where lower("state") = lower(x."usa_state_code")
;

------------------------------------------------------------------------------------
-- Propagate region and state into all tables, they are used as Workspace Data Filters
-- Use prefix wdf__, so no labels are generated for these denormalized columns
------------------------------------------------------------------------------------
alter table "order_lines" add "wdf__state" varchar(64)
;
alter table "order_lines" add "wdf__region" varchar(128)
;

update "order_lines" ol set "wdf__region" = c."region", "wdf__state" = c."state"
from "customers" c
where ol."customer_id" = c."customer_id"
;

----------------------------
-- Shift date so it covers actual year, so filters like "This month" show any data
-- To do not have to implement various version for various databases, we shift by 365 days.
-- Equijoin required by Redshift
----------------------------
update "order_lines" set "date" = "date" + cast(dateshift as int)
from (
  -- Calculate the diff between max(date) in data vs. actual year.
  -- Create string 'X year', which can be CASTed to interval and used for the shift
  select (date_part('year', current_date) - date_part('year', max("date") over ())) * 365  as dateshift,
    "order_line_id" as "update_order_line"
  from "order_lines"
) d
where "update_order_line" = "order_line_id"
;

----------------------------
-- Drop helping tables, we do not want to expose it to users
----------------------------
drop table "countries_geo_coordinates"
;

drop table "countries"
;

drop table "out_demo__countries"
;

drop table "usa_states"
;
