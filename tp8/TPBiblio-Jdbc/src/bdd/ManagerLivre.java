package bdd;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * objet qui fait la liaison avec la base de données pour accéder aux données de type Livre
 * nécessite une connexion pour s'initialiser
 */

@SuppressWarnings("unused")
public class ManagerLivre {
	private Connection connexion;
	
	private PreparedStatement  rechercherLesLivres;
	
	/**
	 * associer la connexion permet d'initialiser les preparedStaement
	 * 
	 */
	public void setConnection (Connection c) throws AppliException {
		// A FAIRE
		connexion = c;
		try {
			Statement stat = connexion.createStatement();
			String query = "select l.id,titre,"
					+ "p.id as idE, p.nom as nomE, p.prenom as prenomE,"
					+ "p2.id as idR, p2.nom as nomR, p2.prenom as prenomR "
					+ "from tp_livre l "
					+ "left join tp_personne p on l.id_emprunte = p.id "
					+ "left join tp_personne p2 on l.id_reserve = p2.id";
			rechercherLesLivres = connexion.prepareStatement(query);
		} catch (SQLException e) {
			e.printStackTrace();
		}
				
	}
	
	/** 
	 * retourne la liste de tous les livres tries par titre
	 * a chaque livre sont associes son emprunteur et la personne qui a reserve
	 */
	
	public List <Livre> getLesLivres() throws AppliException {
		//A  Faire
		List<Livre> list = new ArrayList<>();
		try {
			ResultSet rs = rechercherLesLivres.executeQuery();
			while(rs.next()){
				Livre livre = new Livre (rs.getInt("id"),rs.getString("titre"));
				rs.getInt("idE");
				if(!rs.wasNull()){
					Personne emp = new Personne (rs.getInt("idE"),rs.getString("nomE"),rs.getString("prenomE"));
					livre.setEmprunte(emp);
				}
				rs.getInt("idR");
				if(!rs.wasNull()){
					Personne res = new Personne (rs.getInt("idR"),rs.getString("nomR"),rs.getString("prenomR"));
					livre.setReserve(res);
				}
				list.add(livre);
			}
			rs.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
		
	}
}
