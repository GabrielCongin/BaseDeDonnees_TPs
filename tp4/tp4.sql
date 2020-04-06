drop table tp_livre;
drop table tp_personne;
drop sequence seq_personne;
drop sequence seq_livre;
drop package paq_biblio;

create sequence Seq_Personne ;
create sequence Seq_livre ;

create table TP_Personne (
  id number(2) constraint Personne_pk primary key,
  nom varchar2(20) not null,
  prenom varchar2(20) not null
) ;

-- id_emprunte is null si le tp_livre n'est pas emprunté
-- idem pour id_reserve
create table Tp_livre (
  id number(2) constraint livre_pk primary key,
  titre varchar2(50),
  id_emprunte constraint personne_emprunte_le_livre_fk references tp_Personne(id), 
  id_reserve  constraint personne_reserve_le_livre_fk references tp_Personne(id)
) ;

insert into tp_personne values (Seq_Personne.nextval,'Canet','Guillaume') ;
insert into tp_personne values (Seq_Personne.nextval,'Debbouze','Jamel') ;
insert into tp_personne values (Seq_Personne.nextval,'Tautou','Audrey') ;
insert into tp_personne values (Seq_Personne.nextval,'Moreau','Yolande') ;

insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Asterix le gaulois') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Tintin au tibet') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'La zizanie') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'XIII - la nuit du 3 août') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Un goût de rouille et d''os') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Introduction aux bases de données') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Voyage au centre de la terre') ;
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Le Papyrus de César');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Au bonheur des dames');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Germinal');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Le Horla');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Une vie');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'Madame Bovary');
insert into tp_livre (id, titre) values (Seq_Livre.nextval,'La cuisine pour les nuls');

create or replace
package paq_biblio is

/* operation emprunter
 * declenche l'exception parametre_indefini si un des parametres n'est pas defini
 * declenche l'exception livre_inconnu (resp.  personne_inconnue) si 
 l'identifiant du livre (resp. de la personne) passe en parametre n'existe pas
 * declenche l'exception livre_non_disponible si le livre dont l'identifiant
 est passe en parametre est deja emprunte ou encore reserve par une autre 
 personne que celle dont l'identifiant est passe en parametre
 * declenche l'exception  trop_emprunts si la personne dont l'identifiant
 est passe en parametre a deja 3 emprunts
 * dans les autres cas, en sortie, le livre d'identifiant L a pour emprunteur 
  la personne d'identifiant P et n'est plus reserve.
 */
  procedure emprunter(L in TP_livre.id%type, P in TP_Personne.id%type) ;

/* operation reserver
 * declenche l'exception parametre_indefini si un des parametres n'est pas
 defini
 * declenche l'exception livre_inconnu (resp.  personne_inconnue) si 
l'identifiant du livre (resp. de la personne) passe en parametre n'existe pas
 * declenche l'exception livre_non_emprunte si le livre d'identifiant L 
n'a aucun emprunteur
 * declenche l'exception livre_non_disponible si le livre d'identifiant L
  est deja  reserve par une autre personne que celle d'identifiant P
 * dans les autres cas, en sortie, le livre d'identifiant L est maintenant
 reserve par  la personne d'identifiant P.
 */
  procedure reserver (L in TP_livre.id%type, P in TP_Personne.id%type) ;

/* operation restituer
 * declenche l'exception parametre_indefini si le parametre n'est pas defini
 * declenche l'exception livre_inconnu si l'identifiant du livre  passe en 
 parametre n'existe pas
 * declenche l'exception livre_non_emprunte si le livre d'identifiant L n'a 
 aucun emprunteur
 * dans les autres cas, en sortie, le livre d'identifiant L n'a plus d'emprunteur
 */ 
  procedure restituer(L in Tp_livre.id%type);

  /* les exceptions */
  
  parametre_indefini exception ;
  livre_inconnu exception ;
  personne_inconnue exception ;
  trop_emprunts exception ;
  livre_non_disponible exception ;
  livre_non_emprunte exception ;
  
  pragma exception_init(parametre_indefini,-20111);
  pragma exception_init(livre_inconnu,-20112);
  pragma exception_init(personne_inconnue,-20113);
  pragma exception_init(trop_emprunts,-20114);
  pragma exception_init(livre_non_disponible,-20115);
  pragma exception_init(livre_non_emprunte,-20116);
end paq_biblio ;




