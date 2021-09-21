--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2 (Debian 13.2-1.pgdg110+1)
-- Dumped by pg_dump version 13.2 (Debian 13.2-1.pgdg110+1)

--SET statement_timeout = 0;
--SET lock_timeout = 0;
--SET idle_in_transaction_session_timeout = 0;
--SET client_encoding = 'UTF8';
--SET standard_conforming_strings = on;
--SELECT pg_catalog.set_config('search_path', '', false);
--SET check_function_bodies = false;
--SET xmloption = content;
--SET client_min_messages = warning;
--SET row_security = off;

--
-- Name: centipede; Type: SCHEMA; Schema: -; Owner: centipede
--

CREATE SCHEMA centipede;


ALTER SCHEMA centipede OWNER TO centipede;

--
-- Name: pg_cron; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_cron WITH SCHEMA public;


--
-- Name: EXTENSION pg_cron; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION pg_cron IS 'Job scheduler for PostgreSQL';


--
-- Name: logs; Type: SCHEMA; Schema: -; Owner: centipede
--

CREATE SCHEMA logs;


ALTER SCHEMA logs OWNER TO centipede;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


--
-- Name: defaut_store(); Type: FUNCTION; Schema: centipede; Owner: centipede
--

CREATE FUNCTION centipede.defaut_store() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
	IF ( OLD.defaut_count > 0 AND NEW.defaut_count = 0 ) THEN
	  INSERT INTO defaut_logs VALUES
		(nextval('defaut_logs_id_seq'::regclass),
		OLD.mp,
		OLD.defaut,
		OLD.defaut_persist);
		RETURN NEW;
	END IF;
	RETURN NEW;
  END;
  $$;


ALTER FUNCTION centipede.defaut_store() OWNER TO centipede;

