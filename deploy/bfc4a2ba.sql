
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS additional_chargeable_weight bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_chargeable_weight SET DEFAULT '0';
		UPDATE order_price SET additional_chargeable_weight = '0' WHERE additional_chargeable_weight IS NULL;

COMMIT;
