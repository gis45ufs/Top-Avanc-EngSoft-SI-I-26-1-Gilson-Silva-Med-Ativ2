--
-- PostgreSQL database dump
--

\restrict 2LweuI37mS32tbHnbDRwXk9BhL5f4hK8xHJBULzJzpDjmt5rRip2a9cuNCgFIfj

-- Dumped from database version 17.8
-- Dumped by pg_dump version 17.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alternativas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alternativas (
    id_alternativa integer NOT NULL,
    id_pergunta integer NOT NULL,
    letra character varying(2) NOT NULL,
    texto text NOT NULL,
    is_correta boolean DEFAULT false NOT NULL
);


ALTER TABLE public.alternativas OWNER TO postgres;

--
-- Name: alternativas_id_alternativa_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alternativas_id_alternativa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alternativas_id_alternativa_seq OWNER TO postgres;

--
-- Name: alternativas_id_alternativa_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alternativas_id_alternativa_seq OWNED BY public.alternativas.id_alternativa;


--
-- Name: avaliacoes_humanas_atividade_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacoes_humanas_atividade_1 (
    id_avaliacao_humana integer NOT NULL,
    id_resposta_ativa1 integer NOT NULL,
    clinical_correctness_0_2 smallint,
    completeness_0_2 smallint,
    alignment_with_gold_0_2 smallint,
    safety_0_2 smallint,
    clarity_0_2 smallint,
    total_score_0_10 smallint,
    nota_humana_1a5 smallint,
    comentarios text,
    data_avaliacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT avaliacoes_humanas_atividade_1_alignment_with_gold_0_2_check CHECK (((alignment_with_gold_0_2 >= 0) AND (alignment_with_gold_0_2 <= 2))),
    CONSTRAINT avaliacoes_humanas_atividade_1_clarity_0_2_check CHECK (((clarity_0_2 >= 0) AND (clarity_0_2 <= 2))),
    CONSTRAINT avaliacoes_humanas_atividade_1_clinical_correctness_0_2_check CHECK (((clinical_correctness_0_2 >= 0) AND (clinical_correctness_0_2 <= 2))),
    CONSTRAINT avaliacoes_humanas_atividade_1_completeness_0_2_check CHECK (((completeness_0_2 >= 0) AND (completeness_0_2 <= 2))),
    CONSTRAINT avaliacoes_humanas_atividade_1_nota_humana_1a5_check CHECK (((nota_humana_1a5 >= 1) AND (nota_humana_1a5 <= 5))),
    CONSTRAINT avaliacoes_humanas_atividade_1_safety_0_2_check CHECK (((safety_0_2 >= 0) AND (safety_0_2 <= 2))),
    CONSTRAINT avaliacoes_humanas_atividade_1_total_score_0_10_check CHECK (((total_score_0_10 >= 0) AND (total_score_0_10 <= 10)))
);


ALTER TABLE public.avaliacoes_humanas_atividade_1 OWNER TO postgres;

--
-- Name: avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq OWNER TO postgres;

--
-- Name: avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq OWNED BY public.avaliacoes_humanas_atividade_1.id_avaliacao_humana;


--
-- Name: avaliacoes_juiz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avaliacoes_juiz (
    id_avaliacao integer NOT NULL,
    id_resposta_ativa1 integer NOT NULL,
    id_modelo_juiz integer NOT NULL,
    nota_atribuida smallint NOT NULL,
    chain_of_thought text NOT NULL,
    data_avaliacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT avaliacoes_juiz_nota_atribuida_check CHECK (((nota_atribuida >= 1) AND (nota_atribuida <= 5)))
);


ALTER TABLE public.avaliacoes_juiz OWNER TO postgres;

--
-- Name: avaliacoes_juiz_id_avaliacao_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.avaliacoes_juiz_id_avaliacao_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.avaliacoes_juiz_id_avaliacao_seq OWNER TO postgres;

--
-- Name: avaliacoes_juiz_id_avaliacao_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.avaliacoes_juiz_id_avaliacao_seq OWNED BY public.avaliacoes_juiz.id_avaliacao;


--
-- Name: datasets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.datasets (
    id_dataset integer NOT NULL,
    nome_dataset character varying(100) NOT NULL,
    dominio character varying(50) NOT NULL,
    tipo_questao character varying(30) NOT NULL,
    CONSTRAINT datasets_tipo_questao_check CHECK (((tipo_questao)::text = ANY ((ARRAY['aberta'::character varying, 'multipla_escolha'::character varying])::text[])))
);


ALTER TABLE public.datasets OWNER TO postgres;

--
-- Name: datasets_id_dataset_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.datasets_id_dataset_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.datasets_id_dataset_seq OWNER TO postgres;

--
-- Name: datasets_id_dataset_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.datasets_id_dataset_seq OWNED BY public.datasets.id_dataset;


--
-- Name: modelos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modelos (
    id_modelo integer NOT NULL,
    nome_modelo character varying(100) NOT NULL,
    versao character varying(50),
    papel character varying(20) NOT NULL,
    parametro_precisao character varying(20),
    observacoes text,
    CONSTRAINT modelos_papel_check CHECK (((papel)::text = ANY ((ARRAY['candidato'::character varying, 'juiz'::character varying])::text[])))
);


ALTER TABLE public.modelos OWNER TO postgres;

--
-- Name: modelos_id_modelo_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.modelos_id_modelo_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modelos_id_modelo_seq OWNER TO postgres;

--
-- Name: modelos_id_modelo_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.modelos_id_modelo_seq OWNED BY public.modelos.id_modelo;


--
-- Name: perguntas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perguntas (
    id_pergunta integer NOT NULL,
    id_dataset integer NOT NULL,
    official_id integer NOT NULL,
    enunciado text NOT NULL,
    resposta_ouro text NOT NULL,
    metadados jsonb DEFAULT '{}'::jsonb NOT NULL
);


ALTER TABLE public.perguntas OWNER TO postgres;

--
-- Name: perguntas_id_pergunta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perguntas_id_pergunta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.perguntas_id_pergunta_seq OWNER TO postgres;

--
-- Name: perguntas_id_pergunta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perguntas_id_pergunta_seq OWNED BY public.perguntas.id_pergunta;


--
-- Name: respostas_atividade_1; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.respostas_atividade_1 (
    id_resposta integer NOT NULL,
    id_pergunta integer NOT NULL,
    id_modelo integer NOT NULL,
    texto_resposta text NOT NULL,
    tempo_inferencia_ms double precision,
    data_geracao timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    origem character varying(50) DEFAULT 'atividade_1'::character varying NOT NULL
);


ALTER TABLE public.respostas_atividade_1 OWNER TO postgres;

--
-- Name: respostas_atividade_1_id_resposta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.respostas_atividade_1_id_resposta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.respostas_atividade_1_id_resposta_seq OWNER TO postgres;

--
-- Name: respostas_atividade_1_id_resposta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.respostas_atividade_1_id_resposta_seq OWNED BY public.respostas_atividade_1.id_resposta;


--
-- Name: alternativas id_alternativa; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas ALTER COLUMN id_alternativa SET DEFAULT nextval('public.alternativas_id_alternativa_seq'::regclass);


--
-- Name: avaliacoes_humanas_atividade_1 id_avaliacao_humana; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_humanas_atividade_1 ALTER COLUMN id_avaliacao_humana SET DEFAULT nextval('public.avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq'::regclass);


--
-- Name: avaliacoes_juiz id_avaliacao; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_juiz ALTER COLUMN id_avaliacao SET DEFAULT nextval('public.avaliacoes_juiz_id_avaliacao_seq'::regclass);


--
-- Name: datasets id_dataset; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets ALTER COLUMN id_dataset SET DEFAULT nextval('public.datasets_id_dataset_seq'::regclass);


--
-- Name: modelos id_modelo; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modelos ALTER COLUMN id_modelo SET DEFAULT nextval('public.modelos_id_modelo_seq'::regclass);


--
-- Name: perguntas id_pergunta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perguntas ALTER COLUMN id_pergunta SET DEFAULT nextval('public.perguntas_id_pergunta_seq'::regclass);


--
-- Name: respostas_atividade_1 id_resposta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respostas_atividade_1 ALTER COLUMN id_resposta SET DEFAULT nextval('public.respostas_atividade_1_id_resposta_seq'::regclass);


--
-- Data for Name: alternativas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alternativas (id_alternativa, id_pergunta, letra, texto, is_correta) FROM stdin;
1	16	A	Adjustment of the warfarin dosage to maintain an INR between 1.5 and	f
2	16	B	Ciprofloxacin therapy	f
3	16	C	Cystoscopy	t
4	16	D	Discontinuation of hydrochlorothiazide therapy	f
5	16	E	Finasteride therapy	f
6	17	A	Bed rest	f
7	17	B	Closed reduction followed by traction	f
8	17	C	Hip spica hinge brace	f
9	17	D	Limited weight bearing with use of crutches	f
10	17	E	Operative reduction and internal fixation	t
11	18	A	Alcohol cessation	f
12	18	B	Smoking cessation	f
13	18	C	Weight loss program	f
14	18	D	Antihypertensive therapy	t
15	18	E	Cholesterol-lowering therapy	f
16	19	A	Haemophilus influenzae	f
17	19	B	Influenza A virus	t
18	19	C	Legionella pneumophila	f
19	19	D	Mycobacterium tuberculosis	f
20	19	E	Pseudomonas aeruginosa	f
21	20	A	Attention-deficit/hyperactivity disorder	f
22	20	B	Expressive language disorder	f
23	20	C	Intellectual developmental disorder	f
24	20	D	Learning disorder	t
25	20	E	Social anxiety disorder (social phobia)	f
26	21	A	Cerumen impaction	f
27	21	B	Ear canal trauma	f
28	21	C	Otitis externa	t
29	21	D	Polychondritis	f
30	21	E	Seborrheic dermatitis	f
31	22	A	CT scan of the sinuses	f
32	22	B	Gram stain and culture of nasal discharge	f
33	22	C	Ibuprofen and decongestant therapy	t
34	22	D	Trimethoprim-sulfamethoxazole therapy	f
35	22	E	X-ray of the sinuses	f
36	23	A	Bronchospasm	f
37	23	B	Laryngeal braking	f
38	23	C	Subglottic mass	f
39	23	D	Tracheal collapse	t
40	23	E	Upper airway compression	f
41	24	A	Accept the surgeon’s answer and only pursue further action if there is	f
42	24	B	Determine whether other staff have noticed anything different about	f
43	24	C	Inform the surgeon that he should consider retirement	f
44	24	D	Instruct the surgeon to take a temporary leave of absence and undergo	t
45	25	A	CT scan of the cervical spine	f
46	25	B	Electromyography and nerve conduction studies	f
47	25	C	Lumbar puncture for examination of cerebrospinal fluid	f
48	25	D	Measurement of serum Lyme (Borrelia burgdorferi) antibody	f
49	25	E	MRI of the brain	t
50	26	A	Amyloid plaque imaging	f
51	26	B	Determination of ApoE allele status	f
52	26	C	Measurement of beta-amyloid in the cerebrospinal fluid	f
53	26	D	MRI of the brain with volumetric analysis	f
54	26	E	No additional diagnostic studies are indicated	t
55	27	A	Add carbamazepine to the medication regimen	f
56	27	B	Add dantrolene to the medication regimen	f
57	27	C	Add haloperidol to the medication regimen	f
58	27	D	Discontinue paroxetine and duloxetine	t
59	27	E	Switch from duloxetine to olanzapine	f
60	28	A	Begin clonazepam therapy	f
61	28	B	Begin risperidone therapy	f
62	28	C	Begin sertraline therapy	f
63	28	D	Determine whether the patient has friends or family who can monitor	f
64	28	E	Determine whether the patient has had thoughts of harming others	t
65	29	A	Cervical carcinoma	f
66	29	B	External hemorrhoids	f
67	29	C	Rectal carcinoma	f
68	29	D	Rectal polyps	f
69	29	E	Vulvar carcinoma	t
70	30	A	CT scan of the neck	f
71	30	B	Fine-needle aspiration biopsy	f
72	30	C	Reexamination in 3 months	f
73	30	D	Surgical excision	f
74	30	E	Ultrasonography of the thyroid gland	t
75	31	A	Lopinavir-ritonavir and trimethoprim-sulfamethoxazole	f
76	31	B	Lopinavir-ritonavir only	f
77	31	C	Penicillin	f
78	31	D	Trimethoprim-sulfamethoxazole only	f
79	31	E	Zidovudine (AZT)	t
80	32	A	Biopsy of the pituitary gland	f
81	32	B	Cabergoline therapy	t
82	32	C	Gamma knife radiation to the pituitary gland	f
83	32	D	Oral contraceptive therapy	f
84	32	E	Transsphenoidal pituitary surgery	f
85	33	A	Measurement of prothrombin time and partial thromboplastin time	f
86	33	B	Measurement of stool reducing substances	f
87	33	C	Stool culture	f
88	33	D	Upper gastrointestinal series	f
89	33	E	X-ray of the abdomen	t
90	34	A	The patient received appropriate care under the circumstances	f
91	34	B	The pediatric surgeon at the suburban hospital should have insisted on	f
92	34	C	The rural hospital should have sent the patient directly to the	f
93	34	D	The suburban hospital executed unethical but legal conduct in this case	f
94	34	E	The suburban hospital violated the Emergency Medical Treatment and	t
95	35	A	Interview following amobarbital administration	f
96	35	B	Measurement of serum antiepileptic concentration	f
97	35	C	Measurement of serum creatine kinase activity	f
98	35	D	Neuropsychological testing	f
99	35	E	Video EEG monitoring	t
100	36	A	Azithromycin therapy	f
101	36	B	CT angiography	f
102	36	C	Electrocardiography	f
103	36	D	Ibuprofen therapy	t
104	36	E	Prednisone therapy	f
105	37	A	Gonadal dysgenesis 45,X (Turner syndrome)	f
106	37	B	Hypothalamic hypogonadism	t
107	37	C	Polycystic ovarian syndrome	f
108	37	D	Premature ovarian failure	f
109	37	E	Prolactinoma	f
110	38	A	Estradiol	f
111	38	B	Follicle-stimulating hormone	t
112	38	C	?-hCG	f
113	38	D	Luteinizing hormone	f
114	38	E	Progesterone	f
115	39	A	Amoxicillin as needed for febrile illness	f
116	39	B	Instructions for the parents to palpate the long bones routinely	f
117	39	C	Instructions for the parents to take and record the patient’s pulse daily	f
118	39	D	Low-dose aspirin therapy	f
119	39	E	Oral prophylactic penicillin therapy	t
120	40	A	Air-contrast enema	f
121	40	B	Ultrasonography of the abdomen	t
122	40	C	Upper gastrointestinal series	f
123	40	D	Colonoscopy	f
124	40	E	Esophagogastroduodenoscopy	f
125	41	A	Pulmonary function tests	f
126	41	B	CT scan of the chest	f
127	41	C	Course of prednisone	f
128	41	D	Discontinuation of lisinopril	t
129	41	E	Use of a cough suppressant	f
130	42	A	Maternal fever	f
131	42	B	Maternal tachycardia	f
132	42	C	Neonatal acidosis	f
133	42	D	Neonatal arrhythmia	f
134	42	E	Neonatal respiratory depression	t
\.


--
-- Data for Name: avaliacoes_humanas_atividade_1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avaliacoes_humanas_atividade_1 (id_avaliacao_humana, id_resposta_ativa1, clinical_correctness_0_2, completeness_0_2, alignment_with_gold_0_2, safety_0_2, clarity_0_2, total_score_0_10, nota_humana_1a5, comentarios, data_avaliacao) FROM stdin;
1	1	2	2	2	2	2	10	5	Correct, safe, clear, and well aligned with the gold-standard answer.	2026-04-23 16:44:41.964307
2	2	2	2	2	2	2	10	5	Correct, safe, clear, and well aligned with the gold-standard answer; expands on possible causes and warning signs without contradicting the specialist answer.	2026-04-23 16:44:41.964307
3	3	2	2	2	2	2	10	5	Correct, safe, and clear; maintains the recommendation for medical evaluation and presents plausible causes without contradicting the gold-standard answer.	2026-04-23 16:44:41.964307
4	4	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it advises against abrupt discontinuation and emphasizes the need for medical supervision.	2026-04-23 16:44:41.964307
5	5	1	2	1	1	2	7	4	Clear and relatively complete, but less safe and less aligned with the gold-standard answer because it suggests that abrupt discontinuation may be acceptable in some cases, which weakens the main recommendation to avoid stopping the medication suddenly without medical supervision.	2026-04-23 16:44:41.964307
6	6	2	2	2	2	2	10	5	Correct, safe, and well aligned with the gold-standard answer; it highlights the long half-life of fluoxetine, the lower risk of withdrawal symptoms, and the need for supervised tapering.	2026-04-23 16:44:41.964307
7	7	2	1	2	2	2	9	5	Correct, safe, and well aligned with the gold-standard answer regarding recovery time and warning signs, but less complete because it does not mention symptom relief measures or other factors that can influence recovery.	2026-04-23 16:44:41.964307
8	8	1	2	1	2	2	8	4	Clear and reasonably complete, but less aligned with the gold-standard answer because it suggests a shorter expected duration for severe strains, whereas the specialist answer notes that severe cases may last for months.	2026-04-23 16:44:41.964307
9	9	2	1	2	2	2	9	5	Correct, clear, safe, and well aligned with the gold-standard answer; it distinguishes recovery time by severity, notes that full recovery may take weeks to months, and includes relevant warning signs, but it is slightly less complete because it does not mention symptom relief measures or other factors that may affect recovery.	2026-04-23 16:44:41.964307
10	10	2	1	2	2	2	9	5	Correct, clear, and safe; it explains what creatinine is and its relationship to kidney function, but it is less complete than the gold-standard answer because it does not mention eGFR, urine, intense exercise, or medications.	2026-04-23 16:44:41.964307
11	11	2	1	2	2	2	9	5	Correct, clear, and safe; it describes creatinine as a marker of kidney function, but it is less complete than the gold-standard answer because it does not address eGFR, urine findings, or transient factors such as exercise or medications.	2026-04-23 16:44:41.964307
12	12	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it explains the relationship between creatinine and kidney filtration and appropriately mentions interpretation together with eGFR.	2026-04-23 16:44:41.964307
13	13	2	1	2	2	2	9	5	Correct, clear, and safe; it recognizes Abreva/docosanol as an option for cold sores, states that it is not a cure, and recommends medical evaluation if the condition is more severe, but it is less complete than the gold-standard answer.	2026-04-23 16:44:41.964307
14	14	2	2	1	2	2	9	5	Correct, clear, and safe, but less aligned with the gold-standard answer because it presents the benefit more categorically, whereas the specialist answer emphasizes mixed evidence regarding the effectiveness of docosanol.	2026-04-23 16:44:41.964307
15	15	2	2	1	2	2	9	5	Correct, clear, and safe, but less aligned with the gold-standard answer because it presents the effectiveness of docosanol more directly, whereas the specialist answer highlights conflicting evidence.	2026-04-23 16:44:41.964307
16	16	2	1	2	2	2	9	5	Correct, clear, and safe; it conditions the use of Tinactin on the lesion truly being fungal and recommends medical evaluation if the diagnosis is uncertain or if there is no improvement, but it is less complete than the gold-standard answer.	2026-04-23 16:44:41.964307
17	17	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it recognizes the use of Tinactin for superficial fungal infections and appropriately defines situations in which medical evaluation is needed.	2026-04-23 16:44:41.964307
18	18	1	1	1	2	2	7	4	Clear and safe, but only partially aligned with the gold-standard answer; it accepts the use of Tinactin, but focuses more on general diagnostic cautions and does not cover the typical indications and expected treatment approach as well.	2026-04-23 16:44:41.964307
19	19	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it appropriately distinguishes amoxicillin alone from Augmentin and explains the role of clavulanate.	2026-04-23 16:44:41.964307
20	20	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it explains that Augmentin contains amoxicillin with clavulanate and that this broadens activity against resistant bacteria.	2026-04-23 16:44:41.964307
21	21	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it appropriately distinguishes Augmentin from amoxicillin and explains in technical terms how clavulanate affects bacterial resistance.	2026-04-23 16:44:41.964307
22	22	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it recognizes the serotonergic risk, recommends medical supervision, and mentions relevant warning symptoms.	2026-04-23 16:44:41.964307
23	23	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it acknowledges that the combination may be used in clinical practice, while still emphasizing the need for supervision and monitoring for serotonin syndrome.	2026-04-23 16:44:41.964307
24	24	2	1	2	2	2	9	5	Correct, clear, and safe; it recognizes the serotonergic risk and the need for medical supervision, but it is slightly less complete than the gold-standard answer because it mentions fewer specific warning symptoms.	2026-04-23 16:44:41.964307
25	25	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly states that Saxenda is a daily subcutaneous injection and mentions the use of a multi-dose device after proper instruction.	2026-04-23 16:44:41.964307
26	26	2	1	2	2	2	9	5	Correct, clear, and safe; it correctly states that Saxenda is a daily subcutaneous injection, but it is less complete than the gold-standard answer because it does not explicitly mention the multi-dose pen or self-administration after proper instruction.	2026-04-23 16:44:41.964307
27	27	2	1	2	2	2	9	5	Correct, clear, and safe; it correctly states that Saxenda is a daily subcutaneous injection, but it is less complete than the gold-standard answer because it does not explicitly highlight the multi-dose pen or self-administration after proper instruction.	2026-04-23 16:44:41.964307
28	28	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it directly states that Valtrex is the brand name for valacyclovir and gives clinically appropriate examples of use.	2026-04-23 16:44:41.964307
29	29	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly identifies Valtrex as the commercial name for valacyclovir and adds a useful note about brand and generic equivalence.	2026-04-23 16:44:41.964307
30	30	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it adequately explains that Valtrex is the brand name for valacyclovir and adds compatible technical details about the drug.	2026-04-23 16:44:41.964307
31	31	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it states that isotretinoin is not an antibiotic and correctly emphasizes the serious pregnancy risk.	2026-04-23 16:44:41.964307
32	32	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it identifies isotretinoin as a retinoid rather than an antibiotic and appropriately reinforces the need for pregnancy prevention during treatment.	2026-04-23 16:44:41.964307
33	33	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it explains that isotretinoin is not an antibiotic, highlights the risk of severe birth defects, and appropriately mentions contraception and monitoring.	2026-04-23 16:44:41.964307
34	34	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly states that blepharitis is generally not contagious and mentions compatible causes.	2026-04-23 16:44:41.964307
35	35	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it appropriately states that blepharitis is not contagious and adds hygiene guidance without contradicting the specialist answer.	2026-04-23 16:44:41.964307
36	36	2	2	1	2	2	9	5	Correct, clear, and safe; it appropriately states that blepharitis is not contagious, but it is slightly less aligned with the gold-standard answer because it adds secondary transmission-related nuances that are not central to the specialist response.	2026-04-23 16:44:41.964307
37	37	2	1	2	2	2	9	5	Correct, clear, and safe; it correctly states that a “flu test” and an “influenza test” are equivalent, but it is less complete than the gold-standard answer because it does not address the clinical context, specimen collection, or when testing is most indicated.	2026-04-23 16:44:41.964307
38	38	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it explains that a “flu test” and an “influenza test” are equivalent and adds useful information about test types and diagnostic limitations without contradicting the specialist answer.	2026-04-23 16:44:41.964307
39	39	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly states that “flu” means influenza and adds useful details about test type, specimen, and the time window in which testing has the best diagnostic yield.	2026-04-23 16:44:41.964307
40	40	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly distinguishes ibuprofen from acetaminophen/paracetamol and makes it clear that Tylenol does not contain ibuprofen.	2026-04-23 16:44:41.964307
41	41	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it appropriately explains that ibuprofen and Tylenol are different medications and correctly separates ibuprofen from acetaminophen/paracetamol.	2026-04-23 16:44:41.964307
42	42	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it correctly distinguishes ibuprofen from Tylenol and adds useful guidance about labels and combination products without contradicting the specialist answer.	2026-04-23 16:44:41.964307
43	43	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it explains that abscesses usually cause pain but can sometimes be painless, and it appropriately recommends medical evaluation.	2026-04-23 16:44:41.964307
44	44	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it recognizes that painless abscesses can occur and appropriately reinforces the need for medical evaluation.	2026-04-23 16:44:41.964307
45	45	2	2	2	2	2	10	5	Correct, clear, safe, and well aligned with the gold-standard answer; it appropriately states that abscesses can be painless and recommends clinical evaluation for diagnostic clarification.	2026-04-23 16:44:41.964307
\.


