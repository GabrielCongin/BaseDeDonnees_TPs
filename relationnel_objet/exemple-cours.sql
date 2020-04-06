/*
drop table client_tab cascade constraints;
drop table produit_tab cascade constraints ;
drop table commande_tab cascade constraints ;

drop type client_type force ;
drop type commande_type force ;
drop type ens_lignes_cmde_type force ;
drop type ref_commande_type force ;
drop type ens_commandes_type force ;
drop type produit_type force ;
drop type ligne_commande_type force ;
*/

------------------------
-- creation des types --
------------------------
create type produit_type as object(
  num_produit NUMBER(3),
	nom VARCHAR2(30),
	prix_unitaire NUMBER(5,2)
) ;
/
-- on ne peut pas utiliser not null pour la définition d'un attribut
-- doc oracle "you cannot specify NULL or NOT NULL for an attribute of an object. Instead, use a CHECK constraint with the IS [NOT] NULL condition."
-- voir par exemple : http://docs.oracle.com/cd/B19306_01/server.102/b14200/clauses002.htm#i1002779

create type ligne_commande_type as object(
	la_ref_produit REF produit_type,
	quantite NUMBER(2)
) ;
/

create type ens_lignes_cmde_type as table of ligne_commande_type ; 
/

create type client_type ;
/
-- incomplete type
/*
An incomplete type is a type created by a forward type definition. 
It is called incomplete because it has a name but no attributes or methods. 
It can be referenced by other types, allowing you define types that refer to each other. 
However, you must fully specify the type before you can use it to create a table or an object column or a column of a nested table type.
*/

create type commande_type as object(
  num_commande number(3),
	date_commande DATE,
	le_client REF client_type,
	le_contenu ens_lignes_cmde_type
);
/
  
create type ref_commande_type as object(
  ref_commande REF commande_type
);
/

create type ens_commandes_type as table of ref_commande_type ;
/

create or replace type client_type as object(
	num_client NUMBER(3),
	nom VARCHAR2(20), 
	prenom VARCHAR2(20),
	solde NUMBER(6,2),
	les_commandes ens_commandes_type
) ;
/

-------------------------
-- creation des tables --
-------------------------

create table produit_tab of produit_type(
  constraint produit_tab_pkey primary key(num_produit),
  constraint col_not_null check (nom is not null and prix_unitaire is not null)
);

create table client_tab of client_type(
  constraint client_tab_pkey primary key(num_client),
  constraint col_client_not_null check (nom is not null and prenom is not null and solde is not null),
  constraint solde_default_zero solde default 0.0,
  constraint les_commandes_default les_commandes default ens_commandes_type()
  )nested table les_commandes store as client_les_commandes_tab ;
  
create table commande_tab of commande_type(
  constraint commande_tab_pkey primary key(num_commande),
  constraint le_client_fkey foreign key(le_client) references client_tab,
  constraint col_cmde_not_null check (date_commande is not null), -- on pourrait aussi mettre le client en not null
  constraint le_contenu_default le_contenu default ens_lignes_cmde_type()
)nested table le_contenu store as commande_lignes_tab ;

/*
Remarque : on ne peut pas exprimer toutes les contraintes de référence :
alter table client_les_commandes_tab add constraint verif_commande_fkey
  foreign key(ref_commande) references commande_tab ;
--> Rapport d'erreur :
Erreur SQL : ORA-30730: contrainte référentielle interdite sur une colonne de table imbriquée
30730. 00000 -  "referential constraint not allowed on nested table column"
*Cause:    An attempt was made to define a referential constraint on a nested
           table column.
*Action:   Do not specify referential constraints on nested table columns.

*/

--------------------------
-- insertion de données --
--------------------------

insert into client_tab(num_client,nom,prenom,solde) values (1,'DUVAL','SOPHIE',500);
insert into client_tab(num_client,nom,prenom,solde) values (2,'DUVAL','LAURENT',500);
insert into client_tab(num_client,nom,prenom) values (3,'DUPONT','JULIE'); -- le solde vaut donc 0.0

