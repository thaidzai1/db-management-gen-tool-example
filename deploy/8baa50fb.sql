
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;
COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';
CREATE TABLE IF NOT EXISTS vendor_fee_tier_history (
	id bigserial primary key,
	revision bigint,
	changes jsonb,
	vendor_fee_tier_id bigint,
	user_id bigint,
	updated_at timestamptz DEFAULT 'now()'
);

ALTER TABLE vendor_fee_tier ADD COLUMN rid bigint;

CREATE FUNCTION public.vendor_fee_tier_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE changes JSONB;
BEGIN
    IF (TG_OP = 'INSERT') THEN
		INSERT INTO vendor_fee_tier_history(
			revision, 
			vendor_fee_tier_id,
			user_id,
			changes
		)
        VALUES (
			NEW.rid, 
			NEW.id,
			NEW.action_admin_id,
			to_json(NEW)
		);
    ELSE
        -- calculate only changed columns then encode as jsonb
        -- also ignore uninteresting fields like "updated_at", "rid"
		changes := to_jsonb((hstore(NEW.*)-hstore(OLD.*)) - '{updated_at,rid,	action_admin_id}'::TEXT[]);

        -- ignore trivial changes
        IF (changes = '{}'::JSONB) THEN RETURN NULL; END IF;

        INSERT INTO vendor_fee_tier_history(
			revision,
			vendor_fee_tier_id,
			user_id, 
			changes
		)
        VALUES (
			NEW.rid, 
			NEW.id,
			NEW.action_admin_id,
				
			changes
		);
    END IF;
    RETURN NULL;
END
$$;

CREATE SEQUENCE IF NOT EXISTS vendor_fee_tier_history_seq;
CREATE TRIGGER update_rid BEFORE INSERT OR UPDATE ON public.vendor_fee_tier FOR EACH ROW EXECUTE PROCEDURE public.update_rid('vendor_fee_tier_history_seq');
CREATE TRIGGER vendor_fee_tier_history AFTER INSERT OR UPDATE ON public.vendor_fee_tier FOR EACH ROW EXECUTE PROCEDURE public.vendor_fee_tier_history();
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;
COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';
CREATE TABLE IF NOT EXISTS vendor_history (
	id bigserial primary key,
	revision bigint,
	changes jsonb,
	vendor_id bigint,
	user_id bigint,
	updated_at timestamptz DEFAULT 'now()'
);

ALTER TABLE vendor ADD COLUMN rid bigint;

CREATE FUNCTION public.vendor_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE changes JSONB;
BEGIN
    IF (TG_OP = 'INSERT') THEN
		INSERT INTO vendor_history(
			revision, 
			vendor_id,
			user_id,
			changes
		)
        VALUES (
			NEW.rid, 
			NEW.id,
			NEW.action_admin_id,
			to_json(NEW)
		);
    ELSE
        -- calculate only changed columns then encode as jsonb
        -- also ignore uninteresting fields like "updated_at", "rid"
		changes := to_jsonb((hstore(NEW.*)-hstore(OLD.*)) - '{updated_at,rid,	action_admin_id}'::TEXT[]);

        -- ignore trivial changes
        IF (changes = '{}'::JSONB) THEN RETURN NULL; END IF;

        INSERT INTO vendor_history(
			revision,
			vendor_id,
			user_id, 
			changes
		)
        VALUES (
			NEW.rid, 
			NEW.id,
			NEW.action_admin_id,
				
			changes
		);
    END IF;
    RETURN NULL;
END
$$;

CREATE SEQUENCE IF NOT EXISTS vendor_history_seq;
CREATE TRIGGER update_rid BEFORE INSERT OR UPDATE ON public.vendor FOR EACH ROW EXECUTE PROCEDURE public.update_rid('vendor_history_seq');
CREATE TRIGGER vendor_history AFTER INSERT OR UPDATE ON public.vendor FOR EACH ROW EXECUTE PROCEDURE public.vendor_history();

COMMIT;
