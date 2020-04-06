drop table inscription;
drop table groupe;
drop table etape;
drop table ville;
drop table circuit;
drop table client2;

-- 1.1

create table circuit(
    idc number(4) constraint circuit_pkey PRIMARY KEY,
    nomc varchar(20)
);

create table ville(
    idv number(4) constraint ville_pkey PRIMARY KEY,
    nomv varchar(20),
    pays varchar(20)
);

create table etape(
    idc number(4) constraint circuit_fkey1 REFERENCES circuit on delete cascade,
    idv number(4) constraint ville_fkey REFERENCES ville on delete cascade,
    numero number(4),
    activite varchar(20),
    constraint etape_pkey PRIMARY KEY(idc,numero)
);

create table groupe(
    idg number(4) constraint groupe_pkey PRIMARY KEY,
    idc number(4) constraint circuit_fkey2 REFERENCES circuit on delete cascade,
    capacite number(4),
    effectif number(4),
    tarif number(4),
    debut Date,
    fin Date
);

create table client2 (
    idcl number(4) constraint client_pkey PRIMARY KEY,
    nom varchar(20),
    prenom varchar(20),
    solde number(4)
);

create table inscription (
    idcl number(4) constraint client_fkey REFERENCES client2 on delete cascade,
    idg number(4) constraint groupe_key2 REFERENCES groupe on delete cascade,
    constraint inscription_pkey PRIMARY KEY(idcl,idg)
);

--1.2

create or replace trigger calcul_fin
before insert or update
on groupe
for each row
declare
nume etape.numero%type; 
begin
    select max(numero) into nume
    from etape e
    where e.idc = :new.idc;
    
    :new.fin := :new.debut + nume;
end;
/

insert into circuit values(16,'nord');
insert into circuit values(17,'paca');
insert into ville values(1,'Lille','Espagne');
insert into etape values (16,1,10,'saut a la perche');
insert into client2 values(1,'damien','risoli',2000);
insert into client2 values(2,'robert','delanoche',2500);
insert into groupe(idg, capacite, tarif, idc, effectif,debut) values(4,20,1150,16,10,to_date('06/20/2018','MM/DD/YYYY'));
insert into groupe(idg, capacite, tarif, idc, effectif,debut) values(5,50,1500,17,20,to_date('02/18/2018','MM/DD/YYYY'));
insert into inscription values (1,4);
insert into inscription values (1,5);
insert into inscription values (2,4);
select * from groupe;

-- 1.3

--1
select idg idc, debut, capacite, effectif
from groupe
where effectif < capacite;
--2
select nom, prenom, debut, nomc
from inscription i
join client2 c on c.idcl = i.idcl
join groupe g on g.idg = i.idg
join circuit cir on cir.idc = g.idc;
--3
select c.idc,nomc
from circuit c
join etape e on e.idc = c.idc
join ville v on v.idv = e.idv
where pays = 'Espagne';
--4
select distinct c.idc, nomc
from circuit c
join etape e on e.idc = c.idc
join ville v on v.idv = e.idv
where pays = 'Espagne'
group by c.idc,nomc
having count(*) = (select count(*)
                    from circuit c2
                    join etape e2 on e2.idc = c2.idc);
                    
--5
select c.idcl,nom,prenom,count(*)
from client2 c
join inscription i on i.idcl = c.idcl
group by c.idcl,nom,prenom;

--6

select cl.idcl,cl.nom,cl.prenom,
sum(Decode(sign(g.debut - sysdate),-1,1,0) )as nb_inscription_passes,
sum(Decode(sign(g.debut - sysdate),1,1,0)) as nb_inscription_a_venir
from client2 cl 
left join Inscription I on I.idcl=cl.idcl
join groupe g on g.idg = I.idcl
group by c.idcl, nom, prenom;

create or replace
package paq_inscription as
    PARAMETRE_INDEFINI Exception ;
    CLIENT_INCONNU Exception ;
    CLIENT_NON_INSCRIT Exception ;
    GROUPE_INCONNU Exception ;
    GROUPE_COMPLET Exception ;
    DEJA_INSCRIT Exception ;
    
    pragma Exception_init(PARAMETRE_INDEFINI, -20000);
    pragma Exception_init(CLIENT_INCONNU, -20001);
    pragma Exception_init(CLIENT_NON_INSCRIT, -20002);
    pragma Exception_init(GROUPE_INCONNU, -20003);
    pragma Exception_init(GROUPE_COMPLET, -20004);
    pragma Exception_init(DEJA_INSCRIT, -20005);
    
    procedure inscrire(le_client client2.idcl%type, le_groupe groupe.idg%type);
    procedure desinscrire(le_client client2.idcl%type, le_groupe groupe.idg%type);
    procedure annuler_groupe(le_groupe groupe.idg%type);

end paq_inscription;
/

