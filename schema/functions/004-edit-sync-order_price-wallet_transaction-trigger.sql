CREATE OR REPLACE FUNCTION public.sync_order_price_wallet_transaction() RETURNS trigger
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
    