--
-- Name: asbinary(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asbinary(public.geometry) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(public.geometry) OWNER TO postgres;

--
-- Name: asbinary(public.geometry, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.asbinary(public.geometry, text) RETURNS bytea
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_asBinary';


ALTER FUNCTION public.asbinary(public.geometry, text) OWNER TO postgres;

--
-- Name: astext(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.astext(public.geometry) RETURNS text
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_asText';


ALTER FUNCTION public.astext(public.geometry) OWNER TO postgres;

--
-- Name: estimated_extent(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.estimated_extent(text, text) RETURNS public.box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-3', 'geometry_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text) OWNER TO postgres;

--
-- Name: estimated_extent(text, text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.estimated_extent(text, text, text) RETURNS public.box2d
    LANGUAGE c IMMUTABLE STRICT SECURITY DEFINER
    AS '$libdir/postgis-3', 'geometry_estimated_extent';


ALTER FUNCTION public.estimated_extent(text, text, text) OWNER TO postgres;

--
-- Name: geomfromtext(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1)$_$;


ALTER FUNCTION public.geomfromtext(text) OWNER TO postgres;

--
-- Name: geomfromtext(text, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.geomfromtext(text, integer) RETURNS public.geometry
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT ST_GeomFromText($1, $2)$_$;


ALTER FUNCTION public.geomfromtext(text, integer) OWNER TO postgres;

--
-- Name: make_point(); Type: FUNCTION; Schema: public; Owner: centipede
--

CREATE FUNCTION public.make_point() RETURNS trigger
    LANGUAGE plpgsql IMMUTABLE
    AS $$
BEGIN
  NEW.geom=ST_SetSRID(ST_MakePoint(NEW.longitude,NEW.latitude,NEW.altitude),4326);
  NEW.identifier=c.nom FROM public.antenne a JOIN public.commune c ON ST_INTERSECTS(NEW.geom,c.geom) WHERE a.id=NEW.id;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.make_point() OWNER TO centipede;

--
-- Name: ndims(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.ndims(public.geometry) RETURNS smallint
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_ndims';


ALTER FUNCTION public.ndims(public.geometry) OWNER TO postgres;

--
-- Name: ntripcaster(); Type: FUNCTION; Schema: public; Owner: centipede
--

CREATE FUNCTION public.ntripcaster() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  COPY (SELECT type FROM centipede.ntripcaster ORDER by id) TO PROGRAM 'rm /home/sourcetable.dat; cat >> /home/sourcetable.dat';
  COPY (SELECT type, mp, identifier, BTRIM(format,'"'), formatd, carrier, navsys, network, country, round(latitude,3), round(longitude,3), nmea, solution, generator, compres, auth,fee,bit,misc
FROM public.antenne ORDER by mp) TO PROGRAM 'cat >> /home/sourcetable.dat; chmod 644 /home/sourcetable.dat;' WITH DELIMITER ';';
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.ntripcaster() OWNER TO centipede;

--
-- Name: setsrid(public.geometry, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.setsrid(public.geometry, integer) RETURNS public.geometry
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_set_srid';


ALTER FUNCTION public.setsrid(public.geometry, integer) OWNER TO postgres;

--
-- Name: srid(public.geometry); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.srid(public.geometry) RETURNS integer
    LANGUAGE c IMMUTABLE STRICT
    AS '$libdir/postgis-3', 'LWGEOM_get_srid';


ALTER FUNCTION public.srid(public.geometry) OWNER TO postgres;

--
-- Name: st_asbinary(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_asbinary(text) RETURNS bytea
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsBinary($1::geometry);$_$;


ALTER FUNCTION public.st_asbinary(text) OWNER TO postgres;

--
-- Name: st_astext(bytea); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.st_astext(bytea) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$ SELECT ST_AsText($1::geometry);$_$;


ALTER FUNCTION public.st_astext(bytea) OWNER TO postgres;

--
-- Name: gist_geometry_ops; Type: OPERATOR FAMILY; Schema: public; Owner: postgres
--

CREATE OPERATOR FAMILY public.gist_geometry_ops USING gist;


ALTER OPERATOR FAMILY public.gist_geometry_ops USING gist OWNER TO postgres;

--
-- Name: gist_geometry_ops; Type: OPERATOR CLASS; Schema: public; Owner: postgres
--

CREATE OPERATOR CLASS public.gist_geometry_ops
    FOR TYPE public.geometry USING gist FAMILY public.gist_geometry_ops AS
    STORAGE public.box2df ,
    OPERATOR 1 public.<<(public.geometry,public.geometry) ,
    OPERATOR 2 public.&<(public.geometry,public.geometry) ,
    OPERATOR 3 public.&&(public.geometry,public.geometry) ,
    OPERATOR 4 public.&>(public.geometry,public.geometry) ,
    OPERATOR 5 public.>>(public.geometry,public.geometry) ,
    OPERATOR 6 public.~=(public.geometry,public.geometry) ,
    OPERATOR 7 public.~(public.geometry,public.geometry) ,
    OPERATOR 8 public.@(public.geometry,public.geometry) ,
    OPERATOR 9 public.&<|(public.geometry,public.geometry) ,
    OPERATOR 10 public.<<|(public.geometry,public.geometry) ,
    OPERATOR 11 public.|>>(public.geometry,public.geometry) ,
    OPERATOR 12 public.|&>(public.geometry,public.geometry) ,
    OPERATOR 13 public.<->(public.geometry,public.geometry) FOR ORDER BY pg_catalog.float_ops ,
    OPERATOR 14 public.<#>(public.geometry,public.geometry) FOR ORDER BY pg_catalog.float_ops ,
    FUNCTION 1 (public.geometry, public.geometry) public.geometry_gist_consistent_2d(internal,public.geometry,integer) ,
    FUNCTION 2 (public.geometry, public.geometry) public.geometry_gist_union_2d(bytea,internal) ,
    FUNCTION 3 (public.geometry, public.geometry) public.geometry_gist_compress_2d(internal) ,
    FUNCTION 4 (public.geometry, public.geometry) public.geometry_gist_decompress_2d(internal) ,
    FUNCTION 5 (public.geometry, public.geometry) public.geometry_gist_penalty_2d(internal,internal,internal) ,
    FUNCTION 6 (public.geometry, public.geometry) public.geometry_gist_picksplit_2d(internal,internal) ,
    FUNCTION 7 (public.geometry, public.geometry) public.geometry_gist_same_2d(public.geometry,public.geometry,internal) ,
    FUNCTION 8 (public.geometry, public.geometry) public.geometry_gist_distance_2d(internal,public.geometry,integer);


ALTER OPERATOR CLASS public.gist_geometry_ops USING gist OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contact; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.contact (
    id integer NOT NULL,
    id_antenne integer NOT NULL,
    id_structure integer,
    mail character varying,
    id_recepteur integer,
    id_type_antenne integer,
    rapport character varying
);


ALTER TABLE centipede.contact OWNER TO centipede;

--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.contact_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.contact_id_seq OWNER TO centipede;

--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.contact_id_seq OWNED BY centipede.contact.id;


--
-- Name: layer_styles; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.layer_styles (
    id integer NOT NULL,
    f_table_catalog character varying,
    f_table_schema character varying,
    f_table_name character varying,
    f_geometry_column character varying,
    stylename text,
    styleqml xml,
    stylesld xml,
    useasdefault boolean,
    description text,
    owner character varying(63) DEFAULT CURRENT_USER,
    ui xml,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying
);


ALTER TABLE centipede.layer_styles OWNER TO centipede;

--
-- Name: layer_styles_old; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.layer_styles_old (
    id integer NOT NULL,
    f_table_catalog character varying,
    f_table_schema character varying,
    f_table_name character varying,
    f_geometry_column character varying,
    stylename character varying(30),
    styleqml xml,
    stylesld xml,
    useasdefault boolean,
    description text,
    owner character varying(30),
    ui xml,
    update_time timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    type character varying
);


ALTER TABLE centipede.layer_styles_old OWNER TO centipede;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.layer_styles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.layer_styles_id_seq OWNER TO centipede;

--
-- Name: layer_styles_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.layer_styles_id_seq OWNED BY centipede.layer_styles_old.id;


--
-- Name: layer_styles_id_seq1; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.layer_styles_id_seq1
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.layer_styles_id_seq1 OWNER TO centipede;

--
-- Name: layer_styles_id_seq1; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.layer_styles_id_seq1 OWNED BY centipede.layer_styles.id;


--
-- Name: list_contact; Type: VIEW; Schema: centipede; Owner: centipede
--

CREATE VIEW centipede.list_contact AS
 SELECT row_number() OVER () AS unique_id,
    string_agg(DISTINCT (contact.mail)::text, '; '::text) AS string_agg
   FROM centipede.contact;


ALTER TABLE centipede.list_contact OWNER TO centipede;

--
-- Name: ntripcaster; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.ntripcaster (
    id integer NOT NULL,
    type character varying
);


ALTER TABLE centipede.ntripcaster OWNER TO centipede;

--
-- Name: ntripcaster_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.ntripcaster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.ntripcaster_id_seq OWNER TO centipede;

--
-- Name: ntripcaster_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.ntripcaster_id_seq OWNED BY centipede.ntripcaster.id;


--
-- Name: recepteur; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.recepteur (
    id integer NOT NULL,
    name character varying NOT NULL,
    lien character varying
);


ALTER TABLE centipede.recepteur OWNER TO centipede;

--
-- Name: recepteur_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.recepteur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.recepteur_id_seq OWNER TO centipede;

--
-- Name: recepteur_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.recepteur_id_seq OWNED BY centipede.recepteur.id;


--
-- Name: structure; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.structure (
    id integer NOT NULL,
    name character varying(50)
);


ALTER TABLE centipede.structure OWNER TO centipede;

--
-- Name: structure_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.structure_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.structure_id_seq OWNER TO centipede;

--
-- Name: structure_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.structure_id_seq OWNED BY centipede.structure.id;


--
-- Name: type_antenne; Type: TABLE; Schema: centipede; Owner: centipede
--

CREATE TABLE centipede.type_antenne (
    id integer NOT NULL,
    name character varying NOT NULL,
    lien character varying
);


ALTER TABLE centipede.type_antenne OWNER TO centipede;

--
-- Name: type_antenne_id_seq; Type: SEQUENCE; Schema: centipede; Owner: centipede
--

CREATE SEQUENCE centipede.type_antenne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE centipede.type_antenne_id_seq OWNER TO centipede;

--
-- Name: type_antenne_id_seq; Type: SEQUENCE OWNED BY; Schema: centipede; Owner: centipede
--

ALTER SEQUENCE centipede.type_antenne_id_seq OWNED BY centipede.type_antenne.id;


--
-- Name: active_eteinte; Type: TABLE; Schema: logs; Owner: centipede
--

CREATE TABLE logs.active_eteinte (
    id integer NOT NULL,
    ae_date timestamp without time zone NOT NULL,
    active integer NOT NULL,
    eteinte integer NOT NULL
);


ALTER TABLE logs.active_eteinte OWNER TO centipede;

--
-- Name: active_eteinte_id_seq; Type: SEQUENCE; Schema: logs; Owner: centipede
--

CREATE SEQUENCE logs.active_eteinte_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE logs.active_eteinte_id_seq OWNER TO centipede;

--
-- Name: active_eteinte_id_seq; Type: SEQUENCE OWNED BY; Schema: logs; Owner: centipede
--

ALTER SEQUENCE logs.active_eteinte_id_seq OWNED BY logs.active_eteinte.id;


--
-- Name: antenne; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.antenne (
    id integer NOT NULL,
    type character varying(3),
    mp character varying NOT NULL,
    identifier character varying,
    format character varying,
    formatd character varying,
    carrier integer,
    navsys character varying,
    network character varying,
    country character varying(3),
    latitude numeric,
    longitude numeric,
    nmea integer,
    solution integer,
    generator character varying,
    compres character varying,
    auth character varying(1),
    fee character varying(1),
    "bit" integer,
    misc character varying,
    altitude numeric,
    id_structure integer,
    geom public.geometry(PointZ,4326),
    ping boolean DEFAULT false NOT NULL,
    ping_date timestamp with time zone,
    receiver character varying,
    version character varying,
    antenne character varying,
    station_id integer,
    syscoor character varying,
    date_declar date
);


ALTER TABLE public.antenne OWNER TO centipede;

--
-- Name: COLUMN antenne.syscoor; Type: COMMENT; Schema: public; Owner: centipede
--

COMMENT ON COLUMN public.antenne.syscoor IS 'coordinate system';


--
-- Name: COLUMN antenne.date_declar; Type: COMMENT; Schema: public; Owner: centipede
--

COMMENT ON COLUMN public.antenne.date_declar IS 'date de declaration de la base RTK';


--
-- Name: antenne_futur; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.antenne_futur (
    id integer NOT NULL,
    geom public.geometry(Point,4326),
    carrier integer
);


ALTER TABLE public.antenne_futur OWNER TO centipede;

--
-- Name: antenne_futur_id_seq; Type: SEQUENCE; Schema: public; Owner: centipede
--

CREATE SEQUENCE public.antenne_futur_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.antenne_futur_id_seq OWNER TO centipede;

--
-- Name: antenne_futur_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: centipede
--

ALTER SEQUENCE public.antenne_futur_id_seq OWNED BY public.antenne_futur.id;


--
-- Name: antenne_id_seq; Type: SEQUENCE; Schema: public; Owner: centipede
--

CREATE SEQUENCE public.antenne_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.antenne_id_seq OWNER TO centipede;

--
-- Name: antenne_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: centipede
--

ALTER SEQUENCE public.antenne_id_seq OWNED BY public.antenne.id;


--
-- Name: carriertobuffer; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.carriertobuffer (
    carrier integer NOT NULL,
    buffer integer,
    frequence character varying
);


ALTER TABLE public.carriertobuffer OWNER TO centipede;

--
-- Name: defaut; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.defaut (
    mp character varying NOT NULL,
    control timestamp with time zone,
    defaut timestamp with time zone,
    defaut_persist interval,
    defaut_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.defaut OWNER TO centipede;

--
-- Name: buffer; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.buffer AS
 SELECT row_number() OVER () AS unique_id,
    public.st_buffer(public.st_transform(a.geom, 2154), (cb.buffer)::double precision, 35) AS st_buffer,
    a.mp AS antenne,
    cb.carrier,
    cb.frequence,
        CASE
            WHEN (d.defaut_count = 0) THEN 'active'::text
            ELSE 'eteinte'::text
        END AS ping,
        CASE
            WHEN (con.mail IS NULL) THEN 0
            ELSE 1
        END AS legal
   FROM (((public.antenne a
     LEFT JOIN public.carriertobuffer cb ON ((a.carrier = cb.carrier)))
     LEFT JOIN centipede.contact con ON ((con.id_antenne = a.id)))
     LEFT JOIN public.defaut d ON (((d.mp)::text = (a.mp)::text)))
  WHERE (a.longitude <> (0)::numeric);


ALTER TABLE public.buffer OWNER TO centipede;

--
-- Name: buffer_futur; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.buffer_futur AS
 SELECT row_number() OVER () AS unique_id,
    public.st_buffer(public.st_transform(a.geom, 2154), (cb.buffer)::double precision, 35) AS st_buffer,
    cb.carrier,
    cb.frequence
   FROM (public.antenne_futur a
     LEFT JOIN public.carriertobuffer cb ON ((a.carrier = cb.carrier)));


ALTER TABLE public.buffer_futur OWNER TO centipede;

--
-- Name: buffer_wgs84; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.buffer_wgs84 AS
 SELECT row_number() OVER () AS unique_id,
    public.st_buffer(public.st_transform(a.geom, 4326), (cb.buffer)::double precision, 35) AS st_buffer,
    a.mp AS antenne,
    cb.carrier,
    cb.frequence,
        CASE
            WHEN (a.ping = true) THEN 'active'::text
            ELSE 'eteinte'::text
        END AS ping,
        CASE
            WHEN (con.mail IS NULL) THEN 0
            ELSE 1
        END AS legal
   FROM ((public.antenne a
     LEFT JOIN public.carriertobuffer cb ON ((a.carrier = cb.carrier)))
     LEFT JOIN centipede.contact con ON ((con.id_antenne = a.id)))
  WHERE (a.longitude <> (0)::numeric);


ALTER TABLE public.buffer_wgs84 OWNER TO centipede;

--
-- Name: commune; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.commune (
    id integer NOT NULL,
    nom character varying,
    geom public.geometry(Polygon,4326)
);


ALTER TABLE public.commune OWNER TO centipede;

--
-- Name: commune_id_seq; Type: SEQUENCE; Schema: public; Owner: centipede
--

CREATE SEQUENCE public.commune_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.commune_id_seq OWNER TO centipede;

--
-- Name: commune_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: centipede
--

ALTER SEQUENCE public.commune_id_seq OWNED BY public.commune.id;


--
-- Name: etat_antennes; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.etat_antennes AS
 SELECT antenne.id,
    public.st_transform(antenne.geom, 2154) AS anten,
    antenne.mp,
        CASE
            WHEN (d.defaut_count = 0) THEN 'active'::text
            ELSE 'eteinte'::text
        END AS ping,
    d.control AS check_activite,
    round(antenne.longitude, 5) AS longitude,
    round(antenne.latitude, 5) AS latitude,
    round(antenne.altitude, 3) AS altitude,
    btrim((antenne.format)::text, '"'::text) AS data_format,
    antenne.formatd AS rtcm_messages,
    antenne.navsys AS systeme,
    cb.frequence,
        CASE
            WHEN (con.mail IS NULL) THEN 0
            ELSE 1
        END AS legal,
    r.name AS recepteur,
    ta.name AS type_antenne,
    con.rapport,
    antenne.receiver,
    antenne.version,
    antenne.antenne,
    antenne.syscoor
   FROM (((((public.antenne antenne
     LEFT JOIN public.carriertobuffer cb ON ((antenne.carrier = cb.carrier)))
     LEFT JOIN centipede.contact con ON ((con.id_antenne = antenne.id)))
     LEFT JOIN centipede.type_antenne ta ON ((ta.id = con.id_type_antenne)))
     LEFT JOIN centipede.recepteur r ON ((r.id = con.id_recepteur)))
     LEFT JOIN public.defaut d ON (((d.mp)::text = (antenne.mp)::text)))
  WHERE (antenne.longitude <> (0)::numeric)
  ORDER BY antenne.mp;


ALTER TABLE public.etat_antennes OWNER TO centipede;

--
-- Name: count_base; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.count_base AS
 SELECT now() AS now,
    a.c AS active,
    e.c AS eteinte
   FROM ( SELECT count(etat_antennes.mp) AS c
           FROM public.etat_antennes
          WHERE (etat_antennes.ping = 'active'::text)) a,
    ( SELECT count(etat_antennes.mp) AS c
           FROM public.etat_antennes
          WHERE (etat_antennes.ping = 'eteinte'::text)) e;


ALTER TABLE public.count_base OWNER TO centipede;

--
-- Name: defaut_logs; Type: TABLE; Schema: public; Owner: centipede
--

CREATE TABLE public.defaut_logs (
    id integer NOT NULL,
    mp character varying NOT NULL,
    defaut timestamp with time zone NOT NULL,
    defaut_persist interval NOT NULL
);


ALTER TABLE public.defaut_logs OWNER TO centipede;

--
-- Name: defaut_day; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.defaut_day AS
 SELECT defaut_logs.id,
    ant.id AS id_antenne,
    defaut_logs.mp,
    date_trunc('minutes'::text, defaut_logs.defaut) AS defaut,
        CASE
            WHEN (round(date_part('epoch'::text, defaut_logs.defaut_persist)) >= (86400)::double precision) THEN round(((date_part('epoch'::text, defaut_logs.defaut_persist) / (86400)::double precision))::numeric, 2)
            ELSE NULL::numeric
        END AS days,
        CASE
            WHEN ((round(date_part('epoch'::text, defaut_logs.defaut_persist)) >= (3600)::double precision) AND (round(date_part('epoch'::text, defaut_logs.defaut_persist)) < (86400)::double precision)) THEN round(((date_part('epoch'::text, defaut_logs.defaut_persist) / (3600)::double precision))::numeric, 2)
            ELSE NULL::numeric
        END AS hours,
        CASE
            WHEN ((round(date_part('epoch'::text, defaut_logs.defaut_persist)) >= (60)::double precision) AND (round(date_part('epoch'::text, defaut_logs.defaut_persist)) < (3600)::double precision)) THEN round(((date_part('epoch'::text, defaut_logs.defaut_persist) / (60)::double precision))::numeric, 2)
            ELSE NULL::numeric
        END AS minu,
        CASE
            WHEN (round(date_part('epoch'::text, defaut_logs.defaut_persist)) < (60)::double precision) THEN round((date_part('epoch'::text, defaut_logs.defaut_persist))::numeric, 2)
            ELSE NULL::numeric
        END AS sec
   FROM (public.defaut_logs
     LEFT JOIN public.antenne ant ON (((ant.mp)::text = (defaut_logs.mp)::text)))
  WHERE (ant.id IS NOT NULL)
  ORDER BY (round((date_part('epoch'::text, defaut_logs.defaut_persist) / (60)::double precision))) DESC;


ALTER TABLE public.defaut_day OWNER TO centipede;

--
-- Name: defaut_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: centipede
--

CREATE SEQUENCE public.defaut_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.defaut_logs_id_seq OWNER TO centipede;

--
-- Name: defaut_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: centipede
--

ALTER SEQUENCE public.defaut_logs_id_seq OWNED BY public.defaut_logs.id;


--
-- Name: defaut_minutes; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.defaut_minutes AS
 SELECT defaut_logs.id,
    defaut_logs.mp,
    date_trunc('hours'::text, defaut_logs.defaut) AS defaut,
        CASE
            WHEN ((round(date_part('epoch'::text, defaut_logs.defaut_persist)) < (3600)::double precision) AND (round(date_part('epoch'::text, defaut_logs.defaut_persist)) >= (60)::double precision)) THEN round(((date_part('epoch'::text, defaut_logs.defaut_persist) / (60)::double precision))::numeric, 2)
            ELSE NULL::numeric
        END AS minu,
    ant.id AS id_antenne
   FROM (public.defaut_logs
     LEFT JOIN public.antenne ant ON (((ant.mp)::text = (defaut_logs.mp)::text)))
  WHERE (ant.id IS NOT NULL)
  ORDER BY (round((date_part('epoch'::text, defaut_logs.defaut_persist) / (60)::double precision))) DESC;


ALTER TABLE public.defaut_minutes OWNER TO centipede;

--
-- Name: defaut_minutes_7d; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.defaut_minutes_7d AS
 SELECT defaut_logs.id,
    defaut_logs.mp,
    defaut_logs.defaut,
    defaut_logs.defaut_persist
   FROM public.defaut_logs
  WHERE (defaut_logs.defaut >= (now() - '7 days'::interval));


ALTER TABLE public.defaut_minutes_7d OWNER TO centipede;

--
-- Name: defaut_reseau_20s; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.defaut_reseau_20s AS
 SELECT d.mp,
    d.control,
    d.defaut_persist AS ti
   FROM (public.defaut d
     JOIN public.antenne a ON (((a.mp)::text = (d.mp)::text)))
  WHERE (d.defaut_count > 0)
  ORDER BY d.control DESC;


ALTER TABLE public.defaut_reseau_20s OWNER TO centipede;

--
-- Name: etat_1_2; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.etat_1_2 AS
 SELECT etat_antennes.mp,
        CASE
            WHEN (etat_antennes.ping = 'active'::text) THEN '1'::text
            WHEN (etat_antennes.ping = 'eteinte'::text) THEN '2'::text
            ELSE NULL::text
        END AS etat
   FROM public.etat_antennes
  ORDER BY etat_antennes.mp;


ALTER TABLE public.etat_1_2 OWNER TO centipede;

--
-- Name: etat_antenne_wgs84; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.etat_antenne_wgs84 AS
 SELECT etat_antennes.id,
    public.st_setsrid(public.st_makepoint((etat_antennes.longitude)::double precision, (etat_antennes.latitude)::double precision, (etat_antennes.altitude)::double precision), 4326) AS geom_wgs84,
    etat_antennes.mp,
    etat_antennes.ping,
    etat_antennes.check_activite,
    etat_antennes.longitude,
    etat_antennes.latitude,
    etat_antennes.altitude,
    etat_antennes.data_format,
    etat_antennes.rtcm_messages,
    etat_antennes.systeme,
    etat_antennes.frequence,
    etat_antennes.legal,
    etat_antennes.recepteur,
    etat_antennes.type_antenne,
    etat_antennes.rapport
   FROM public.etat_antennes;


ALTER TABLE public.etat_antenne_wgs84 OWNER TO centipede;

--
-- Name: etat_antennes2; Type: VIEW; Schema: public; Owner: centipede
--

CREATE VIEW public.etat_antennes2 AS
 SELECT antenne.id,
    public.st_transform(antenne.geom, 2154) AS anten,
    antenne.mp,
        CASE
            WHEN (d.defaut_count = 0) THEN 'active'::text
            ELSE 'eteinte'::text
        END AS ping,
    d.control AS check_activite,
    round(antenne.longitude, 5) AS longitude,
    round(antenne.latitude, 5) AS latitude,
    round(antenne.altitude, 3) AS altitude,
    btrim((antenne.format)::text, '"'::text) AS data_format,
    antenne.formatd AS rtcm_messages,
    antenne.navsys AS systeme,
    cb.frequence,
        CASE
            WHEN (con.mail IS NULL) THEN 0
            ELSE 1
        END AS legal,
    r.name AS recepteur,
    ta.name AS type_antenne,
    con.rapport
   FROM (((((public.antenne antenne
     LEFT JOIN public.carriertobuffer cb ON ((antenne.carrier = cb.carrier)))
     LEFT JOIN centipede.contact con ON ((con.id_antenne = antenne.id)))
     LEFT JOIN centipede.type_antenne ta ON ((ta.id = con.id_type_antenne)))
     LEFT JOIN centipede.recepteur r ON ((r.id = con.id_recepteur)))
     LEFT JOIN public.defaut d ON (((d.mp)::text = (antenne.mp)::text)))
  WHERE (antenne.longitude <> (0)::numeric)
  ORDER BY antenne.mp;


ALTER TABLE public.etat_antennes2 OWNER TO centipede;

--
-- Name: contact id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact ALTER COLUMN id SET DEFAULT nextval('centipede.contact_id_seq'::regclass);


--
-- Name: layer_styles id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.layer_styles ALTER COLUMN id SET DEFAULT nextval('centipede.layer_styles_id_seq1'::regclass);


--
-- Name: layer_styles_old id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.layer_styles_old ALTER COLUMN id SET DEFAULT nextval('centipede.layer_styles_id_seq'::regclass);


--
-- Name: ntripcaster id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.ntripcaster ALTER COLUMN id SET DEFAULT nextval('centipede.ntripcaster_id_seq'::regclass);


--
-- Name: recepteur id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.recepteur ALTER COLUMN id SET DEFAULT nextval('centipede.recepteur_id_seq'::regclass);


--
-- Name: structure id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.structure ALTER COLUMN id SET DEFAULT nextval('centipede.structure_id_seq'::regclass);


--
-- Name: type_antenne id; Type: DEFAULT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.type_antenne ALTER COLUMN id SET DEFAULT nextval('centipede.type_antenne_id_seq'::regclass);


--
-- Name: active_eteinte id; Type: DEFAULT; Schema: logs; Owner: centipede
--

ALTER TABLE ONLY logs.active_eteinte ALTER COLUMN id SET DEFAULT nextval('logs.active_eteinte_id_seq'::regclass);


--
-- Name: antenne id; Type: DEFAULT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.antenne ALTER COLUMN id SET DEFAULT nextval('public.antenne_id_seq'::regclass);


--
-- Name: antenne_futur id; Type: DEFAULT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.antenne_futur ALTER COLUMN id SET DEFAULT nextval('public.antenne_futur_id_seq'::regclass);


--
-- Name: commune id; Type: DEFAULT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.commune ALTER COLUMN id SET DEFAULT nextval('public.commune_id_seq'::regclass);


--
-- Name: defaut_logs id; Type: DEFAULT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.defaut_logs ALTER COLUMN id SET DEFAULT nextval('public.defaut_logs_id_seq'::regclass);


--
-- Name: layer_styles_old layer_styles_pkey; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.layer_styles_old
    ADD CONSTRAINT layer_styles_pkey PRIMARY KEY (id);


--
-- Name: layer_styles layer_styles_pkey1; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.layer_styles
    ADD CONSTRAINT layer_styles_pkey1 PRIMARY KEY (id);


--
-- Name: contact pk_contact; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT pk_contact PRIMARY KEY (id);


--
-- Name: ntripcaster pk_ntripcaster; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.ntripcaster
    ADD CONSTRAINT pk_ntripcaster PRIMARY KEY (id);


--
-- Name: structure pk_structure; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.structure
    ADD CONSTRAINT pk_structure PRIMARY KEY (id);


--
-- Name: recepteur recepteur_pkey; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.recepteur
    ADD CONSTRAINT recepteur_pkey PRIMARY KEY (id);


--
-- Name: type_antenne type_antenne_pkey; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.type_antenne
    ADD CONSTRAINT type_antenne_pkey PRIMARY KEY (id);


--
-- Name: contact uniq_rapport_name; Type: CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT uniq_rapport_name UNIQUE (rapport);


--
-- Name: active_eteinte active_eteinte_pkey; Type: CONSTRAINT; Schema: logs; Owner: centipede
--

ALTER TABLE ONLY logs.active_eteinte
    ADD CONSTRAINT active_eteinte_pkey PRIMARY KEY (id);


--
-- Name: defaut_logs defaut_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.defaut_logs
    ADD CONSTRAINT defaut_logs_pkey PRIMARY KEY (id);


--
-- Name: defaut mp_pkey; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.defaut
    ADD CONSTRAINT mp_pkey PRIMARY KEY (mp);


--
-- Name: antenne pk_antenne; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.antenne
    ADD CONSTRAINT pk_antenne PRIMARY KEY (id);


--
-- Name: antenne_futur pk_antenne_futur; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.antenne_futur
    ADD CONSTRAINT pk_antenne_futur PRIMARY KEY (id);


--
-- Name: carriertobuffer pk_carriertobuffer; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.carriertobuffer
    ADD CONSTRAINT pk_carriertobuffer PRIMARY KEY (carrier);


--
-- Name: commune pk_commune; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.commune
    ADD CONSTRAINT pk_commune PRIMARY KEY (id);


--
-- Name: antenne uniq_MP; Type: CONSTRAINT; Schema: public; Owner: centipede
--

ALTER TABLE ONLY public.antenne
    ADD CONSTRAINT "uniq_MP" UNIQUE (mp);


--
-- Name: ae_index; Type: INDEX; Schema: logs; Owner: centipede
--

CREATE INDEX ae_index ON logs.active_eteinte USING btree (id DESC NULLS LAST);


--
-- Name: antenna_ind; Type: INDEX; Schema: public; Owner: centipede
--

CREATE INDEX antenna_ind ON public.antenne USING gist (geom);


--
-- Name: defaut_logs_ind; Type: INDEX; Schema: public; Owner: centipede
--

CREATE INDEX defaut_logs_ind ON public.defaut_logs USING btree (id);


--
-- Name: index_geom_com; Type: INDEX; Schema: public; Owner: centipede
--

CREATE INDEX index_geom_com ON public.commune USING gist (geom);


--
-- Name: ntripcaster trig_ntripcaster2; Type: TRIGGER; Schema: centipede; Owner: centipede
--

CREATE TRIGGER trig_ntripcaster2 AFTER INSERT OR DELETE OR UPDATE ON centipede.ntripcaster FOR EACH ROW EXECUTE FUNCTION public.ntripcaster();


--
-- Name: defaut defaut_store; Type: TRIGGER; Schema: public; Owner: centipede
--

CREATE TRIGGER defaut_store BEFORE UPDATE ON public.defaut FOR EACH ROW EXECUTE FUNCTION centipede.defaut_store();


--
-- Name: antenne trig_make_point; Type: TRIGGER; Schema: public; Owner: centipede
--

CREATE TRIGGER trig_make_point BEFORE INSERT OR UPDATE ON public.antenne FOR EACH ROW EXECUTE FUNCTION public.make_point();


--
-- Name: antenne trig_ntripcaster; Type: TRIGGER; Schema: public; Owner: centipede
--

CREATE TRIGGER trig_ntripcaster AFTER INSERT OR DELETE OR UPDATE ON public.antenne FOR EACH ROW EXECUTE FUNCTION public.ntripcaster();


--
-- Name: contact fk_antenne; Type: FK CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT fk_antenne FOREIGN KEY (id_antenne) REFERENCES public.antenne(id);


--
-- Name: contact fk_recepteur; Type: FK CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT fk_recepteur FOREIGN KEY (id_recepteur) REFERENCES centipede.recepteur(id);


--
-- Name: contact fk_structure; Type: FK CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT fk_structure FOREIGN KEY (id_structure) REFERENCES centipede.structure(id);


--
-- Name: contact fk_type_antenne; Type: FK CONSTRAINT; Schema: centipede; Owner: centipede
--

ALTER TABLE ONLY centipede.contact
    ADD CONSTRAINT fk_type_antenne FOREIGN KEY (id_type_antenne) REFERENCES centipede.type_antenne(id);


--
-- Name: job cron_job_policy; Type: POLICY; Schema: cron; Owner: postgres
--

CREATE POLICY cron_job_policy ON cron.job USING ((username = CURRENT_USER));


--
-- Name: job_run_details cron_job_run_details_policy; Type: POLICY; Schema: cron; Owner: postgres
--

CREATE POLICY cron_job_run_details_policy ON cron.job_run_details USING ((username = CURRENT_USER));


--
-- Name: job; Type: ROW SECURITY; Schema: cron; Owner: postgres
--

ALTER TABLE cron.job ENABLE ROW LEVEL SECURITY;

--
-- Name: job_run_details; Type: ROW SECURITY; Schema: cron; Owner: postgres
--

ALTER TABLE cron.job_run_details ENABLE ROW LEVEL SECURITY;

--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: centipede
--

ALTER DEFAULT PRIVILEGES FOR ROLE centipede IN SCHEMA public REVOKE ALL ON TABLES  FROM centipede;
ALTER DEFAULT PRIVILEGES FOR ROLE centipede IN SCHEMA public GRANT SELECT ON TABLES  TO centipede;


--
-- PostgreSQL database dump complete
--