--
-- Data for Name: avaliacoes_juiz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avaliacoes_juiz (id_avaliacao, id_resposta_ativa1, id_modelo_juiz, nota_atribuida, chain_of_thought, data_avaliacao) FROM stdin;
46	2	6	4	The candidate AI response is clinically sound and aligns well with the gold-standard reference answer, emphasizing the need for medical evaluation for persistent muscle pain without exercise and listing possible causes. It also provides guidance on when to seek urgent care and the potential need for medical assessment and lab tests, demonstrating good medical reasoning and attention to safety.	2026-04-27 00:55:32.699837
47	3	6	3	The candidate AI response is clinically acceptable and broadly correct, highlighting potential causes of muscle aches without exercise, such as viral infections, medication side effects, and rheumatologic conditions. It also provides safety guidance by recommending medical evaluation if the condition persists, worsens, or is disabling, and advises against prolonged self-medication with anti-inflammatories. However, it lacks the detail and comprehensive approach of the gold-standard reference answer, which emphasizes the importance of a full history, physical examination, and possible laboratory studies and imaging for an accurate diagnosis.	2026-04-27 00:55:35.482347
48	1	6	3	The candidate AI response is clinically acceptable and broadly correct, emphasizing the need for medical evaluation of persistent muscle pain without exercise, especially with worsening symptoms or specific red flags like dark urine or significant weakness. It lists possible causes and advises seeking urgent care under certain conditions, which aligns with safety principles. However, it lacks the comprehensive approach of the gold-standard answer, such as detailing the importance of a full history, physical examination, and possible laboratory studies and imaging for an accurate diagnosis.	2026-04-27 00:55:36.673126
49	5	6	4	The candidate AI response is broadly correct and emphasizes the importance of medical guidance for discontinuing Prozac, which aligns with the gold standard. It also mentions the drug's long half-life and the potential for abrupt stopping to be tolerated in some cases, but always under medical supervision. The response does not provide a specific tapering schedule as the gold standard does, but it does suggest a gradual taper may be necessary based on patient factors, which is clinically acceptable.	2026-04-27 00:55:37.769977
50	6	6	3	The candidate AI response is clinically acceptable and aligns with the gold standard by advising against abrupt discontinuation of Fluoxetine (Prozac) and recommending dosage tapering under medical supervision, which prioritizes patient safety and acknowledges the potential for withdrawal symptoms. However, it lacks the specific guidance on the tapering period (1-2 weeks) provided in the gold standard, making it not fully detailed but still safe and broadly correct.	2026-04-27 00:55:38.687735
51	4	6	3	The candidate AI response is clinically acceptable and broadly correct, emphasizing the importance of not stopping fluoxetine abruptly due to the risk of withdrawal symptoms, even though it has a lower risk compared to other SSRIs. It also correctly advises discussing dose reduction with the prescribing clinician and avoiding abrupt withdrawal unless there's a serious adverse effect, aligning with the gold standard's recommendation for a gradual reduction under medical supervision. However, it lacks specific details on the weaning period, such as the duration (1-2 weeks) and the dose (20mg) provided in the gold-standard reference answer.	2026-04-27 00:55:39.866769
52	8	6	3	The candidate AI response provides a generally accurate timeline for recovery from a muscle strain and appropriately suggests rest, ice, and anti-inflammatories as treatment, aligning with the gold standard. However, it lacks detail on when to seek medical attention beyond worsening pain, persistence beyond two weeks, weakness, or significant swelling, and does not mention the importance of considering the severity and location of the injury, personal health history, and age in recovery time. Despite this, the response does not contain critical errors, omit essential safety steps, or demonstrate major diagnostic misunderstandings, making it clinically acceptable but incomplete.	2026-04-27 00:55:41.023279
53	9	6	3	The candidate AI response provides a generally accurate timeline for the recovery of muscle strains, categorizing them by severity and providing a timeframe for when acute pain may resolve. It also offers guidance on when to seek medical evaluation, which aligns with safety principles by advising users to seek help if pain does not improve within a certain timeframe or if severe symptoms occur. However, the response lacks detailed information on how to manage symptoms (such as the application of ice, use of elastic bandages, and specific medications like acetaminophen or ibuprofen) and does not fully address the importance of individual health history and age in recovery, which are mentioned in the gold-standard reference answer.	2026-04-27 00:55:42.327105
54	7	6	3	The candidate AI response is broadly correct in stating that many cases of muscle strain start to feel better within about 2 weeks, but it lacks essential details such as the importance of rest, ice, and compression, as well as specific guidance on medication and when to seek care, which are all present in the gold-standard reference answer. However, it does not contain any critical errors, dangerous recommendations, or major diagnostic misunderstandings, and it provides some basic safety advice by suggesting when to seek care.	2026-04-27 00:55:43.347238
55	11	6	3	The candidate AI response is broadly correct and identifies creatinine as a waste product related to muscle metabolism that is filtered by the kidneys, serving as a key marker of kidney function. It also provides a normal range and advises interpretation of results with a doctor, which is safe and responsible. However, it lacks detail on how creatinine levels are used to assess kidney function, such as the calculation of eGFR, and does not mention factors like intense exercise and certain medications that can temporarily affect serum creatinine levels, making it not fully aligned with the gold standard in terms of completeness and nuance.	2026-04-27 00:55:44.621106
56	12	6	3	The candidate AI response accurately describes creatinine as a waste product from muscle metabolism and its role in assessing renal function, aligning with key points from the gold-standard reference answer. However, it lacks detail on how creatinine levels are used (e.g., calculation of eGFR) and does not mention factors like intense exercise and certain medications that can temporarily elevate serum creatinine levels, which are important for comprehensive understanding and interpretation of test results.	2026-04-27 00:55:45.698546
57	10	6	3	The candidate AI response is broadly correct in stating that creatinine is a waste product from muscle breakdown and that kidneys remove it, which helps assess kidney function. However, it lacks important details such as the factors that can temporarily elevate serum creatinine levels (like intense exercise and some medications) and the use of creatinine levels to calculate eGFR for assessing kidney function, as mentioned in the gold-standard reference answer. The response is clinically acceptable but incomplete, aligning with a mid-range score for its brevity and omission of key points.	2026-04-27 00:55:46.912372
58	14	6	3	The candidate AI response is clinically acceptable and broadly correct, aligning with the gold standard by stating that Abreva (docosanol) is an FDA-approved over-the-counter antiviral for cold sores and can shorten healing time when applied early. However, it lacks important follow-up details and nuance, such as the mixed results regarding Abreva's efficacy and the fact that it does not cure HSV1 or HSV2, which are present in the gold-standard reference answer.	2026-04-27 00:55:47.922845
59	15	6	3	The candidate AI response is clinically acceptable and broadly correct, providing accurate information about Abreva's mechanism of action and its effectiveness when applied at the first sign of symptoms. However, it lacks important follow-up details and nuance present in the gold standard, such as the mixed results regarding Abreva's efficacy, the natural resolution of cold sores, and the potential use of other medications like lidocaine or acyclovir for symptom alleviation or more severe cases.	2026-04-27 00:55:49.069833
88	44	6	4	The candidate AI response is clinically sound and aligns well with the gold-standard reference answer, acknowledging that painless abscesses can occur, especially in specific patient populations, and emphasizing the importance of medical evaluation regardless of pain level to prevent progression to sepsis. It demonstrates good medical reasoning and prioritizes patient safety without omitting essential safety steps or showing diagnostic misunderstandings.	2026-04-27 00:57:19.963015
60	13	6	3	The candidate AI response is broadly correct in stating that Abreva (docosanol) can help treat cold sores, especially if started early, and that it may shorten healing time and reduce symptoms, but it is not a cure. However, it lacks important follow-up details and nuance, such as the mixed results regarding the efficacy of Abreva, the importance of seeking medical advice for severe recurrences, and the availability of alternative treatments like oral antiviral medication. The response does not contain any critical errors or major diagnostic misunderstandings, but its incompleteness and lack of alignment with the gold standard prevent it from being considered a very good or excellent answer.	2026-04-27 00:55:50.139684
61	17	6	3	The candidate AI response is clinically acceptable and broadly correct, recommending Tinactin for superficial fungal infections like ringworm or athlete's foot, while also noting its ineffectiveness against Candida and advising a doctor's visit if no improvement is seen within 2 weeks or if the area involves nails, scalp, or genitals. However, it lacks some important follow-up details and nuance present in the gold standard, such as the specific treatment duration and alternative treatments for fungal nail infections.	2026-04-27 00:55:51.155621
62	18	6	3	The candidate AI response is clinically acceptable and broadly correct, as it suggests the use of an OTC antifungal like Tinactin for a potential fungal infection, which aligns with the gold standard. However, it lacks important follow-up details and nuance, such as the specific duration of treatment and the possibility of oral systemic antifungal therapy for severe infections, which are mentioned in the gold standard. The response also provides some safety precautions, like avoiding use on severely broken skin, but does not fully address all potential safety concerns or differential diagnoses.	2026-04-27 00:55:52.135491
63	16	6	3	The candidate AI response is broadly correct in suggesting the use of an OTC antifungal like Tinactin for common fungal infections such as athlete's foot, jock itch, or ringworm, but it lacks detail on application frequency and duration, and does not address the limitations of topical treatments for fungal nail infections or the potential need for oral systemic antifungal therapy for severe cases, thus it is incomplete but does not pose a significant safety risk.	2026-04-27 00:55:53.136365
64	20	6	5	The candidate AI response accurately distinguishes between Augmentin and amoxicillin, correctly identifying that Augmentin is a combination of amoxicillin and clavulanate potassium, which enhances its effectiveness against a broader range of bacteria by inhibiting bacterial resistance mechanisms. The response also appropriately notes the difference in usage between the two, reserving Augmentin for more complex or resistant infections, and emphasizes the importance of medical guidance for their use, demonstrating a strong alignment with the gold standard and prioritizing patient safety.	2026-04-27 00:55:54.164083
65	21	6	5	The candidate AI response accurately distinguishes Augmentin from amoxicillin, correctly identifying it as a combination of amoxicillin and potassium clavulanate, and explains the role of clavulanate in protecting the antibiotic from beta-lactamases, thus broadening its spectrum of activity. The response also appropriately notes the potential for increased gastrointestinal side effects and emphasizes the importance of using the medication as prescribed, demonstrating good medical reasoning and alignment with the gold standard.	2026-04-27 00:55:55.095706
66	19	6	5	The candidate AI response accurately distinguishes Augmentin from amoxicillin, correctly identifying that Augmentin contains both amoxicillin and clavulanate, which helps overcome bacterial resistance and broadens its spectrum of activity. This response aligns well with the gold-standard reference answer, demonstrating a clear understanding of the pharmacological difference between the two medications without omitting essential safety information or promoting harmful practices.	2026-04-27 00:55:58.119071
67	23	6	4	The candidate AI response is broadly correct and aligns with the gold standard by acknowledging the risk of serotonin syndrome when combining Buspar and Zoloft, emphasizing the need for medical supervision, and warning against adjusting medications without a doctor's guidance. However, it does not fully detail the symptoms of serotonin syndrome as comprehensively as the gold standard, which might be considered a lack of important follow-up details.	2026-04-27 00:56:02.240482
68	24	6	3	The candidate AI response is broadly correct in stating that the combination of Buspar and Zoloft can increase the risk of serotonin syndrome, a serious condition. However, it does not fully align with the gold standard in terms of providing a comprehensive list of symptoms of serotonin syndrome and does not explicitly mention the need for immediate medical attention if serotonin syndrome is suspected. Despite this, the response does convey the importance of professional medical supervision and the potential risks associated with the combination, making it clinically acceptable but not fully detailed.	2026-04-27 00:56:06.551838
69	22	6	4	The candidate AI response is broadly correct and aligns with the gold-standard reference answer by acknowledging the risk of serotonin syndrome when combining Buspar and Zoloft, and it advises medical supervision and lists symptoms that warrant seeking medical advice. However, it does not fully detail all potential symptoms of serotonin syndrome as comprehensively as the gold standard, which might be considered a lack of completeness but does not compromise patient safety directly.	2026-04-27 00:56:09.677196
70	26	6	4	The candidate AI response accurately states that Saxenda is a once-daily subcutaneous injection, which aligns with the gold-standard reference answer. It also provides additional relevant information about the dosage and the importance of using it alongside diet and exercise under medical supervision, enhancing patient safety and adherence to the treatment regimen. However, it does not explicitly mention that it is suitable for self-injection after proper explanation, a detail present in the gold standard. Despite this, the response does not contain critical errors, omit essential safety steps, or show major diagnostic misunderstandings, making it clinically acceptable and broadly correct.	2026-04-27 00:56:12.975789
71	27	6	5	The candidate AI response accurately states that Saxenda is a once-daily subcutaneous injection, which aligns with the gold-standard reference answer. It also provides additional, clinically relevant details such as the suitable injection sites, the importance of administering the dose at the same time each day, and what to do if a dose is missed, all of which enhance patient safety and adherence to the medication regimen. The response demonstrates a strong understanding of the medication's use and safety profile, closely aligning with the gold standard without introducing any critical errors or omissions that could compromise patient safety.	2026-04-27 00:56:16.41397
72	25	6	5	The candidate AI response accurately states that Saxenda is given as a once-daily subcutaneous injection, aligning with the gold-standard reference answer. It also mentions the use of a prefilled multi-dose pen and the need for proper instruction, which are crucial for patient safety and effective use of the medication. The response is concise, clear, and free of critical errors or omissions that could compromise patient safety.	2026-04-27 00:56:20.601443
73	29	6	4	The candidate AI response accurately identifies Valtrex as the brand name for valacyclovir and correctly states that they are identical in active ingredient, dosing, and efficacy, with the primary difference being price. However, it slightly deviates from the gold standard by mentioning the treatment of herpes infections (cold sores, genital herpes) in addition to shingles and chickenpox, which are the specific conditions mentioned in the gold standard. Despite this, the response does not introduce any critical errors, safety concerns, or major diagnostic misunderstandings, and it aligns well with the gold standard in terms of pharmacologic accuracy.	2026-04-27 00:56:23.755154
74	30	6	4	The candidate AI response accurately identifies Valtrex as the brand name for the generic drug valacyclovir and correctly states its use for herpes simplex and varicella-zoster infections, aligning with the gold standard. It also provides additional relevant information about the mechanism of action and the importance of following healthcare provider instructions, demonstrating good medical reasoning and attention to safety, but it slightly diverges from the gold standard by mentioning herpes simplex, which is not included in the reference answer.	2026-04-27 00:56:26.801688
75	28	6	3	The candidate AI response is clinically acceptable and broadly correct but incomplete, lacking specific details about the varicella-zoster virus and its role in shingles and chickenpox.	2026-04-27 00:56:31.087521
76	32	6	5	The candidate AI response accurately identifies Accutane as a retinoid, not an antibiotic, and correctly states its use for severe acne. It also appropriately highlights the drug's teratogenic effects, the necessity for strict contraception methods, and regular pregnancy testing, aligning with the gold standard's emphasis on preventing pregnancy during treatment. The response is concise, clinically sound, and prioritizes patient safety, particularly concerning the risks associated with isotretinoin during pregnancy.	2026-04-27 00:56:34.288666
77	33	6	5	The candidate AI response accurately identifies Accutane as not being an antibiotic and correctly states its use for severe acne, highlighting the critical contraindication during pregnancy due to the risk of severe birth defects and miscarriage. It also appropriately mentions the necessity of a mandated safety program, use of two forms of contraception, and regular pregnancy tests, aligning closely with the gold-standard reference answer in terms of safety and pharmacologic accuracy.	2026-04-27 00:56:38.511013
78	31	6	3	The candidate AI response accurately identifies Accutane (isotretinoin) as not being an antibiotic and highlights its potential to cause severe birth defects and pregnancy loss, emphasizing the need to avoid pregnancy during treatment and for a month after stopping. However, it lacks the detail about the necessity of a negative pregnancy test before starting treatment and the use of two forms of birth control throughout, which are crucial safety measures outlined in the gold-standard reference answer.	2026-04-27 00:56:42.811258
79	35	6	4	The candidate AI response accurately states that blepharitis is not contagious and provides a brief overview of its causes, including seborrheic dermatitis, bacterial overgrowth, and Demodex mites. It also advises basic hygiene practices to prevent potential transmission, which aligns with the gold-standard reference answer. The response is clinically sound, does not omit essential safety steps, and demonstrates good medical reasoning, making it a very good answer.	2026-04-27 00:56:46.326094
80	36	6	5	The candidate AI response accurately states that blepharitis itself is not contagious, aligning with the gold-standard reference answer. It also provides additional relevant information about potential secondary infections or mite infestations that could spread through shared items, which is a useful nuance for patient education and safety. The response does not contain any critical errors, dangerous recommendations, or major diagnostic misunderstandings, and it promotes professional evaluation for long-term management, demonstrating good medical reasoning and attention to safety.	2026-04-27 00:56:49.861189
81	34	6	4	The candidate AI response accurately states that blepharitis is usually not contagious and provides a brief overview of its causes, aligning with the gold-standard reference answer. It correctly identifies that the condition is related to skin conditions, blocked oil glands, or bacteria normally present on the skin, and implies that it does not spread from person to person, thus posing no significant safety concerns or diagnostic misunderstandings.	2026-04-27 00:56:53.202811
82	38	6	3	The candidate AI response is broadly correct in stating that "flu test" and "influenza test" are the same, and it provides some detail about the types of tests available, including their sensitivity and the importance of interpreting results alongside clinical symptoms. However, it lacks the nuance and detail of the gold-standard reference answer, particularly regarding the self-limited nature of the illness in healthy individuals under 65 and the specific scenarios where testing is necessary. The response does not contain critical errors or dangerous recommendations, making it clinically acceptable but incomplete.	2026-04-27 00:56:57.977226
83	39	6	4	The candidate AI response accurately states that a "flu test" is synonymous with an "influenza test" and provides details on the types of tests used, such as RIDT and PCR, which is consistent with the gold-standard reference answer. However, it lacks some details present in the gold standard, like the consideration for testing in individuals under 65 who are normally healthy and the specific analysis methods like RT-PCR or antigen immunofluorescence assays. The response is clinically sound, emphasizes the importance of timing for testing, and does not omit essential safety steps or key contraindications, making it a very good answer.	2026-04-27 00:57:02.211873
84	37	6	3	The candidate AI response is brief and to the point, correctly stating that a flu test and an influenza test are the same, which aligns with the gold-standard reference answer. However, it lacks essential details about when a test is necessary, the method of testing, and considerations for high-risk patients, making it incomplete compared to the gold standard.	2026-04-27 00:57:06.579201
85	41	6	5	The candidate AI response accurately distinguishes between ibuprofen and Tylenol (acetaminophen), highlighting their different mechanisms of action and effects, which aligns with the gold-standard reference answer. It also provides safe guidance on their use, noting they can be alternated under medical guidance but are not interchangeable, demonstrating good medical reasoning and attention to patient safety.	2026-04-27 00:57:09.627679
86	42	6	5	The candidate AI response accurately distinguishes between ibuprofen and acetaminophen, correctly identifying them as distinct medications with different active ingredients and safety profiles. It also provides a crucial safety tip by advising to check the "Drug Facts" label to prevent accidental overdosage, demonstrating good medical reasoning and alignment with the gold standard. The response is clinically sound, well-structured, and prioritizes patient safety without omitting essential information or introducing harmful recommendations.	2026-04-27 00:57:13.125427
87	40	6	5	The candidate AI response is clinically sound, accurately differentiates between ibuprofen and acetaminophen, and demonstrates good medical reasoning with no relevant safety concerns.	2026-04-27 00:57:16.519143
89	45	6	4	The candidate AI response is clinically sound and well aligned with the gold standard, acknowledging that while pain is a typical symptom of an abscess, some can be painless due to various factors such as size, location, or patient characteristics. It also provides relevant examples of conditions where abscesses might be painless, such as in patients with peripheral neuropathy or those with "cold abscesses" associated with fungal infections or tuberculosis, and emphasizes the need for clinical evaluation. The response demonstrates good medical reasoning and prioritizes patient safety by recommending clinical evaluation for any painless, firm, or growing lump to distinguish an abscess from other conditions.	2026-04-27 00:57:24.242172
90	43	6	4	The candidate AI response is broadly correct and aligns with the gold-standard reference answer in stating that an abscess can be painless and emphasizing the importance of medical evaluation. It also mentions key symptoms such as swelling, redness, drainage, fever, or the lump getting larger, which are relevant for seeking medical attention. However, it lacks the detail about the definition of an abscess and its potential locations as provided in the gold standard, but it does not omit any critical safety steps or essential information that would compromise patient safety.	2026-04-27 00:57:28.539145
\.