insert into produit_tab(num_produit, nom, prix_unitaire) values (1,'dentifrice',2.50) ;
insert into produit_tab(num_produit, nom, prix_unitaire) values (2,'cahier',2.0) ;
insert into produit_tab(num_produit, nom, prix_unitaire) values (3,'crayons',7.5);
insert into produit_tab(num_produit, nom, prix_unitaire) values (4,'stylo plume',21.65);
insert into produit_tab(num_produit, nom, prix_unitaire) values (5,'lait',6.50) ;
insert into produit_tab(num_produit, nom, prix_unitaire) values (6,'eau',5.50) ;
insert into produit_tab(num_produit, nom, prix_unitaire) values (7,'yop',0.80);
insert into produit_tab(num_produit, nom, prix_unitaire) values (8,'cafe',4.75);

--commandes de Sophie Duval
insert into commande_tab(num_commande, date_commande, le_client) 
values (1,'15/01/2015',(select ref(c) from client_tab c where c.num_client = 1)) ;

insert into commande_tab(num_commande, date_commande, le_client) 
values (2,'18/02/2015',(select ref(c) from client_tab c where c.num_client = 1)) ;

-- liens inverses (on insere plusieurs lignes dans la table imbriquee les_commandes)
insert into the(select cl.les_commandes from client_tab cl where cl.num_client=1)
select ref(c) from commande_tab c where c.le_client.num_client = 1 ;

--commandes de Laurent Duval
insert into commande_tab(num_commande, date_commande, le_client) 
values (3,'16/03/2015',(select ref(c) from client_tab c where c.num_client = 2)) ;

insert into commande_tab(num_commande, date_commande, le_client) 
values (4,'21/04/2015',(select ref(c) from client_tab c where c.num_client = 2)) ;

insert into the(select cl.les_commandes from client_tab cl where cl.num_client=2)
select ref(c) from commande_tab c where c.le_client.num_client = 2 ;

-- commande 1 : 5 cahiers, 1 lot de crayons et 1 stylo
insert into the(select c.le_contenu from commande_tab c where c.num_commande=1)
values ((select ref(p) from produit_tab p where p.num_produit=2), 5); -- remarque : on n'utilise pas le constructeur de ligne_commande_type

insert into the(select c.le_contenu from commande_tab c where c.num_commande=1)
values ((select ref(p) from produit_tab p where p.num_produit=3), 1);

insert into the(select c.le_contenu from commande_tab c where c.num_commande=1)
values ((select ref(p) from produit_tab p where p.num_produit=4), 1);


-- commande 2 : lait + 2*yop
insert into the(select c.le_contenu from commande_tab c where c.num_commande=2)
values ((select ref(p) from produit_tab p where p.num_produit=5), 1);

insert into the(select c.le_contenu from commande_tab c where c.num_commande=2)
values ((select ref(p) from produit_tab p where p.num_produit=7), 2);

-- commande 3 : lait + eau
insert into the(select c.le_contenu from commande_tab c where c.num_commande=3)
values ((select ref(p) from produit_tab p where p.num_produit=5), 1);

insert into the(select c.le_contenu from commande_tab c where c.num_commande=3)
values ((select ref(p) from produit_tab p where p.num_produit=6), 1);

-- commande 4 : dentifrice + 3*cahiers + 2*cafe
insert into the(select c.le_contenu from commande_tab c where c.num_commande=4)
values ((select ref(p) from produit_tab p where p.num_produit=1), 1);

insert into the(select c.le_contenu from commande_tab c where c.num_commande=4)
values ((select ref(p) from produit_tab p where p.num_produit=2), 3);

insert into the(select c.le_contenu from commande_tab c where c.num_commande=4)
values ((select ref(p) from produit_tab p where p.num_produit=8), 2);

--------------
-- test DML --
--------------
-- on supprime le produit 8 (café) dans la commande 4
delete from table(select c.le_contenu from commande_tab c where c.num_commande=4) nt
where nt.la_ref_produit.num_produit = 8;

-- on insere 1 produit 5 (lait) dans la commande 4
insert into table(select c.le_contenu from commande_tab c where c.num_commande=4)
values ((select ref(p) from produit_tab p where p.num_produit=5),1);

--  on remplace le produit 1 (dentifrice) par 2 * produit 8 (café) dans la commande 4
update table(select c.le_contenu from commande_tab c where c.num_commande=4) nt
set nt.quantite=2,
nt.la_ref_produit=(select ref(p) from produit_tab p where p.num_produit=8)
where nt.la_ref_produit.num_produit = 1;

