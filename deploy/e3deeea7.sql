
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN chargeable_weight SET DEFAULT '0';
		UPDATE order_price SET chargeable_weight = '0' WHERE chargeable_weight = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price SET DEFAULT '0';
		UPDATE order_price SET prev_total_price = '0' WHERE prev_total_price = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price SET DEFAULT '0';
		UPDATE order_price SET curr_total_price = '0' WHERE curr_total_price = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price SET DEFAULT '0';
		UPDATE order_price SET additional_price = '0' WHERE additional_price = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price_vat SET DEFAULT '0';
		UPDATE order_price SET prev_total_price_vat = '0' WHERE prev_total_price_vat = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price_vat SET DEFAULT '0';
		UPDATE order_price SET curr_total_price_vat = '0' WHERE curr_total_price_vat = NULL;
			

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price_vat SET DEFAULT '0';
		UPDATE order_price SET additional_price_vat = '0' WHERE additional_price_vat = NULL;
			

	
DROP TABLE IF EXISTS hscode CASCADE;

COMMIT;
