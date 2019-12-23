
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

	
	ALTER TABLE IF EXISTS product
		ADD COLUMN IF NOT EXISTS hscode_id bigint;
CREATE TABLE IF NOT EXISTS hscode (
	id bigint PRIMARY KEY NOT NULL,
	name_vn text,
	name_en text,
	name_kr text,
	name_cn text,
	description text,
	user_id bigint,
	created_at timestamp NOT NULL,
	updated_at timestamp NOT NULL
);
CREATE INDEX IF NOT EXISTS hscode_id ON "hscode" USING btree (id);
CREATE INDEX IF NOT EXISTS hscode_created_at ON "hscode" USING btree (created_at);
CREATE INDEX IF NOT EXISTS hscode_updated_at ON "hscode" USING btree (updated_at);
CREATE INDEX IF NOT EXISTS hscode_user_id ON "hscode" USING btree (user_id);
CREATE INDEX IF NOT EXISTS hscode_name_vn ON "hscode" USING btree (name_vn);
CREATE INDEX IF NOT EXISTS hscode_name_kr ON "hscode" USING btree (name_kr);
CREATE INDEX IF NOT EXISTS hscode_name_cn ON "hscode" USING btree (name_cn);

COMMIT;
