
--TD2_CINEMA(ci_ref,ci_nom, ci_ville)

--TD2_FILM (fi_ref,fi_titre,fi_annee)

--TD2_SEANCE (se_ref,fi_ref, ci_ref,se_horaire)

--TD2_SPECTATEUR(sp_ref,sp_nom,sp_prenom,sp_mail)

--TD2_ASSISTE(sp_ref,se_ref,as_avis)

drop table TD2_ASSISTE;
drop table TD2_SPECTATEUR;
drop table TD2_SEANCE;
drop table TD2_FILM;
drop table TD2_CINEMA;

create table TD2_CINEMA (
  ci_ref varchar2(5) constraint PK_TD2_CINEMA primary key,
  ci_nom varchar2(20) not null,
  ci_ville varchar2(20) not null
);

insert into TD2_CINEMA values ('ci1', 'METROPOLE', 'LILLE');
insert into TD2_CINEMA values ('ci2', 'GAUMONT', 'LILLE');
insert into TD2_CINEMA values ('ci3', 'BASTILLE', 'PARIS');
insert into TD2_CINEMA values ('ci4', 'ODEON', 'PARIS');

create table TD2_FILM (
  fi_ref  varchar2(5) constraint PK_TD2_FILM primary key,
  fi_titre varchar2(30) not null,
  fi_annee number(4) not null
); 

insert into TD2_FILM values ('fi1', 'Gravity', 2013);
insert into TD2_FILM values ('fi2', 'gone girl', 2014);
insert into TD2_FILM values ('fi3', 'mommy', 2014);

create table TD2_SEANCE (
  se_ref varchar2(5) constraint PK_TD2_SEANCE primary key,
  fi_ref varchar2(5) not null constraint FK_SEANCE_REF_FILM references TD2_FILM,
  ci_ref varchar2(5) not null constraint FK_SEANCE_REF_CINEMA references TD2_CINEMA,
  se_horaire DATE not null
);

