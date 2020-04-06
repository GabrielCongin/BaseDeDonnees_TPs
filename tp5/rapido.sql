-------------------------
-- TD/TP Licence MIAGE --
-------------------------

---------------------------------
-- creation du schema 'Rapido' --
---------------------------------
drop view CONSO_PAR_MAGASIN_ET_PRODUIT;
drop table ff_stock;
drop package paq_stock;
drop sequence gen_clef ;
drop table ff_consommation ;
drop table ff_magasin ;
drop table ff_constitue ;
drop table ff_menu ;
drop table ff_simple ;
drop table ff_produit ;
drop package paq_produits ;


---------------------------------
-- creation du schema 'Rapido' --
---------------------------------
create table FF_PRODUIT(
  p_ref number(4) constraint ff_produit_pkey PRIMARY KEY,
  nom varchar2(30) not null,
  prix number(5,2),
  taille varchar2(5) not null,
  constraint nom_unique unique(nom), -- pas 2 produits avec le meme nom
  constraint enum_taille check (taille in ('petit','moyen','grand')),
  constraint prix_positif check (prix > 0)
);

create table FF_SIMPLE(
  s_ref number(4) constraint ff_simple_pkey PRIMARY KEY
  constraint ff_simple_ff_produit_fkey REFERENCES FF_PRODUIT on delete cascade,
  categ varchar2(15),
  constraint enum_categ check (categ in ('boisson','dessert','salade','accompagnement','sandwich'))
);

create table FF_MENU(
  m_ref number(4) constraint ff_menu_pkey PRIMARY KEY
  constraint ff_menu_ff_produit_fkey REFERENCES FF_PRODUIT on delete cascade,
  promo varchar2(50)
);

create table FF_CONSTITUE(
  ref_menu number(4) constraint ff_constitue_ff_menu_fkey REFERENCES FF_MENU on delete cascade,
  ref_simple number(4) constraint ff_constitue_ff_simple_fkey REFERENCES FF_SIMPLE,
  constraint ff_constitue_pkey PRIMARY KEY(ref_menu, ref_simple)
);

create table FF_MAGASIN(
  m_ref number(4) constraint ff_magasin_pkey PRIMARY KEY,
  nom varchar2(30) not null,
  ville varchar2(30) not null
);

create table FF_CONSOMMATION(
  estampille TIMESTAMP not null,
  ref_produit number(4) not null constraint consom_ff_produit_fkey REFERENCES FF_PRODUIT,
  ref_magasin number(4) not null constraint consom_ff_magasin_fkey REFERENCES FF_MAGASIN
);

-- sequence pour les clefs des produits
create sequence gen_clef
increment by 1
start with 1 ;

----VUE----
--Q3)
drop view conso_par_magasin_et_produit;
create view CONSO_PAR_MAGASIN_ET_PRODUIT as
select m.m_ref, m.nom as nom_mag, m.ville, p.p_ref, p.nom as nom_prod, count(*) as quantite, sum(p.prix) as CA 
from ff_consommation c
inner join ff_magasin m on m.m_ref = c.ref_magasin
inner join ff_produit p on p.p_ref = c.ref_produit
group by m.m_ref, m.nom, m.ville, p.p_ref,p.nom;

--- FONCTION ---
--Q4

create or replace function meilleur_magasin (p ff_produit.p_ref%type) RETURN ff_magasin.m_ref%type is
res ff_magasin.m_ref%type;
begin
    select c.m_ref into res from conso_par_magasin_et_produit c
    where c.quantite = (select max(c1.quantite) from conso_par_magasin_et_produit c1 where c1.p_ref = p);
    return res;
end;
/

----------------------------
-- Paquetage PAQ_PRODUITS --
----------------------------

