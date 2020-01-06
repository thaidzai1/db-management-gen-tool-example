
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

		ALTER TABLE IF EXISTS order_price
			RENAME COLUMN curr_total_price_vat TO total_amount_after_discount_vnd;

	

COMMIT;