--gravity
insert into TD2_SEANCE values ('se1', 'fi1', 'ci2', to_date('21/04/2013:17:00', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se2', 'fi1', 'ci2', to_date('24/04/2013:21:00', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se3', 'fi1', 'ci3', to_date('22/04/2013:20:30', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se4', 'fi1', 'ci4', to_date('26/04/2013:18:30', 'dd/mm/yyyy/hh24:mi'));
--gone girl
insert into TD2_SEANCE values ('se10', 'fi2', 'ci2', to_date('12/06/2014:17:00', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se11', 'fi2', 'ci3', to_date('17/07/2014:21:00', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se12', 'fi2', 'ci3', to_date('22/08/2014:20:30', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se13', 'fi2', 'ci4', to_date('26/08/2014:18:30', 'dd/mm/yyyy/hh24:mi'));
--mommy
insert into TD2_SEANCE values ('se20', 'fi3', 'ci4', to_date('12/09/2014:20:15', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se21', 'fi3', 'ci4', to_date('17/09/2014:21:00', 'dd/mm/yyyy/hh24:mi'));
insert into TD2_SEANCE values ('se22', 'fi3', 'ci1', to_date('21/09/2014:21:00', 'dd/mm/yyyy/hh24:mi'));

create table TD2_SPECTATEUR (
  sp_ref varchar2(5) constraint PK_TD2_SPECTATEUR primary key,
  sp_nom varchar2(20) not null,
  sp_prenom varchar2(20) not null,
  sp_mail varchar2(30) not null,
  constraint TD2_SPECTATEUR_MAIL check (REGEXP_LIKE (sp_mail, '^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}$'))
 );


--le spectateur sp20 n'a rien vu
insert into TD2_SPECTATEUR values ('sp1', 'Breton', 'Michel', 'breton@gmail.com');
insert into TD2_SPECTATEUR values ('sp2', 'Cambier', 'Aline', 'cambier@yahoo.fr');
insert into TD2_SPECTATEUR values ('sp3', 'Kante', 'Karamoko', 'kante@free.fr');
insert into TD2_SPECTATEUR values ('sp4', 'Chberreq', 'Ahmed', 'achberreq@gmail.com');
insert into TD2_SPECTATEUR values ('sp5', 'Roux', 'Julien', 'julien@hotmail.com');
insert into TD2_SPECTATEUR values ('sp6', 'Pele', 'Marie', 'marie.pele@laposte.net');
insert into TD2_SPECTATEUR values ('sp7', 'Zeng', 'Yifan', 'yifanzeng@gmail.com');
insert into TD2_SPECTATEUR values ('sp8', 'Schmid', 'Damien', 'dscmid-56@free.fr');
insert into TD2_SPECTATEUR values ('sp9', 'Cervantes', 'Pablo', 'pablo59@hotmail.fr');
insert into TD2_SPECTATEUR values ('sp10', 'Ramos', 'Irene', 'irene.ramos@gmail.com');
insert into TD2_SPECTATEUR values ('sp11', 'Vallet', 'Valerie', 'vava@gmail.com');
insert into TD2_SPECTATEUR values ('sp20', 'Bravo', 'Victor', 'bravo@gmail.com');


create table TD2_ASSISTE (
  sp_ref varchar2(5) constraint ASSISTE_REF_SPECTATEUR references TD2_SPECTATEUR,
  se_ref varchar2(5) constraint ASSISTE_REF_SEANCE references TD2_SEANCE,
  se_avis varchar2(10) not null constraint LISTE_AVIS check (se_avis in ('tres bon','pas mal','moyen','mauvais','sans avis'))
);

alter table TD2_ASSISTE add constraint ASSITE_PK PRIMARY KEY(sp_ref, se_ref);

-- sp8 a trouve tous les films qu'il a vu mauvais, idem pour sp1
-- la seance se20 et se21 a fait l'unanimite : que des avis tres bon
-- sp3 a vu 2 fois gone girl et a donne 2 avis differents
-- pour gone girl, 90% des avis sont tres bon ou pas mal (et pour mommy aussi)


insert into TD2_ASSISTE values ('sp8', 'se2', 'mauvais');
insert into TD2_ASSISTE values ('sp8', 'se11', 'mauvais');
insert into TD2_ASSISTE values ('sp1', 'se1', 'mauvais');

insert into TD2_ASSISTE values ('sp3', 'se20', 'tres bon');
insert into TD2_ASSISTE values ('sp4', 'se20', 'tres bon');
insert into TD2_ASSISTE values ('sp9', 'se20', 'tres bon');
insert into TD2_ASSISTE values ('sp2', 'se21', 'tres bon');
insert into TD2_ASSISTE values ('sp6', 'se21', 'tres bon');
insert into TD2_ASSISTE values ('sp10', 'se21', 'tres bon');

insert into TD2_ASSISTE values ('sp3', 'se10', 'moyen');
insert into TD2_ASSISTE values ('sp3', 'se11', 'pas mal');


--gone girl a deja 1 mauvais, 1 moyen, 1 pas mal - pour avoir + de 80% d'avis pas mal ou tres bon il en faut au moins 7 de plus, sans le 1,8,3
insert into TD2_ASSISTE values ('sp2', 'se10', 'pas mal');
insert into TD2_ASSISTE values ('sp4', 'se10', 'tres bon');
insert into TD2_ASSISTE values ('sp5', 'se11', 'pas mal');
insert into TD2_ASSISTE values ('sp6', 'se12', 'pas mal');
insert into TD2_ASSISTE values ('sp6', 'se11', 'pas mal');
insert into TD2_ASSISTE values ('sp7', 'se13', 'tres bon');
insert into TD2_ASSISTE values ('sp9', 'se13', 'pas mal');
insert into TD2_ASSISTE values ('sp10', 'se12', 'tres bon');
insert into TD2_ASSISTE values ('sp11', 'se11', 'tres bon');

--des spectateurs pour gravity sauf sp1 et sp8

insert into TD2_ASSISTE values ('sp2', 'se1', 'pas mal');
insert into TD2_ASSISTE values ('sp3', 'se1', 'moyen');
insert into TD2_ASSISTE values ('sp4', 'se2', 'mauvais');
insert into TD2_ASSISTE values ('sp6', 'se2', 'pas mal');
insert into TD2_ASSISTE values ('sp9', 'se3', 'sans avis');
insert into TD2_ASSISTE values ('sp10', 'se3', 'tres bon');
insert into TD2_ASSISTE values ('sp11', 'se4', 'pas mal');
insert into TD2_ASSISTE values ('sp5', 'se4', 'tres bon');

--des spectateurs pour la seance 22 (pas sp1 et sp8)
insert into TD2_ASSISTE values ('sp5', 'se22', 'tres bon');
insert into TD2_ASSISTE values ('sp6', 'se22', 'moyen');
insert into TD2_ASSISTE values ('sp10', 'se22', 'pas mal');
insert into TD2_ASSISTE values ('sp11', 'se22', 'moyen');

-- 2.3.1
select fi_ref,fi_titre,fi_annee from td2_film
where fi_annee = '2014';
-- 2.3.2
select ci_nom, se_horaire from td2_cinema c
join td2_seance s on c.ci_ref = s.ci_ref
join td2_film f on s.fi_ref = f.fi_ref
where fi_titre = 'Gravity';
-- 2.3.3
select count(*) nb_spectateurs_se10
from td2_assiste
where se_ref = 'se10';
-- 2.3.4
select avg(count(*)) nb_moyen
from td2_assiste
group by se_ref;
-- 2.3.5
select s.sp_ref, sp_nom, sp_prenom, count(*) nb_seances
from td2_assiste a
join td2_spectateur s on a.sp_ref = s.sp_ref
group by s.sp_ref, sp_nom, sp_prenom;
-- 2.3.6                
select distinct sp_nom, sp_prenom
from td2_assiste a
join td2_spectateur s on a.sp_ref = s.sp_ref
where a.se_avis = 'mauvais'
and s.sp_ref not in ( select sp_ref from td2_assiste a1 
                    where se_avis <> 'mauvais' );
-- 2.3.7
select fi_titre
from td2_assiste a
join td2_seance s on s.se_ref = a.se_ref
join td2_film f on f.fi_ref = s.fi_ref
where a.se_avis = 'tres bon'
group by fi_titre
having count(fi_titre) >= all ( select count(fi_titre) from td2_assiste a
                                              join td2_seance s on s.se_ref = a.se_ref
                                              join td2_film f on f.fi_ref = s.fi_ref
                                              where a.se_avis = 'tres bon'
                                              group by fi_titre );

select fi_titre
from td2_assiste a
join td2_seance s on s.se_ref = a.se_ref
join td2_film f on f.fi_ref = s.fi_ref
where a.se_avis = 'tres bon'
group by fi_titre
having count(fi_titre) = ( select max(count(fi_titre)) from td2_assiste a
                                              join td2_seance s on s.se_ref = a.se_ref
                                              join td2_film f on f.fi_ref = s.fi_ref
                                              where a.se_avis = 'tres bon'
                                              group by fi_titre ) ;
                                              
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
                                              
with req as (
    select f.fi_titre as titre, count(se_avis) as nb_avis_tres_bon, 
    max ( decode ( se_avis, 'tres bon', 1 , 0) ) as max_avis_tres_bon
    from td2_assiste a
    join td2_seance se on se.se_ref = a.se_ref
    join td2_film f on f.fi_ref = se.fi_ref
    where se_avis = 'tres bon'
    group by f.fi_ref, f.fi_titre
)
select titre,nb_avis_tres_bon,max_avis_tres_bon
from req
where nb_avis_tres_bon = max_avis_tres_bon;                                         
-- 2.3.9

select distinct spec.sp_ref, sp_nom, sp_prenom, fi_titre
from td2_assiste a
join td2_assiste a1 on a.sp_ref = a1.sp_ref
join td2_spectateur spec on a.sp_ref = spec.sp_ref and a1.sp_ref = spec.sp_ref
join td2_seance se on se.se_ref = a.se_ref
join td2_seance se2 on se2.se_ref = a1.se_ref
join td2_film f on f.fi_ref = se.fi_ref and f.fi_ref = se2.fi_ref
where a1.se_avis <> a.se_avis;

-- 2.3.10

select ci_nom, ci_ville, count(se.ci_ref) as nb_we, ( select count(se2.ci_ref)
                                             from td2_seance se2
                                             where se2.ci_ref = c.ci_ref and 
                                             to_char(se2.se_horaire,'D') > '5') as nb_hors_we
from td2_seance se
join td2_cinema c on c.ci_ref = se.ci_ref
where to_char(se.se_horaire,'D') between '1' AND '5'
group by c.ci_ref,ci_nom, ci_ville;

-- autre version

select c.ci_nom, c.ci_ville, 

( select count(se3.ci_ref)
from td2_seance se3
where se3.ci_ref = c.ci_ref and 
to_char(se3.se_horaire,'D') between '1' AND '5') as nb_we, 

( select count(se2.ci_ref)
from td2_seance se2
where se2.ci_ref = c.ci_ref and 
to_char(se2.se_horaire,'D') > '5') as nb_hors_we
 
from td2_seance se
join td2_cinema c on c.ci_ref = se.ci_ref
group by c.ci_ref,c.ci_nom, c.ci_ville;

-- 2.3.11

select f.fi_titre, sum ( decode ( a.se_avis,'mauvais',1,0) ) as nb_mauvais,
                    sum ( decode ( a.se_avis,'moyen',1,0) ) as nb_moyen,
                    sum ( decode ( a.se_avis,'pas mal',1,0) ) as nb_pas_mal,
                    sum ( decode ( a.se_avis,'tres bon',1,0) ) as nb_tres_bon
from td2_assiste a
join td2_seance se on se.se_ref = a.se_ref
join td2_film f on se.fi_ref = f.fi_ref
group by f.fi_ref, f.fi_titre;

-- autre version


select f.fi_titre, 

(select count(*)
from td2_assiste a1
join td2_seance se1 on se1.se_ref = a1.se_ref
join td2_film f1 on se1.fi_ref = f1.fi_ref
where a1.se_avis = 'mauvais' and f1.fi_ref = f.fi_ref) as nb_mauvais, 

( select count(*)
from td2_assiste a2
join td2_seance se2 on se2.se_ref = a2.se_ref
join td2_film f2 on se2.fi_ref = f2.fi_ref
where a2.se_avis = 'moyen' and f2.fi_ref = f.fi_ref) as nb_moyen,

( select count(*)
from td2_assiste a3
join td2_seance se3 on se3.se_ref = a3.se_ref
join td2_film f3 on se3.fi_ref = f3.fi_ref
where a3.se_avis = 'pas mal' and f3.fi_ref = f.fi_ref) as nb_pas_mal,

( select count(*)
from td2_assiste a4
join td2_seance se4 on se4.se_ref = a4.se_ref
join td2_film f4 on se4.fi_ref = f4.fi_ref
where a4.se_avis = 'tres bon' and f4.fi_ref = f.fi_ref) as nb_tres_bon

from td2_assiste a
join td2_seance se on se.se_ref = a.se_ref
join td2_film f on se.fi_ref = f.fi_ref
group by f.fi_ref, f.fi_titre;

-- 2.3.12

select to_char(se.se_horaire,'Day') as jour
from td2_assiste a
join td2_seance se on a.se_ref = se.se_ref
where a.se_avis = 'tres bon'
group by To_char(se.se_horaire,'Day')
having count(To_char(se.se_horaire,'Day')) = ( select max(count(to_char(se1.se_horaire,'Day')))
                            from td2_assiste a1
                            join td2_seance se1 on a1.se_ref = se1.se_ref
                            where a1.se_avis = 'tres bon'
                            group by To_char(se1.se_horaire,'Day') );
                            
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
-- 2.3.13

select c.ci_nom, c.ci_ville,to_char(se.se_horaire,'Day') as jour
from td2_assiste a
join td2_seance se on a.se_ref = se.se_ref
join td2_cinema c on se.ci_ref = c.ci_ref
where a.se_avis = 'tres bon'
group by To_char(se.se_horaire,'Day'), c.ci_ref, c.ci_nom, c.ci_ville
having count(To_char(se.se_horaire,'Day')) = ( select max(count(to_char(se1.se_horaire,'Day')))
                                             from td2_assiste a1
                                             join td2_seance se1 on a1.se_ref = se1.se_ref
                                             join td2_cinema c1 on se1.ci_ref = c1.ci_ref
                                             where a1.se_avis = 'tres bon'
                                             and c1.ci_ref = c.ci_ref
                                             group by c1.ci_ref,To_char(se1.se_horaire,'Day') )
order by c.ci_nom asc;

-- 2.3.14

with req as (
    select f.fi_titre as titre, count(se_avis) as nb_avis, 
    sum ( decode ( se_avis, 'tres bon', 1 ,'pas mal', 1 , 0) ) as nb_avis_tres_bon_pas_mal
    from td2_assiste a
    join td2_seance se on se.se_ref = a.se_ref
    join td2_film f on f.fi_ref = se.fi_ref
    group by f.fi_ref, f.fi_titre
)
select titre,nb_avis,nb_avis_tres_bon_pas_mal
from req
where (nb_avis_tres_bon_pas_mal/nb_avis) >= 0.8;


select f.fi_titre
from td2_assiste a
join td2_seance se on se.se_ref = a.se_ref
join td2_film f on f.fi_ref = se.fi_ref
where a.se_avis = 'tres bon' or a.se_avis = 'pas mal'
group by f.fi_ref, f.fi_titre
having count(f.fi_titre) >= 0.8 * ( select count(f1.fi_titre)
                                  from td2_assiste a1
                                  join td2_seance se1 on se1.se_ref = a1.se_ref
                                  join td2_film f1 on f1.fi_ref = se1.fi_ref
                                  where f1.fi_ref = f.fi_ref);
-- 2.3.15

select f.fi_titre, 

( select count(f1.fi_titre) / (select count(f2.fi_titre)
                               from td2_assiste a2
                               join td2_seance se2 on a2.se_ref = se2.se_ref
                               join td2_film f2 on f2.fi_ref = se2.fi_ref
                               join td2_cinema c2 on c2.ci_ref = se2.ci_ref
                               where f2.fi_ref = f.fi_ref and c2.ci_ville = 'lille'
                               group by f2.fi_ref)
 from td2_assiste a1
 join td2_seance se1 on a1.se_ref = se1.se_ref
 join td2_film f1 on f1.fi_ref = se1.fi_ref
 join td2_cinema c1 on c1.ci_ref = se1.ci_ref
 where f1.fi_ref = f.fi_ref and a1.se_avis = 'tres bon'
 and c1.ci_ville = 'lille'
 group by f1.fi_ref
) as ratio_lille,

(
select count(f3.fi_titre) / (select count(f4.fi_titre)
                               from td2_assiste a4
                               join td2_seance se4 on a4.se_ref = se4.se_ref
                               join td2_film f4 on f4.fi_ref = se4.fi_ref
                               join td2_cinema c4 on c4.ci_ref = se4.ci_ref
                               where f4.fi_ref = f.fi_ref and c4.ci_ville = 'paris'
                               group by f4.fi_ref)
 from td2_assiste a3
 join td2_seance se3 on a3.se_ref = se3.se_ref
 join td2_film f3 on f3.fi_ref = se3.fi_ref
 join td2_cinema c3 on c3.ci_ref = se3.ci_ref
 where f3.fi_ref = f.fi_ref and a3.se_avis = 'tres bon'
 and c3.ci_ville = 'paris'
 group by f3.fi_ref
) as ratio_paris
from td2_assiste a
join td2_seance se on se.se_ref = a.se_ref
join td2_film f on se.fi_ref = f.fi_ref
join td2_cinema c on c.ci_ref = se.ci_ref
group by f.fi_ref, f.fi_titre;

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



                            




