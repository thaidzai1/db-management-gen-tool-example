
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

		ALTER TABLE IF EXISTS order_price
			ALTER COLUMN wallet_transaction_id TYPE bigint USING wallet_transaction_id::bigint;

	

COMMIT;
