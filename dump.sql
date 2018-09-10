--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.14
-- Dumped by pg_dump version 10.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: find_least_experienced_aircraft_member(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_least_experienced_aircraft_member() RETURNS text
    LANGUAGE plpgsql
    AS $$
declare
	least_experienced RECORD;
BEGIN
	SELECT c.first_name INTO least_experienced 
	FROM crew_members c 
	LEFT JOIN aircrafts_members am
	ON am.crew_id = c.id 
	WHERE am.crew_id IS NULL LIMIT 1;
	
	RETURN least_experienced.first_name;
END;	

$$;


--
-- Name: find_most_experienced_aircraft_member(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_most_experienced_aircraft_member() RETURNS text
    LANGUAGE plpgsql
    AS $$declare
	most_experienced RECORD;
BEGIN
	SELECT c.first_name INTO most_experienced 
    FROM crew_members c
    INNER JOIN aircrafts_members am ON am.crew_id = c.id 
    GROUP BY am.crew_id, c.first_name ORDER BY COUNT(*) DESC 
    LIMIT 1;

    RETURN most_experienced.first_name;
END;

$$;


--
-- Name: find_nth_oldest_crew_member(integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_nth_oldest_crew_member(offset_variable integer DEFAULT 1) RETURNS text
    LANGUAGE plpgsql
    AS $$declare
	nth_oldest RECORD;
BEGIN
	SELECT c.first_name INTO nth_oldest
	FROM crew_members c
	WHERE c.birth_data = (SELECT DISTINCT birth_data FROM crew_members ORDER BY 1 OFFSET offset_variable LIMIT 1)
	ORDER BY id LIMIT 1;
	RETURN nth_oldest.first_name;
END;
$$;


--
-- Name: find_oldest_crew_member(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.find_oldest_crew_member() RETURNS text
    LANGUAGE plpgsql
    AS $$declare
	firstName text;
BEGIN
   SELECT first_name into firstName FROM crew_members order by birth_data asc limit 1;
   RETURN firstName;
END;
$$;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: aircrafts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aircrafts (
    id integer NOT NULL,
    name text NOT NULL,
    engine text NOT NULL,
    date_created date NOT NULL,
    description text NOT NULL
);


--
-- Name: aircrafts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aircrafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aircrafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aircrafts_id_seq OWNED BY public.aircrafts.id;


--
-- Name: aircrafts_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.aircrafts_members (
    id integer NOT NULL,
    aircraft_id integer NOT NULL,
    crew_id integer NOT NULL,
    years_studied integer NOT NULL
);


--
-- Name: aircrafts_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.aircrafts_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aircrafts_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.aircrafts_members_id_seq OWNED BY public.aircrafts_members.id;


--
-- Name: crew_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crew_members (
    id integer NOT NULL,
    first_name text NOT NULL,
    last_name text NOT NULL,
    birth_data date NOT NULL,
    email text NOT NULL
);


--
-- Name: members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.members_id_seq OWNED BY public.crew_members.id;


--
-- Name: aircrafts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts ALTER COLUMN id SET DEFAULT nextval('public.aircrafts_id_seq'::regclass);


--
-- Name: aircrafts_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts_members ALTER COLUMN id SET DEFAULT nextval('public.aircrafts_members_id_seq'::regclass);


--
-- Name: crew_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crew_members ALTER COLUMN id SET DEFAULT nextval('public.members_id_seq'::regclass);


--
-- Data for Name: aircrafts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aircrafts (id, name, engine, date_created, description) FROM stdin;
1	North American X-15	CF6-40	1999-01-08	lightweight plane
2	Boeing 747–200	CF6-45	1999-01-08	lightweight plane
\.


--
-- Data for Name: aircrafts_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.aircrafts_members (id, aircraft_id, crew_id, years_studied) FROM stdin;
28	2	16	5
29	2	11	5
34	2	15	5
35	2	16	5
\.


--
-- Data for Name: crew_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.crew_members (id, first_name, last_name, birth_data, email) FROM stdin;
11	anttisa	antic	1971-07-13	antisa@gmail.com
13	marko	maric	1981-07-13	marko@gmail.com
14	marko2	maric2	1971-01-13	marko2@gmail.com
15	marko3	maric3	1952-02-13	marko3@gmail.com
16	ivica2	ivic2	1951-06-03	ivica21@gmail.com
17	marijo3	maric3	1992-12-01	marijo33@gmail.com
18	stipe	stipic	1952-02-13	stipe@gmail.com
\.


--
-- Name: aircrafts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aircrafts_id_seq', 2, true);


--
-- Name: aircrafts_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.aircrafts_members_id_seq', 35, true);


--
-- Name: members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.members_id_seq', 17, true);


--
-- Name: aircrafts_members aircrafts_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts_members
    ADD CONSTRAINT aircrafts_members_pkey PRIMARY KEY (id);


--
-- Name: aircrafts aircrafts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts
    ADD CONSTRAINT aircrafts_pkey PRIMARY KEY (id);


--
-- Name: crew_members members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crew_members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: fki_aircraft_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_aircraft_id ON public.aircrafts_members USING btree (aircraft_id);


--
-- Name: fki_crew_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_crew_id ON public.aircrafts_members USING btree (crew_id);


--
-- Name: aircrafts_members aircraft_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts_members
    ADD CONSTRAINT aircraft_id FOREIGN KEY (aircraft_id) REFERENCES public.aircrafts(id) ON DELETE CASCADE;


--
-- Name: aircrafts_members crew_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.aircrafts_members
    ADD CONSTRAINT crew_id FOREIGN KEY (crew_id) REFERENCES public.crew_members(id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

