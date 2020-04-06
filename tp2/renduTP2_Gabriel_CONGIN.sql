EXERCICE 1

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

EXERCICE 2

-- 2.3.2
select ci_nom, se_horaire from td2_cinema c
join td2_seance s on c.ci_ref = s.ci_ref
join td2_film f on s.fi_ref = f.fi_ref
where fi_titre = 'Gravity';

-- 2.3.4
select avg(count(*)) nb_moyen
from td2_assiste
group by se_ref;

-- 2.3.6
select distinct sp_nom, sp_prenom
from td2_assiste a
join td2_spectateur s on a.sp_ref = s.sp_ref
where a.se_avis = 'mauvais'
and s.sp_ref not in ( select sp_ref from td2_assiste a1
                    where se_avis <> 'mauvais' );

--2.3.8

select ci_nom, ci_ville, fi_titre, count(fi_titre)
from td2_assiste a
join td2_seance s on s.se_ref = a.se_ref
join td2_film f on f.fi_ref = s.fi_ref
join td2_cinema c on c.ci_ref = s.ci_ref
where a.se_avis = 'tres bon'
group by c.ci_ref, ci_nom, ci_ville, fi_titre
having count(fi_titre) = (select max(count(fi_titre)) from td2_assiste a1
                                              join td2_seance s1 on s1.se_ref = a1.se_ref
                                              join td2_film f1 on f1.fi_ref = s1.fi_ref
                                              join td2_cinema c1 on c1.ci_ref = s1.ci_ref
                                              where a1.se_avis = 'tres bon'
                                              and c1.ci_ref = c.ci_ref
                                              group by s1.fi_ref );

-- 2.3.10
select ci_nom, ci_ville, count(se.ci_ref) as nb_we, ( select count(se2.ci_ref)
                                             from td2_seance se2
                                             where se2.ci_ref = c.ci_ref and 
                                             to_char(se2.se_horaire,'D') > '5') as nb_hors_we
from td2_seance se
join td2_cinema c on c.ci_ref = se.ci_ref
where to_char(se.se_horaire,'D') between '1' AND '5'
group by c.ci_ref,ci_nom, ci_ville;

-- 2.3.12
with req as (
    select To_char(se.se_horaire,'Day') as jour, count(se_avis) as nb_tres_bien
    from td2_assiste a
    join td2_seance se on a.se_ref = se.se_ref
    where a.se_avis = 'tres bon'
    group by To_char(se.se_horaire,'Day')
)
select jour
from req
where nb_tres_bien = ( select max(nb_tres_bien) from req);

-- 2.3.14
with req as (
    select f.fi_titre as titre, count(se_avis) as nb_avis,
    sum ( decode ( se_avis, 'tres bon', 1 ,'pas mal', 1 , 0) ) as nb_avis_tres_bon_pas_mal
    from td2_assiste a
    join td2_seance se on se.se_ref = a.se_ref
    join td2_film f on f.fi_ref = se.fi_ref
    group by f.fi_ref, f.fi_titre
)
select titre
from req
where (nb_avis_tres_bon_pas_mal/nb_avis) >= 0.8;

-- 2.4.1
insert into td2_spectateur values ('sp42','Congin','Gabriel','gabriel.congin@gmail.com');

-- 2.4.2
delete from td2_assiste a
where a.se_ref in ( select se.se_ref
                   from td2_seance se
                   where se_horaire < To_Date('01/07/2013:10:00','dd/mm/yyyy/hh24:mi'));
delete from td2_seance
where se_horaire < To_Date('01/07/2013:10:00','dd/mm/yyyy/hh24:mi');

-- 2.4.3
update td2_spectateur sp
set sp.sp_nom = 'Normand'
where sp.sp_nom = 'Breton';

-- 2.4.4
update td2_assiste a
set a.se_avis = 'pas mal'
where a.se_ref = 'se4'
and a.sp_ref = ( select sp.sp_ref from td2_spectateur sp
                 where sp.sp_nom = 'Roux');

-- 2.5
alter table td2_film
add  derniereProjection Date;

-- 2.6
select max(se.se_horaire)
from td2_seance se
join td2_film f on f.fi_ref = se.fi_ref
where f.fi_ref = 'fi1';

-- 2.7
update td2_film f
set f.derniereProjection = ( select max(se1.se_horaire)
                              from td2_seance se1
                              join td2_film f1 on f1.fi_ref = se1.fi_ref
                               where f.fi_ref = f1.fi_ref);

