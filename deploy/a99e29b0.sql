
BEGIN;

/*-- TRIGGER BEGIN --*/
CREATE OR REPLACE FUNCTION public.sync_order_item_package_info() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec record;
    changes JSONB;
BEGIN
    IF NEW.package_info_id > 0 AND NEW.state = '3A' AND OLD.state = '1SZ' AND NEW.wh_inventory_item_id > 0 THEN
        SELECT * INTO rec FROM wh_inventory_item WHERE id = NEW.wh_inventory_item_id LIMIT 1;
        UPDATE package_info set actual_weight = NEW.real_weight, actual_width = rec.width, actual_length = rec.length, actual_height = rec.height WHERE id = NEW.package_info_id;
    END IF;
    RETURN NULL;
END
$$; 
CREATE OR REPLACE FUNCTION public.sync_order_price_wallet_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec record;
    changes JSONB;
BEGIN
    IF NEW.state <> '' THEN
        SELECT * INTO rec FROM order_price WHERE wallet_transaction_id = NEW.id LIMIT 1;
        IF rec <> null THEN
            UPDATE order_price set wallet_transaction_state = NEW.state WHERE id = rec.id;
        END IF;
    END IF;
    RETURN NULL;
END
$$; 

CREATE TRIGGER sync_order_price_wallet_transaction AFTER UPDATE ON wallet_transaction
    FOR EACH ROW EXECUTE PROCEDURE sync_order_price_wallet_transaction();CREATE OR REPLACE FUNCTION public.sync_order_price_wallet_transaction() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    rec record;
    changes JSONB;
BEGIN
    IF NEW.state <> '' THEN
        SELECT * INTO rec FROM order_price WHERE wallet_transaction_id = NEW.id LIMIT 1;
        IF rec IS NOT NULL THEN
            UPDATE order_price set wallet_transaction_state = NEW.state WHERE id = rec.id;
        END IF;
    END IF;
    RETURN NULL;
END
$$; 

CREATE TRIGGER sync_order_price_wallet_transaction AFTER UPDATE ON wallet_transaction
    FOR EACH ROW EXECUTE PROCEDURE sync_order_price_wallet_transaction();
/*-- TRIGGER END --*/

COMMIT;
