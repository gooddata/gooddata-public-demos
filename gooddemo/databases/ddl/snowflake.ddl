create table "products"
(
    "product_id"   integer,
    "product_name" varchar(128),
    "category"     varchar(128),
    constraint pk_products primary key ("product_id")
)
;

create table "campaigns"
(
    "campaign_id"   integer,
    "campaign_name" varchar(128),
    constraint pk_campaigns primary key ("campaign_id")
)
;

create table "customers"
(
    "customer_id"   integer,
    "customer_name" varchar(128),
    "state"         varchar(64),
    "region"        varchar(64),
    "geo__state__location" varchar(64),
    constraint pk_customers primary key ("customer_id")
)
;

create table "campaign_channels"
(
    "campaign_channel_id" varchar(128),
    "category"            varchar(128),
    "type"                varchar(128),
    "budget"              decimal(15, 2),
    "spend"               decimal(15, 2),
    "campaign_id"         integer,
    constraint pk_campaign_channels primary key ("campaign_channel_id"),
    constraint fk_campaign_channels_campaign foreign key ("campaign_id") references "campaigns" ("campaign_id")
)
;

create table "order_lines"
(
    "order_line_id" varchar(128),
    "order_id"      varchar(128),
    "order_status"  varchar(128),
    "date"          date,
    "campaign_id"   integer,
    "customer_id"   integer,
    "product_id"    integer,
    "price"         decimal(15, 2),
    "quantity"      decimal(15, 2),
    "wdf__state"    varchar(64),
    "wdf__region"   varchar(128),
    constraint pk_order_lines primary key ("order_line_id"),
    constraint fk_order_lines_campaign foreign key ("campaign_id") references "campaigns" ("campaign_id"),
    constraint fk_customer foreign key ("customer_id") references "customers" ("customer_id"),
    constraint fk_product foreign key ("product_id") references "products" ("product_id")
)
;
