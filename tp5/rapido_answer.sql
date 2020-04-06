-- Gabriel Congin L3 MIAGE Groupe 1

-- 3)
create view CONSO_PAR_MAGASIN_ET_PRODUIT as
select m.m_ref, m.nom as nom_mag, m.ville, p.p_ref, p.nom as nom_prod, count(*) as quantite, sum(p.prix) as CA 
from ff_consommation c
inner join ff_magasin m on m.m_ref = c.ref_magasin
inner join ff_produit p on p.p_ref = c.ref_produit
group by m.m_ref, m.nom, m.ville, p.p_ref,p.nom;

-- 4)
create or replace function meilleur_magasin (p ff_produit.p_ref%type) RETURN ff_magasin.m_ref%type is
res ff_magasin.m_ref%type;
begin
	    select c.m_ref into res from conso_par_magasin_et_produit c
	    where c.quantite = (select max(c1.quantite) from conso_par_magasin_et_produit c1 where c1.p_ref = p);
	    return res;
end;
/

-- 5)
insert into ff_stock select m_ref, s_ref, 0 as quantite from ff_magasin, ff_simple;

-- 6)

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

-- 8)
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
