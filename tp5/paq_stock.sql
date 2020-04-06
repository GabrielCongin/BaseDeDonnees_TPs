create or replace PACKAGE BODY PAQ_STOCK AS

  quantite_inferieure exception;
  pragma exception_init(quantite_inferieure,-2290);
  procedure modifie_stock_simple(la_ref_produit FF_STOCK.REF_PRODUIT%type, 
                                            la_quantite FF_STOCK.QUANTITE%type, 
                                            la_ref_magasin FF_STOCK.REF_MAGASIN%type)  AS
  refMag ff_magasin.m_ref%type;
  refSimple ff_simple.s_ref%type;
  BEGIN
    if la_ref_produit is null or la_quantite is null or la_ref_magasin is null
    then
        raise PAQ_PRODUITS.PARAMETRE_INDEFINI;
    end if;
    begin
        select m_ref into refMag
        from ff_magasin
        where m_ref = la_ref_magasin;
    exception
        when no_data_found then raise PAQ_PRODUITS.MAGASIN_INCONNU;
    end;
    begin
        select s_ref into refSimple
        from ff_simple
        where s_ref = la_ref_produit;
    exception
        when no_data_found then raise PAQ_PRODUITS.PRODUIT_INCONNU;
    end;
    if la_quantite != 0
    then
        begin
        update ff_stock
        set quantite = quantite + la_quantite
        where ref_magasin = la_ref_magasin and ref_produit = la_ref_produit;
        exception
            when quantite_inferieure then raise PB_STOCK;
        end;
    end if;
    
  END modifie_stock_simple;

  procedure modifie_stock_menu(la_ref_menu FF_MENU.M_REF%type, 
                                                     la_quantite FF_STOCK.QUANTITE%type, 
                                                     la_ref_magasin FF_STOCK.REF_MAGASIN%type)  AS
  quantiteInf ff_stock.quantite%type;
  refMag ff_magasin.m_ref%type;
  refMenu ff_menu.m_ref%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_STOCK.modifie_stock_menu
    if la_ref_menu is null or la_quantite is null or la_ref_magasin is null
    then
        raise PAQ_PRODUITS.PARAMETRE_INDEFINI;
    end if;
    begin
        select m_ref into refMag
        from ff_magasin
        where m_ref = la_ref_magasin;
    exception
        when no_data_found then raise PAQ_PRODUITS.MAGASIN_INCONNU;
    end;
    begin
        select m_ref into refMenu
        from ff_menu
        where m_ref = la_ref_menu;
    exception
        when no_data_found then raise PAQ_PRODUITS.PRODUIT_INCONNU;
    end; 

    if la_quantite != 0
    then
        begin
        update ff_stock
        set quantite = quantite + la_quantite
        where ref_magasin = la_ref_magasin
        and ref_produit in ( select ref_simple from ff_constitue
                             where ref_menu = la_ref_menu);
        if SQL%notfound then
            raise PAQ_PRODUITS.PRODUIT_INCONNU;
         end if;
        exception
            when quantite_inferieure then raise PB_STOCK;
        
        end;
    end if;
  END modifie_stock_menu;

END PAQ_STOCK;
