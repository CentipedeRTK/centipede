create table public.llh (

        id serial NOT NULL,
	dat date,
	tim time without time zone,
	lati numeric,
	longi numeric,
	height numeric,
	q integer,
	ns integer,
	sdn numeric,
	sde numeric,
	sdu numeric,
	age numeric,
	ratio numeric,
        geom geometry(Point,4326),                      --Geométrie fabrique avec les long lat
	CONSTRAINT id_pkey PRIMARY KEY (id)
);

--make Geom with lon_lat
CREATE OR REPLACE FUNCTION public.func_add_geom()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    IMMUTABLE NOT LEAKPROOF
AS $BODY$
BEGIN
  NEW.geom = st_setsrid(st_makepoint(NEW.nmea_longitude,NEW.nmea_latitude), 4326) AS geom;
  RETURN NEW;
END;
$BODY$;

CREATE  TRIGGER add_geom
    BEFORE INSERT OR UPDATE 
    ON public.llh
    FOR EACH ROW
    EXECUTE PROCEDURE public.func_add_geom();


