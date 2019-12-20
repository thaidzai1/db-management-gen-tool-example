
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/
CREATE TABLE IF NOT EXISTS hub (
	id bigserial PRIMARY KEY NOT NULL,
	code text Unique,
	name text NOT NULL Unique,
	description text,
	address text,
	country text,
	created_at timestamp,
	updated_at timestamp,
	active boolean
);
CREATE INDEX IF NOT EXISTS hub_id_idx ON "hub" USING btree (id);
CREATE INDEX IF NOT EXISTS hub_code_idx ON "hub" USING btree (code);
CREATE INDEX IF NOT EXISTS hub_name_idx ON "hub" USING btree (name);

COMMIT;
