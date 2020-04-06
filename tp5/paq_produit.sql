create or replace PACKAGE BODY PAQ_PRODUITS AS
    
  procedure ajouter_simple(le_nom ff_produit.nom%type, 
                           le_prix ff_produit.prix%type, 
                           la_taille ff_produit.taille%type, 
                           la_categ ff_simple.categ%type)  AS
  nom_prod FF_PRODUIT.nom%type;
  k FF_PRODUIT.p_ref%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_PRODUITS.ajouter_simple
    if le_nom is null or le_prix is null or la_taille is null or la_categ is null
    then raise PARAMETRE_INDEFINI;
    end if;
    
    if(le_prix<=0) then raise PRIX_NON_POSITIF;
    end if;
    
    if(la_taille not in ('petit','moyen','grand')) then raise PB_VALEUR_TAILLE;
    end if;
    
    if(la_categ not in ('boisson','dessert','salade','accompagnement','sandwich')) then raise PB_VALEUR_CATEGORIE;
    end if;
    
    select gen_clef.nextval into k from dual;
    insert into FF_PRODUIT(p_ref,nom,prix,taille)
    values (k,le_nom,le_prix,la_taille);
    insert into FF_SIMPLE(s_ref,categ)
    values (k,la_categ);
    exception
        when DUP_VAL_ON_INDEX then
        raise DOUBLON_NOM_PRODUIT;
  END ajouter_simple;

  procedure ajouter_menu(le_nom ff_produit.nom%type, 
                         le_prix ff_produit.prix%type, 
                         la_taille ff_produit.taille%type, 
                         la_promo ff_menu.promo%type)  AS
  k FF_PRODUIT.p_ref%type;
  nom_prod FF_PRODUIT.nom%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_PRODUITS.ajouter_menu
    if le_nom is null or le_prix is null or la_taille is null or la_promo is null
    then raise PARAMETRE_INDEFINI;
    end if;
    
    if(le_prix<=0) then raise PRIX_NON_POSITIF;
    end if;
        
    if(la_taille not in ('petit','moyen','grand')) then raise PB_VALEUR_TAILLE;
    end if;
    
    select gen_clef.nextval into k from dual;
    insert into FF_PRODUIT(p_ref,nom,prix,taille)
    values (k,le_nom,le_prix,la_taille);
    insert into FF_MENU(m_ref,promo)
    values(k,la_promo);
    exception
        when DUP_VAL_ON_INDEX then
        raise DOUBLON_NOM_PRODUIT;
  END ajouter_menu;

  procedure enrichir_menu(la_ref_menu ff_menu.m_ref%type, la_ref_simple ff_simple.s_ref%type)  AS
  refSimple2 FF_SIMPLE.s_ref%type;
  refSimple FF_SIMPLE.s_ref%type;
  refMenu FF_MENU.m_ref%type;
  tailleMenu FF_PRODUIT.taille%type;
  tailleSimple FF_PRODUIT.taille%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_PRODUITS.enrichir_menu
    if la_ref_menu is null or la_ref_simple is null
    then raise PARAMETRE_INDEFINI;
    end if;
    begin 
        select s_ref into refSimple
        from ff_simple
        where s_ref = la_ref_simple;
        exception
            when no_data_found then raise PRODUIT_INCONNU;
    end;
    begin 
        select m_ref into refMenu
        from ff_menu
        where m_ref = la_ref_menu;
        exception
            when no_data_found then raise PRODUIT_INCONNU;
    end;
    select taille into tailleMenu
    from ff_produit
    where p_ref = la_ref_menu;
    
    select taille into tailleSimple
    from ff_produit
    where p_ref= la_ref_simple;
    
    if(tailleSimple<>tailleMenu) then raise INCOHERENCE_TAILLES;
    end if;
    
    insert into ff_constitue(ref_menu, ref_simple)
    values(la_ref_menu, la_ref_simple);
    exception
        when DUP_VAL_ON_INDEX then null;
  
  END enrichir_menu;

  procedure appauvrir_menu(la_ref_menu ff_menu.m_ref%type, la_ref_simple ff_simple.s_ref%type)  AS
  refMenu FF_MENU.m_ref%type;
  refSimple FF_SIMPLE.s_ref%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_PRODUITS.appauvrir_menu
     if la_ref_menu is null or la_ref_simple is null
    then raise PARAMETRE_INDEFINI;
    end if;
    begin 
        select s_ref into refSimple
        from ff_simple
        where s_ref = la_ref_simple;
        exception
            when no_data_found then raise PRODUIT_INCONNU;
    end;
    begin 
        select m_ref into refMenu
        from ff_menu
        where m_ref = la_ref_menu;
        exception
            when no_data_found then raise PRODUIT_INCONNU;
    end; 
  
    delete from ff_constitue
    where ref_menu = la_ref_menu and ref_simple = la_ref_simple;
    if SQL%notfound then
        raise PB_COMPOSITION;
    end if;
  END appauvrir_menu;

  procedure consommer(le_produit ff_produit.p_ref%type, le_magasin ff_magasin.m_ref%type, 
                      l_instant ff_consommation.estampille%type := sysdate) AS
  mag ff_magasin.m_ref%type;
  prod ff_produit.p_ref%type;
  BEGIN
    -- TODO: Implementation required for procedure PAQ_PRODUITS.consommer
    if le_produit is null or le_magasin is null
    then raise PARAMETRE_INDEFINI;
    end if;
    begin
        select p_ref into prod
        from ff_produit
        where p_ref = le_produit;
    exception
        when no_data_found then raise PRODUIT_INCONNU;
    end;
     begin
        select m_ref into mag
        from ff_magasin
        where m_ref = le_magasin;
    exception
        when no_data_found then raise MAGASIN_INCONNU;
    end;
    if l_instant is null then
        insert into ff_consommation(ref_produit, ref_magasin,estampille)
         values(le_produit,le_magasin,sysdate);
    else
        insert into ff_consommation(ref_produit, ref_magasin,estampille)
         values(le_produit,le_magasin,l_instant);
    end if;
  END consommer;
END PAQ_PRODUITS;
