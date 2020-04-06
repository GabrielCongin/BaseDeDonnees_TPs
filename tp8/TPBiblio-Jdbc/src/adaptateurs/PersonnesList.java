package adaptateurs;

import java.sql.*;
import java.util.List;

import bdd.AppliException;
import bdd.ManagerPersonne;
import bdd.Personne;

/**
 * Une liste d'objets Personne qui pourra alimenter les Jlist de swing
 * cette classe hérite de DonneesListe et la spécialise pour les Personnes
 * On lui associe un ManagerPersonne qui permet de récupérer les personnes de la base
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class PersonnesList extends DonneesList<Personne>  {
	
	private ManagerPersonne pm;
	
	
	public PersonnesList() {
		super();
	
	}


	public void setManagerPersonne (ManagerPersonne pm) {
		this.pm = pm;
	}
	
	protected void ajouterTous () throws AppliException {

		List<Personne> lesPersonnes = pm.getLesPersonnes();
		for (Personne p : lesPersonnes) ajouter(p);

	}

}
