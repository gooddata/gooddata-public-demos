create table "products"
(
    "product_id"   integer,
    "product_name" varchar(128),
    "category"     varchar(128),
    constraint pk_products primary key ("product_id")
);

create table "campaigns"
(
    "campaign_id"   integer,
    "campaign_name" varchar(128),
    constraint pk_campaigns primary key ("campaign_id")
);

create table "customers"
(
    "customer_id"   integer,
    "customer_name" varchar(128),
    "state"         varchar(64),
    "region"        varchar(64),
    constraint pk_customers primary key ("customer_id")
);

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
);

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
    constraint pk_order_lines primary key ("order_line_id"),
    constraint fk_order_lines_campaign foreign key ("campaign_id") references "campaigns" ("campaign_id"),
    constraint fk_customer foreign key ("customer_id") references "customers" ("customer_id"),
    constraint fk_product foreign key ("product_id") references "products" ("product_id")
);

create table "countries"
(
    "country"          varchar(128),
    "region"           varchar(128),
    "population"       bigint,
    "area"             bigint,
    "pop_density"      float,
    "coast_line"       float,
    "net_migration"    float,
    "infant_mortality" float,
    "gdp"              bigint,
    "literacy"         float,
    "phones_per_1k"    float,
    "arable"           float,
    "crops"            float,
    "other"            float,
    "climate"          float,
    "birth_rate"       float,
    "death_rate"       float,
    "agriculture"      float,
    "industry"         float,
    "service"          float
);

create table "countries_geo_coordinates"
(
    "code"                VARCHAR(2),
    "latitude"            float,
    "longitude"           float,
    "name"                varchar(128),
    "usa_state_code"      VARCHAR(2),
    "usa_state_latitude"  float,
    "usa_state_longitude" float,
    "usa_state"           varchar(128)
);
