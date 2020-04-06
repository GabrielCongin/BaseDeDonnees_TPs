-- Sujet sur les triggers
-- Exercice sur le MARATHON 

drop table mar_classement;
drop table mar_course;
drop table mar_coureur;
drop table mar_categorie;
drop table mar_capteur;
drop table mar_parametre;


create table MAR_PARAMETRE (
	nom varchar2(20) constraint MAR_PARAMETRE_PK PRIMARY KEY,
        valeur varchar2(20) NOT NULL
);

insert into MAR_PARAMETRE values ('date', '23/02/2021');
insert into MAR_PARAMETRE values ('nbInscrits', 0);


Create table MAR_CATEGORIE (
	libelle varchar2(20) constraint MAR_CATEGORIE_PK PRIMARY KEY,
	ageMin number(3),
	ageMax number(3)
);

insert into MAR_CATEGORIE values ('Poussin', 0,9);
insert into MAR_CATEGORIE values ('Pupille', 10,11);
insert into MAR_CATEGORIE values ('Benjamin', 12,13);
insert into MAR_CATEGORIE values ('Minime', 14,15);
insert into MAR_CATEGORIE values ('Cadet', 16,17);
insert into MAR_CATEGORIE values ('Junior', 18,19);
insert into MAR_CATEGORIE values ('Espoir', 20,21);
insert into MAR_CATEGORIE values ('Senior', 23,39);
insert into MAR_CATEGORIE values ('Veteran', 40,200);


create table MAR_COUREUR (
	idCoureur number(3) generated always as identity constraint MAR_COUREUR_PK PRIMARY KEY,
	nom varchar2(20) NOT NULL,
	age number(3) NOT NULL,
	categorie varchar2(20) NOT NULL constraint MAR_CATEGORIE_IN_COUREUR_FK references MAR_CATEGORIE
);
-- l'id de la table coureur est généré automatiquement : 
-- le "ALWAYS" force l'utilisation du générateur (identity). 
-- si on insère une ligne en donnant une valeur (même null) pour la colonne identity, on a une erreur
--> ORA-32795: cannot insert into a generated always identity column
-- on ne peut pas non plus une valeur de colonne "Always Identity"
--> ORA-32796: cannot update a generated always identity column

create table MAR_CAPTEUR (
	idCapteur varchar2(5) constraint MAR_CAPTEUR_PK PRIMARY KEY,
	distance number(6) not null
);

insert into MAR_CAPTEUR values ('C134', 1000);
insert into MAR_CAPTEUR values ('C234', 3000);
insert into MAR_CAPTEUR values ('C334', 5000);
insert into MAR_CAPTEUR values ('C434', 10000);

create table MAR_COURSE (
	idCoureur number(3) constraint MAR_COUREUR_IN_COURSE_FK references MAR_COUREUR,
	idCapteur varchar2(5) constraint MAR_CAPTEUR_IN_COURSE_FK references MAR_CAPTEUR,
	chrono number(6) not null,
	constraint MAR_COURSE_PK PRIMARY KEY (idCoureur, idCapteur)
);

create table MAR_CLASSEMENT (
	idCoureur number(3) constraint  MAR_COUREUR_IN_CLASSEMENT_FK references MAR_COUREUR ON DELETE CASCADE,
	distance number(6) ,
	chrono number(6),
    rang number(4)
);
-- 2.1
create or replace trigger categorie
before insert or update of age, categorie on mar_coureur
for each row
begin
    select libelle into :new.categorie
    from mar_categorie
    where :new.age between agemin and agemax;
end;
/
--2.2
create or replace trigger update_classement
after insert or delete
on mar_coureur
for each row
begin
    if inserting then
    insert into mar_classement(idCoureur,distance,chrono, rang)
    values(:new.idCoureur,NULL,NULL,NULL);
    update mar_parametre
    set valeur = valeur + 1
    where nom = 'nbInscrits';
    end if;
    if deleting then
    update mar_parametre
    set valeur = valeur - 1
    where nom = 'nbInscrits';
    end if;
end;
/

--2.3
create or replace trigger update_classementBis
after insert
on mar_course
for each row
begin
    select c.distance into ma_distance
    from mar_capteur c
    where c.idCapteur = :new.idCapteur;
    
    select rang into oldRang
    from mar_classement
    where idCoureur = :new.idCoureur;
    
    if rang < nb
    then
    else
    end if;
   
    select count(*) into nb from mar_classement
    where distance > ma_distance or (distance = ma_distance and chrono < :new.chrono);
    
    if 
    
    update mar_classement
    set chrono = :new.chrono;
    update mar_classement m
    set m.distance = ma_distance;
end;
