
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/
CREATE TABLE IF NOT EXISTS package_type (
	id bigserial PRIMARY KEY NOT NULL,
	name text
);

COMMIT;
