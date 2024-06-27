create or replace TABLE "customer"
(
	"customer_id" VARCHAR(128) NOT NULL,
	"ls__customer_id__customer_name" VARCHAR(128),
	"customer_city" VARCHAR(128),
	"geo__customer_city__city_pushpin_longitude" VARCHAR(128),
        "geo__customer_city__city_pushpin_latitude" VARCHAR(128),
	"customer_country" VARCHAR(128),
	"customer_email" VARCHAR(128),
	"customer_state" VARCHAR(128),
	"customer_created_date" DATE,
	"wdf__client_id" VARCHAR(128),
	primary key ("customer_id")
)
;

create or replace TABLE "orders"
(
	"order_id" VARCHAR(128) NOT NULL,
	"wdf__client_id" VARCHAR(128),
	"order_status" VARCHAR(128) DEFAULT 'Processed',
	primary key ("order_id")
)
;

create or replace TABLE "product"
(
	"product_id" VARCHAR(128) NOT NULL,
	"ls__product_id__product_name" VARCHAR(128),
	"ls__product_id__product_id_image_web" VARCHAR(250),
	"product_brand" VARCHAR(128),
        "product_category" VARCHAR(128),
	"product_image" VARCHAR(250),
	"ls__product_image__product_image_web" VARCHAR(250),
        "rating" NUMBER(12,2),
        "product_rating" VARCHAR(16),
	"wdf__product_category" VARCHAR(128),
	primary key ("product_id")
)
;

create or replace TABLE "monthlyinventory"
(
	"monthly_inventory_id" VARCHAR(128) NOT NULL,
	"product__product_id" VARCHAR(128),
	"inventory_month" DATE,
	"monthly_quantity_eom" NUMBER(12,2),
        "wdf__client_id" VARCHAR(128),
	"monthly_quantity_bom" NUMBER(12,2),
	"date" TIMESTAMP_NTZ(9),
	primary key ("monthly_inventory_id"),
	foreign key ("product__product_id") references "product"("product_id")
)
;

create or replace TABLE "order_lines"
(
	"order_line_id" VARCHAR(128) NOT NULL,
	"order__order_id" VARCHAR(128),
	"product__product_id" VARCHAR(128),
	"customer__customer_id" VARCHAR(128),
	"order_unit_price" NUMBER(12,2),
	"order_unit_quantity" NUMBER(12,2),
	"wdf__client_id" VARCHAR(128),
	"order_unit_discount" NUMBER(12,2),
	"order_unit_cost" NUMBER(12,2),
	"date" TIMESTAMP_NTZ(9),
	"order_date" TIMESTAMP_NTZ(9),
	"customer_age" VARCHAR(128),
	primary key ("order_line_id"),
	foreign key ("product__product_id") references "product"("product_id"),
	foreign key ("order__order_id") references "orders"("order_id"),
	foreign key ("customer__customer_id") references "customer"("customer_id")
)
;

create or replace TABLE "returns"
(
	"return_id" VARCHAR(128) NOT NULL,
	"order__order_id" VARCHAR(128),
	"product__product_id" VARCHAR(128),
	"customer__customer_id" VARCHAR(128),
	"return_unit_cost" NUMBER(12,2),
	"return_unit_quantity" NUMBER(12,2),
	"wdf__client_id" VARCHAR(128),
	"return_unit_paid_amount" NUMBER(12,2),
	"date" TIMESTAMP_NTZ(9),
	"return_date" TIMESTAMP_NTZ(9),
	primary key ("return_id"),
	foreign key ("product__product_id") references "product"("product_id"),
	foreign key ("order__order_id") references "orders"("order_id"),
	foreign key ("customer__customer_id") references "customer"("customer_id")
)
;
