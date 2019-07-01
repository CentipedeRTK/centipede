

----Centipede Database--------
-------------TABLES--------------------

﻿CREATE TABLE public.structure
(
  id serial NOT NULL,
  name character varying(50), --type de structure (institution, agriculteur, particulier...)
  CONSTRAINT pk_structure PRIMARY KEY (id)
);

CREATE TABLE public.message
(
  id serial NOT NULL,
  msg integer, --message code https://www.use-snip.com/kb/knowledge-base/rtcm-3-message-list/
  name character varying(50), --message name
  usage character varying, --Usage Commentary
  CONSTRAINT pk_message PRIMARY KEY (id)
);

CREATE TABLE public.antenne
(
  id serial NOT NULL,
  type character varying(3), -- 3caracteres STR
  mp character varying NOT NULL, --MOUNT POINT
  identifier character varying, -- commune
  format character varying, --data format RTCM, raw...
  formatd character varying, --RTCM messages types & update periode entre parenthese/seconde extraction en json ex: [1002,1006,1010,1097,1107,1117,1127]
  carrier integer, --data stream information 0=no(dgps) 1=yes,L1 2=yes,L1&L2
  navsys character varying, --GPS+GLO+GAL+BDS+SBS
  network character varying, --EUREF
  country character varying(3), --FRA code in ISO 3166
  latitude numeric, --wgs84
  longitude numeric, --wgs84
  nmea integer, --Necessity for Client to send NMEA message with approximate position to Caster 0 = Client must not send NMEA  1 = Client must send NMEA
  solution integer, --Stream generated from single reference station or from networked reference stations 0=Single base 1= Network
  generator character varying, --sNTRIP Hard- or software generating data stream)
  compres character varying, --none Compression/Encryption algorithm applied
  auth character varying(1), --Access protection for this particular data stream N=None B=Basic D=Digest
  fee character varying(1), --User fee for receiving this particular data stream N=No user fee Y=Usage is charged
  bit integer, --(101 emlid) Bit rate of data stream, bits per second
  misc character varying,--Miscellaneous information, last data field in record
  altitude numeric, --wgs84
  id_structure integer, --structure d'acceuil
  geom geometry(PointZ,4326), --geometrie à partir de la lont lat generé en auto
  ping boolean NOT NULL DEFAULT false, --base active?
  ping_date timestamp with time zone, --date du dernier ping?
  photo character varying, -- chemin vers la photo de la base
  contact character varying, -- mail du responsable de la base( alerte si base down)
  CONSTRAINT pk_antenne PRIMARY KEY (id),
  CONSTRAINT fk_structure FOREIGN KEY (id_structure)
      REFERENCES public.structure (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT "uniq_MP" UNIQUE (mp)
);


--parameters schema  
CREATE SCHEMA centipede
  AUTHORIZATION centipede;
GRANT ALL ON SCHEMA centipede TO centipede;

--paramaters of ntripcaster
CREATE TABLE centipede.ntripcaster
(
  id serial NOT NULL,
  type character varying, --parameters
  CONSTRAINT pk_ntripcaster PRIMARY KEY (id)
);

-------------VIEW--------------------
--Buffer view
CREATE OR REPLACE VIEW public.buffer10000 AS 
 SELECT row_number() OVER () AS unique_id,
    st_buffer(antenne.geom, 10000::double precision, 35) AS st_buffer, --buffer de 10km autour de la base pour le L1
    antenne.mp AS antenne, --mountPoint
    structure.name AS structure --structure
   FROM public.antenne,
        public.structure
  WHERE antenne.id_structure = structure.id;
  

-------------FUNCTION-----------------

--function for generate a postgis POINTZ geom with lat long alt values from RTM3
CREATE OR REPLACE FUNCTION make_point()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  NEW.geom=ST_SetSRID(ST_MakePoint(NEW.longitude,NEW.latitude,NEW.altitude),4326);
  RETURN NEW;
END;
$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE;

CREATE TRIGGER trig_make_point BEFORE INSERT OR UPDATE
   ON public.antenne FOR EACH ROW
   EXECUTE PROCEDURE public.make_point();
   
--function generate ntripcaster.conf 
CREATE OR REPLACE FUNCTION public.ntripcaster()
  RETURNS TRIGGER AS
$BODY$
BEGIN
  COPY ( select type from centipede.ntripcaster union ALL (select '/'||mp from public.antenne order by mp)) TO '/home/ntripcaster.conf';
  RETURN NEW;
END;
$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

CREATE TRIGGER trig_ntripcaster AFTER INSERT OR UPDATE OR DELETE
   ON public.antenne FOR EACH ROW
   EXECUTE PROCEDURE public.ntripcaster();
   
--function for generate ntripcaster.conf when a Mount Point is modified  !!!! pas possible lancer docker avec postgres user...
--CREATE OR REPLACE FUNCTION public.up_antenne()
--  RETURNS trigger AS
--$BODY$
--BEGIN
--  EXECUTE format('COPY (select 1 ) TO PROGRAM ''docker run --rm --network host -e MP=%s jancelin/centipede:check'' ', NEW.mp);
--  RETURN NEW;
--END;
--$BODY$
--  LANGUAGE plpgsql VOLATILE;

--CREATE TRIGGER trig_ntripcaster AFTER INSERT OR UPDATE OR DELETE
--   ON public.antenne FOR EACH ROW
--   EXECUTE PROCEDURE public.ntripcaster();
   
   
   
   
   
   
