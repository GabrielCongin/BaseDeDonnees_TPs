-- Exercice 2
DROP TABLE Recommandation;
DROP TABLE Matiere;
DROP TABLE Ecrit;
DROP TABLE Enseignant;
DROP TABLE Diplome;
DROP TABLE Auteur;
DROP TABLE Livre;


create table Diplome (
    code_diplome number(6)
        constraint diplome_key primary key,
    libelle varchar2(30)
);

create table Matiere (
    id_matiere number(5),
    code_diplome number(6),
    libelle varchar2(30),
    constraint Code_diplome_FK foreign key (code_diplome) references Diplome (code_diplome) on delete cascade,
    constraint matiere_pk primary key (id_matiere, code_diplome)
);

create table Auteur (
    id_auteur number(5)
        constraint auteur_key primary key,
    prenom varchar2(20),
    nom varchar2(20)
);

create table Livre (
    id_livre number(5)
        constraint livre_key primary key,
    titre varchar2(40),
    editeur varchar2(20)
);

create table Enseignant (
    id_enseignant number(5)
        constraint enseignant_key primary key,
    prenom varchar2(20),
    nom varchar2(20),
    mail varchar2(50),
    tel char(10) check (regexp_like(tel, '[0-9]{10}')),
    check (mail is not null or tel is not null)
);

create table Ecrit (
    id_livre number(5)
        constraint livre_fk references Livre(id_livre),
    id_auteur number(5)
        constraint auteur_fk references Auteur(id_auteur),
    constraint Ecrit_PK primary key (id_livre, id_auteur)
);

create table Recommandation (
    id_livre number(5)
        constraint livre__recommandation_fk references Livre(id_livre),
    id_matiere number(5),
    code_diplome number(6),
    id_enseignant number(5)
        constraint enseignant_fk references Enseignant(id_enseignant),
    constraint matiere_fk foreign key (id_matiere, code_diplome) references Matiere (id_matiere, code_diplome),
    constraint recommandation_pk primary key (id_livre, code_diplome, id_matiere)
);

insert into Livre values (1,'SQL pour Oracle','Eyrolles');
insert into Livre values (2,'Design Patterns, Tete la Premiere','OReilly');
insert into Livre values (3,'Les reseaux','Eyrolles');
insert into Livre values (4,'Reseaux et Telecoms','Dunod');
insert into Livre values (5,'Les Bases de donnees pour les nuls','Generales First');
insert into Livre values (6,'Test','Pasquier');

insert into Auteur values (1,'Christian','Soutou');
insert into Auteur values (2,'Olivier','Teste');
insert into Auteur values (3,'Eric','Freeman');
insert into Auteur values (4,'Elisabeth','Freeman');
insert into Auteur values (5,'Guy','Pujolle');
insert into Auteur values (6,'Claude','Servin');
insert into Auteur values (7,'Fabien','Fabre');

insert into Ecrit values (1,1);
insert into Ecrit values (1,2);
insert into Ecrit values (2,3);
insert into Ecrit values (2,4);
insert into Ecrit values (3,5);
insert into Ecrit values (4,6);
insert into Ecrit values (5,7);

insert into Enseignant values (1,'Anne-cecile','caron','Anne-cecile.caron@univ-lille.fr','0607080910');
insert into Enseignant values (2,'Yves','Roos','yves.roos@univ-lille.fr','0640414243');
insert into Enseignant values (3,'Laurent','Noe','laurent.noe@univ-lille.fr','0650515253');
insert into Enseignant values (4,'Bruno','Bogaert','bruno.bogaert@univ-lille.fr','0660616263');

insert into Diplome values (123456,'licence 3 miage');
insert into Diplome values (123232,'licence 2 informatique');
insert into Diplome values (123789,'licence 3 informatique');

insert into Matiere values (1,123456,'Base de donnees');
insert into Matiere values (2,123232,'Technologie du web');
insert into Matiere values (3,123456,'Conception orientee objet');
insert into Matiere values (4,123789,'Reseaux');
insert into Matiere values (5,123456,'Reseaux');

insert into recommandation values (1,1,123456,1);
insert into recommandation values (5,1,123456,1);
insert into recommandation values (5,2,123232,4);
insert into recommandation values (2,3,123456,2);
insert into recommandation values (3,5,123456,3);
insert into recommandation values (4,5,123456,3);
insert into recommandation values (3,4,123789,3);
insert into recommandation values (4,4,123789,3);

-- 1.4.1
select id_livre,titre,editeur
from livre;

-- 1.4.2
select distinct mail 
from enseignant
where mail is not null;

-- 1.4.3
select titre
from ecrit e
join livre l on l.id_livre = e.id_livre
join auteur a on a.id_auteur = e.id_auteur
where a.prenom = 'Guy' and a.nom = 'Pujolle';

-- 1.4.4
select distinct titre
from ecrit e
join livre l on l.id_livre = e.id_livre
join auteur a on a.id_auteur = e.id_auteur
where a.nom like 'F%';

-- 1.4.5
select l.titre, count(id_auteur)
from ecrit e
join livre l on l.id_livre = e.id_livre
group by l.id_livre, l.titre;

-- 1.4.6
select avg(count(id_auteur))
from ecrit e
join livre l on l.id_livre = e.id_livre
group by l.id_livre;

-- 1.4.7
select l.id_livre, l.titre, count(l.id_livre) as nb_conseils
from recommandation r
join livre l on r.id_livre = l.id_livre
group by l.id_livre, l.titre;

-- 1.4.8
select l.id_livre, l.titre
from recommandation r
join livre l on r.id_livre = l.id_livre
group by l.id_livre, l.titre
having count(*) > 3;

-- 1.4.9
select l.id_livre, l.titre
from livre l
where l.id_livre not in ( select r.id_livre
                        from recommandation r);
                        
-- 1.4.10
select l.editeur
from livre l
group by l.editeur
having count(l.editeur) >= (select max(count(l1.editeur))
                            from livre l1
                            group by l1.editeur);
                            
-- 1.4.11
select avg(count(r.id_livre)) as nb_moyen_conseils
from recommandation r
group by r.id_enseignant;