--
-- Data for Name: datasets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.datasets (id_dataset, nome_dataset, dominio, tipo_questao) FROM stdin;
1	K-QA	Medico	aberta
2	USMLE	Medico	multipla_escolha
\.


--
-- Data for Name: modelos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modelos (id_modelo, nome_modelo, versao, papel, parametro_precisao, observacoes) FROM stdin;
1	GPT-5.4 Thinking	\N	candidato	N/A	Modelo candidato da Atividade 1
2	Claude 4.6 Sonnet	\N	candidato	N/A	Modelo candidato da Atividade 1
3	Gemini 3.0	\N	candidato	N/A	Modelo candidato da Atividade 1
4	JUDGE_MODEL	\N	juiz	N/A	Substituir pelo modelo juiz escolhido pela equipe
5	llama3-70b-8192	\N	juiz	N/A	Modelo juiz Groq criado automaticamente
6	llama-3.3-70b-versatile	\N	juiz	N/A	Modelo juiz Groq criado automaticamente
\.


--
-- Data for Name: perguntas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perguntas (id_pergunta, id_dataset, official_id, enunciado, resposta_ouro, metadados) FROM stdin;
1	1	86	If the muscle aches continue without exercising, should I be concerned?	If your muscle ache continues without exercising, you should consult with your healthcare provider in order to obtain an accurate diagnosis. There are many causes of muscle aches, including overuse injury, trauma, viral and bacterial infections, medications, and rheumatic disease. Your doctor will take a full history, perform a physical examination, and possibly request laboratory studies and imaging.	{"team": "Equipe 2 - Medicina", "sources": "https://www.uptodate.com/contents/approach-to-the-patient-with-myalgia?search=muscle%20ache%20without%20exercise&source=search_result&selectedTitle=1~150&usage_type=default&display_rank=1", "student": "Gilson Inácio da Silva", "must_have": "If muscle ache continues without exercising, it is recommended to consult with a healthcare provider for an accurate diagnosis.", "specialty": "Clínica médica", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Viral infections can be a cause of muscle aches. | Overuse injury can be a cause of muscle aches. | Bacterial infections can be a cause of muscle aches. | Rheumatic disease can be a cause of muscle aches. | Imaging may be requested in the diagnostic process for muscle aches. | Laboratory studies may be requested in the diagnostic process for muscle aches. | Trauma can be a cause of muscle aches. | Certain medications can be a cause of muscle aches.", "observations": null, "curator_notes": "Question about persistent muscle pain without exercise; focus on clinical evaluation and investigation of possible causes.", "reference_used": "UpToDate — Approach to the patient with myalgia"}
2	1	87	If the side effects of the Prozac become too much is there a wean down period I would have to go through or would I be able to stop it immediately?	It is typically recommended to avoid abruptly discontinuing selective serotonin reuptake inhibitors (SSRIs) as this may result in unpleasant withdrawal symptoms. While Prozac has a lower risk of such symptoms, it is still advisable to gradually reduce doses of 20mg over a period of 1-2 weeks before stopping completely. Any change in your treatment plan should be done under your healthcare provider's guidance and supervision.	{"team": "Equipe 2 - Medicina", "sources": "https://www.uptodate.com/contents/discontinuing-antidepressant-medications-in-adults?search=fluoxetine%20withdrawal&source=search_result&selectedTitle=1~150&usage_type=default&display_rank=1\\n \\n\\n https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8841913/\\n \\n\\n https://khealth.com/learn/antidepressants/how-long-does-prozac-stay-in-your-system/\\n \\n\\n https://www.uptodate.com/contents/fluoxetine-drug-information?search=fluoxetine&source=panel_search_result&selectedTitle=1~149&usage_type=panel&kp_tab=drug_general&display_rank=1", "student": "Gilson Inácio da Silva", "must_have": "If experiencing unpleasant side effects from Prozac, it is recommended to avoid abruptly discontinuing the medication | Abrupt discontinuation of selective serotonin reuptake inhibitors (SSRIs) may result in withdrawal symptoms | Prozac has a lower risk of withdrawal symptoms compared to other SSRIs | It is advisable to gradually reduce Prozac doses of 20mg over a period of 1-2 weeks before stopping completel | Any change in your treatment plan should be done under your healthcare provider's guidance and supervision.", "specialty": "Psiquiatria / Farmacologia", "difficulty": "Medium", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "", "observations": null, "curator_notes": "Question about discontinuation of fluoxetine; focus on tapering and the risk of withdrawal symptoms.", "reference_used": "UpToDate — Discontinuing antidepressant medications in adults"}
3	1	88	If this is just muscle strain, how many days should I expect the pain to go away?	If a muscle is stretched too much or too quickly, or if it is overworked, a muscle strain can occur. This can happen during an exercise or as a result of an accident. The time it takes to recover fully from a muscle strain depends on various factors, including the severity and location of the injury, your personal health history, and age. Mild strains can cause discomfort lasting from several days to several weeks, while severe strains can last for months. To reduce symptoms, rest the muscle, apply ice to the affected area, wrap the muscle with an elastic bandage, and take medication to relieve pain and swelling. Acetaminophen (Tylenol) and Ibuprofen (Advil, Motrin) are examples of such medications. Contact a healthcare provider if you experience any of the following: inability to move the injured muscle due to pain, worsening pain or swelling, recurrent strain of the same muscle, new symptoms, or symptoms that persist for more than two weeks.	{"team": "Equipe 2 - Medicina", "sources": "https://www.uptodate.com/contents/muscle-strain-the-basics?search=muscle%20strain&source=search_result&selectedTitle=1~127&usage_type=default&display_rank=1\\n https://my.clevelandclinic.org/health/diseases/22336-muscle-strains\\n https://www.afcurgentcaremonroerd.com/how-long-does-pain-from-a-pulled-muscle-last/\\n https://starkvilleurgentcareclinic.com/muscle-strains-know-how-long-they-take-to-heal/\\n https://www.drugs.com/cg/muscle-strain.html#:~:text=For%20mild%20and%20moderate%20muscle,ice%20on%20the%20injured%20area.", "student": "Gilson Inácio da Silva", "must_have": "If a muscle is stretched too much or too quickly, or if it is overworked, a muscle strain can occur | Muscle strains can happen during exercise or as a result of an accident | Recovery time from a muscle strain depends on factors such as severity, location, personal health history, and age | Mild muscle strains can cause discomfort lasting from several days to several weeks | Severe muscle strains can last for months | Acetaminophen (Tylenol) and Ibuprofen (Advil, Motrin) are examples of medications to relieve pain and swelling from a muscle strain | Contact a healthcare provider if you experience inability to move the injured muscle due to pain | Contact a healthcare provider if you experience worsening pain or swelling | Contact a healthcare provider if you experience recurrent strain of the same muscle | Contact a healthcare provider if you experience new symptoms | Contact a healthcare provider if symptoms persist for more than two weeks", "specialty": "Ortopedia / Clínica Médica", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "To reduce symptoms of a muscle strain, rest the muscle | To reduce symptoms of a muscle strain, apply ice to the affected area | To reduce symptoms of a muscle strain, wrap the muscle with an elastic bandage", "observations": null, "curator_notes": "Question about the expected recovery time for a muscle strain.", "reference_used": "UpToDate — Muscle strain (The Basics)"}
4	1	89	Im confused what creatinine?	The body produces creatinine as a byproduct of muscle cells breaking down creatine phosphate for energy. The kidneys filter creatinine out of the blood and eliminate it through urine. Creatinine levels that are high in the blood and low in urine may indicate kidney problems. Doctors can use creatinine levels, along with patient age, gender, and race, to calculate eGFR, which helps assess kidney function. Healthcare providers may request creatinine testing as part of a regular check-up or if kidney disease is suspected. It's worth noting that intense exercise and some medications can lead to temporarily elevated serum creatinine levels.	{"team": "Equipe 2 - Medicina", "sources": "https://labtestsonline.org.uk/tests/creatinine\\n \\n\\n https://medlineplus.gov/lab-tests/creatinine-test/\\n \\n\\n https://www.niddk.nih.gov/health-information/professionals/clinical-tools-patient-management/kidney-disease/laboratory-evaluation/frequently-asked-questions", "student": "Gilson Inácio da Silva", "must_have": "Creatinine is a byproduct of muscle cells breaking down creatine phosphate for energy | The kidneys filter creatinine out of the blood and eliminate it through urine | High creatinine levels in the blood and low levels in urine may indicate kidney problems | Intense exercise can lead to temporarily elevated serum creatinine levels | Some medications can lead to temporarily elevated serum creatinine level", "specialty": "Nefrologia / Medicina Laboratorial", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Healthcare providers may request creatinine testing as part of a regular check-up or if kidney disease is suspected | Doctors can use creatinine levels, along with patient age, gender, and race, to calculate eGFR, which helps assess kidney function", "observations": null, "curator_notes": "Conceptual question about creatinine and its clinical usefulness.", "reference_used": "MedlinePlus / Lab Tests Online — Creatinine test"}
5	1	90	In any case, is a product like abreva still good to use for cold sore treatment?	Docosanol (Abreva) is a topical antiviral treatment that can be purchased over the counter to help soothe cold sores or fever blisters on the face and lips. It's important to note that studies have produced mixed results regarding the efficacy of Abreva. In addition, Abreva does not cure HSV1 or HSV2 or prevent the virus from spreading. Typically, cold sores will resolve by themselves within a few days, but you can take medication to alleviate symptoms, such as local topical anesthetics like lidocaine. If you experience more severe recurrences, oral antiviral medication like acyclovir (Zovirax) may be prescribed.	{"team": "Equipe 2 - Medicina", "sources": "https://www-uptodate-com.meir.idm.oclc.org/contents/docosanol-drug-information?search=abreva&topicRef=8287&source=see_link#F162115\\n https://www-uptodate-com.meir.idm.oclc.org/contents/treatment-and-prevention-of-herpes-simplex-virus-type-1-in-immunocompetent-adolescents-and-adults?search=docosanol&source=search_result&selectedTitle=2~3&usage_type=default&display_rank=1", "student": "Gilson Inácio da Silva", "must_have": "Cold sores are usually self-limited and recover whithin a few days. | Studies show conflicted data regarding the potential benefits of Docosanol (Abreva) for treating cold sores. | Docosanol (Abreva) is an over-the-counter antiviral topical treatment for cold sores or fever blisters on the face and lips. | In occasional and more severe recurrence of cold sores, oral antiviral medication such as acyclovir (zovirax) is an optional treatment. | Docosanol (Abreva) does not cure HSV1 and does not prevent the passing of the virus. | Docosanol (Abreva) does not cure HSV2 and does not prevent the passing of the virus.", "specialty": "Dermatologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Medication such as local topical anesthetics like lidocaine could be taken to relieve symptoms of cold sores.", "observations": null, "curator_notes": "Question about the treatment of herpes labialis with docosanol (Abreva).", "reference_used": "UpToDate — Docosanol drug information"}
6	1	91	In case it does turn out to be fungal, would it be bad to pick up an OTC anti-fungal like Tinactin to apply to the area or would that be a bad idea?	If you have a fungal infection like athlete's foot, jock itch or ringworm, you can use over-the-counter topical antifungal drugs such as Tinactin to treat it. Apply the medication once or twice a day until the infection goes away, which usually takes around four weeks.\nIf topical antifungal therapy doesn't work or the infection is severe, your doctor may prescribe oral systemic antifungal therapy, with drugs like terbinafine and itraconazole.\nFor fungal nail infections, topical treatment options are limited to specific medications like Efinaconazole that are designed for nail disease. Alternatively, your doctor may prescribe oral terbinafine to treat the infection.	{"team": "Equipe 2 - Medicina", "sources": "https://www.drugs.com/search.php?searchterm=Tinactin&a=1\\n \\n\\n https://www.uptodate.com/contents/dermatophyte-tinea-infections?search=antifungals&source=search_result&selectedTitle=6~148&usage_type=default&display_rank=6#H300483\\n \\n\\n https://www.uptodate.com/contents/tolnaftate-drug-information?search=tinactin&source=panel_search_result&selectedTitle=1~3&usage_type=panel&kp_tab=drug_general&display_rank=1", "student": "Gilson Inácio da Silva", "must_have": "If you have a fungal infection like athlete's foot, you can use over-the-counter topical antifungal drugs such as Tinactin to treat it | If you have a fungal infection like jock itch, you can use over-the-counter topical antifungal drugs such as Tinactin to treat it | If you have a fungal infection like ringworm, you can use over-the-counter topical antifungal drugs such as Tinactin to treat it | For fungal nail infections, topical treatment options are limited to specific medications like Efinaconazole that are designed for nail disease", "specialty": "Dermatologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Apply Tinactin once or twice a day until the infection goes away, which usually takes around four weeks | If topical antifungal therapy doesn't work or the infection is severe, your doctor may prescribe oral systemic antifungal therapy, with drugs like terbinafine and itraconazole | Alternatively, your doctor may prescribe oral terbinafine to treat fungal nail infections", "observations": null, "curator_notes": "Question about the use of an over-the-counter topical antifungal if the lesion is fungal.", "reference_used": "UpToDate — Dermatophyte (tinea) infection; Drugs.com — Tinactin"}
7	1	92	Is Augmentin the same thing as Amoxcicilin?	Augmentin is an antibacterial medication which is consisted of two active drugs: amoxicillin and clavulanic acid. Amoxicillin is an antibiotic from the penicillin family, which is used against certain bacterial infections. Some bacteria developed mechanisms of resistance to amoxicillin effect. The added-on compound of clavulanic acid inhibits some of these mechanisms which results in amoxicillin having a broader spectrum of anti-bacterial activity.	{"team": "Equipe 2 - Medicina", "sources": "https://www-uptodate-com.meir.idm.oclc.org/contents/amoxicillin-and-clavulanate-drug-information#F134594", "student": "Gilson Inácio da Silva", "must_have": "Augmentin is an antibacterial medication composed of two active drugs: amoxicillin and clavulanic acid. | Clavulanic acid, a component of Augmentin, inhibits some mechanisms of bacterial resistance to amoxicillin.", "specialty": "Farmacologia / Infectologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Amoxicillin is an antibiotic from the penicillin family, used against certain bacterial infections. | Some bacteria have developed mechanisms of resistance to amoxicillin.", "observations": null, "curator_notes": "Question about the difference between Augmentin and amoxicillin.", "reference_used": "UpToDate — Amoxicillin and clavulanate drug information"}
8	1	93	Is Buspar a good medicine to take with the Zoloft?	Both Buspirone (Buspar) and Sertraline (Zoloft) elevate the serotonin levels in the brain. \nThis combination may increase the risk of serotonin syndrome, a serious and life-threatening condition. Symptoms of serotonin syndrome include diarrhea, nausea, vomiting, tremors, sweating, high fever, muscle stiffness, seizures, and abnormal or rapid heartbeat. Patients taking both medications should be closely monitored for any of these symptoms. If you suspect serotonin syndrome, seek immediate medical attention.	{"team": "Equipe 2 - Medicina", "sources": "https://www.uptodate.com/contents/buspirone-drug-information?search=buspar&source=panel_search_result&selectedTitle=1~80&usage_type=panel&kp_tab=drug_general&display_rank=1#F143260\\n \\n\\n https://www.uptodate.com/contents/buspirone-drug-information?search=buspar&source=panel_search_result&selectedTitle=1~80&usage_type=panel&kp_tab=drug_general&display_rank=1#F143260\\n \\n\\n https://www.uptodate.com/drug-interactions/?source=responsive_home#di-document\\n \\n\\n https://my.clevelandclinic.org/health/drugs/20084-buspirone-tablets\\n \\n\\n https://my.clevelandclinic.org/health/diseases/17687-serotonin-syndrome", "student": "Gilson Inácio da Silva", "must_have": "Buspirone (Buspar) and Sertraline (Zoloft) both elevate serotonin levels in the brain | Combining Buspirone (Buspar) and Sertraline (Zoloft) may increase the risk of serotonin syndrome | Seek immediate medical attention if you suspect serotonin syndrome", "specialty": "Psiquiatria / Farmacologia", "difficulty": "Medium", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Symptoms of serotonin syndrome can include diarrhea. | Symptoms of serotonin syndrome can include high fever. | Symptoms of serotonin syndrome can include tremor. | Symptoms of serotonin syndrome can include vomiting. | Symptoms of serotonin syndrome can include seizures. | Symptoms of serotonin syndrome can include abnormal or rapid heartbeat. | Symptoms of serotonin syndrome can include nausea. | Symptoms of serotonin syndrome can include sweating. | Symptoms of serotonin syndrome can include muscle stiffness. | Serotonin syndrome is a serious and life-threatening condition | Patients taking both Buspirone (Buspar) and Sertraline (Zoloft) should be closely monitored for symptoms of serotonin syndrome", "observations": null, "curator_notes": "Question about combining buspirone with sertraline, with emphasis on the safety of concomitant use.", "reference_used": "UpToDate — Buspirone drug information"}
9	1	94	Is Saxenda a daily injection?	Saxenda is an injection given once a day under the skin (subcutaneous) from a multi-dose injection pen, and it is suitable for self-injection after receiving a proper explanation about how to do so.	{"team": "Equipe 2 - Medicina", "sources": "https://www.drugs.com/saxenda.html\\n https://www.saxenda.com/about-saxenda/dosing-schedule.html", "student": "Gilson Inácio da Silva", "must_have": "Saxenda is administered as a daily injection. | Saxenda is delivered from a multi-dose injection pen.", "specialty": "Endocrinologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Saxenda is injected under the skin (subcutaneously). | Saxenda is suitable for self-injection after proper instruction.", "observations": null, "curator_notes": "Objective question about the dosing frequency of Saxenda.", "reference_used": "Saxenda official dosing schedule"}
10	1	95	Is Valtrex the same thing as valacyclovir?	Valtrex is the US brand name for valacyclovir, used to treat shingles and chickenpox – both caused by the varicella-zoster virus.	{"team": "Equipe 2 - Medicina", "sources": "https://www-uptodate-com.meir.idm.oclc.org/contents/valacyclovir-drug-information#F232777", "student": "Gilson Inácio da Silva", "must_have": "Valtrex is the US brand name for the drug valacyclovir.", "specialty": "Farmacologia / Infectologia", "difficulty": "Medium", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Valacyclovir is used to treat shingles and chickenpox. | Shingles and chickenpox are both caused by the varicella zoster virus.", "observations": null, "curator_notes": "Question about the equivalence between Valtrex and valacyclovir.", "reference_used": "UpToDate — Valacyclovir drug information"}
11	1	96	Is accutane like an antibiotic and would it affect a baby if I got pregnant?	Isotretinoin (Accutane) is a form of vitamin A that helps to reduce the amount of oil produced by your skin's oil glands, but it's not an antibiotic. This drug is used to treat severe acne that has not responded to other treatments. It's important to note that this medication can cause severe birth defects or even fetus death if taken during pregnancy. It's crucial to have a negative pregnancy test before starting Isotretinoin and to use two forms of birth control throughout the treatment. If you're considering becoming pregnant or are already pregnant, you should speak to your healthcare provider about alternatives.	{"team": "Equipe 2 - Medicina", "sources": "https://www.drugs.com/accutane.html\\n https://www.nhs.uk/medicines/isotretinoin-capsules/\\n https://my.clevelandclinic.org/health/drugs/19186-isotretinoin-capsules", "student": "Gilson Inácio da Silva", "must_have": "Isotretinoin (Accutane) works by reducing the amount of oil released by oil glands in the skin. | Isotretinoin (Accutane) is a form of vitamin A, not an antibiotic drug. | Two forms of birth control are required to prevent pregnancy while taking Isotretinoin (Accutane). | Consultation with a healthcare provider is necessary about any chance of present or planned pregnancy and about alternatives before taking Isotretinoin (Accutane). | A single dose of Isotretinoin (Accutane) can cause severe birth defects or death of a baby. | A negative pregnancy test is required before taking Isotretinoin (Accutane).", "specialty": "Dermatologia / Farmacologia", "difficulty": "Medium", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Isotretinoin (Accutane) is used to treat severe acne that has not responded to other treatments, including antibiotics.", "observations": null, "curator_notes": "Question about isotretinoin, its mechanism of action, and its teratogenic risk during pregnancy.", "reference_used": "NHS / Cleveland Clinic — Isotretinoin information and pregnancy risk"}
19	2	139	A 27-year-old primigravid woman at 21 weeks’ gestation comes to the\nemergency department because of a 2-day\nhistory of moderate headache, shortness of breath, nausea, vomiting,\nmuscle aches, and malaise. She also has had\ncough occasionally productive of sputum. Pregnancy had been\nuncomplicated. She has no history of serious illness,\nand her only medication is a prenatal vitamin. She immigrated to the USA\nfrom India 6 months ago. Temperature is\n38.3°C (100.9°F), pulse is 100/min, respirations are 18/min, and blood\npressure is 100/60 mm Hg. On examination,\nbreath sounds are decreased at the right lung base. Fundal height is 22 cm.\nFetal heart rate is 160/min. Chest x-ray\nshows right-sided interstitial infiltrates. Which of the following is the most\nlikely infectious agent?	B	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Obstetrics / Infectious Diseases", "difficulty": "Medium", "explanation": "Influenza A virus\\nKey reasoning:\\nPresentation is acute (2 days) with systemic symptoms (fever, myalgias,\\nheadache, malaise, nausea/vomiting) plus cough and tachycardia, which is\\ntypical for influenza-associated community-acquired pneumonia (CAP) in\\notherwise healthy young adults; chest radiograph often shows interstitial\\ninfiltrates.[1][2][3]\\nPregnancy increases risk for severe influenza and lower respiratory tract\\ninvolvement due to physiologic and immunologic changes; influenza A/B is\\na leading viral etiology of CAP, and viral etiologies are common in younger\\noutpatients.[1][4][5][6]\\nEpidemiology in pregnancy supports influenza as a major cause of acute\\nrespiratory illness with lower respiratory tract involvement; studies in\\npregnant cohorts show influenza frequently identified among viral ALRTIs.\\nThe ACOG and the Infectious Diseases Society of America emphasize\\nprompt recognition and treatment of suspected influenza in pregnancy.[3]\\n[5][6][7][8]\\nLess likely alternatives:\\nStreptococcus pneumoniae and Haemophilus influenzae typically cause\\nlobar or bronchopneumonia rather than predominant interstitial patterns\\nand lack prominent systemic myalgias; onset can be less abruptly systemic.\\n[1][2][4]\\nMycobacterium tuberculosis usually presents subacutely/chronic, often\\nwith constitutional symptoms over weeks and upper-lobe involvement;\\nacute myalgias and abrupt symptom onset are atypical.[1]\\nLegionella pneumophila would suggest high fevers, GI symptoms,\\nhyponatremia, and exposure risk; not evident here.[1]\\nPseudomonas aeruginosa is uncommon without structural lung disease or\\nhealthcare exposure.[1]\\n• \\n• \\n• \\n• \\n• \\n• \\n• \\nClinical implication: In pregnancy with suspected influenza, initiate\\nneuraminidase inhibitor therapy promptly; oseltamivir 75 mg orally twice daily\\nfor 5 days is recommended by the Infectious Diseases Society of America and\\nACOG, ideally within 48 hours but not withholding if later.[6][8]", "curator_notes": "Pregnant patient with acute fever, myalgias, cough, and interstitial pulmonary infiltrates; the most likely infectious agent is influenza A virus, which is especially important in pregnancy because of increased maternal risk and the need for prompt antiviral treatment.", "reference_used": "Guidance on influenza in pregnancy", "usmle_source_index": "138", "dataset_source_index": "139"}
12	1	97	Is blepharitis contagious?	Blepharitis is an inflammation of the eyelid that causes red, swollen, and irritated eyelids. The exact cause of blepharitis is unknown, but it might be associated with bacterial buildup, seborrheic dermatitis, clogged oil glands in the eyelids, rosacea, allergies, and eyelash mites. While it could be caused by bacterial buildup on the eyelids, that bacteria is normal skin bacteria, which can not transfer and infect other people. Therefore, blepharitis is not a contagious disease.	{"team": "Equipe 2 - Medicina", "sources": "https://www.nei.nih.gov/learn-about-eye-health/eye-conditions-and-diseases/blepharitis\\n \\n\\n https://www.healthline.com/health/eye-health/is-blepharitis-contagious\\n \\n\\n https://www.mayoclinic.org/diseases-conditions/blepharitis/symptoms-causes/syc-20370141", "student": "Gilson Inácio da Silva", "must_have": "Blepharitis is not contagious", "specialty": "Oftalmologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Blepharitis might be associated with seborrheic dermatitis. | Blepharitis might be associated with allergies. | Blepharitis might be associated with rosacea. | Blepharitis might be associated with other reasons. | Blepharitis might be associated with clogged oil glands in the eyelids. | Blepharitis might be associated with eyelash mites. | The bacteria involved in blepharitis is normal skin bacteria. | Blepharitis is an inflammation of the eyelid that causes red, swollen, and irritated eyelids. | The bacteria involved in blepharitis cannot transfer and infect other people. | Blepharitis could be caused by bacterial buildup on the eyelids.", "observations": null, "curator_notes": "Question about whether blepharitis is contagious.", "reference_used": "NEI — Blepharitis"}
13	1	98	Is flu test same as influenza test ?	The flu test and the influenza test are the same thing. "Flu" is a common name for an acute respiratory illness caused by the influenza virus. If you experience a sudden fever, cough, and muscle aches during the winter months, it's likely that you have influenza. In such cases, an influenza test can be taken to confirm the diagnosis. However, in most cases, there's no need for a test since the symptoms during flu season are enough to diagnose the illness. The illness is self-limited in individuals under 65 years of age who are normally healthy. However, older patients or those at higher risk for complications may need a test. To perform the test, a sample is collected from the throat or nose and analyzed in the lab using RT-PCR or antigen immunofluorescence assays.	{"team": "Equipe 2 - Medicina", "sources": "https://www-uptodate-com.meir.idm.oclc.org/contents/seasonal-influenza-in-adults-clinical-manifestations-and-diagnosis?search=influenza%20diagnosis&sectionRank=1&usage_type=default&anchor=H4280894726&source=machineLearning&selectedTitle=1~150&display_rank=1#H4280894726", "student": "Gilson Inácio da Silva", "must_have": "Flu is the common name for an acute respiratory illness caused by the virus influenza. | Flu test is the same as influenza test.", "specialty": "Infectologia / Diagnóstico", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "In patients above age 65 or patients with high risk for complications, a flu test is in order. | Flu test includes performing a molecular assay in the lab using RT-PCR or antigen immunofluorescence assays. | Flu test includes collecting a sample from throat or nose. | Abrupt fever, cough and muscle aches during the winter raise a high suspicion for influenza. | In most cases, there is no need to test for flu since the clinical presentation during flu season is enough to make a diagnosis.", "observations": null, "curator_notes": "Question about the equivalence between a “flu test” and an influenza test.", "reference_used": "UpToDate — Seasonal influenza in adults: diagnosis"}
14	1	99	Is ibuprofen a part of tylenol?	Ibuprofen( Advil, Motrin) and Acetaminophen (Tylenol) are common pain and fever relievers. Whilst the two drugs share some similar features, the active ingredient is different, and Ibuprofen is not a part of Acetaminophen.	{"team": "Equipe 2 - Medicina", "sources": "https://www.nhs.uk/medicines/ibuprofen-for-adults/\\n https://www.uptodate.com/contents/acetaminophen-paracetamol-drug-information?search=tylenol&source=panel_search_result&selectedTitle=1~149&usage_type=panel&kp_tab=drug_general&display_rank=1\\n https://www.uptodate.com/contents/ibuprofen-drug-information?search=ibuprofen&source=panel_search_result&selectedTitle=1~149&usage_type=panel&kp_tab=drug_general&display_rank=1", "student": "Gilson Inácio da Silva", "must_have": "The active ingredient in Ibuprofen is different from that in Acetaminophen. | Ibuprofen (Advil, Motrin) is not a part of Acetaminophen (Tylenol).", "specialty": "Farmacologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "Ibuprofen (Advil, Motrin) and Acetaminophen (Tylenol) are common pain and fever relievers.", "observations": null, "curator_notes": "Question about the difference between ibuprofen and Tylenol (acetaminophen/paracetamol).", "reference_used": "NHS / UpToDate — Ibuprofen and acetaminophen drug information"}
15	1	100	Is it common to have an abscess with no pain?	An abscess is a pocket of pus that can develop anywhere in your body, including the skin, mouth, and internal organs. Typically, pain is the primary symptom of an abscess, and it is often what prompts patients to seek medical help. However, some abscesses can be painless due to factors like size, location, and the patient's individual characteristics. If you suspect that you have an abscess, it is crucial to consult with a healthcare provider for proper diagnosis and treatment. Medical intervention is usually necessary for abscesses.	{"team": "Equipe 2 - Medicina", "sources": "https://my.clevelandclinic.org/health/diseases/22876-abscess#:~:text=An%20abscess%20is%20a%20pocket,up%20within%20the%20damaged%20tissue.\\n https://www.uptodate.com/contents/skin-abscesses-in-adults-treatment?search=abscess&source=search_result&selectedTitle=1~108&usage_type=default&display_rank=1\\n https://www.health.harvard.edu/a_to_z/brain-abscess-a-to-z\\n https://www.gentledentalmenomonie.com/not-just-pulp-fiction-the-truth-about-dental-abscesses/", "student": "Gilson Inácio da Silva", "must_have": "Not experiencing pain does not exclude the presence of an abscess. | If you suspect you might have an abscess, you should consult your healthcare provider for diagnosis and treatment. | A common symptom of an abscess is pain. | Less commonly, an abscess can be painless due to its location, size, patient's characteristics and other causes.", "specialty": "Clínica médica / Dermatologia", "difficulty": "Easy", "model_1_name": null, "model_2_name": null, "model_3_name": null, "nice_to_have": "An abscess is a pocket of pus that can form almost anywhere in your body including the skin, mouth and internal organs. | Abscesses usually require a medical intervention. | Pain is often the reason patients with an abscess seek medical attention.", "observations": null, "curator_notes": "Question about a painless abscess, with emphasis on the variability of its clinical presentation.", "reference_used": "Cleveland Clinic — Abscess"}
16	2	136	A 58-year-old man comes to the clinic for a follow-up examination 3\nmonths after beginning warfarin therapy for\ndeep venous thrombosis. He noted blood in his urine 1 week ago but has\nnot seen any since that time. He has not had\npain, fever, or increased urinary frequency. He has not sustained any recent\ntrauma. His prothrombin time and INR\nhave been within the therapeutic ranges during his previous\nmeasurements. He has hypertension and benign\nprostatic hyperplasia. Medications are warfarin and hydrochlorothiazide.\nHe smoked one pack of cigarettes daily for\n40 years but quit when diagnosed with deep venous thrombosis.\nTemperature is 35.9°C (96.6°F), pulse is 88/min,\nrespirations are 18/min, and blood pressure is 135/87 mm Hg. The prostate\nis moderately enlarged; no nodules are\nnoted.\nLaboratory studies showed that the Prothrombin time is 19 sec (INR=2.5),\nserum Urea nitrogen is 18 mg/dL, serum Creatinine is 1 mg/dL, and\nProstate-specific antigen is 3.8 ng/mL (N<4).\nThe laboratory result on urine showed the following: blood is 3+, protein is\n1+, RBC is too numerous to count, WBC is 2/hpf, no casts, and negative for\nNitrites and Leukocyte esterase.\nIn addition to a CT scan of the abdomen, which of the following is the most\nappropriate next step in management?	C	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Urology", "difficulty": "Medium", "explanation": "Cystoscopy is the most appropriate next step because guidelines and evidence\\nindicate that all patients with gross hematuria and risk factors—including those\\non therapeutic anticoagulation—require prompt urologic evaluation to exclude\\nmalignancy. The patient has gross hematuria, is male, age >35, with a heavy\\nsmoking history; anticoagulation at a therapeutic INR is not considered a\\nsufficient explanation, and malignancy must be ruled out with cystoscopy plus\\nupper tract imaging.[1][2][3][4] The American Urological Association (AUA/SUFU)\\nalso recommends cystoscopy as part of risk-based evaluation for hematuria; the\\nAmerican College of Physicians emphasizes that antithrombotic therapy should\\nnot preclude evaluation.[4][5] Observational data show antithrombotic therapy\\ncan unmask otherwise silent bladder cancers, reinforcing the need for\\ncystoscopy despite therapeutic INR.[3] Empiric antibiotics are not indicated\\nwithout infection, finasteride is a consideration only after exclusion of\\nmalignancy, hydrochlorothiazide is not causally implicated, and down-titration\\nof warfarin is inappropriate with therapeutic INR.[1][2][6][7]\\nTherefore, in addition to CT imaging of the upper tracts, the next step is \\nCystoscopy.\\nTo contextualize the diagnostic approach, comparative modeling of guideline\\nstrategies shows that cystoscopy is a core test across risk-based pathways for\\nhematuria; CT urography is generally reserved for higher-risk presentations\\nsuch as gross hematuria or smokers, aligning with this patient’s profile.[8]\\nCaption: Model Input Variables<|END VISUAL|>", "curator_notes": "Gross hematuria in a patient on therapeutic anticoagulation with important urologic risk factors; therapeutic anticoagulation does not exclude evaluation for malignancy, and the appropriate next step is cystoscopy.", "reference_used": "AUA/SUFU guideline — hematuria evaluation", "usmle_source_index": "135", "dataset_source_index": "136"}
17	2	137	A 32-year-old woman is brought to the emergency department\nimmediately after being involved in a motor vehicle\ncollision. She was the unrestrained driver. On arrival, she says she has\nsevere pain in her right groin. On\nexamination, any movement of the right hip produces pain. An x-ray of the\npelvis shows a completely displaced\nfracture of the femoral neck. In addition to intravenous morphine, which of\nthe following is the most appropriate\nmanagement?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Orthopedics / Trauma", "difficulty": "Medium", "explanation": "Operative fixation is indicated. In a young adult with a completely displaced\\nfemoral neck fracture from high-energy trauma, urgent anatomical reduction\\nand stable internal fixation is the standard to preserve the femoral head and\\nmitigate risks of osteonecrosis and nonunion; nonoperative options (bed rest,\\ntraction, bracing, limited weight bearing) are inadequate and associated with\\npoor outcomes.[1][2][3] Contemporary evidence in this age group favors fixed-\\nangle constructs over multiple cancellous screws alone for displaced patterns,\\nwith augmentation (e.g., sliding hip screw plus medial femoral neck buttress\\nplate and antirotation screw) improving construct success; surgery should occur\\nwithin 24–48 hours when feasible.[1][3][4][5][6]\\nCorrect answer: Operative reduction and internal fixation.\\nFigure 4 from NEJM illustrates the treatment schema: internal fixation for\\nfemoral-neck fractures and arthroplasty options for displaced fractures in older\\nadults; for young patients with displaced femoral-neck fractures, the goal is head\\npreservation via reduction and internal fixation rather than arthroplasty.[1] This\\nvisual reinforces that conservative measures are not definitive care for this injury\\npattern.\\nFigure 4. Selected Treatments for Hip Fracture.\\nUsed under license from The New England Journal of Medicine.\\nWhy not the other options:\\nBed rest, traction, hip spica, or limited weight bearing do not address\\nvascular compromise or instability and carry high risks of nonunion and\\navascular necrosis in displaced femoral-neck fractures.[1][2][5][6]\\nClosed reduction followed by traction is obsolete for definitive care;\\ndefinitive internal fixation is required.[1][2][3]\\n• \\n• \\nKey operative considerations:\\nUrgent closed or open reduction to restore alignment and decompress\\nintracapsular pressure; stable internal fixation with a fixed-angle construct,\\noften augmented with a medial buttress plate and antirotation screw, has\\nlower failure than screws alone in displaced fractures in younger adults.[4]\\n[5]\\nEarly surgery within 24–48 hours optimizes outcomes.[1][3]", "curator_notes": "Completely displaced femoral neck fracture in a young adult after high-energy trauma; the appropriate management is operative reduction and internal fixation to preserve the femoral head and reduce the risk of avascular necrosis and nonunion.", "reference_used": "Orthopedic trauma literature — displaced femoral neck fracture in young adults", "usmle_source_index": "136", "dataset_source_index": "137"}
18	2	138	A 57-year-old man comes to the physician 1 week after he had a 45-minute\nepisode of slurred speech and\nclumsiness of his right hand. The episode occurred during his daily walk;\nthe symptoms resolved during the next 24\nhours. He has no history of similar symptoms. He has a 20-year history of\nhypertension and a 15-year history of\nhypercholesterolemia controlled with a low-cholesterol diet and daily\nexercise. He takes no medications. He has\nsmoked one pack of cigarettes daily for 40 years and drinks one to two\nglasses of wine nightly with dinner. He is\nalert and fully oriented. He is 178 cm (5 ft 10 in) tall and weighs 86 kg (190\nlb); BMI is 27 kg/m². His temperature is\n37.0°C (98.6°F), pulse is 88/min, respirations are 10/min, and blood\npressure is 170/90 mm Hg. Examination,\nincluding neurologic examination, shows no other abnormalities. Daily\nenteric-coated aspirin therapy is begun.\nWhich of the following is the most appropriate next step to decrease this\npatient’s risk for subsequent cerebral\ninfarction?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Neurology / Internal Medicine", "difficulty": "Medium", "explanation": "Antihypertensive therapy.\\nRationale: After TIA, blood pressure lowering provides the largest proven\\nreduction in recurrent stroke risk. The American College of Cardiology/\\nAmerican Heart Association recommend initiating or intensifying\\nantihypertensive therapy a few days after TIA when BP is ?140/90 mm Hg, with\\npreferred agents including a thiazide diuretic, ACE inhibitor, ARB, or a thiazide–\\nACE inhibitor combination; a target <130/80 mm Hg is reasonable for most\\npatients.[1][2] Trials summarized by the American Stroke Association show BP\\nlowering after stroke/TIA reduces recurrence by roughly 30–40% (e.g.,\\nindapamide alone; perindopril ± indapamide) and support prioritizing these\\nclasses.[3] This patient’s BP (170/90 mm Hg) is markedly above target, making\\nantihypertensive therapy the most immediate and impactful next step.\\nOther measures:\\nHigh-intensity statin therapy is recommended for presumed\\natherosclerotic TIA and reduces recurrent vascular events, but BP control\\nhas stronger direct evidence for recurrent stroke reduction and is the most\\nurgent abnormality here.[2][3][4]\\nSmoking cessation improves outcomes after stroke/TIA and should be\\ncounseled, but effect sizes in observational data are smaller and less\\nimmediate than BP lowering.[3][5]\\nAlcohol reduction and weight optimization are advisable for risk factor\\ncontrol, but evidence for preventing recurrent stroke events is less direct.\\n[3][4]\\nAgent selection and dosing should be individualized; commonly used regimens\\ninclude a thiazide (e.g., chlorthalidone 12.5–25 mg daily) and/or ACE inhibitor\\n• \\n• \\n• \\n(e.g., perindopril 4–8 mg daily) or ARB, titrated to achieve <130/80 mm Hg as\\ntolerated.[1][2][3]", "curator_notes": "Clinical presentation is consistent with a transient ischemic attack; the key management issue is secondary prevention, and the most appropriate next step to reduce recurrent cerebral infarction risk is antihypertensive therapy because blood pressure is markedly elevated.", "reference_used": "AHA/ASA guideline — secondary prevention after TIA/stroke", "usmle_source_index": "137", "dataset_source_index": "138"}
20	2	140	A 7-year-old boy is brought to the physician because of a 1-year history of\npoor performance in school. His parents\nsay that he is bright, has many friends, and seems to want to do well in\nschool. His teachers report that he seems\nfrustrated with his own progress and his inability to meet the expectations\nof his parents. Speech fluency and\narticulation and motor skills are appropriate for age. Physical examination\nshows no abnormalities. When asked to\nread during the examination, he has significant difficulty sounding out\nwords he is unfamiliar with. Visual acuity\ntest and audiometry show no abnormalities. Which of the following is the\nmost likely diagnosis?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Pediatrics / Neurodevelopment", "difficulty": "Medium", "explanation": "The most likely diagnosis is Learning disorder.\\nThe child has persistent, specific reading impairment—difficulty sounding out\\nunfamiliar words—despite normal speech, motor skills, and sensory function,\\nand with otherwise intact cognition and sociability. This pattern is characteristic\\nof specific learning disorder with impairment in reading (dyslexia), which\\nrequires academic skills substantially below age expectations, persists despite\\ntargeted help, begins in school years, and is not better explained by intellectual\\ndisability, language disorder, or sensory deficits.[1] Expressive language disorder\\nwould present with impaired expressive language (e.g., syntax, verb use), not\\nisolated decoding failure.[2] Intellectual developmental disorder requires global\\ndeficits in intellectual and adaptive functioning, which are absent here.[3] ADHD\\nis not suggested by attention/hyperactivity symptoms. Social anxiety disorder\\ncenters on fear of scrutiny and avoidance, not isolated phonologic decoding\\ndeficits.[4] The course is chronic and non-urgent.[5]\\nTo contextualize why social anxiety is unlikely in this vignette (despite poor\\nschool performance), the DSM-5 criteria emphasize fear of negative evaluation\\nand avoidance of social or performance situations, which are not described in\\nthis case.[4]\\nTable 1. Diagnostic Criteria for Social Anxiety Disorder.\\nUsed under license from The New England Journal of Medicine.\\nKey features supporting specific learning disorder (reading/dyslexia):\\nPersistent inaccurate/effortful word reading and difficulty sounding out\\nwords.[1]\\nAcademic underachievement confined to reading; normal speech fluency/\\narticulation and normal hearing/vision.[1][2]\\nNo global intellectual/adaptive deficits.[3]\\nNot better accounted for by anxiety or attentional disorders.[1][4]\\nThe American Psychiatric Association’s DSM-5-TR criteria (2022) specify these\\ndiagnostic elements and exclusion criteria.[1]\\n• \\n• \\n• \\n•", "curator_notes": "Child with persistent difficulty sounding out unfamiliar words despite normal hearing, vision, speech, and motor development; the presentation is most consistent with specific learning disorder with impairment in reading.", "reference_used": "Guidance on specific learning disorder evaluation", "usmle_source_index": "139", "dataset_source_index": "140"}
21	2	141	A 23-year-old woman who is an active-duty enlisted airman in the US Air\nForce comes to the base clinic because of\na 4-week history of an itchy sensation in her right ear. She has not had\nringing in her ears or hearing loss. She works\nas a fuel specialist and at first attributed her symptom to the earplugs she\nuses when she is on the flight line. The\nsymptom has not improved despite the patient's wearing headphones\ninstead of the earplugs during the past 2 weeks.\nShe has no history of serious illness and takes no medications. Vital signs\nare within normal limits. During\nexamination, pulling of the right pinna inferiorly to examine the ear canal\nproduces pain. The right ear canal appears\nerythematous and edematous. The tympanic membrane cannot be fully\nvisualized because of the presence of\ncerumen. Examination of the left ear shows no abnormalities. Which of the\nfollowing is the most likely diagnosis?	C	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Otolaryngology", "difficulty": "Easy", "explanation": "Otitis externa (C)\\nThe most likely diagnosis is otitis externa because the patient’s symptoms and\\nexamination findings—especially pain with pinna movement and canal\\ninflammation—are classic for this condition and are best explained by infection\\nof the external auditory canal rather than cerumen impaction, trauma, or\\ndermatologic disease.[1][2][3][4][5] Pruritus, canal erythema/edema, and marked\\ntenderness with manipulation of the pinna or tragus are hallmark features;\\noccupational earplug use and minor canal trauma are common precipitants.[1][2]\\n[3][5][6][7] Cerumen impaction alone would not cause pain with pinna\\nmovement or diffuse canal edema; trauma typically requires a clear inciting\\ninjury with focal findings; polychondritis involves the cartilaginous pinna sparing\\nthe lobule, often bilateral and systemic; seborrheic dermatitis causes scaling/\\nerythema without severe tragal/pinna tenderness or canal edema.[2][3][4][8]\\nThe diagnosis is clinical; absence of systemic symptoms and unilateral canal\\ninflammation further support uncomplicated acute otitis externa in this setting.\\n[1][2][3][4]", "curator_notes": "Itchy ear with pain on pinna manipulation, erythematous and edematous external canal, and no major systemic symptoms are classic for acute otitis externa.", "reference_used": "Clinical practice guideline — acute otitis externa", "usmle_source_index": "140", "dataset_source_index": "141"}
22	2	142	A 34-year-old woman who is on active duty in the US Army comes to the\nmilitary urgent care clinic because of a 4-\nday history of headache, purulent nasal discharge, and left facial pain. She\nhas not had fever or chills. She has\nchronic bilateral knee pain, which she attributes to multiple parachute\njumps while she was assigned to an airborne\nunit 7 years ago. The knee pain is exacerbated by long-distance running on\npavement. Her only medication is\noccasional ibuprofen for the knee pain. The patient has no known\nmedication allergies. Temperature is 37.1°C\n(98.8°F), pulse is 60/min, respirations are 14/min, and blood pressure is\n122/80 mm Hg. Cervical lymph nodes are\nnot palpable. There is tenderness to palpation over the left maxillary sinus.\nNasal examination shows inflamed\nturbinates and purulent discharge. The patient needs to blow her nose\ntwice during the examination. Bilateral\notoscopic examination discloses no abnormalities. Examination of the\noropharynx shows scant purulent discharge\nposteriorly. The remainder of the examination discloses no abnormalities.\nWhich of the following is the most\nappropriate next step in management?	C	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Otolaryngology / Internal Medicine", "difficulty": "Easy", "explanation": "The most appropriate next step is symptomatic management with analgesics and\\ndecongestants for uncomplicated acute rhinosinusitis of 4 days’ duration.\\nTherefore, the correct answer is: Ibuprofen and decongestant therapy.\\nRationale:\\nPresentation is consistent with viral acute rhinosinusitis (<7–10 days,\\nnonsevere, no “double sickening”), for which watchful waiting and\\nsymptomatic therapy are recommended; antibiotics are reserved for\\npersistent (>10 days), severe, or worsening illness.[1][2][3][4]\\nImaging (CT or X-ray) and routine Gram stain/culture of nasal discharge\\nare not indicated in uncomplicated cases.[2][3][5][6]\\nTrimethoprim–sulfamethoxazole is not recommended empirically due to\\nhigh resistance in S. pneumoniae and H. influenzae (IDSA).[7]\\nPractical symptomatic options:\\nIbuprofen as needed for pain; consider intranasal corticosteroids and brief\\ntopical nasal decongestant use (?3–5 days) or oral decongestants for\\ncongestion; saline irrigation may help with purulent drainage.[1][2][4][8]\\nIf symptoms persist beyond 7–10 days or worsen, initiate antibiotics (e.g.,\\namoxicillin or amoxicillin–clavulanate per guideline).[1][2][4]\\nTo contextualize when antibiotics would be used if criteria are later met, the\\nfollowing table lists recommended antibiotic options and dosing from NEJM.[1]\\n• \\n• \\n• \\n• \\nHere is a concise table of recommended first-line antibiotic options and dosing\\nfor adults with acute bacterial sinusitis, useful if watchful waiting fails or severe\\ncriteria develop:\\nTable 1. Recommended Antibiotics for the Treatment of Acute Bacterial Sinusitis in Adults.\\nUsed under license from The New England Journal of Medicine.\\nCitations: NEJM clinical practice review on acute sinusitis; AAFP reviews; ACP/\\nCDC high-value care advice; American Academy of Otolaryngology–Head and\\nNeck Surgery guideline; IDSA ABRS guideline (Trimethoprim–sulfamethoxazole\\nnot recommended); IDSA/ASM diagnostic microbiology guidance (avoid nasal\\ndischarge cultures).[1][2][3][4][5][6][7][8]", "curator_notes": "Short-duration acute rhinosinusitis with purulent nasal discharge and maxillary sinus tenderness, without severe features or prolonged course; the appropriate next step is symptomatic treatment with ibuprofen and decongestants rather than imaging or antibiotics.", "reference_used": "Guidance on acute rhinosinusitis", "usmle_source_index": "141", "dataset_source_index": "142"}
23	2	143	A 16-year-old boy with VATER syndrome is brought to the physician\nbecause of 2-week history of harsh cough that\nbegan with a common cold. He receives no medications. Temperature is\n37°C (98.6°F), pulse is 70/min, respirations\nare 20/min, and blood pressure is 112/64 mm Hg. Examination shows a\nharsh vibratory sound in the mid anterior\nchest with forced expiration. A systolic murmur is heard best at the lower\nleft sternal border. There is mild scoliosis.\nSpirometry shows an FVC of 2.54 L (78% of predicted) and a slow vital\ncapacity of 2.88 L (85% of predicted). A\nflow volume loop shows scooping on the expiratory limb. Which of the\nfollowing is the most likely cause of the\ndiscrepancy between this patient’s forced and slow vital capacity\nmeasurements?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Pediatric Pulmonology", "difficulty": "Hard", "explanation": "Tracheal collapse\\nThe clinical context (history of TEF in VATER association, harsh expiratory\\nvibratory sound) and spirometry pattern (expiratory scooping on the flow–\\nvolume loop) point to intrathoracic tracheomalacia with dynamic expiratory\\ncollapse. During a forced maneuver, dynamic central airway collapse and early\\nairway closure reduce exhaled volume, so FVC underestimates true vital\\ncapacity, whereas SVC obtained with a slow maneuver is less affected and closer\\nto the actual VC. This produces the observed FVC < SVC discrepancy. The\\nAmerican Thoracic Society/European Respiratory Society technical standards\\nrecognize that dynamic airway collapsibility can lead to a lower FVC than SVC\\nand that inspiratory–expiratory loop abnormalities help localize intrathoracic\\ncentral airway obstruction.[1] Tracheomalacia is classically associated with TEF/\\nEA and VACTERL, and presents with barking/harsh cough and expiratory noise;\\nexpiratory flow–volume “scooping” and dynamic collapse are well described in\\npediatric tracheobronchomalacia.[2][3][4][5]\\nAlternatives are less consistent:\\nBronchospasm primarily causes airflow limitation but does not typically\\nexplain a marked SVC > FVC difference attributable to dynamic central\\nairway collapse.[6][7][8]\\nLaryngeal braking and extrathoracic lesions (subglottic mass, upper airway\\ncompression) produce inspiratory plateaus or variable extrathoracic\\npatterns rather than intrathoracic expiratory collapse with scooped\\nexpiratory limb.[1]\\nThus, dynamic intrathoracic airway collapse best explains the discrepant FVC\\nand SVC in this patient.[1][2][3][4][5]", "curator_notes": "Teenager with VATER syndrome, harsh expiratory cough/noise, and expiratory flow-volume loop abnormality; the discrepancy between FVC and slow vital capacity is best explained by dynamic intrathoracic tracheal collapse (tracheomalacia).", "reference_used": "Literature on tracheomalacia / dynamic tracheal collapse", "usmle_source_index": "142", "dataset_source_index": "143"}
24	2	144	A chief medical officer at a hospital has received several reports that one of\nher colleagues, a 64-year-old male\nsurgeon, has “not been acting like himself” recently. An administrative\nassistant says that during the past 6 months,\nthe surgeon’s dictations have become hard to follow and appear to be\nmissing information; previously, they were\ncomprehensive and easy to transcribe. The assistant adds that after the\nsurgeon missed three meetings in a row\nduring the past 2 months, he asked her to send him a text message 5\nminutes before the next meeting to let him\nknow its location. Previously, he was always in attendance and on time for\nmeetings. A senior resident also has\nnoted unusual behavior by the surgeon; the resident says that while on\nrounds 3 days ago, the surgeon listed\nincorrect indications for a specific surgical procedure. A scrub nurse\nreported that the surgeon used unsterile\npractices three times during a 2-hour procedure today. The chief medical\nofficer meets with the surgeon and asks\nhim about these reported incidents. The surgeon says that “nothing is\nwrong” and the people who reported him are\nangry with him for various reasons and “are trying to stir up trouble.”\nWhich of the following is the most appropriate\naction for the chief medical officer to take?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Medical Ethics / Psychiatry", "difficulty": "Medium", "explanation": "The most appropriate action is to Instruct the surgeon to take a temporary\\nleave of absence and undergo a medical evaluation.\\nRecent cognitive and behavioral changes with patient safety implications\\n(incorrect indications, unsterile technique) constitute a sentinel concern that\\nwarrants immediate restriction of clinical duties and prompt, formal fitness-for-\\nduty evaluation, irrespective of the surgeon’s denial or lack of insight. Deferring\\naction until further complaints or informally canvassing staff risks patient harm\\nand delays necessary assessment.[1][2][3][4]\\nBest practices include:\\nImmediate temporary removal from clinical duties to protect patients while\\nevaluation proceeds.[2][3][4]\\nComprehensive assessment encompassing medical, psychiatric, substance\\nuse, sensory, and cognitive/neuropsychological testing (e.g., MoCA,\\nMicroCog; escalation to full neuropsychological assessment as indicated) to\\ndetermine fitness and guide remediation or scope modification.[1][2][3][5]\\n[6][7][8]\\nA supportive, policy-based process through the medical staff well-being/\\ncredentialing structure, with pathways for remediation, restriction, or\\nretirement calibrated to findings.[1][2][3][5]\\n• \\n• \\n• \\nRationale: Physicians are poor self-assessors; peer reports alone are insufficient\\nsafeguards. Institutional policies and the American College of Physicians\\nemphasize acting on credible concerns to ensure patient safety, with\\nrehabilitation and reintegration when possible.[1][3][7][8]", "curator_notes": "Older surgeon with progressive cognitive and behavioral changes affecting documentation, judgment, and sterile technique; the appropriate action is temporary removal from clinical duties and formal medical evaluation to protect patient safety.", "reference_used": "Guidance on impaired physician and patient safety", "usmle_source_index": "143", "dataset_source_index": "144"}
25	2	145	A 33-year-old woman is admitted to the hospital because of visual field loss\nfollowing a 48-hour history of acute eye\npain. She also has a 3-week history of numbness and a feeling of\n"heaviness" in both legs. She has no history of\nserious illness and takes no medications. Six weeks ago, she returned from\na hiking expedition in the northeastern\nUSA; she has no recent history of international travel. Vital signs are within\nnormal limits. Muscle strength is 5/5 in\nthe upper extremities, 3/5 in the hip flexors and knee extensors, and 4/5\nin the knee flexors and ankle dorsiflexors.\nPatellar and ankle reflexes are 3+ bilaterally, and there is nonsustained\nankle clonus bilaterally. Sensation to\npinprick is absent throughout the lower extremities. Ophthalmologic\nexamination discloses optic neuritis and\nreconfirms the visual field loss. Which of the following studies is most likely\nto confirm the diagnosis?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Neurology", "difficulty": "Medium", "explanation": "Magnetic resonance imaging of the brain\\nThe presentation (acute optic neuritis, painful visual loss, and concurrent\\npyramidal and sensory signs with hyperreflexia and clonus) is classic for a\\ndemyelinating clinically isolated syndrome highly suggestive of multiple sclerosis\\n(MS). Brain MRI is the most sensitive test to demonstrate characteristic\\ndemyelinating lesions in typical locations and to establish dissemination in space\\nand, with contrast or new lesions over time, dissemination in time, enabling\\nconfirmation per contemporary diagnostic practice.[1][2][3][4] In optic neuritis\\ncohorts, abnormal brain MRI strongly predicts conversion to MS and\\noutperforms other modalities for initial confirmation, while optic nerve/3D-DIR\\nsequences further increase sensitivity to optic pathway involvement in MS\\ncontexts.[1][2][3]\\nCSF analysis for oligoclonal bands supports diagnosis and can substitute for\\ndissemination in time under the 2017 McDonald framework, increasing\\ndiagnostic sensitivity when MRI shows dissemination in space; however, MRI\\nremains the primary study to confirm MS in this clinical scenario and LP is\\ntypically reserved for atypical or equivocal cases.[2][4][5][6][7]\\nComputed tomography lacks sensitivity for demyelination. Electromyography/\\nnerve conduction studies evaluate peripheral neuropathies and neuromuscular\\ndisorders rather than central demyelination, and are not confirmatory here.[8][9]\\nLyme serology is not first-line in this presentation without specific\\nepidemiologic or clinical features suggesting neuroborreliosis.", "curator_notes": "Young woman with optic neuritis and upper motor neuron signs in the lower extremities; the presentation is highly suggestive of a demyelinating disorder such as multiple sclerosis, and brain MRI is the most appropriate study to confirm the diagnosis.", "reference_used": "Guidance on optic neuritis / demyelinating disease / multiple sclerosis", "usmle_source_index": "144", "dataset_source_index": "145"}
26	2	146	A 68-year-old woman comes to the office because she is concerned about\ndeveloping Alzheimer disease. She says\nshe has had increasing difficulty recalling names of people and objects\nduring the past 6 months. She has not had\ndifficulty with her activities of daily living, finances, or shopping. She\nteaches part-time at a local community\ncollege. She has no history of serious illness and takes no medications. She\ndoes not smoke cigarettes. She drinks\none 5-oz glass of wine daily. Her mother developed dementia, Alzheimer\ntype, in her mid 70s. Physical and\nneurologic examinations of the patient show no abnormalities. On\ncognitive testing, she has delayed recall of three\nof five words. She is able to perform serial sevens, knows similarities, is\nfully oriented, and has intact executive,\nvisuospatial, and attention abilities. Which of the following is the most\nappropriate next step in management?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Geriatrics / Neurology", "difficulty": "Medium", "explanation": "No additional diagnostic studies are indicated\\nThis presentation is typical amnestic mild cognitive impairment (MCI): objective\\nmemory deficit with preserved IADLs and normal neurologic exam. In such\\ncases, consensus guidance emphasizes clinical monitoring and risk-factor\\nmanagement rather than advanced biomarker testing, because routine use of\\namyloid PET, CSF biomarkers, APOE genotyping, or MRI volumetrics does not\\nchange management or improve outcomes in typical MCI without atypical\\nfeatures or rapid progression.[1][2][3][4][5][6] The American Academy of\\nNeurology (AAN) advises serial follow-up to track progression and address\\nmodifiable contributors (e.g., vascular risk, depression, medications), with\\ncounseling on exercise and cognitive/social engagement; no disease-modifying\\npharmacotherapy has proven benefit at this stage.[1][2]\\nWhy not the other options:\\nAmyloid PET: Appropriate only when results are expected to alter\\nmanagement after expert evaluation in atypical/unclear cases; not for\\nroutine MCI with typical features, and outcome benefit is unproven.[4][5]\\nAPOE genotyping: Not recommended for routine evaluation; does not alter\\nmanagement.[4]\\nCSF beta-amyloid: May be considered when diagnosis is unclear or atypical;\\nnot routinely indicated in straightforward MCI.[4]\\nMRI with volumetrics: Imaging in MCI is adjunctive to exclude structural\\nmimics when clinically suspected; routine volumetrics are not required in a\\ntypical case.[3]\\nPlan: longitudinal cognitive follow-up; optimize vascular risk factors, sleep,\\nmood; encourage aerobic exercise and cognitive/social engagement.[1][2]\\n• \\n• \\n• \\n•", "curator_notes": "Older woman with isolated memory impairment, preserved daily functioning, and otherwise intact cognition; the presentation is most consistent with amnestic mild cognitive impairment, and routine advanced diagnostic studies are not indicated at this stage.", "reference_used": "Guidance on mild cognitive impairment", "usmle_source_index": "145", "dataset_source_index": "146"}
27	2	147	A 55-year-old man with major depressive disorder is brought to the\nemergency department 1 1/2 hours after he was\nfound by his brother in his home acting strangely. On arrival, he is babbling\nincoherently and cannot answer\nquestions. There are two empty pill bottles in his pockets; one is for\nparoxetine and the other is for duloxetine. He is\nrestless, diaphoretic, and says he has a severe headache. Temperature is\n38.5°C (101.3°F), pulse is 130/min, and\nblood pressure is 145/105 mm Hg. The pupils are 8 mm and reactive to\nlight. Deep tendon reflexes are 4+ and\nsymmetric in all extremities. There is spontaneous myoclonus in the upper\nextremities. Results of laboratory studies,\nincluding a complete blood count, serum electrolyte concentrations,\ncreatine phosphokinase activity, and thyroid\nfunction tests, are within the reference ranges. After admitting the patient\nto the hospital for observation and\nsupportive care, what are you going to give or change in terms of\npharmacotherapy?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Psychiatry / Toxicology", "difficulty": "Medium", "explanation": "The presentation (abrupt onset after overdose of two serotonergic agents,\\nagitation, hyperthermia 38.5°C, tachycardia, hypertension, dilated pupils,\\nhyperreflexia 4+, and spontaneous myoclonus) meets Hunter/Sternbach features\\nof serotonin syndrome rather than NMS or anticholinergic toxicity.[1][2][3][4][5]\\n[6] First-line management is immediate cessation of serotonergic drugs and\\nsupportive care; antidopamine agents or dantrolene are not indicated for\\nserotonin toxicity.[4][5][7][8][9] Cyproheptadine can be used for moderate–\\nsevere cases but is not the pharmacotherapy “to add” in this stem after initial\\nstabilization.[4][5][8]\\nTherefore, the best choice is to stop the offending agents: Discontinue\\nparoxetine and duloxetine.[4][5][7][8][9]\\nWhy not the other options:\\nDantrolene treats NMS, not serotonin syndrome; its use in SS lacks\\nevidence.[2][9]\\nHaloperidol and olanzapine may worsen hyperthermia/rigidity or confound\\nNMS vs SS; they do not treat SS pathophysiology.[2][9]\\nCarbamazepine offers no benefit for SS and adds drug–drug risks.\\nThe following comparative table underscores the distinguishing neuromuscular\\nfindings (hyperreflexia/clonus in SS vs rigidity and reduced reflexes in NMS),\\nsupporting discontinuation of serotonergic agents as the correct action in this\\nscenario.[2]\\nThis table contrasts serotonin syndrome with NMS across key clinical features,\\nhighlighting hyperreflexia and clonus as signals of serotonin toxicity that direct\\nmanagement toward stopping serotonergic agents and supportive care rather\\nthan dantrolene or antipsychotics.\\n• \\n• \\n• \\nTable 1. Disorders That Simulate Neuroleptic Malignant Syndrome (NMS).*\\nUsed under license from The New England Journal of Medicine.", "curator_notes": "Patient with overdose of serotonergic agents, hyperthermia, diaphoresis, hyperreflexia, and spontaneous myoclonus; the presentation is classic for serotonin syndrome, and the appropriate pharmacologic step is to discontinue the offending serotonergic medications.", "reference_used": "Guidance on serotonin syndrome", "usmle_source_index": "146", "dataset_source_index": "147"}
28	2	148	A 32-year-old man comes to the office for a follow-up examination 2\nmonths after he was diagnosed with\nhypertension. He arrives late for the appointment, stating that he had to\nmake sure no one followed him here because\nsome "drug dealers" are after him. He insists that he be seen in an\nexamination room with no windows. He says he is\n"fine" but is reluctant to answer questions because "doctors hold\neverything against me." He doubts his diagnosis\nand says, "Doctors and drug companies are in cahoots trying to get my\nmoney." He refuses to speak with the office\nmanager about his bill because he thinks "she looks at me funny and makes\nnasty remarks about me behind my\nback." He says he has no history of psychiatric illness; his medical record\nindicates that he has made similar\nstatements during the past 7 years concerning doctors and office staff but\nhe always refused to elaborate on his\nstatements. His medications are metoprolol and hydrochlorothiazide. He\ndoes not drink alcohol or use illicit drugs.\nVital signs are within normal limits. Physical and neurologic examinations\nshow no abnormalities. Results of\nscreening laboratory studies are within the reference ranges. Which of the\nfollowing is the most appropriate next\nstep in management?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Psychiatry", "difficulty": "Medium", "explanation": "Determine whether the patient has had thoughts of harming others.\\nSafety assessment is the first priority in a patient with chronic paranoid ideation.\\nThe American Psychiatric Association recommends that the initial psychiatric\\nevaluation explicitly assess current and prior homicidal or aggressive thoughts,\\npast violent behaviors, access to weapons, targets, and related risk factors, with\\ndocumentation of risk estimation.[1] Paranoid delusions can be associated with\\nviolence risk; rapid determination of dangerousness informs need for urgent\\nreferral, possible involuntary hold, or hospitalization as outlined in pediatric-to-\\nyoung-adult care pathways when safety is a concern.[2] Only after establishing\\nsafety should treatment (e.g., antipsychotic initiation for suspected delusional\\ndisorder) be pursued; while second-generation antipsychotics such as\\nrisperidone can be effective in persistent delusional disorder, therapy selection\\nand setting hinge on the risk assessment.[3][4]\\nPractical next steps after asking about homicidal ideation include:\\nIf any positive or concerning responses: assess specifics (intent, plan,\\nmeans, targets), access to firearms, impulsivity, substance use, and arrange\\nED/psychiatric evaluation urgently as needed.[1][2]\\nIf risk is low and no dangerousness: proceed with outpatient management,\\nincluding discussing antipsychotic options and adherence strategies, and\\nconsider collateral information and monitoring supports.\\n• \\n• \\nInitiating clonazepam or sertraline does not address psychosis and is not\\nappropriate before safety is established; starting risperidone may be reasonable\\nsubsequently but should follow a structured risk assessment.[1][2][3]", "curator_notes": "Patient with chronic persecutory/paranoid ideation and impaired trust in healthcare staff; the most appropriate next step is to assess for thoughts of harming others because safety and violence risk must be clarified before treatment decisions.", "reference_used": "APA guideline — initial psychiatric evaluation and violence risk", "usmle_source_index": "147", "dataset_source_index": "148"}
29	2	149	An 87-year-old woman, gravida 2, para 2, is brought to the emergency\ndepartment from a skilled nursing care\nfacility because of profuse vaginal bleeding for 2 days. At the age of 41\nyears, she underwent a cold knife cone\nbiopsy for cervical dysplasia. Annual follow-up Pap smears until the age of\n65 years showed no abnormalities. She\nis in moderate distress. Temperature is 36.1°C (97.0°F), pulse is 84/min,\nrespirations are 30/min, and blood pressure\nis 140/90 mm Hg. Abdominal examination shows mild distention and\ntenderness; no masses are palpated. Pelvic\nexamination shows a large verrucous lesion on the perineum partially\ncovering the anal verge. Speculum\nexamination shows atrophic changes on the vagina and cervix. Which of\nthe following is the most likely explanation\nfor these findings?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Gynecologic Oncology", "difficulty": "Medium", "explanation": "Vulvar carcinoma\\nA large verrucous perineal lesion in an elderly woman, partially covering the anal\\nverge, with associated bleeding is most consistent with vulvar squamous cell\\ncarcinoma, often with verrucous morphology in this age group. Verrucous\\ncarcinoma of the vulva presents as an exophytic, warty mass in older women and\\nmay bleed or ulcerate.[1][2][3][4] The anatomic location (perineum/vulva\\nabutting the anal verge) and morphology argue against rectal carcinoma or\\npolyps, which typically present intraluminally; external hemorrhoids are not\\nverrucous and usually cause perianal pain/itching with defecation rather than\\nprofuse vaginal bleeding.[5] Cervical carcinoma is less likely given decades of\\nnormal screening through age 65, atrophic cervix on exam, and the lesion’s\\nlocation and appearance.[6] While colorectal and anal primaries can rarely mimic\\ngynecologic disease, the described exophytic verrucous vulvar/perineal mass in\\nthis clinical context favors a primary vulvar malignancy.[7] Biopsy is required for\\nconfirmation and staging.[2]", "curator_notes": "Older woman with profuse bleeding and a large verrucous perineal/vulvar lesion partially covering the anal verge; the presentation is most consistent with vulvar carcinoma rather than cervical, rectal, or hemorrhoidal disease.", "reference_used": "Guidance on vulvar carcinoma", "usmle_source_index": "148", "dataset_source_index": "149"}
30	2	150	A 47-year-old woman comes to the office for a routine health maintenance\nexamination. She feels well and has no\nhistory of serious illness. Examination shows a 2-cm, soft, nontender\nnodule in the right lobe of the thyroid gland.\nThere is no lymphadenopathy. Her serum thyroid-stimulating hormone\nconcentration is within the reference range.\nWhich of the following is the most appropriate initial step in management?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Endocrinology", "difficulty": "Medium", "explanation": "The most appropriate initial step is to obtain a diagnostic neck ultrasound. In an\\nasymptomatic, euthyroid patient with a newly palpated 2-cm thyroid nodule,\\nultrasound is the first test to characterize composition, echogenicity, margins,\\ncalcifications, shape, and cervical nodes; these sonographic features, together\\nwith size, determine whether fine-needle aspiration (FNA) is indicated.[1][2][3][4]\\n[5] CT and surgery are not first-line without compressive or invasive features;\\nshort-interval clinical reexamination without imaging is not recommended.[1][6]\\n[7]\\nTherefore, the correct choice is: Ultrasonography of the thyroid gland.\\nHow ultrasound guides next steps:\\nIf high/intermediate suspicion features are present, US-guided FNA is\\nrecommended at ?1 cm; for low suspicion, ?1.5 cm; for very low suspicion,\\nconsider FNA at ?2 cm or observation. Given a 2-cm nodule, FNA would be\\nindicated if the ultrasound is ?low suspicion.[4][5]\\nThe table below, endorsed by contemporary guidelines, summarizes how\\nstandardized ultrasound risk systems direct FNA decisions, which is precisely\\nwhy ultrasound is the first step.\\n• \\nTable 1. Standardized Sonographic Scoring Systems Proposed or Endorsed by Practice Guidelines for\\nRisk-Based Fine-Needle Aspiration Biopsy Guidance for Thyroid Nodules\\nUsed under license from JAMA Network.\\nWhy other options are not first:\\nFine-needle aspiration: performed selectively based on ultrasound\\nfeatures/size, not before ultrasound.[1][4][5]\\nCT neck: not recommended for routine initial evaluation; reserved for\\nsuspected invasive disease, substernal extension, or nodal disease not well-\\nvisualized on ultrasound.[6][7]\\nSurgical excision: not indicated without cytologic/clinical suspicion.[1][4]\\n[5]\\n• \\n• \\n• \\nReexamination in 3 months: delays essential risk stratification; ultrasound\\nshould be performed now.[1][5]", "curator_notes": "Euthyroid adult with a newly detected 2-cm thyroid nodule; the most appropriate initial step is thyroid ultrasound to characterize sonographic features and determine whether fine-needle aspiration is indicated.", "reference_used": "ATA guideline — thyroid nodule evaluation", "usmle_source_index": "149", "dataset_source_index": "150"}
31	2	151	A 1-hour-old male newborn is examined in the hospital nursery. He was\nborn at term to a 22-year-old woman,\ngravida 1, para 1, with HIV infection. The mother took antiretroviral therapy\nthroughout her pregnancy, and her HIV\nviral load was consistently <1000 copies/mL. She received intravenous\nzidovudine (AZT) during labor. The\npatient’s Apgar scores were 8 and 9 at 1 and 5 minutes, respectively. He is at\nthe 50th percentile for length, weight,\nand head circumference. He appears well. Examination shows no\nabnormalities. In addition to administration of the\nhepatitis B vaccine, which of the following is the most appropriate\npharmacotherapy for this newborn?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Pediatrics / Infectious Diseases", "difficulty": "Medium", "explanation": "Zidovudine (AZT)\\nThis term newborn is low risk for perinatal HIV transmission given maternal ART\\nwith sustained low viral load and intrapartum IV zidovudine. U.S. guidance\\n(American Academy of Pediatrics and HHS Perinatal Panel) recommends\\nneonatal zidovudine monotherapy started as soon as possible after birth\\n(preferably within 6 hours). Duration can be shortened in low-risk infants;\\ncurrent HHS guidance favors 2 weeks for infants with sustained maternal\\nsuppression, with longer courses used in higher-risk scenarios.[1][2][3][4] Typical\\ndosing for term infants: ZDV 4 mg/kg orally every 12 hours (if IV needed: 3 mg/\\nkg every 12 hours); adjust per gestational age.\\nMulti-drug presumptive therapy is reserved for high-risk exposures (e.g.,\\nmaternal viremia near delivery, no antepartum ART, or drug resistance).[1][2]\\nLopinavir-ritonavir is not recommended in neonates due to safety concerns and\\nage restrictions, particularly in the immediate postnatal period.[1][2][5][6]\\nTrimethoprim-sulfamethoxazole is not indicated at birth; it is used starting at 4–\\n6 weeks only for infants with indeterminate or confirmed HIV infection for\\nPneumocystis prophylaxis.[1] Penicillin is used for congenital syphilis, not HIV\\nprophylaxis.[7]", "curator_notes": "Term newborn of a mother with well-controlled HIV infection and low viral load; this is a low-risk perinatal HIV exposure scenario, and the appropriate neonatal pharmacotherapy is zidovudine monotherapy.", "reference_used": "AAP / HHS guidance — prevention of perinatal HIV transmission", "usmle_source_index": "150", "dataset_source_index": "151"}
32	2	152	A 25-year-old woman comes to the office because she has not had a\nmenstrual period for 6 months. Previously,\nmenses occurred at regular 28-day intervals. She has not had blurred or\ndouble vision. She has no history of serious\nillness and takes no medications. Temperature is 37.0°C (98.6°F), pulse is\n72/min, and blood pressure is\n108/60 mm Hg. The pupils are equal and reactive to light; extraocular\nmuscles are intact. Funduscopic examination\nshows no abnormalities. Visual field testing shows bitemporal hemianopia.\nMilky discharge can be expressed from\nthe nipples. Pelvic examination shows no abnormalities. Serum studies\nshow a thyroid-stimulating hormone\nconcentration of 2.0 ?U/mL and a prolactin concentration of 100 ng/mL. A\nurine pregnancy test is negative. MRI of\nthe pituitary gland shows a 1.2 × 1.5-cm mass compressing the optic\nchiasm. Which of the following is the most\nappropriate next step in management?	B	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Endocrinology / Gynecology", "difficulty": "Hard", "explanation": "The most appropriate next step is Cabergoline therapy.\\nRationale:\\nThis presentation is classic for a macroprolactinoma (1.2 × 1.5 cm) with\\nchiasmal compression causing bitemporal hemianopia and\\nhyperprolactinemia. First-line therapy for prolactinomas, including\\nmacroadenomas with visual field defects, is a dopamine agonist (preferably\\ncabergoline), which both normalizes prolactin and rapidly shrinks tumor\\nvolume, often reversing visual compromise. According to a review\\npublished in JAMA:[1][2][3][4][5]\\n\\"Dopamine agonist therapy is first-line treatment for patients with\\nprolactinomas and for patients with idiopathic hyperprolactinemia\\n(hyperprolactinemia without a discernible cause) who are\\nsymptomatic, those with macroadenomas, or those who are\\nconsidering pregnancy. Bromocriptine (2.5-10 mg/d orally) and\\ncabergoline (0.5-2.0 mg/wk orally) are approved by the US Food and\\nDrug Administration (FDA) for treating hyperprolactinemia and\\nprolactinomas.\\"\\n—Nicholas A. Tritos, MD, DSc1,2 et al., Neuroendocrine Unit,\\nMassachusetts General Hospital, Boston and other institutions. \\nDiagnosis and Management of Pituitary Adenomas: A Review. JAMA.\\nApril 25, 2023.\\nUsed under license from JAMA Network.\\nCabergoline typical starting dose: 0.25–0.5 mg twice weekly (0.5–1 mg/\\nweek), titrated to normalize prolactin and reduce tumor size, with close\\nfollow-up of visual fields and MRI to document early decompression. Rapid\\n• \\n• \\nvisual improvement can occur within days to weeks as the tumor involutes.\\n[2][3][4]\\nSurgery is not first-line in the absence of acute, rapidly progressive vision\\nloss, apoplexy, dopamine-agonist intolerance, or resistance. Gamma knife is\\nreserved for refractory disease after medical and surgical options. Biopsy is\\nunnecessary given classic biochemical and radiographic findings. Oral\\ncontraceptives do not treat the underlying adenoma.[1][2][4][6]\\nAdditional note:\\nComparative data suggest similar short-term visual outcomes between\\ninitial medical and surgical approaches in macro/giant prolactinomas,\\nfurther supporting initial dopamine agonist therapy unless there is urgent\\nneuro-ophthalmologic deterioration.[7]\\nAnswer: Cabergoline therapy (choice B).", "curator_notes": "Young woman with amenorrhea, galactorrhea, hyperprolactinemia, bitemporal hemianopia, and a pituitary macroadenoma compressing the optic chiasm; the most appropriate next step is cabergoline therapy as first-line treatment for macroprolactinoma.", "reference_used": "Guidance on prolactinoma / hyperprolactinemia", "usmle_source_index": "151", "dataset_source_index": "152"}
33	2	153	A 2-week-old boy is evaluated in the neonatal intensive care unit because\nof temperature instability and decreased\nactivity. He was born by cesarean delivery at 30 weeks’ gestation because\nof premature rupture of membranes. Since birth, he has been fed breast\nmilk by orogastric tube. He was feeding and growing appropriately until\ntoday, when\nhis axillary temperature was 36.5°C (97.7°F) and he had decreased activity.\nDuring the past 4 hours, gastric residue\nhas been noted in the orogastric tube when it is aspirated prior to feedings.\nTemperature is now 37.0°C (98.6°F),\npulse is 160/min, respirations are 50/min, and blood pressure is 70/40 mm\nHg. The anterior fontanel is soft.\nCardiopulmonary examination shows no abnormalities. The abdomen is\nmildly distended, and there is mild\ntenderness to palpation diffusely; there are no masses. Bowel sounds are\ndecreased. There is a small amount of\nblood-streaked stool in the diaper. The remainder of the examination\nshows no abnormalities. Leukocyte count is\n18,000/mm³ (N=5000–34,000) (80% segmented neutrophils, 5% bands, 10%\nlymphocytes, and 5% monocytes), and\nplatelet count is 100,000/mm³. Blood culture results are pending. Which of\nthe following is most likely to confirm the diagnosis?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Neonatology", "difficulty": "Medium", "explanation": "E) X-ray of the abdomen\\nAbdominal radiography is the most likely study to confirm necrotizing\\nenterocolitis (NEC) in this clinical context. Classic radiographic hallmarks include\\npneumatosis intestinalis, portal venous gas, and pneumoperitoneum, which are\\nspecific for NEC and establish the diagnosis in a compatible clinical setting. This\\npatient’s temperature instability, abdominal distension, decreased bowel sounds,\\nblood-streaked stool, and thrombocytopenia are highly concerning for NEC,\\nwhere abdominal X-ray is the diagnostic test of choice due to speed, availability,\\nand ability to visualize pathognomonic findings.[1]\\nPT/PTT (A) may identify coagulopathy but does not confirm NEC. \\nStool reducing substances (B) assess carbohydrate malabsorption; not\\ndiagnostic for NEC. \\nStool culture (C) evaluates infectious diarrhea; yield is limited and not\\nconfirmatory for NEC, and culture-independent tests are preferred when\\nbacterial gastroenteritis is suspected per the Infectious Diseases Society of\\nAmerica. [2]\\nUpper GI series (D) is not first-line in suspected NEC given risk of\\nperforation and limited utility.\\nIn neonates with hematochezia and abdominal distension, NEC is a leading\\ncause; abdominal X-ray provides specific evidence to confirm the diagnosis and\\nguide urgent management.[1][2]\\n• \\n• \\n• \\n•", "curator_notes": "Premature neonate with feeding intolerance, abdominal distension, blood-streaked stool, and thrombocytopenia; the presentation is highly suspicious for necrotizing enterocolitis, and abdominal X-ray is the most likely study to confirm the diagnosis.", "reference_used": "Guidance on necrotizing enterocolitis", "usmle_source_index": "152", "dataset_source_index": "153"}
34	2	154	A 13-month-old boy is brought to a small rural emergency department (ED)\nnear his family's community because of an erythematous, edematous mass\nin his perianal area that is hot to touch. He has no history of serious illness\nand receives no medications. Growth and development are appropriate for\nage. Vaccinations are up-to-date. He is at the 50th percentile for length\nand weight. Temperature is 39.4°C (103.0°F), pulse is 160/min, and\nrespirations are 36/min. Examination shows fluctuance and exquisite\ntenderness to palpation of the perianal mass. Oral acetaminophen and a\ndose of oral cephalexin are administered, and the parents are told that\ntheir child’s case is beyond the capabilities of the hospital. They are\nreferred to the nearest hospital with a pediatric service, a suburban\nhospital 50 miles away. The suburban hospital is contacted regarding the\nreferral and a pediatric surgeon accepts transfer of the patient. When the\npatient is brought to the ED of the suburban hospital, a triage nurse\nobtains his oral temperature of 37.7°C (99.8°F) and pulse of 126/min. The\nnurse notes that the family has no health insurance and states that the case\nis beyond the capabilities of the hospital. The nurse recommends taking\nthe patient to the ED of a downtown university hospital 4 miles away. The\nparents follow this recommendation, and the patient undergoes incision\nand drainage of the abscess at the downtown hospital later that day. Which\nof the following is the most accurate characterization of this patient's\npattern of care?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Emergency Medicine / Health Ethics", "difficulty": "Hard", "explanation": "(E) The suburban hospital violated the Emergency Medical Treatment and\\nActive Labor Act (EMTALA)\\nEMTALA imposes a nondiscriminatory duty on Medicare-participating hospitals\\nwith emergency departments to provide an appropriate medical screening\\nexamination (MSE) to anyone who presents for emergency care and to provide\\nnecessary stabilizing treatment or an appropriate transfer if an emergency\\nmedical condition exists, regardless of insurance status.[1][2][3] The American\\nCollege of Emergency Physicians emphasizes that the MSE and stabilizing care\\nmust not be delayed or denied based on ability to pay and that on-call specialists\\nmust respond within a reasonable time to provide stabilizing care within the\\nhospital’s capabilities.[4] Pediatric patients are fully covered by EMTALA; consent\\nor insurance issues cannot delay the MSE or stabilizing treatment, as noted by\\nthe American College of Emergency Physicians’ guidance on minors.[5][6]\\nHere, the suburban hospital accepted the transfer for a child with a likely\\nperianal abscess—an emergent, painful condition that typically requires timely\\nincision and drainage. Redirecting the family upon arrival based solely on lack of\\ninsurance, without an MSE and stabilizing care, constitutes impermissible\\n“patient dumping” under EMTALA’s screening and stabilization mandates.[1][2][7]\\nThe literature further underscores that financially motivated redirection or\\ntransfer is the type of conduct EMTALA was enacted to prevent.[8][9][10]", "curator_notes": "Infant with an emergency condition was redirected after transfer acceptance because of lack of insurance; this pattern of care is most consistent with an EMTALA violation because emergency screening and stabilizing treatment cannot be denied on financial grounds.", "reference_used": "EMTALA", "usmle_source_index": "153", "dataset_source_index": "154"}
35	2	155	A 25-year-old woman is brought to the emergency department by\nparamedics because of a seizure that began 45\nminutes ago at home. Intravenous antiepileptic therapy begun en route to\nthe hospital has not stopped her seizure.\nHer parents report that she initially began crying, then fell to the floor and\nexhibited asymmetric kicking and\nthrashing of all extremities. Fifteen years ago, she was diagnosed with a\nseizure disorder. Her seizures had been well\ncontrolled with oral antiepileptic therapy until this morning. Today, while\nthe physician is in the patient’s room, the\nmovements of her extremities gradually subside. The patient then sits up\nand asks the physician what happened. She\nis fully oriented. Vital signs are within normal limits. Examination shows no\nevidence of tongue biting, urinary\nincontinence, or other abnormalities. Which of the following is most likely\nto confirm this patient’s diagnosis?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Neurology / Psychiatry", "difficulty": "Hard", "explanation": "The semiology described (prolonged event, ictal crying, asynchronous\\nthrashing/kicking, preserved orientation, no tongue biting/incontinence, and\\nrefractoriness to AEDs) is most consistent with psychogenic nonepileptic\\nseizures (PNES). The diagnostic gold standard is capturing a typical event\\nwithout ictal epileptiform activity on simultaneous video-EEG. Therefore, the\\nbest confirmatory test is: Video electroencephalogram monitoring.\\nPNES is suggested by long duration, fluctuating/asynchronous movements,\\nictal crying, eye closure, and absence of postictal confusion or injury. [1][2]\\n[3]\\nWhile neuropsychological testing and psychometrics may support the\\nassessment, they do not confirm PNES and have limited standalone\\ndiscriminative power. [4][5]\\nPostictal labs (CK, prolactin) can be supportive but are neither necessary\\nnor sufficient to confirm PNES and have limited sensitivity/negative\\npredictive value. [6][7][8]\\nDrug levels do not distinguish PNES from epilepsy. \\nIn refractory or atypical cases, inpatient EMU evaluation with vEEG is\\nrecommended; expert consensus and the National Association of Epilepsy\\nCenters emphasize vEEG as essential for differentiating epileptic from\\nnonepileptic events.[9][10][11]", "curator_notes": "Prolonged seizure-like episode with ictal crying, asynchronous thrashing, preserved orientation after the event, and no typical postictal findings; the presentation is most consistent with psychogenic nonepileptic seizures, and video EEG monitoring is the best confirmatory test.", "reference_used": "Literature on psychogenic nonepileptic seizures", "usmle_source_index": "154", "dataset_source_index": "155"}
36	2	156	A 32-year-old woman comes to the emergency department because of a 1-\nday history of sharp, right-sided chest\npain that worsens with coughing and sneezing. Four days ago, she had a\nmild sore throat and runny nose followed\nby nonproductive cough 1 day later. Over-the-counter decongestant and\naspirin mildly relieved the symptoms. She\nhas not had shortness of breath, blood-tinged sputum, fever, or chills. She\nhas a long-standing history of recurrent\naphthous ulcers. Her only medication is an oral contraceptive. Temperature\nis 37.2°C (99.0°F), pulse is 65/min, and\nrespirations are 14/min. Pulse oximetry on room air shows an oxygen\nsaturation of 99%. Splinting is observed over\nthe right hemithorax with deep breathing. On cardiac examination, no\nabnormalities are heard. The remainder of the\nexamination shows no abnormalities. Chest x-ray shows no abnormalities.\nWhich of the following is the most\nappropriate next step in management?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Internal Medicine / Emergency Medicine", "difficulty": "Easy", "explanation": "Ibuprofen therapy\\nThe presentation (young woman with viral prodrome, sharp pleuritic right-sided\\nchest pain, normal vitals and oxygenation, normal chest radiograph, and chest\\nwall splinting) is most consistent with viral pleurisy/nonspecific pleuritic chest\\npain. For uncomplicated, low-risk pleuritic chest pain after a viral URI, first-line\\nmanagement is NSAIDs for analgesia and anti-inflammatory effect; further\\ntesting is not indicated when serious causes have been reasonably excluded\\nclinically and by chest radiography.[1][2][3][4] The American College of\\nCardiology/American Heart Association multisociety chest pain guideline\\nemphasizes prioritizing exclusion of life-threatening causes; in a low-risk patient\\nwithout red flags, additional testing (ECG, CTA, echocardiography) is not\\nroutinely required.[2][3] Pericarditis is unlikely given absence of positional\\ncomponent, friction rub, ECG changes, or effusion; if suspected, NSAIDs are also\\nfirst-line.[5]\\nReason against azithromycin: no evidence of bacterial pneumonia (afebrile,\\nnormal CXR), and antibiotics are not indicated for acute bronchitis/viral\\npleurisy in this setting.[1][6][7]\\nReason against prednisone: no indication; short courses carry measurable\\nrisks (e.g., VTE), particularly relevant in an oral contraceptive user.[8]\\nReason against CTA/ECG/echo: no features suggesting PE, ACS, or\\nstructural cardiac disease; PE pretest probability is low despite OCP use,\\nand oxygenation/exam are normal.[1][2][3][4]\\nTypical NSAID dosing for pleuritic pain: ibuprofen 400–600 mg orally every 6–8\\nhours as needed, for several days with gastroprotection as appropriate.[1][5]\\nReassess if red flags develop (dyspnea, hypoxemia, fever, hemoptysis, syncope,\\ncalf pain/swelling) or pain persists/worsens.\\n• \\n• \\n•", "curator_notes": "Young woman with pleuritic chest pain after a viral prodrome, normal oxygenation, and normal chest x-ray; the presentation is most consistent with uncomplicated viral pleurisy, and ibuprofen is the most appropriate next step in management.", "reference_used": "Guidance on pleuritic chest pain / viral pleurisy", "usmle_source_index": "155", "dataset_source_index": "156"}
37	2	157	A 30-year-old nulligravid woman, who is a military veteran, comes to the\noffice because she has not had a menstrual\nperiod for the past year. She has not had nausea, vomiting, or night sweats.\nMenses previously occurred at regular\n28-day intervals. She is sexually active with one male partner and uses\ncondoms consistently. Three weeks ago, she\nreturned from a 1-year deployment in the Middle East, where she worked\nas an army combat medic. She resumed\nwork as a teacher 2 weeks ago. She appears tearful but otherwise in no\ndistress. Temperature is 37.1°C (98.7°F),\npulse is 88/min, respirations are 16/min, and blood pressure is 116/72 mm\nHg. Physical examination, including\npelvic examination, shows no abnormalities. Serum studies show:\nThyroid-stimulating hormone: 2 ?U/mL\nFollicle-stimulating hormone: 7 mIU/mL\nLuteinizing hormone: 10 mIU/mL\nProlactin: 10 ng/mL\n?-hCG: negative\nWhich of the following is the most likely cause of this patient’s\namenorrhea?	B	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Endocrinology / Gynecology", "difficulty": "Medium", "explanation": "The most likely cause is hypothalamic hypogonadism (functional hypothalamic\\namenorrhea). This patient has secondary amenorrhea with normal TSH and\\nprolactin, low–normal gonadotropins (FSH 7 mIU/mL, LH 10 mIU/mL), and no\\nvasomotor or hyperandrogenic features. Her recent prolonged military\\ndeployment and transition stress are classic precipitants of stress-related GnRH\\nsuppression leading to anovulation and amenorrhea.[1][2][3][4][5] The Endocrine\\nSociety (US) emphasizes psychosocial stress, energy imbalance, and intensive\\ntraining (including military settings) as common triggers for FHA with reduced\\nGnRH/LH pulsatility and low/normal gonadotropins.[3][5] Alternative diagnoses\\nare less consistent: Turner syndrome and primary ovarian insufficiency typically\\nshow elevated FSH; prolactinoma shows hyperprolactinemia; and PCOS requires\\nhyperandrogenism and/or polycystic ovarian morphology, which are absent\\nhere.[2][6][7][8]\\nTo clarify the ovulatory dysfunction differential that includes PCOS, it is helpful\\nto recall that PCOS diagnosis requires combinations of hyperandrogenism,\\novulatory dysfunction, and polycystic ovaries; this patient lacks clinical/\\nbiochemical hyperandrogenism and has long-standing amenorrhea temporally\\nlinked to stress, favoring FHA over PCOS.[6]\\nTable 1. Diagnostic Criteria for the Polycystic Ovary Syndrome.\\nUsed under license from The New England Journal of Medicine.\\nClinical pearls:\\nFHA: stress/energy deficit/exercise; low or low-normal LH/FSH; normal\\nprolactin/TSH; anovulation.[1][2][3][4]\\nPCOS: requires hyperandrogenism and/or polycystic ovarian morphology\\nplus ovulatory dysfunction; typically features clinical or biochemical\\nhyperandrogenism.[6]\\nPOI/Turner: hypergonadotropic hypogonadism (elevated FSH) and often\\nvasomotor symptoms.[7][8]\\nProlactinoma: elevated prolactin and often galactorrhea.[2]\\nNext steps for FHA: confirm exclusion of pregnancy/organic causes, assess\\nstress, nutrition, and exercise; address modifiable triggers; consider bone health\\nassessment; and reserve pharmacologic ovulation induction only if fertility is\\ndesired and lifestyle measures fail.[1][3][4]\\n• \\n• \\n• \\n•", "curator_notes": "Secondary amenorrhea in a young woman with normal prolactin, normal TSH, negative pregnancy test, and low-normal gonadotropins after prolonged psychosocial stress; the presentation is most consistent with functional hypothalamic hypogonadism.", "reference_used": "Guidance on functional hypothalamic amenorrhea", "usmle_source_index": "156", "dataset_source_index": "157"}
38	2	158	A 45-year-old woman comes to the office because she has not had a\nmenstrual period for 1 year. Menses previously\noccurred at regular 30-day intervals. She feels well, has no history of\nserious illness, and takes no medications. She\nhas smoked one-half pack of cigarettes daily for 20 years. She is sexually\nactive with one male partner and uses\ncondoms consistently. She is 163 cm (5 ft 4 in) tall and weighs 63 kg (140 lb);\nBMI is 24 kg/m². Vital signs are\nwithin normal limits. Physical examination, including pelvic examination,\nshows no abnormalities. Measurement of\nwhich of the following serum concentrations is most likely to confirm the\ndiagnosis?	B	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Gynecology / Endocrinology", "difficulty": "Easy", "explanation": "The clinical picture is consistent with natural menopause (12 months of\\namenorrhea at age 45 without other causes). The single serum measurement\\nmost likely to confirm ovarian failure in this context is an elevated follicle-\\nstimulating hormone, reflecting loss of ovarian negative feedback; estradiol and\\nLH fluctuate and are less reliable, and beta-hCG is used to exclude pregnancy,\\nnot confirm menopause. Smoking increases the likelihood of earlier menopause\\nin this patient’s age range, further supporting the expectation of elevated FSH.[1]\\n[2][3][4][5][6][7]\\nAnswer: Follicle-stimulating hormone\\nThe diagnostic approach for ovarian insufficiency/menopause emphasizes\\nmeasuring FSH (and, when needed, confirming with concurrent low estradiol), as\\nshown below.[1] Although the Choosing Wisely statement advises against using\\nFSH to “identify the menopausal transition,” once 12 months of amenorrhea have\\noccurred, FSH elevation is the most specific laboratory corroboration of ovarian\\nfailure.[1][2][3][4]\\nFigure 1. Diagnostic Approach in a Patient with Possible Primary Ovarian Insufficiency.\\nUsed under license from The New England Journal of Medicine.", "curator_notes": "Woman aged 45 with 12 months of amenorrhea and no evidence of another cause; the most useful laboratory confirmation of ovarian failure/menopause is an elevated follicle-stimulating hormone level.", "reference_used": "Guidance on menopause / ovarian failure laboratory evaluation", "usmle_source_index": "157", "dataset_source_index": "158"}
39	2	159	A 2-month-old girl is brought to the office by her mother for a routine\nexamination. Newborn screening\nelectrophoresis showed hemoglobin FS. The mother says her daughter has\nnot had fever or pallor. The patient is\nfeeding well and gaining weight appropriately. She receives no medications.\nShe appears well. She is at the 35th\npercentile for length and weight. Temperature is 37.0°C (98.6°F), pulse is\n158/min, and respirations are 28/min.\nExamination shows no abnormalities. All routine immunizations are\nadministered. In addition to routine anticipatory\nguidance about feeding and development, the mother is instructed to\nobserve the patient for pallor and fever and to\npalpate for an enlarged spleen. Which of the following is most appropriate\nto prevent complications in this patient?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Pediatrics / Hematology", "difficulty": "Medium", "explanation": "Oral prophylactic penicillin therapy\\nHemoglobin FS on newborn screening indicates sickle cell disease (most\\ncommonly HbSS), with functional asplenia in early infancy and high risk for\\ninvasive pneumococcal disease. The American Academy of Pediatrics\\nrecommends initiating penicillin V potassium prophylaxis by age 2 months for all\\ninfants with HbSS or S?0-thalassemia to prevent life-threatening pneumococcal\\nsepsis, increasing the dose at age 3 years, and continuing until at least age 5\\nyears or completion of an appropriate pneumococcal vaccine series, with\\nconsideration of longer use in select patients (e.g., prior invasive pneumococcal\\ndisease or postsplenectomy).[1] GeneReviews likewise recommends penicillin V\\n125 mg PO twice daily starting by 2 months, increased to 250 mg PO twice daily\\nat age 3 years, through at least age 5 years; amoxicillin 20 mg/kg/day may be\\nsubstituted for palatability or cost, and erythromycin for penicillin allergy.[2]\\nRandomized trials summarized in a Cochrane review support reduced\\npneumococcal infections with prophylactic penicillin in young children with SCD\\nand minimal adverse effects.[3]\\nOther listed options are not appropriate for prevention of early invasive\\npneumococcal disease: amoxicillin “as needed” for fever does not provide\\nprophylaxis; routine palpation of long bones and daily pulse checks are not\\nrecommended preventive measures; low-dose aspirin is not indicated for SCD\\nprophylaxis in children given insufficient evidence and potential risks.[1][2][3][4]", "curator_notes": "Infant with newborn screening showing hemoglobin FS, consistent with sickle cell disease; the most appropriate preventive measure is oral prophylactic penicillin to reduce the risk of invasive pneumococcal infection in early childhood.", "reference_used": "AAP guidance — sickle cell disease prophylaxis in infancy", "usmle_source_index": "158", "dataset_source_index": "159"}
40	2	160	A 3-week-old boy is brought to the physician by his mother because of a 5-\nday history of yellow eyes and skin and\nwhite stools. Pregnancy and delivery were uncomplicated. The patient's\ntemperature is 37.1°C (98.8°F), pulse is\n160/min, respirations are 40/min, and blood pressure is 85/50 mm Hg.\nExamination shows diffuse jaundice.\nCardiopulmonary examination shows no abnormalities. The abdomen is\nnontender. The liver edge is palpated 4 cm\nbelow the right costal margin. The spleen tip is palpated 3 cm below the\nleft costal margin. Laboratory studies show:\nLeukocyte count: 10,000/mm³\nSerum\nBilirubin, total: 16 mg/dL\nDirect: 12 mg/dL\nAST: 800 U/L\nALT: 500 U/L\nAmylase: 100 U/L\nWhich of the following is the most appropriate next step in diagnosis?	B	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Pediatrics / Gastroenterology", "difficulty": "Medium", "explanation": "Ultrasonography of the abdomen.\\nA 3-week-old with persistent jaundice, acholic stools, hepatosplenomegaly, and\\ndirect hyperbilirubinemia has high pretest probability of neonatal cholestasis,\\nespecially biliary atresia. Expedited evaluation is essential to enable timely Kasai\\nportoenterostomy when indicated. The North American Society for Pediatric\\nGastroenterology, Hepatology and Nutrition/European Society for Pediatric\\nGastroenterology, Hepatology and Nutrition and the American Academy of\\nPediatrics endorse urgent workup of cholestatic infants and highlight acholic\\nstools as a “red flag” warranting targeted evaluation for biliary atresia.[1][2][3]\\nAbdominal ultrasound is the recommended first-line imaging: it is noninvasive\\nand can identify findings suggestive of biliary atresia (eg, abnormal or\\nnonvisualized gallbladder, triangular cord sign) and alternative obstructive\\netiologies (eg, choledochal cyst), while also assessing for features of chronic\\nhepatopathy; normal US does not exclude biliary atresia but guides next steps.[1]\\n[4][5][6][7] Radiology appropriateness criteria list abdominal US as “usually\\nappropriate” initial imaging for cholestatic hyperbilirubinemia.[8] HIDA/MRCP/\\nbiopsy are reserved for equivocal cases or subsequent steps; contrast GI studies\\nand endoscopy are not indicated in this presentation.[1][5][7][8]\\nGiven this infant’s presentation, the most appropriate immediate diagnostic test\\namong the options is abdominal ultrasound to evaluate for biliary atresia and\\nother obstructive causes without delaying further management.[1][5][7][8]", "curator_notes": "Young infant with jaundice, acholic stools, hepatosplenomegaly, and marked direct hyperbilirubinemia; the presentation is highly concerning for neonatal cholestasis, especially biliary atresia, and abdominal ultrasonography is the most appropriate next diagnostic step.", "reference_used": "Guidance on neonatal cholestasis / biliary atresia", "usmle_source_index": "159", "dataset_source_index": "160"}
41	2	161	A 52-year-old woman comes to the physician for a follow-up examination.\nShe received the diagnosis of\nhypertension 3 weeks ago, and lisinopril therapy was begun at that time.\nShe has had a constant, nonproductive,\nhacking cough for 2 weeks but has not had any other problems. She has no\nhistory of serious illness and takes no\nother medications. She does not smoke. She drinks one to two glasses of\nwine daily. She does aerobic exercise for\n30 minutes four to five times weekly. Her blood pressure has decreased\nfrom 164/92 mm Hg 3 weeks ago to 140/84\nmm Hg today. Lungs are clear to auscultation. Which of the following is the\nmost appropriate next step in\nmanagement of this patient's cough?	D	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Internal Medicine / Pharmacology", "difficulty": "Easy", "explanation": "Discontinuation of lisinopril\\nACE inhibitors commonly cause a persistent, nonproductive cough, especially in\\nwomen; the temporal relationship after initiation and absence of alternative\\ncauses make ACE inhibitor–induced cough the leading diagnosis here.[1][2][3]\\nThe appropriate management is to stop the ACE inhibitor; cough typically\\nresolves within days to a few weeks after discontinuation, with cohort data\\nshowing resolution in most patients within ?10 days.[4][5] The American College\\nof Cardiology/American Heart Association guideline advises substituting an\\nangiotensin receptor blocker (ARB) when cough develops on an ACE inhibitor, as\\nARBs provide comparable BP control with a much lower risk of cough.[6][7][8]\\nFurther diagnostics (pulmonary function tests, chest CT) are unnecessary\\nat this stage given the clear clinical attribution to the ACE inhibitor. [3][4]\\nPrednisone or cough suppressants do not address the mechanism and are\\nnot recommended for ACE inhibitor–related cough. [4][9]\\nObservation without change is inappropriate because the offending agent is\\nongoing.[4][6]\\nPlan: Discontinue lisinopril and initiate an ARB (e.g., losartan, valsartan) with\\nstandard hypertension dosing and titration to BP targets per guideline practice,\\nmonitoring BP, renal function, and potassium.[6][7]", "curator_notes": "Woman with new persistent dry cough shortly after starting lisinopril; the presentation is most consistent with ACE inhibitor–induced cough, and the appropriate next step is to discontinue lisinopril.", "reference_used": "Guidance on ACE inhibitor adverse effects", "usmle_source_index": "160", "dataset_source_index": "161"}
42	2	162	A 27-year-old primigravid woman at 41 weeks' gestation is admitted to the\nhospital for induction of labor. She has\nreceived cervical ripening agents and is now receiving oxytocin. The cervix\nis 9 cm dilated and 100% effaced; the\nvertex is at 0 station. Fetal monitoring shows contractions every 3 minutes\nand a reassuring heart rate. She requests\npain medication. Which of the following is the most likely adverse effect of\nan intravenous opioid in this patient?	E	{"team": "Equipe 2 - Medicina", "student": "Gilson Inácio da Silva", "specialty": "Obstetrics / Pharmacology", "difficulty": "Medium", "explanation": "Neonatal respiratory depression.\\nIntravenous opioids administered in active labor cross the placenta rapidly and\\ncan depress the neonatal respiratory drive, particularly when given close to\\ndelivery. FDA labeling across multiple opioids (e.g., meperidine, hydrocodone,\\nsufentanil) explicitly warns of neonatal respiratory depression during labor and\\nrecommends immediate availability of naloxone and neonatal monitoring.[1][2][3]\\nReviews and consensus statements note that systemic opioids offer limited\\nmitigation of labor stress but are associated with fetal–neonatal depression;\\nrespiratory depression is the clinically significant neonatal risk that necessitates\\npreparedness for resuscitation and reversal.[4][5][6][7] Small trials of IV fentanyl\\nduring labor report generally normal Apgar and cord gases with careful dosing\\nand timing, yet acknowledge the need for neonatal observation and readiness for\\nnaloxone/oxygen if distress occurs.[8] Broader public health guidance\\nemphasizes monitoring for opioid-related neonatal effects when exposure\\noccurs near delivery.[9]\\nOther listed options are less characteristic: maternal fever and tachycardia are\\nnot typical opioid toxicities; neonatal acidosis and arrhythmia are not the\\npredominant risks compared with respiratory depression in this context.[4][5][7]", "curator_notes": "Term pregnant woman in advanced labor requesting analgesia; intravenous opioids given close to delivery can cross the placenta and most importantly cause neonatal respiratory depression.", "reference_used": "Guidance on opioid use during labor", "usmle_source_index": "161", "dataset_source_index": "162"}
\.


--
-- Data for Name: respostas_atividade_1; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.respostas_atividade_1 (id_resposta, id_pergunta, id_modelo, texto_resposta, tempo_inferencia_ms, data_geracao, origem) FROM stdin;
1	1	1	Persistent muscle pain without exercise should be medically evaluated, especially if it worsens or is associated with weakness, fever, swelling, or dark urine. Possible causes include infection, medication effects, deficiencies, hypothyroidism, or inflammatory conditions. Seek care urgently for dark urine or significant weakness, and arrange medical review if symptoms persist for 1–2 weeks or are disabling.	\N	2026-04-23 16:44:41.964307	atividade_1
2	1	2	Yes. Persistent muscle pain without exercise deserves medical evaluation, especially if it is continuous or worsening. Possible causes include viral infections, rheumatologic disease, hypothyroidism, vitamin deficiencies, medication effects, or chronic anxiety/depression. Seek urgent care if there is weakness, dark urine, fever, swelling, redness, or systemic symptoms. If symptoms last more than 1–2 weeks, medical assessment and lab tests may be needed.	\N	2026-04-23 16:44:41.964307	atividade_1
3	1	3	Persistent muscle pain without exercise can be concerning, especially if it comes with fever, swelling, true weakness, or dark urine. Possible causes include viral infections, medication side effects, vitamin or mineral deficiencies, hypothyroidism, or rheumatologic conditions. If it lasts more than 1–2 weeks, worsens, or is disabling, medical evaluation is recommended. Avoid prolonged self-medication with anti-inflammatories.	\N	2026-04-23 16:44:41.964307	atividade_1
4	2	1	Fluoxetine usually should not be stopped abruptly. Even though it has a lower risk of withdrawal symptoms than some other SSRIs because of its long half-life, dose reduction should still be discussed with the prescribing clinician. Abrupt withdrawal is generally avoided unless there is a serious adverse effect, and medication changes should be supervised medically.	\N	2026-04-23 16:44:41.964307	atividade_1
5	2	2	Prozac (fluoxetine) has a very long half-life (4–6 days), allowing the body to taper naturally, making discontinuation syndrome rare. In many cases, especially with low doses or short-term use, abrupt stopping is well tolerated — but never without medical guidance. The doctor will assess whether a gradual taper (e.g., 20mg ? 10mg ? stop) or medication switch is needed, based on duration of use, current dose, and patient history. If side effects are bothersome, inform your doctor immediately.	\N	2026-04-23 16:44:41.964307	atividade_1
6	2	3	Fluoxetine should generally not be stopped abruptly. Its long half-life reduces discontinuation symptoms compared to other SSRIs, but sudden cessation can still lead to relapse or withdrawal symptoms. Dosage tapering should be individualized and performed under medical supervision, unless a severe adverse reaction necessitates immediate discontinuation.	\N	2026-04-23 16:44:41.964307	atividade_1
7	3	1	If it is a muscle strain, many cases start to feel better within about 2 weeks, but severe strains can take weeks to months to fully recover. Seek care if pain worsens, normal use is difficult, or it is not improving.	\N	2026-04-23 16:44:41.964307	atividade_1
8	3	2	For a simple muscle strain, pain typically improves in 3–5 days and fully resolves within 1–2 weeks; severe cases may take up to 4 weeks. Rest, ice (first 48h), and anti-inflammatories if needed usually suffice. See a doctor if pain worsens, persists beyond 2 weeks, or is accompanied by weakness or significant swelling.	\N	2026-04-23 16:44:41.964307	atividade_1
9	3	3	Mild muscle strains (Grade 1) usually subside within 2 to 7 days, while more significant tears (Grade 2) may take 2 to 4 weeks for acute pain to resolve. Full recovery can take weeks to months. Seek medical evaluation if pain does not improve within 48 to 72 hours, or if severe swelling, bruising, or loss of mobility occurs to rule out a complete rupture (Grade 3).	\N	2026-04-23 16:44:41.964307	atividade_1
10	4	1	Creatinine is a waste product from normal muscle breakdown. Your kidneys remove it from the blood, so creatinine tests help assess kidney function. Higher levels may suggest reduced kidney function.	\N	2026-04-23 16:44:41.964307	atividade_1
11	4	2	Creatinine is a muscle metabolism waste product filtered by the kidneys. It's a key marker of kidney function: high levels suggest impaired filtration, low levels may indicate reduced muscle mass. Normal range is ~0.6–1.2 mg/dL in adults, varying by age and sex. Always interpret results with a doctor.	\N	2026-04-23 16:44:41.964307	atividade_1
12	4	3	Creatinine is a waste product from muscle metabolism filtered by the kidneys and excreted in urine, serving as a key biomarker for renal function. Elevated blood levels may indicate impaired kidney filtration (low eGFR), though results are influenced by muscle mass, age, and hydration. Abnormal levels require professional medical interpretation alongside eGFR to accurately assess kidney health and determine if further diagnostic testing is necessary.	\N	2026-04-23 16:44:41.964307	atividade_1
13	5	1	Yes. Abreva (docosanol) can help treat cold sores, especially if started early. It may shorten healing time and reduce symptoms, but it is not a cure. Seek medical advice if the sore is severe or not healing.	\N	2026-04-23 16:44:41.964307	atividade_1
14	5	2	Yes, Abreva (docosanol 10%) is an FDA-approved over-the-counter antiviral for cold sores (oral herpes/HSV-1). When applied at the first sign of symptoms (tingling, itching), it can shorten healing time by 1–2 days. It is safe for most adults but less effective if applied late. For frequent, severe, or immunocompromised cases, a doctor may prescribe stronger antivirals like acyclovir or valacyclovir.	\N	2026-04-23 16:44:41.964307	atividade_1
15	5	3	Abreva (docosanol 10%) is an FDA-approved OTC topical treatment that reduces cold sore duration by inhibiting HSV-1 entry into skin cells. It is most effective when applied at the first sign of tingling or itching (prodrome); efficacy decreases significantly once a blister forms. While generally safe, users should consult a doctor if the lesion persists beyond 10 days or if they are immunocompromised to consider stronger prescription antivirals.	\N	2026-04-23 16:44:41.964307	atividade_1
16	6	1	If it is truly fungal, an OTC antifungal like Tinactin may help for athlete’s foot, jock itch, or ringworm. If the diagnosis is uncertain, the site is unusual, or it is not improving, medical evaluation is safer.	\N	2026-04-23 16:44:41.964307	atividade_1
17	6	2	Tinactin (tolnaftate) is a safe OTC antifungal suitable for superficial infections like ringworm or athlete's foot, but ineffective against Candida. Reasonable to try if fungal infection is suspected, but see a doctor if no improvement within 2 weeks or if the area involves nails, scalp, or genitals.	\N	2026-04-23 16:44:41.964307	atividade_1
18	6	3	Applying an OTC antifungal like Tinactin (tolnaftate) is generally safe but may delay correct treatment if the underlying cause is bacterial or inflammatory. Avoid use on severely broken skin to prevent irritation. If the lesion does not improve within 2 weeks or if signs of secondary infection (pus, spreading redness) appear, discontinue use and seek clinical evaluation for a confirmed diagnosis via skin scraping or culture.	\N	2026-04-23 16:44:41.964307	atividade_1
19	7	1	No. Augmentin is not the same as amoxicillin alone. Augmentin contains amoxicillin plus clavulanate, which helps overcome some bacterial resistance and gives it a broader spectrum than amoxicillin by itself.	\N	2026-04-23 16:44:41.964307	atividade_1
20	7	2	Augmentin is not the same as amoxicillin, though it contains it. Augmentin combines amoxicillin with clavulanate potassium, a beta-lactamase inhibitor that blocks bacterial resistance mechanisms, making it effective against a broader range of bacteria. Plain amoxicillin is used for simpler infections; Augmentin is reserved for resistant or more complex ones. They are not interchangeable without medical guidance.	\N	2026-04-23 16:44:41.964307	atividade_1
21	7	3	No, Augmentin is not the same as amoxicillin; it is a combination of amoxicillin (a penicillin-type antibiotic) and potassium clavulanate (a beta-lactamase inhibitor). While amoxicillin kills bacteria by inhibiting cell wall synthesis, the addition of clavulanate protects the antibiotic from being deactivated by certain bacterial enzymes (beta-lactamases). This addition broadens the drug's spectrum of activity against resistant strains but may also increase the likelihood of gastrointestinal side effects. It should only be used as specifically prescribed for the diagnosed infection.	\N	2026-04-23 16:44:41.964307	atividade_1
22	8	1	Buspirone can sometimes be used with sertraline, but the combination should only be taken under medical supervision because both can increase serotonin activity and may raise the risk of serotonin syndrome. Seek medical advice promptly if symptoms such as agitation, tremor, fever, diarrhea, or muscle stiffness occur.	\N	2026-04-23 16:44:41.964307	atividade_1
23	8	2	Buspar (buspirone) is sometimes combined with Zoloft (sertraline) in clinical practice, particularly when anxiety symptoms are not fully controlled by sertraline alone. The combination is generally considered acceptable, but carries a low risk of serotonin syndrome, especially at higher doses. This combination should only be used under medical supervision, with careful dose adjustment and monitoring for symptoms like agitation, tremor, or rapid heartbeat. Never start, stop, or adjust either medication without your doctor's guidance.	\N	2026-04-23 16:44:41.964307	atividade_1
24	8	3	Buspirone (Buspar) is often used as an adjunct to sertraline (Zoloft) to treat residual anxiety or mitigate SSRI-induced side effects. While generally safe and effective for treatment-resistant depression or generalized anxiety, both medications increase serotonin levels, creating a rare but serious risk of serotonin syndrome (agitation, tachycardia, muscle rigidity). This combination requires professional medical supervision to monitor dosing and potential drug-drug interactions based on your specific clinical profile.	\N	2026-04-23 16:44:41.964307	atividade_1
25	9	1	Yes. Saxenda (liraglutide) is given as a once-daily subcutaneous injection, usually using a prefilled multi-dose pen after proper instruction on how to use it. (accessdata.fda.gov)	\N	2026-04-23 16:44:41.964307	atividade_1
26	9	2	Yes, Saxenda (liraglutide) is a once-daily subcutaneous injection used for chronic weight management. It is started at a low dose (0.6 mg/day) and gradually increased over 5 weeks to the maintenance dose of 3 mg/day to minimize side effects like nausea. It requires a prescription and should be used alongside diet and exercise under medical supervision.	\N	2026-04-23 16:44:41.964307	atividade_1
27	9	3	Yes, Saxenda (liraglutide) is a once-daily subcutaneous injection for chronic weight management. It should be administered at the same time each day (abdomen, thigh, or upper arm) with or without meals. Dosing typically follows a five-week titration schedule to minimize gastrointestinal side effects. If a dose is missed, do not double the next one; if more than three consecutive doses are missed, consult a healthcare provider for instructions on how to safely restart the medication.	\N	2026-04-23 16:44:41.964307	atividade_1
28	10	1	Yes. Valtrex is the brand name for valacyclovir. Valacyclovir is an antiviral used for infections caused by herpes viruses, including cold sores, genital herpes, and shingles.	\N	2026-04-23 16:44:41.964307	atividade_1
29	10	2	Yes, Valtrex is simply the brand name for valacyclovir, an antiviral medication used to treat herpes infections (cold sores, genital herpes, shingles, and chickenpox). They are identical in active ingredient, dosing, and efficacy; the only difference is price, as generic valacyclovir is typically more affordable.	\N	2026-04-23 16:44:41.964307	atividade_1
30	10	3	Yes, Valtrex is the brand name for the generic drug valacyclovir. It is an antiviral prescription medication used for herpes simplex (HSV) and varicella-zoster (VZV) infections. As a prodrug, it converts to acyclovir in the body to inhibit viral replication. Both have the same active ingredient and clinical efficacy, though they may differ in cost and inactive fillers. Always follow a healthcare provider's specific dosing instructions for outbreak management or suppression.	\N	2026-04-23 16:44:41.964307	atividade_1
31	11	1	No. Accutane (isotretinoin) is not an antibiotic; it is a retinoid used for severe acne. It can cause severe birth defects and pregnancy loss, so it must not be used during pregnancy and pregnancy should be strictly avoided during treatment and for 1 month after stopping.	\N	2026-04-23 16:44:41.964307	atividade_1
32	11	2	Accutane (isotretinoin) is not an antibiotic but a retinoid (vitamin A derivative) for severe acne. It is highly teratogenic, causing serious birth defects even with brief exposure — pregnancy is strictly contraindicated during use and one month after. In the US, the iPLEDGE program requires two contraception methods and regular pregnancy testing. Strict medical supervision is mandatory.	\N	2026-04-23 16:44:41.964307	atividade_1
33	11	3	Accutane (isotretinoin) is not an antibiotic; it is a potent Vitamin A-derived retinoid used for severe acne. It is strictly contraindicated during pregnancy due to an extremely high risk of severe birth defects (teratogenicity) and miscarriage. Patients must participate in a mandated safety program (like iPledge), use two forms of effective contraception, and have regular pregnancy tests during treatment and for at least one month after the final dose. If pregnancy occurs, stop the medication immediately and consult a healthcare provider.	\N	2026-04-23 16:44:41.964307	atividade_1
34	12	1	Blepharitis is usually not contagious. It is inflammation of the eyelid margins, often related to skin conditions, blocked oil glands, or bacteria normally present on the skin, rather than something that typically spreads from person to person.	\N	2026-04-23 16:44:41.964307	atividade_1
35	12	2	Blepharitis is generally not contagious. Caused by seborrheic dermatitis, bacterial overgrowth, or Demodex mites, it is not easily transmitted through casual contact. Basic hygiene (avoid sharing towels or eye makeup) is advised. It is a chronic condition managed with ongoing eyelid hygiene, not isolation.	\N	2026-04-23 16:44:41.964307	atividade_1
36	12	3	Blepharitis itself is not contagious; it is a chronic inflammatory eyelid condition typically caused by skin bacteria, clogged oil glands, or rosacea. It cannot be transmitted through casual contact. However, secondary bacterial infections or mite infestations (Demodex) associated with it can spread via shared towels, linens, or makeup. Professional evaluation is recommended to identify the specific cause and establish a hygiene regimen, as the condition often requires long-term management rather than a simple cure.	\N	2026-04-23 16:44:41.964307	atividade_1
37	13	1	Yes. A flu test and an influenza test mean the same thing, because “flu” is the common name for influenza. Depending on the test, it may look for influenza A, influenza B, or both.	\N	2026-04-23 16:44:41.964307	atividade_1
38	13	2	Yes, "flu test" and "influenza test" are the same. The most common is the Rapid Influenza Diagnostic Test (RIDT), detecting influenza A and B via nasal swab in 15–30 minutes, but sensitivity is only ~50–70%, making false negatives possible. PCR testing is more accurate. Results should always be interpreted alongside clinical symptoms by a doctor.	\N	2026-04-23 16:44:41.964307	atividade_1
39	13	3	Yes, a "flu test" is synonymous with an "influenza test," as "flu" is the clinical abbreviation for the influenza virus. Tests like RIDT (rapid) or PCR (molecular) specifically detect influenza A and B from nasopharyngeal samples. They do not identify other respiratory viruses with similar symptoms, such as rhinovirus, RSV, or COVID-19. For maximum accuracy, testing should occur within 3 to 4 days of symptom onset when viral shedding is at its peak.	\N	2026-04-23 16:44:41.964307	atividade_1
40	14	1	No. Ibuprofen is not part of Tylenol. Tylenol contains acetaminophen (paracetamol), while ibuprofen is a different medicine in the NSAID class.	\N	2026-04-23 16:44:41.964307	atividade_1
41	14	2	No, ibuprofen and Tylenol (acetaminophen) are entirely different drugs. Ibuprofen is an NSAID reducing pain, fever, and inflammation; acetaminophen relieves pain and fever but has no anti-inflammatory effect. They can be safely alternated under medical guidance but are not interchangeable.	\N	2026-04-23 16:44:41.964307	atividade_1
42	14	3	No, ibuprofen is not an ingredient in Tylenol. They are distinct medications: Tylenol contains acetaminophen (a pain reliever/fever reducer), while ibuprofen (Advil/Motrin) is an NSAID (anti-inflammatory). While some "dual-action" products combine both, standard Tylenol does not. Always check the "Drug Facts" label to verify active ingredients and prevent accidental overdosage, as each medication has different safety profiles and daily limits.	\N	2026-04-23 16:44:41.964307	atividade_1
43	15	1	An abscess often causes pain, but it can sometimes be painless depending on its size, depth, and location. A painless lump can still be an abscess, so medical evaluation is important, especially if there is swelling, redness, drainage, fever, or the lump is getting larger.	\N	2026-04-23 16:44:41.964307	atividade_1
44	15	2	Yes, painless abscesses can occur, particularly in diabetics (neuropathy), immunocompromised patients, or with deep-seated/early-stage collections. Lack of pain does not mean lack of risk — untreated abscesses can progress to sepsis. Any suspected abscess should be evaluated by a doctor regardless of pain level.	\N	2026-04-23 16:44:41.964307	atividade_1
45	15	3	While less common, an abscess can be painless, particularly in early stages or in patients with peripheral neuropathy (e.g., diabetes) or those on immunosuppressants. "Cold abscesses" associated with fungal infections or tuberculosis also lack typical inflammatory pain. Any painless, firm, or growing lump requires clinical evaluation to distinguish an abscess from a cyst or other soft tissue lesion.	\N	2026-04-23 16:44:41.964307	atividade_1
\.


--
-- Name: alternativas_id_alternativa_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alternativas_id_alternativa_seq', 134, true);


--
-- Name: avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.avaliacoes_humanas_atividade_1_id_avaliacao_humana_seq', 45, true);


--
-- Name: avaliacoes_juiz_id_avaliacao_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.avaliacoes_juiz_id_avaliacao_seq', 90, true);


--
-- Name: datasets_id_dataset_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.datasets_id_dataset_seq', 2, true);


--
-- Name: modelos_id_modelo_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.modelos_id_modelo_seq', 6, true);


--
-- Name: perguntas_id_pergunta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perguntas_id_pergunta_seq', 42, true);


--
-- Name: respostas_atividade_1_id_resposta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.respostas_atividade_1_id_resposta_seq', 45, true);


--
-- Name: alternativas alternativas_id_pergunta_letra_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT alternativas_id_pergunta_letra_key UNIQUE (id_pergunta, letra);


--
-- Name: alternativas alternativas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT alternativas_pkey PRIMARY KEY (id_alternativa);


--
-- Name: avaliacoes_humanas_atividade_1 avaliacoes_humanas_atividade_1_id_resposta_ativa1_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_humanas_atividade_1
    ADD CONSTRAINT avaliacoes_humanas_atividade_1_id_resposta_ativa1_key UNIQUE (id_resposta_ativa1);


--
-- Name: avaliacoes_humanas_atividade_1 avaliacoes_humanas_atividade_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_humanas_atividade_1
    ADD CONSTRAINT avaliacoes_humanas_atividade_1_pkey PRIMARY KEY (id_avaliacao_humana);


--
-- Name: avaliacoes_juiz avaliacoes_juiz_id_resposta_ativa1_id_modelo_juiz_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_juiz
    ADD CONSTRAINT avaliacoes_juiz_id_resposta_ativa1_id_modelo_juiz_key UNIQUE (id_resposta_ativa1, id_modelo_juiz);


--
-- Name: avaliacoes_juiz avaliacoes_juiz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_juiz
    ADD CONSTRAINT avaliacoes_juiz_pkey PRIMARY KEY (id_avaliacao);


--
-- Name: datasets datasets_nome_dataset_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_nome_dataset_key UNIQUE (nome_dataset);


--
-- Name: datasets datasets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.datasets
    ADD CONSTRAINT datasets_pkey PRIMARY KEY (id_dataset);


--
-- Name: modelos modelos_nome_modelo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modelos
    ADD CONSTRAINT modelos_nome_modelo_key UNIQUE (nome_modelo);


--
-- Name: modelos modelos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modelos
    ADD CONSTRAINT modelos_pkey PRIMARY KEY (id_modelo);


--
-- Name: perguntas perguntas_id_dataset_official_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perguntas
    ADD CONSTRAINT perguntas_id_dataset_official_id_key UNIQUE (id_dataset, official_id);


--
-- Name: perguntas perguntas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perguntas
    ADD CONSTRAINT perguntas_pkey PRIMARY KEY (id_pergunta);


--
-- Name: respostas_atividade_1 respostas_atividade_1_id_pergunta_id_modelo_origem_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respostas_atividade_1
    ADD CONSTRAINT respostas_atividade_1_id_pergunta_id_modelo_origem_key UNIQUE (id_pergunta, id_modelo, origem);


--
-- Name: respostas_atividade_1 respostas_atividade_1_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respostas_atividade_1
    ADD CONSTRAINT respostas_atividade_1_pkey PRIMARY KEY (id_resposta);


--
-- Name: idx_avaliacoes_humanas_resposta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_avaliacoes_humanas_resposta ON public.avaliacoes_humanas_atividade_1 USING btree (id_resposta_ativa1);


--
-- Name: idx_avaliacoes_juiz_resposta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_avaliacoes_juiz_resposta ON public.avaliacoes_juiz USING btree (id_resposta_ativa1);


--
-- Name: idx_perguntas_dataset; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_perguntas_dataset ON public.perguntas USING btree (id_dataset);


--
-- Name: idx_respostas_modelo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_respostas_modelo ON public.respostas_atividade_1 USING btree (id_modelo);


--
-- Name: idx_respostas_pergunta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_respostas_pergunta ON public.respostas_atividade_1 USING btree (id_pergunta);


--
-- Name: alternativas alternativas_id_pergunta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT alternativas_id_pergunta_fkey FOREIGN KEY (id_pergunta) REFERENCES public.perguntas(id_pergunta) ON DELETE CASCADE;


--
-- Name: avaliacoes_humanas_atividade_1 avaliacoes_humanas_atividade_1_id_resposta_ativa1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_humanas_atividade_1
    ADD CONSTRAINT avaliacoes_humanas_atividade_1_id_resposta_ativa1_fkey FOREIGN KEY (id_resposta_ativa1) REFERENCES public.respostas_atividade_1(id_resposta) ON DELETE CASCADE;


--
-- Name: avaliacoes_juiz avaliacoes_juiz_id_modelo_juiz_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_juiz
    ADD CONSTRAINT avaliacoes_juiz_id_modelo_juiz_fkey FOREIGN KEY (id_modelo_juiz) REFERENCES public.modelos(id_modelo);


--
-- Name: avaliacoes_juiz avaliacoes_juiz_id_resposta_ativa1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avaliacoes_juiz
    ADD CONSTRAINT avaliacoes_juiz_id_resposta_ativa1_fkey FOREIGN KEY (id_resposta_ativa1) REFERENCES public.respostas_atividade_1(id_resposta) ON DELETE CASCADE;


--
-- Name: perguntas perguntas_id_dataset_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perguntas
    ADD CONSTRAINT perguntas_id_dataset_fkey FOREIGN KEY (id_dataset) REFERENCES public.datasets(id_dataset);


--
-- Name: respostas_atividade_1 respostas_atividade_1_id_modelo_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respostas_atividade_1
    ADD CONSTRAINT respostas_atividade_1_id_modelo_fkey FOREIGN KEY (id_modelo) REFERENCES public.modelos(id_modelo);


--
-- Name: respostas_atividade_1 respostas_atividade_1_id_pergunta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.respostas_atividade_1
    ADD CONSTRAINT respostas_atividade_1_id_pergunta_fkey FOREIGN KEY (id_pergunta) REFERENCES public.perguntas(id_pergunta) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict 2LweuI37mS32tbHnbDRwXk9BhL5f4hK8xHJBULzJzpDjmt5rRip2a9cuNCgFIfj

