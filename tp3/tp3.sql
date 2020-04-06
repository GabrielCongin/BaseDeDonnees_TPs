drop table ContenuVente;
drop table Produit;
drop table Vente;
drop table Categorie;
drop table Marque;

create table Marque (
    nom varchar(20),
    descrip varchar(50),
    constraint marque_pk primary key(nom)
);

create table Categorie (
    nom varchar(20) check(nom is not null),
    id_categorie number(5),
    constraint categorie_pk primary key (id_categorie)
);


create table Produit (
    marque varchar(20) not null,
    id_produit number(5),
    refer varchar(10) not null,
    famille varchar(10) check (famille in ('Homme','Femme','Enfant') and famille is not null),
    id_categorie number(5) not null,
    constraint produit_pk primary key(id_produit),
    constraint categorie_fk foreign key (id_categorie) references Categorie(id_categorie),
    constraint marque_fk1 foreign key (marque) references Marque(nom),
    constraint couple_unique unique (marque,refer)
);

create table Vente (
    id_vente number(5),
    date_debut Date not null,
    date_fin Date null,
    marque varchar(20) not null,
    constraint vente_pk primary key(id_vente),
    constraint marque_fk2 foreign key (marque) references Marque(nom),
    check (date_fin - date_debut > 3)
);

create table ContenuVente (
    id_vente number(5),
    id_produit number(5),
    quantite number(5) not null,
    prix_initial number(5) not null,
    prix_solde number(5),
    check(prix_solde < prix_initial and prix_solde is not null),
    constraint ContenuVente_pk primary key (id_vente, id_produit),
    constraint produit_fk foreign key (id_produit) references Produit(id_produit),
    constraint vente_fk foreign key (id_vente) references Vente(id_vente)
);

-- 1.1
select v.id_vente, v.marque
from vente v
where v.date_fin > sysdate;

-- 1.2
select v.id_vente,v.marque
from contenuVente c
inner join produit p on p.id_produit = c.id_produit
inner join vente v on c.id_vente = v.id_vente 
where v.date_debut > sysdate and p.famille = 'Enfant';

-- 1.3
select count(v.id_vente)
from vente v
where date_debut > sysdate;

--1.4
select m.nom
from marque m
where m.nom not in ( select v.marque
                      from vente v);
                      
-- 1.5
select cat.nom, count(cat.id_categorie) as nb_produit
from categorie cat
inner join produit p on p.id_categorie = cat.id_categorie  --left ou right join a faire
group by cat.id_categorie, cat.nom;

-- 1.6
select cat.nom
from categorie cat
inner join produit p on p.id_categorie = cat.id_categorie
group by cat.id_categorie, cat.nom
having count(cat.id_categorie) > 10;

-- 1.7
--select v.id_vente, v.marque, c.quantite as nb_piece, count(p.refer) as nb_ref
--from contenuVente c
--inner join vente v on v.id_vente = c.id_vente
--inner join produit p on p.id_produit = c.id_produit;

-- 1.8
select v1.marque, count(v1.marque)
from contenuVente c1
inner join vente v1 on v1.id_vente = c1.id_vente
inner join produit p1 on p1.id_produit = c1.id_produit
group by v1.marque
having count(v1.marque) = ( select v.marque, count(v.marque)
                            from contenuVente c
                            inner join vente v on v.id_vente = c.id_vente
                            inner join produit p on p.id_produit = c.id_produit
                            where p.famille = 'Enfant'
                            group by v.marque);


--1.9


select max(date_debut)
from vente v
group by (v.marque)

