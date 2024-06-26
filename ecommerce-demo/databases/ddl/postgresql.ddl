create table "customer"
(
	"customer_id" varchar(128) not null,
	"ls__customer_id__customer_name" varchar(128),
	"customer_city" varchar(128),
	"geo__customer_city__city_pushpin_longitude" varchar(128),
	"geo__customer_city__city_pushpin_latitude" varchar(128),
	"customer_country" varchar(128),
	"customer_email" varchar(128),
	"customer_state" varchar(128),
	"customer_created_date" date,
	"wdf__client_id" varchar(128),
	primary key ("customer_id")
)
;

create table "orders"
(
	"order_id" varchar(128) not null,
	"wdf__client_id" varchar(128),
	"order_status" varchar(128) default 'Processed',
	primary key ("order_id")
)
;

create table "product"
(
	"product_id" varchar(128) not null,
	"ls__product_id__product_name" varchar(128),
	"ls__product_id__product_id_image_web" varchar(250),
	"product_brand" varchar(128),
	"product_category" varchar(128),
	"product_image" varchar(250),
	"ls__product_image__product_image_web" varchar(250),
	"rating" decimal(12,2),
	"product_rating" varchar(16),
	"wdf__product_category" varchar(128),
	primary key ("product_id")
)
;

create table "monthlyinventory"
(
	"monthly_inventory_id" varchar(128) not null,
	"product__product_id" varchar(128),
	"inventory_month" date,
	"monthly_quantity_eom" decimal(12,2),
	"wdf__client_id" varchar(128),
	"monthly_quantity_bom" decimal(12,2),
	"date" timestamp,
	primary key ("monthly_inventory_id"),
	foreign key ("product__product_id") references "product"("product_id")
)
;

create table "order_lines"
(
	"order_line_id" varchar(128) not null,
	"order__order_id" varchar(128),
	"product__product_id" varchar(128),
	"customer__customer_id" varchar(128),
	"order_unit_price" decimal(12,2),
	"order_unit_quantity" decimal(12,2),
	"wdf__client_id" varchar(128),
	"order_unit_discount" decimal(12,2),
	"order_unit_cost" decimal(12,2),
	"date" timestamp,
	"order_date" timestamp,
	"customer_age" varchar(128),
	primary key ("order_line_id"),
	foreign key ("product__product_id") references "product"("product_id"),
	foreign key ("order__order_id") references "orders"("order_id"),
	foreign key ("customer__customer_id") references "customer"("customer_id")
)
;

create table "returns"
(
	"return_id" varchar(128) not null,
	"order__order_id" varchar(128),
	"product__product_id" varchar(128),
	"customer__customer_id" varchar(128),
	"return_unit_cost" decimal(12,2),
	"return_unit_quantity" decimal(12,2),
	"wdf__client_id" varchar(128),
	"return_unit_paid_amount" decimal(12,2),
	"date" timestamp,
	"return_date" timestamp,
	primary key ("return_id"),
	foreign key ("product__product_id") references "product"("product_id"),
	foreign key ("order__order_id") references "orders"("order_id"),
	foreign key ("customer__customer_id") references "customer"("customer_id")
)
;
