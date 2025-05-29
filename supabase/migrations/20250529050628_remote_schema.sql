create schema if not exists "my_schema";

create sequence "my_schema"."employee_id_seq";

create table "my_schema"."employee" (
    "id" integer not null default nextval('my_schema.employee_id_seq'::regclass),
    "name" text not null,
    "department" text,
    "created_at" timestamp with time zone default now()
);


alter sequence "my_schema"."employee_id_seq" owned by "my_schema"."employee"."id";

CREATE UNIQUE INDEX employee_pkey ON my_schema.employee USING btree (id);

alter table "my_schema"."employee" add constraint "employee_pkey" PRIMARY KEY using index "employee_pkey";


create sequence "new_schema"."employee_id_seq";

create table "new_schema"."employee" (
    "id" integer not null default nextval('new_schema.employee_id_seq'::regclass),
    "name" character varying(100) not null,
    "created_at" timestamp with time zone default CURRENT_TIMESTAMP
);


alter sequence "new_schema"."employee_id_seq" owned by "new_schema"."employee"."id";

CREATE UNIQUE INDEX employee_pkey ON new_schema.employee USING btree (id);

alter table "new_schema"."employee" add constraint "employee_pkey" PRIMARY KEY using index "employee_pkey";


