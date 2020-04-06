drop table historique;
drop table action;

create table Action (
  id         Number(5) generated always as identity,
  nom        Varchar2(20), -- nom de l'entreprise
  total      Number(10), -- nombre total de titres
  disponible Number(10), -- nombre de titres disponibles à l'achat
  constraint Action_PK primary key(id) 
) ;
  
create table Historique (
  id_action  Number(5),
  jour       Date,
  prix       Number(10, 2) not null, -- prix à la cloture de la journée
  constraint Historique_PK primary key (id_action, jour),
  constraint Historique_Action_FK
     foreign key (id_action) references Action(id) 
) ;

--1.1 et 1.2
alter table Action add ( constraint verif_total check (total >= 0),
                         constraint verif_dispo check (disponible between 0 and total),
                         constraint nbTitreInconnu check(total is not null or disponible is null)
);
--1.3
create or replace trigger pas_update
before update on historique
begin
    raise PAQ_ACTION.update_interdit;
end;
/

--1.4
create or replace trigger nom_action_majuscule
before insert or update of nom on Action
for each row
begin
    :new.nom:=upper(:new.nom);
end;
/