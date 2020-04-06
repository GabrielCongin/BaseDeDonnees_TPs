-- définition d'un schéma en relationnel-objet

----------------------------------
-- ETAPE 1 : création des types --
----------------------------------

-- type pour un quiz - déclaration incomplète
create type quiz_type ;
/

-- type pour une proposition - déclaration incomplète
create type proposition_type ;
/
create type ref_proposition_type as object(
  ref_proposition REF proposition_type 
);
/
-- une collection de (pointeurs sur des) propositions
create type ens_propositions_type as table of ref_proposition_type;
/

-- type pour une question
create type question_type as object(
  le_quiz REF quiz_type, -- pointeur vers le quiz
  numero NUMBER(2), -- numéro de question
  enonce VARCHAR2(100), -- le texte de la question
  les_propositions ens_propositions_type -- les différentes propositions de réponses
);
/
create type ref_question_type as object(
  ref_question REF question_type 
);
/
create type ens_questions_type as table of ref_question_type;
/

-- on complète le type proposition_type
create type proposition_type as object(
  la_question REF question_type, -- la question à laquelle la proposition de réponse correspond
  num_prop NUMBER(1), -- le numéro de proposition
  texte_prop VARCHAR2(100), -- le texte de la proposition
  symbole_prop VARCHAR2(8) -- le symbole associé (carré, triangle, ...)
  -- on ne gere pas de collection avec toutes les reponses contenant cette proposition
);
/

-- ce type permet de donner la signification des 4 symboles utilisés dans les quiz
create type symboles_type as object(
  carre VARCHAR2(500),
  triangle VARCHAR2(500),
  rond VARCHAR2(500),
  etoile VARCHAR2(500)
);
/

-- on complète la définition du type quiz_type
create type quiz_type as object(
  id_quiz NUMBER(3), -- identifiant numérique
  titre VARCHAR2(50), 
  date_parution DATE, 
  les_resultats symboles_type, -- les resultats du quiz, i.e. ce qui permet d'interpréter les réponses ("vous avez une majorité de carrés ...")
  les_questions ens_questions_type -- les questions du quiz
);
/

-- des personnes répondent aux quiz en choisissant des propositions

-- un type pour une personne qui répond à un quiz
create type repondant_type as object(
  id_pers NUMBER(4),
  nom VARCHAR2(30),
  prenom VARCHAR2(30),
  email VARCHAR2(50),
  les_reponses ens_propositions_type -- l'ensemble de toutes les propositions choisies comme réponses aux questions
);
/


----------------------------------
-- ETAPE 2 : création des tables --
----------------------------------
create table TP10_Quiz of quiz_type(
  constraint quiz_pkey primary key(id_quiz),
  constraint titre_not_null titre not null,
  constraint defaut_les_question les_questions default ens_questions_type()
)nested table les_questions store as tab_les_questions ;


create table TP10_question of question_type(
  -- on ne peut pas definir de cle primaire - ce devrait être le couple (le_quiz, numero)
  constraint defaut_les_propositions les_propositions default ens_propositions_type(),
  constraint question_quiz_fkey foreign key(le_quiz) references TP10_quiz
)nested table les_propositions store as tab_les_propositions ;

create table TP10_proposition of proposition_type(
  constraint proposition_question_fkey foreign key(la_question) references TP10_question,
  constraint prop_enum check (symbole_prop in ('carre', 'rond', 'triangle', 'etoile'))
);

create table TP10_repondant of repondant_type(
  constraint repondant_pkey primary key(id_pers),
  constraint prenom_nom_not_null check (nom is not null and prenom is not null),
  constraint defaut_les_reponses les_reponses default ens_propositions_type()
)nested table les_reponses store as tab_les_reponses ;

/*
drop type symboles_type force;
drop type ens_questions_type force;
drop type ref_question_type force;
drop type question_type force;
drop type ens_propositions_type force;
drop type ref_proposition_type force;
drop type proposition_type force;
drop type quiz_type force;
drop type repondant_type force;
drop table repondant cascade constraints;
drop table proposition cascade constraints;
drop table question cascade constraints;
drop table quiz cascade constraints;
*/



