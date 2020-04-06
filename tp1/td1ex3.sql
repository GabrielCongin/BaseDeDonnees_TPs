-- tables pour l'exercice 3 du TD 1
drop table reserve;
drop table bateau;
drop table marin;

create table Marin (
  mid number(3),
  mnom varchar2(20),
  datenaiss date,
  constraint Marin_PK primary key(mid)
);

create table Bateau (
  bid number(3),
  bnom varchar2(20),
  couleur varchar2(20),
  constraint Bateau_PK primary key(bid)
);

create table Reserve (
  mid number(3),
  bid number(3),
  rdate date,
  constraint Reserve_PK primary key(mid,bid,rdate),
  constraint Reserve_Marin_FK foreign key(mid) references Marin(mid),
  constraint Reserve_Bateau_FK foreign key(bid) references Bateau(bid)
);


insert into Marin values (1, 'Nemo', to_date('01/01/1870','dd/mm/yyyy'));
insert into Marin values (2, 'Achab', to_date('01/01/1851','dd/mm/yyyy'));
insert into Marin values (3, 'Bart', to_date('01/01/1650','dd/mm/yyyy'));
insert into Marin values (4, 'Dugay-Trouin', to_date('01/01/1673','dd/mm/yyyy'));
insert into Marin values (5, 'Sparrow', to_date('01/01/1710','dd/mm/yyyy'));
insert into Marin values (6, 'La Pérouse', to_date('01/01/1741','dd/mm/yyyy'));


insert into Bateau values (101, 'Le Pourquoi Pas', 'blanc') ;
insert into Bateau values (102, 'Love Boat', 'rouge') ;
insert into Bateau values (103, 'Nimitz', 'vert') ;
insert into Bateau values (104, 'Queen Anne''s Revenge', 'rouge') ;
insert into Bateau values (105, 'Dunkerque', 'vert') ;

insert into Reserve values (1,101,to_date('01/01/2020','dd/mm/yyyy') );
insert into Reserve values (1,105,to_date('01/01/2020','dd/mm/yyyy') );
insert into Reserve values (2,103,to_date('01/01/2020','dd/mm/yyyy') );
insert into Reserve values (2,101,to_date('01/02/2020','dd/mm/yyyy') );
insert into Reserve values (3,104,to_date('01/01/2020','dd/mm/yyyy') );
insert into Reserve values (4,105,to_date('01/01/2020','dd/mm/yyyy') );
insert into Reserve values (4,104,to_date('01/02/2020','dd/mm/yyyy') );
insert into Reserve values (4,102,to_date('01/02/2020','dd/mm/yyyy') );
insert into Reserve values (5,101,to_date('01/02/2020','dd/mm/yyyy') );
insert into Reserve values (5,104,to_date('01/02/2020','dd/mm/yyyy') );

-- 1)
select mnom from marin m
join reserve r on r.mid = m.mid
where r.bid = 103;
-- 2)
select distinct mnom from reserve r
join marin m on r.mid = m.mid join bateau b on b.bid = r.bid
where b.couleur = 'rouge';
-- 3)
select distinct couleur from reserve r
join marin m on r.mid = m.mid join bateau b on b.bid = r.bid
where mnom = 'Sparrow';
-- 4)
select m.mnom from reserve r
join marin m on r.mid = m.mid
group by m.mnom
having count(*) > 0;
-- 5)
select distinct mnom from reserve r
join marin m on r.mid = m.mid join bateau b on b.bid = r.bid
where b.couleur = 'rouge' or b.couleur = 'vert';
-- 6)
select distinct mnom from reserve r
join marin m on r.mid = m.mid 
join bateau b on b.bid = r.bid
join reserve r2 on m.mid = r2.mid
join bateau b2 on b2.bid = r2.bid
where b.couleur = 'rouge' and b2.couleur = 'vert';
-- 7)
select mnom, count(*) nbReservations
from reserve r
right join marin m on m.mid = r.mid
group by mnom;
-- 8)
select avg(count(*)) moy
from reserve r
join marin m on m.mid = r.mid
group by mnom; -- mettre un champ dans count pour qu'il soit à 0 celui qui n'a pas de bateau

