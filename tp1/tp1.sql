drop table commande;
drop table produit;
drop table producteur;
drop table client;

create table Client (
id Number (5), -- entier de 5 chiffres décimaux
nom Varchar2 (20), -- chaîne d’au plus 20 caractères
solde Number (6, 2), -- de -9999.99 à +9999.99
constraint Client_PK primary key (id)
-- garantit l’unicité de id pour chaque ligne
) ;

insert into Client values ( 1,'toto',200.0);
insert into Client values ( 2, 'titi', 20.0);
insert into Client values ( 3, 'titi', 20.0);
insert into Client values ( 5, 'tata', 120.0);
insert into Client values (15, 'bof', 150.0);
insert into Client values (16, 'bif', 150.0);

select * from client;

-- 1.3.1

select nom from client where solde > 150;

-- 1.3.2

select nom from client where mod(id,2) = 0;

-- 1.3.3

select id,nom from client where nom like '%o%'; 
-- where regexp_like(nom,'o')

-- 1.4

insert into client values (20,'riri',null);  -- si on spécifie null, et que cela n'est pas la clé primaire, le champ est à null
insert into client(id,nom) values (21,'fifi'); -- si on spécifie pas et que cela n'est pas la clé primaire, le champ est à null
insert into client(id,solde) values (22,150.0);  -- same

-- 1.5

   -- insert into client(nom) values ('loulou');  il manque la clé primaire
 
 -- 1.6
 
select count(*) from client ;    --  toutes les lignes sont comptabilisées
select count(nom) from client ;  --  toutes les lignes sauf celles dont le nom est null sont comptabilisés
select avg(solde) from client ;  --  toutes les lignes sauf celles dont le solde est null sont comptabilisés 

-- 1.7.1

update Client
set solde = solde - 30.0, nom='toto'     -- id est unique
where id = 2 ; 

-- 1.7.2

update Client
set solde = solde + 30.0                   -- tout les clients dont le solde est compris entre 100 et 180, il peut donc
where solde between 100.0 and 180.0 ;      -- y en avoir plusieurs

-- 1.8

delete from client where id = 4 ;   -- non ça supprime rien, cet id n'existe pas mais cela ne crée pas d'erreur avec le drop
delete from client where id = 1 ;   -- cela supprime bien le client voulu, et il n'y a pas d'erreur avec le drop

-- 2.1.1

create table Producteur (
id Number (5),
nom Varchar2 (20),
constraint Producteur_PK primary key (id)
) ;

create table Produit (
id Number (5),
nom Varchar2 (20),
prix_unitaire Number (8, 2),
producteur Number (5),
constraint Produit_Producteur_FK
foreign key (producteur) references Producteur (id),
constraint Produit_PK primary key (id)
) ;

select * from produit;
select * from producteur;

insert into Producteur values ( 1, 'Bricolot') ;
insert into Producteur values ( 2, 'Fruit’’n Fibre') ;
insert into Produit (id, nom, prix_unitaire, producteur) values ( 1,'clou',11.0,1) ;
insert into Produit (id, nom, prix_unitaire, producteur) values ( 2, 'robinet',30.0,1) ;
insert into Produit (id, nom, prix_unitaire, producteur) values ( 3,'kiwi',0.3,2) ;

-- insert into Produit (id,nom, prix_unitaire, producteur) values ( 4,'pomme',0.5,3) ;  -- il n'y a pas de producteur d'id 3

select * from produit,producteur; -- producteur = 2l 2col  , produit = 3l 4col  donc 2*3l et 2+4col = 6l 6col, ça correspond

-- 2.1.2

select p1.*, p2.*
from Producteur p1 cross join Producteur p2 ; -- cela double les lignes et les colonnes

-- 2.2.1

--select p1.nom, p2.nom from produit p1, producteur p2 where p1.producteur = p2.id; 
select p1.nom, p2.nom from produit p1 join producteur p2 on p1.producteur = p2.id;

-- 2.2.2

select p1.nom, p2.nom, p1.prix_unitaire, p2.prix_unitaire from produit p1, produit p2
where p1.prix_unitaire < p2.prix_unitaire;

-- 3.1.1

create table Commande (
idClient Number (5),
idProduit Number (5),
quantite Number (5),
constraint Commande_PK primary key (idClient, idProduit),
constraint Commande_Client_FK
foreign key (idClient) references Client (id),
constraint Commande_Produit_FK
foreign key (idProduit) references Produit (id)
) ;
insert into commande values (2, 2, 3);
insert into commande values (2, 3, 20);
insert into commande values (5, 1, 100);
insert into commande values (5, 3, 10);

select * from commande;

--select c.nom, p.nom, co.quantite from commande co, client c, produit p
--where co.idClient = c.id and co.idProduit = p.id;

select c.nom, p.nom, co.quantite from commande co
join client c on co.idClient = c.id join produit p on co.idProduit = p.id;

-- 3.1.2

select distinct c.nom from commande co join client c on co.idClient = c.id; -- jointure

select c.nom from client c where c.id in ( select idClient from commande) ; -- sous requête 

-- 3.2

select count(*), max(prix_unitaire), min(prix_unitaire) from produit;

-- 3.3.1

select c.nom , count(*) from commande co join client c on co.idClient = c.id group by c.nom;

-- 3.3.2

select c.nom , count(co.idClient) from commande co right join client c on co.idClient = c.id group by c.nom;  -- valeur pas à 0 ?

-- 3.3.3

select p2.nom, count(*) nbproduit from produit p1 join producteur p2 on p1.producteur = p2.id group by p2.nom having count(*) > 2;

-- 3.3.4

select p2.nom, sum(prix_unitaire*c.quantite) gain 
from produit p1 join producteur p2 on p1.producteur = p2.id 
join commande c on c.idProduit = p1.id 
group by p2.nom; -- group by

-- todo : sous requete
select p.id, p.nom, 
    (select sum(prix_unitaire  * quantite) 
    from commande c, produit p2 
    where c.idProduit = p2.id 
    and p2.producteur = p.id ) gain
from producteur p;