------------------
-- des requetes --
------------------

-- si on reste sur des attributs simples, on a une requête SQL classique :
select nom,prenom from client_tab ;

select *
from produit_tab
where prix_unitaire >= 10 ;

-- ici, certaines colonnes sont des objets :
select * from client_tab
order by nom,prenom ;

NUM_CLIENT             NOM                  PRENOM               SOLDE                  LES_COMMANDES                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
---------------------- -------------------- -------------------- ---------------------- -----------------------------------------------------------------------------------------------------------------------------
3                      DUPONT               JULIE                0                      CARON.ENS_COMMANDES_TYPE()                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
2                      DUVAL                LAURENT              500                    CARON.ENS_COMMANDES_TYPE(CARON.REF_COMMANDE_TYPE('oracle.sql.REF@551883a'),CARON.REF_COMMANDE_TYPE('oracle.sql.REF@553883a'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
1                      DUVAL                SOPHIE               500                    CARON.ENS_COMMANDES_TYPE(CARON.REF_COMMANDE_TYPE('oracle.sql.REF@54d883a'),CARON.REF_COMMANDE_TYPE('oracle.sql.REF@54f883a'))                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

-- on n'a plus de jointure,
-- select num_commande, date_commande, nom, prenom
-- from commande JOIN client ON commande.num_client = client.num_client ;
-- devient :

select co.num_commande, co.date_commande, co.le_client.nom, co.le_client.prenom
from commande_tab co;

NUM_COMMANDE           DATE_COMMANDE             LE_CLIENT.NOM        LE_CLIENT.PRENOM     
---------------------- ------------------------- -------------------- -------------------- 
2                      18/02/15                  DUVAL                SOPHIE               
1                      15/01/15                  DUVAL                SOPHIE               
4                      21/04/15                  DUVAL                LAURENT              
3                      16/03/15                  DUVAL                LAURENT   


-- si on pose la requête en partant de client :
select co.ref_commande.num_commande, co.ref_commande.date_commande, cl.nom, cl.prenom
from client_tab cl,
  table(cl.les_commandes) co
  
-- le detail des commandes de chaque client devient :
select cl.nom, cl.prenom, co.ref_commande.date_commande, detail.la_ref_produit.nom, detail.quantite
from client_tab cl,
  table(cl.les_commandes) co,
  table (co.ref_commande.le_contenu) detail ;
  
NOM                  PRENOM               REF_COMMANDE.DATE_COMMANDE LA_REF_PRODUIT.NOM             QUANTITE               
-------------------- -------------------- ------------------------- ------------------------------ ---------------------- 
DUVAL                SOPHIE               15/01/15                  cahier                         5                      
DUVAL                SOPHIE               15/01/15                  crayons                        1                      
DUVAL                SOPHIE               15/01/15                  stylo plume                    1                      
DUVAL                SOPHIE               18/02/15                  lait                           1                      
DUVAL                SOPHIE               18/02/15                  yop                            2                      
DUVAL                LAURENT              16/03/15                  lait                           1                      
DUVAL                LAURENT              16/03/15                  eau                            1                      
DUVAL                LAURENT              21/04/15                  dentifrice                     1                      
DUVAL                LAURENT              21/04/15                  cahier                         3                      
DUVAL                LAURENT              21/04/15                  cafe                           2                      

 10 lignes sélectionnées 
 
-- on part de commande
select co.le_client.nom, co.le_client.prenom, co.date_commande, detail.la_ref_produit.nom, detail.quantite
from commande_tab co,
  table (co.le_contenu) detail ;
 
-- le nombre de commandes par client
-- en relationnel, on fait une jointure (si on veut le nom du client) et un group by
-- ou bien une sous-requête corrélative
-- ici, la partition est déjà faite

select cl.nom, cl.prenom, (select count(*) from table(cl.les_commandes))
from client_tab cl

-- si on part de commande, on ne profite pas du découpage en tables imbriquées
select co.le_client.nom, co.le_client.prenom, count(*)
from commande_tab co
group by co.le_client.nom, co.le_client.prenom
