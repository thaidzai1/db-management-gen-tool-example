
BEGIN;

/*-- TRIGGER BEGIN --*/

/*-- TRIGGER END --*/
CREATE TABLE IF NOT EXISTS vendor (
	id bigserial PRIMARY KEY,
	alias text NOT NULL,
	name text NOT NULL,
	bank_account_name text NOT NULL,
	bank_account_number text NOT NULL,
	bank_name text NOT NULL,
	bank_branch text NOT NULL,
	swift_code text NOT NULL,
	payment_type text NOT NULL,
	notes text,
	tax_code text NOT NULL,
	legal_representative text NOT NULL,
	contact_name text NOT NULL,
	contact_phone text NOT NULL,
	contact_email text NOT NULL,
	action_admin_id bigint NOT NULL,
	onboarding_date timestamptz,
	active bool NOT NULL,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_id_idx ON "vendor" USING btree (id);
CREATE INDEX IF NOT EXISTS vendor_alias_idx ON "vendor" USING btree (alias);
CREATE INDEX IF NOT EXISTS vendor_name_idx ON "vendor" USING btree (name);
CREATE INDEX IF NOT EXISTS vendor_active_idx ON "vendor" USING btree (active);
CREATE TABLE IF NOT EXISTS vendor_key_fee (
	id bigserial PRIMARY KEY,
	fee text NOT NULL,
	description_vi text NOT NULL,
	description_en text NOT NULL,
	unit text NOT NULL,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_key_fee_id_idx ON "vendor_key_fee" USING btree (id);
CREATE INDEX IF NOT EXISTS vendor_key_fee_fee_idx ON "vendor_key_fee" USING btree (fee);
CREATE INDEX IF NOT EXISTS vendor_key_unit_id_idx ON "vendor_key_fee" USING btree (unit);
CREATE TABLE IF NOT EXISTS vendor_quotation (
	id bigserial PRIMARY KEY,
	code text NOT NULL,
	vendor_service_id bigint NOT NULL,
	vendor_route_id bigint NOT NULL,
	vendor_id bigint NOT NULL,
	start_validity_date timestamptz,
	end_validity_date timestamptz,
	currency text,
	vat float,
	action_admin_id bigint,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_service_id_idx ON "vendor_quotation" USING btree (id);
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;
COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';
CREATE TABLE IF NOT EXISTS vendor_quotation_history (
	id bigserial primary key,
	revision bigint,
	changes jsonb,
	vendor_quotation_id bigint,
	user_id bigint,
	updated_at timestamptz DEFAULT 'now()'
);

ALTER TABLE vendor_quotation ADD COLUMN rid bigint;

CREATE FUNCTION public.vendor_quotation_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE changes JSONB;
BEGIN
    IF (TG_OP = 'INSERT') THEN
		INSERT INTO vendor_quotation_history(
			revision, 
			vendor_quotation_id,
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

        INSERT INTO vendor_quotation_history(
			revision,
			vendor_quotation_id,
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

CREATE SEQUENCE IF NOT EXISTS vendor_quotation_history_seq;
CREATE TRIGGER update_rid BEFORE INSERT OR UPDATE ON public.vendor_quotation FOR EACH ROW EXECUTE PROCEDURE public.update_rid('vendor_quotation_history_seq');
CREATE TRIGGER vendor_quotation_history AFTER INSERT OR UPDATE ON public.vendor_quotation FOR EACH ROW EXECUTE PROCEDURE public.vendor_quotation_history();
CREATE TABLE IF NOT EXISTS vendor_service_key_fee (
	id bigserial PRIMARY KEY,
	vendor_service_id bigint NOT NULL,
	vendor_key_fee_id bigint NOT NULL,
	active bool NOT NULL,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_service_id_idx ON "vendor_service_key_fee" USING btree (id);
CREATE TABLE IF NOT EXISTS vendor_fee_tier (
	id bigserial PRIMARY KEY,
	vendor_quotation_id bigint NOT NULL,
	vendor_key_fee_id bigint NOT NULL,
	upper_threshold double precision NOT NULL,
	lower_threshold double precision NOT NULL,
	unit_price_quoted double precision,
	minimun_amount_billed double precision,
	action_admin_id bigint,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_fee_tier_id_idx ON "vendor_fee_tier" USING btree (id);
CREATE INDEX IF NOT EXISTS vendor_fee_tier_vendor_quotation_id_idx ON "vendor_fee_tier" USING btree (vendor_quotation_id);
CREATE INDEX IF NOT EXISTS vendor_fee_tier_vendor_key_fee_id_idx ON "vendor_fee_tier" USING btree (vendor_key_fee_id);
CREATE TABLE IF NOT EXISTS vendor_route (
	id bigserial PRIMARY KEY,
	starting_hub_id bigint NOT NULL,
	ending_hub_id bigint NOT NULL,
	starting_checkpoint text,
	ending_checkpoint text,
	status bool DEFAULT 'true',
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_route_id_idx ON "vendor_route" USING btree (id);
CREATE TABLE IF NOT EXISTS vendor_service (
	id bigserial PRIMARY KEY,
	category text NOT NULL,
	sub_category text NOT NULL,
	description_vi text NOT NULL,
	description_en text NOT NULL,
	active bool NOT NULL,
	action_admin_id bigint,
	created_at timestamptz,
	updated_at timestamptz
);
CREATE INDEX IF NOT EXISTS vendor_service_id_idx ON "vendor_service" USING btree (id);
CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;
COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';
CREATE TABLE IF NOT EXISTS vendor_service_history (
	id bigserial primary key,
	revision bigint,
	changes jsonb,
	vendor_service_id bigint,
	user_id bigint,
	updated_at timestamptz DEFAULT 'now()'
);

ALTER TABLE vendor_service ADD COLUMN rid bigint;

CREATE FUNCTION public.vendor_service_history() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE changes JSONB;
BEGIN
    IF (TG_OP = 'INSERT') THEN
		INSERT INTO vendor_service_history(
			revision, 
			vendor_service_id,
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

        INSERT INTO vendor_service_history(
			revision,
			vendor_service_id,
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

CREATE SEQUENCE IF NOT EXISTS vendor_service_history_seq;
CREATE TRIGGER update_rid BEFORE INSERT OR UPDATE ON public.vendor_service FOR EACH ROW EXECUTE PROCEDURE public.update_rid('vendor_service_history_seq');
CREATE TRIGGER vendor_service_history AFTER INSERT OR UPDATE ON public.vendor_service FOR EACH ROW EXECUTE PROCEDURE public.vendor_service_history();

COMMIT;
