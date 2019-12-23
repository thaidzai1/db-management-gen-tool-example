
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN type SET NOT NULL DEFAULT '' ;

	
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN chargeable_weight TYPE bigint USING chargeable_weight::bigint;

	
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS prev_total_price bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price SET DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price SET NOT NULL DEFAULT '0';
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS curr_total_price bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price SET DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price SET NOT NULL DEFAULT '0';
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS additional_price bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price SET DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price SET NOT NULL DEFAULT '0';
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS prev_total_price_vat bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price_vat SET DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN prev_total_price_vat SET NOT NULL DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			RENAME COLUMN total_amount_after_discount_vnd TO curr_total_price_vat;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price_vat TYPE bigint USING curr_total_price_vat::bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN curr_total_price_vat SET DEFAULT '0';
			

	
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS additional_price_vat bigint;
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price_vat SET DEFAULT '0';
		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN additional_price_vat SET NOT NULL DEFAULT '0';
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS wallet_transactoin_id text;
	
	ALTER TABLE IF EXISTS order_price
		ADD COLUMN IF NOT EXISTS wallet_transaction_state text;
DROP TABLE IF EXISTS hscode CASCADE;

COMMIT;
