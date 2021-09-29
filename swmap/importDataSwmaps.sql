CREATE SCHEMA mes;

-- Table: mes.swmap

-- DROP TABLE mes.swmap;

CREATE TABLE IF NOT EXISTS mes.swmap
(
rowid integer,
uuid uuid NOT NULL DEFAULT gen_random_uuid(),
fid uuid,
seq integer,
lat numeric,
lon numeric,
elv numeric,
ortho_ht integer,
"time" bigint,
start_time bigint,
instrument_ht numeric,
fix_quality integer,
speed numeric,
snap_id character varying COLLATE pg_catalog."default",
additional_data character varying COLLATE pg_catalog."default",
reproj character varying COLLATE pg_catalog."default",
dat timestamp without time zone,
acquisition_time_s integer,
geom geometry(PointZ,5698),
x numeric,
y numeric,
z numeric,
epsg integer,
epsgc character varying COLLATE pg_catalog."default",
CONSTRAINT id_swmap_pkey PRIMARY KEY (uuid)
)

TABLESPACE pg_default;

-- FUNCTION: mes.func_reproj()

-- DROP FUNCTION mes.func_reproj();

CREATE FUNCTION mes.func_reproj()
RETURNS trigger
LANGUAGE 'plpgsql'
COST 100
IMMUTABLE NOT LEAKPROOF
AS $BODY$
DECLARE
epsgIN INTEGER := 4171;
epsgOUT INTEGER := 5698;
espgOUTc character varying := 'RGF93 / Lambert-93 + NGF-IGN69 height RAF18b';
BEGIN
NEW.dat = TIMESTAMP 'epoch' + (NEW.start_time::bigint /1000) * INTERVAL '1 second';
NEW.acquisition_time_s = (NEW.time - NEW.start_time) /1000;
NEW.reproj = epsgIN || '>' || epsgOUT;
NEW.geom = st_transform(st_setsrid(st_makepoint(NEW.lon,NEW.lat,NEW.elv), epsgIN),epsgOUT);
NEW.x = round(st_X(st_transform(st_setsrid(st_makepoint(NEW.lon,NEW.lat,NEW.elv), epsgIN),epsgOUT))::numeric,3);
NEW.y = round(st_Y(st_transform(st_setsrid(st_makepoint(NEW.lon,NEW.lat,NEW.elv), epsgIN),epsgOUT))::numeric,3);
NEW.z = round(st_Z(st_transform(st_setsrid(st_makepoint(NEW.lon,NEW.lat,NEW.elv), epsgIN),epsgOUT))::numeric,3);
NEW.epsg = epsgOUT;
NEW.epsgc = espgOUTc;
RETURN NEW;
END;
$BODY$;

-- Trigger: add_reproj

-- DROP TRIGGER add_reproj ON mes.swmap;

CREATE TRIGGER add_reproj
BEFORE INSERT OR UPDATE
ON mes.swmap
FOR EACH ROW
EXECUTE FUNCTION mes.func_reproj();
