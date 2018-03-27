CREATE TABLE public.unlimited
(
  id serial,
  jour date,
  heure time without time zone,
  latitude numeric,
  longitude numeric,
  height numeric,
  rtk_fix_float_sbas_dgps_single_ppp integer,
  satellites integer,
  sdn numeric,
  sde numeric,
  sdu numeric,
  sdne numeric,
  sdeu numeric,
  sdun numeric,
  age numeric,
  ratio numeric,
  CONSTRAINT pk_llh PRIMARY KEY (id)
);

CREATE OR REPLACE VIEW public.unlimited_view AS 
 SELECT row_number() OVER () AS id_unique,
    unlimited.id,
    unlimited.jour,
    unlimited.heure,
    unlimited.latitude,
    unlimited.longitude,
    unlimited.height,
    unlimited.rtk_fix_float_sbas_dgps_single_ppp,
    unlimited.satellites,
    unlimited.sdn,
    unlimited.sde,
    unlimited.sdu,
    unlimited.sdne,
    unlimited.sdeu,
    unlimited.sdun,
    unlimited.age,
    unlimited.ratio,
    st_setsrid(st_makepoint(unlimited.longitude::double precision, unlimited.latitude::double precision), 4326) AS geom
   FROM unlimited;
