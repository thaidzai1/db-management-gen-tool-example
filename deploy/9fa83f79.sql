
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

	
	ALTER TABLE IF EXISTS package_info
		ADD COLUMN IF NOT EXISTS actual_length integer;
	
	ALTER TABLE IF EXISTS package_info
		ADD COLUMN IF NOT EXISTS actual_width integer;
	
	ALTER TABLE IF EXISTS package_info
		ADD COLUMN IF NOT EXISTS actual_height integer;
DROP TABLE IF EXISTS hscode CASCADE;

COMMIT;