create or replace
package PAQ_PRODUITS as
  PARAMETRE_INDEFINI EXCEPTION ;
  PRODUIT_INCONNU EXCEPTION ;
  INCOHERENCE_TAILLES EXCEPTION ; 
  PB_COMPOSITION EXCEPTION ;
  PRIX_NON_POSITIF EXCEPTION ;
  PB_VALEUR_TAILLE EXCEPTION ;
  PB_VALEUR_CATEGORIE EXCEPTION ;
  DOUBLON_NOM_PRODUIT EXCEPTION ;
  MAGASIN_INCONNU EXCEPTION ;

  PRAGMA exception_init(PARAMETRE_INDEFINI,-20102) ;
  PRAGMA exception_init(PRODUIT_INCONNU,-20103);
  PRAGMA exception_init(INCOHERENCE_TAILLES,-20104);
  PRAGMA exception_init(PB_COMPOSITION,-20105);
  PRAGMA exception_init(PRIX_NON_POSITIF,-20106) ;
  PRAGMA exception_init(PB_VALEUR_TAILLE,-20107) ;
  PRAGMA exception_init(PB_VALEUR_CATEGORIE,-20108) ;
  PRAGMA exception_init(DOUBLON_NOM_PRODUIT,-20109) ;
  PRAGMA exception_init(MAGASIN_INCONNU,-20110);
    
  /* on ajoute un produit simple dans la base 
   * Déclenche PARAMETRE_INDEFINI si l'un des paramètres vaut NULL
   * Déclenche PB_VALEUR_TAILLE, PRIX_NON_POSITIF, DOUBLON_NOM_PRODUIT ou PB_VALEUR_CATEGORIE
   * si les contraintes déclarées avec les tables ne sont pas respectées.
   */
  procedure ajouter_simple(le_nom ff_produit.nom%type, 
                           le_prix ff_produit.prix%type, 
                           la_taille ff_produit.taille%type, 
                           la_categ ff_simple.categ%type) ;

  /* on ajoute un menu dans la base 
   * Déclenche PARAMETRE_INDEFINI si l'un des paramètres vaut NULL
   * Déclenche PB_VALEUR_TAILLE, PRIX_NON_POSITIF ou DOUBLON_NOM_PRODUIT
   * si les contraintes déclarées avec les tables ne sont pas respectées.
   */
  procedure ajouter_menu(le_nom ff_produit.nom%type, 
                         le_prix ff_produit.prix%type, 
                         la_taille ff_produit.taille%type, 
                         la_promo ff_menu.promo%type) ;

  /* Ajoute un produit simple dans la composition d'un menu
   * Déclenche PARAMETRE_INDEFINI si l'un des paramètres vaut NULL
   * Déclenche INCOHERENCE_TAILLES si le menu et le simple n'ont pas la même taille
   * par exemple, mettre une petite frite dans un "grand" menu est une erreur.
   * On déclenche PRODUIT_INCONNU si le menu ou le simple n'existe pas.
   * si on veut mettre un produit simple deja present dans ce menu, ça ne declenche pas d'erreur (ça ne fait rien)
   */
  procedure enrichir_menu(la_ref_menu ff_menu.m_ref%type, la_ref_simple ff_simple.s_ref%type) ;

  /* Enlève un produit simple de la constitution d'un menu.
   * Déclenche PARAMETRE_INDEFINI si l'un des paramètres vaut NULL
   * Déclenche PB_COMPOSITION si ce produit simple n'est pas dans ce menu.
   */
  procedure appauvrir_menu(la_ref_menu ff_menu.m_ref%type, la_ref_simple ff_simple.s_ref%type) ;
  
  /* on consomme le_produit dans le_magasin sur le temps l_instant : 
   *  ajoute la ligne correspondante dans la table FF_CONSOMMATION
   * Déclenche PARAMETRE_INDEFINI si l'un des paramètres vaut NULL
   * Déclenche PRODUIT_INCONNU si le produit n'existe pas.
   * Déclenche MAGASIN_INCONNU si le magasin n'existe pas.
   */
  procedure consommer(le_produit ff_produit.p_ref%type, le_magasin ff_magasin.m_ref%type, 
                      l_instant ff_consommation.estampille%type := sysdate);
                      
end;
/

------------------------
-- gestion des stocks --
------------------------
create table FF_Stock(
  ref_magasin constraint ff_stock_mag_fkey REFERENCES FF_MAGASIN,
  ref_produit constraint ff_stock_produit_fkey REFERENCES FF_SIMPLE,
  quantite number(5) default 0 not null,
  constraint stock_qte_positive check (quantite >= 0),
  constraint ff_stock_pkey primary key(ref_magasin, ref_produit)
);

--INITIALISER STOCK--
-- 5)
insert into ff_stock select m_ref, s_ref, 0 as quantite from ff_magasin, ff_simple;

-------------------------
-- Paquetage PAQ_STOCK --
-------------------------

create or replace package PAQ_STOCK as
  PB_STOCK Exception ;
  Pragma Exception_init(PB_STOCK, -20120);

  -- Modifie le stock dans 1 magasin pour 1 produit simple 
  -- Déclenche PAQ_PRODUITS.PRODUIT_INCONNU (resp. PAQ_PRODUITS.MAGASIN_INCONNU) 
  -- si la reference produit (resp. magasin) n'est pas correcte
  -- La quantite peut être positive ou négative.
  -- Ne fait rien si la quantité est à 0
  -- Déclenche PB_STOCK si on essaie de retirer plus de produits qu'il n'y en a en stock
  procedure modifie_stock_simple(la_ref_produit FF_STOCK.REF_PRODUIT%type, 
                                            la_quantite FF_STOCK.QUANTITE%type, 
                                            la_ref_magasin FF_STOCK.REF_MAGASIN%type) ;


  -- Modifie le stock dans 1 magasin pour tous les produits simples qui constituent 1 menu 
  -- Déclenche PAQ_PRODUITS.PRODUIT_INCONNU (resp. PAQ_PRODUITS.MAGASIN_INCONNU) 
  -- si la reference produit (resp. magasin) n'est pas correcte
  -- Déclenche PAQ_PRODUITS.PRODUIT_INCONNU si le menu n'est constitué d'aucun produit simple
  -- La quantite peut être positive ou négative.
  -- Ne fait rien si la quantité est à 0
  -- Déclenche PB_STOCK si on essaie de retirer plus de produits qu'il n'y en a en stock
  procedure modifie_stock_menu(la_ref_menu FF_MENU.M_REF%type, 
                                                     la_quantite FF_STOCK.QUANTITE%type, 
                                                     la_ref_magasin FF_STOCK.REF_MAGASIN%type) ;

end;
/
-- QUESTION 6 --

create or replace trigger insertionMag
after insert
on ff_magasin
for each row
begin
    insert into ff_stock
    select :new.m_ref, s_ref, 0 from ff_simple;
end;
/

create or replace trigger insertionProdSimple
after insert
on ff_simple
for each row
begin
    insert into ff_stock
    select m_ref, :new.s_ref, 0 from ff_magasin;
end;
/

-- QUESTION 8 --

create or replace trigger diminuerStock
after insert
on ff_consommation
for each row
declare
refSimple ff_simple.s_ref%type;
begin
    select s_ref into refSimple
    from ff_simple
    where :new.ref_produit = s_ref;
    
    if refSimple is not null
    then
        PAQ_STOCK.modifie_stock_simple(:new.ref_produit,-1,:new.ref_magasin);
    else
        PAQ_STOCK.modifie_stock_menu(:new.ref_produit,-1,:new.ref_magasin);
    end if;    
end;
/



