
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/

		ALTER TABLE IF EXISTS order_price
			RENAME COLUMN wallet_transactoin_id TO wallet_transaction_id;

	
DROP TABLE IF EXISTS hscode CASCADE;

COMMIT;
