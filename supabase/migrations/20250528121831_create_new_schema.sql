CREATE SCHEMA IF NOT EXISTS new_schema;

CREATE TABLE IF NOT EXISTS new_schema.user_info (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

Insert into new_schema.user_info (id, name) values (01,'Apoorv'), (02,'No Name');
Insert into new_schema.user_info (id, name) values (03,'Name'), (04,'New Name');


ALTER TABLE new_schema.user_info ENABLE ROW LEVEL SECURITY;