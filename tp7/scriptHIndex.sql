-- un chercheur
create table HI_Chercheur (
  idC varchar2(5) constraint pkHI_Chercheur primary key,
  nom varchar2(30) not null,
  prenom varchar2(30) not null
);

-- un article
create table HI_Article (
  idA varchar2(5) constraint pkHI_Article primary key,
  titre varchar2(300) not null
);

-- l'article idA est (co-)écrit par le chercheur idC
create table HI_Auteur ( 
   idA varchar2(5),
   idC varchar2(5),
   constraint pkHI_Auteur primary key (idA, idC),
   constraint fkHI_Article  foreign key (idA) references HI_Article(idA),
   constraint fkHI_Chercheur  foreign key (idC) references HI_Chercheur(idC) 
);

--l'article idA cite l'article idACite
create table HI_Citation (
   idA varchar2(5),
   idACite varchar2(5),
   constraint pkHI_Citation primary key (idA, idACite),
   constraint fkHI_ArticleOrigine foreign key (idA) references HI_Article,
   constraint fkHI_ArticleCite foreign key (idACite) references HI_Article
);

insert into HI_Chercheur values ( 'C1', 'Heutte', 'Jean');
insert into HI_Chercheur values ('C2', 'Fluckiger', 'Cedric');
insert into HI_Chercheur values ('C3', 'Bastide','Isabelle');
insert into HI_Chercheur values ('C4',  'Fenouillet','Fabien');
insert into HI_Chercheur values ('C5', 'Delamotte', 'Eric');
insert into HI_Chercheur values ('C6', 'Delas', 'Yann');
insert into HI_Chercheur values ('C7', 'Boudjaoui', 'Mehdi');
insert into HI_Chercheur values ('C8', 'Bachy', 'Sylviane');
insert into HI_Chercheur values ('C9', 'Donnay', 'Bertrand');
insert into HI_Chercheur values ('C10', 'Jeunet', 'Jessy');

insert into HI_Article(idA,titre) values ('A1',  'L''environnement optimal d''apprentissage vidéo-ludique ');
insert into HI_Article(idA,titre) values ('A2',  'Les contenus informatiques à l''ecole dans le contexte de la convergence entre technique, media et information ');
insert into HI_Article(idA,titre) values ('A3',  'Album papier, album numérisé : une dialectique objet-outil avec le TBI ');
insert into HI_Article(idA,titre) values ('A4',  'EMI et Numérique - point de vue de la didactique de l''informatique');
insert into HI_Article(idA,titre) values ('A5',  'Homo sapiens retiolus : Contribution à l''écologie des communautés d''apprenance ');
insert into HI_Article(idA,titre) values ('A6',  'Hope, engagement and achievement in school ');
insert into HI_Article(idA,titre) values ('A7',  'French validation of the Multidimensional Students ');
insert into HI_Article(idA,titre) values ('A8',  'Ressources numériques au TNI ');
insert into HI_Article(idA,titre) values ('A9',  'Les Contenus d''enseignement et d''apprentissage. Approches didactiques  ');
insert into HI_Article(idA,titre) values ('A10',  'Le tableau comme outil d''enseignement ');
insert into HI_Article(idA,titre) values ('A11',  'Contenus et disciplines : une problématique didactique ');
insert into HI_Article(idA,titre) values ('A12',  'Approche par les compétences et dispositifs en alternance  ');

insert into HI_Auteur values ('A1', 'C1');
insert into HI_Auteur values ('A2', 'C2');
insert into HI_Auteur values ('A2', 'C5');
insert into HI_Auteur values ('A3', 'C2');
insert into HI_Auteur values ('A3', 'C3');
insert into HI_Auteur values ('A4', 'C2');
insert into HI_Auteur values ('A5', 'C1');
insert into HI_Auteur values ('A6', 'C1');
insert into HI_Auteur values ('A6', 'C2');
insert into HI_Auteur values ('A6', 'C6');
insert into HI_Auteur values ('A7', 'C7');
insert into HI_Auteur values ('A8', 'C8');
insert into HI_Auteur values ('A9', 'C2');
insert into HI_Auteur values ('A10', 'C6');
insert into HI_Auteur values ('A10', 'C8');
insert into HI_Auteur values ('A11', 'C4');
insert into HI_Auteur values ('A11', 'C7');
insert into HI_Auteur values ('A12', 'C4');
insert into HI_Auteur values ('A12', 'C9');

/*
-- Question 2.3
alter table HI_Article add nbCitations number(2) default 0;

-- Avant de faire les insertions dans la table citation, 
-- écrire le trigger qui renseigne la colonne nbCitations dans la table HI_Article

insert into HI_Citation values ('A1', 'A2');
insert into HI_Citation values ('A1', 'A3');
insert into HI_Citation values ('A1', 'A4');
insert into HI_Citation values ('A2', 'A1');
insert into HI_Citation values ('A3', 'A2');
insert into HI_Citation values ('A3', 'A6');
insert into HI_Citation values ('A4', 'A8');
insert into HI_Citation values ('A5', 'A1');
insert into HI_Citation values ('A5', 'A2');
insert into HI_Citation values ('A5', 'A4');
insert into HI_Citation values ('A6', 'A11');
insert into HI_Citation values ('A6', 'A10');
insert into HI_Citation values ('A7', 'A2');
insert into HI_Citation values ('A7', 'A4');
insert into HI_Citation values ('A7', 'A11');
insert into HI_Citation values ('A8', 'A3');
insert into HI_Citation values ('A8', 'A2');
insert into HI_Citation values ('A9', 'A7');
insert into HI_Citation values ('A9', 'A8');
insert into HI_Citation values ('A10', 'A6');
insert into HI_Citation values ('A10', 'A3');
insert into HI_Citation values ('A11', 'A5');
insert into HI_Citation values ('A11', 'A6');
insert into HI_Citation values ('A12', 'A4');
insert into HI_Citation values ('A12', 'A9');
insert into HI_Citation values ('A12', 'A10');
*/

