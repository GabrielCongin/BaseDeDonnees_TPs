package bdd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * objet qui fait la liaison avec la base de données pour accéder aux données 
 * de type Personne
 * nécessite une connexion pour s'initialiser
 */

@SuppressWarnings("unused")
public class ManagerPersonne {
	
	private Connection connexion;
	
	private PreparedStatement  rechercherLesPersonnes;
	
	/**
	 * associer la connexion permet d'initialiser les preparedStaement
	 * necesaires aux requetes
	 */
	public void setConnection (Connection c) throws AppliException {
		// A COMPLETER
		connexion = c;
		try {
			Statement stat = connexion.createStatement();
			String query = "select * from tp_personne";
			rechercherLesPersonnes = connexion.prepareStatement(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}		
	}
	
	/**
	 *  retourne la liste des personnes ordonnee par nom
	 * declenche AppliException en cas de pb
	 */
	
	public List <Personne> getLesPersonnes () throws AppliException {
		// A COMPLETER
		List<Personne> list = new ArrayList<>();
		try {
			ResultSet rs = rechercherLesPersonnes.executeQuery();
			while(rs.next()){
				Personne personne = new Personne (rs.getInt("id"),rs.getString("nom"), rs.getString("prenom"));
				list.add(personne);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
		
	}
}
