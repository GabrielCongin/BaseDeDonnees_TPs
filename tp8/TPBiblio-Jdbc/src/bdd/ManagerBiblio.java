package bdd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * objet qui propose tous les services necessaires  pour la gestion de la bibliotheque:
 * operations (emprunter, reserver, restituer)
 */

@SuppressWarnings("unused")
public class ManagerBiblio {
	
	private java.sql.Connection laConnexion ;

	private Statement stmt ; // zone de requete
	private CallableStatement csEmprunter, csRestituer ; // pour les procedures stockees
	

	/**
	 * Constructeur vide 
	 */
	public ManagerBiblio() {
		super();
	}


	/**
	 * la connection passee en parametre permet d'initialiser les objects necessaires 
	 * a la réalisation des opérations : callableStatement,...
	 * @throws AppliException si l'initialisation pose probleme
	 */
	public void setConnection( Connection connection) throws AppliException{
		//A completer
		laConnexion = connection;
		try {
			stmt = laConnexion.createStatement();
			csRestituer = laConnexion.prepareCall("{call PAQ_BIBLIO_JDBC.restituer(?)}");
			csEmprunter = laConnexion.prepareCall("{call PAQ_BIBLIO_JDBC.emprunter(?,?)}");
		} catch (SQLException e) {
			throw new AppliException(e.getErrorCode());
		}

	};


	/**
	 * @param livre un livre dans la base
	 * @param personne une personne dans la base
	 * @throws AppliException si l'emprunt n'est pas possible :  le livre est déjà  emprunté ou réservé par une autre personne, 
	 * ou la personne a déjà  emprunté 3 livres
	 * Réalise l'emprunt du livre par la personne 
	 */
	public void emprunter(Livre livre, Personne personne) throws AppliException{
		try {
			csEmprunter.setInt(1,livre.getId());
			csEmprunter.setInt(2, personne.getId());
			csEmprunter.execute();
		} catch (SQLException e) {
			throw new AppliException(e.getErrorCode());
		}
	}
	
	
	/**
	 * @param livre un livre dans la base
	 * @throws AppliException si la restitution n'est pas possible : il n'est pas emprunté
	 * Réalise la restitution du livre (en sortie il n'est plus emprunté)
	 */
	public void restituer(Livre livre) throws AppliException{
		//A Completer
		try {
			csRestituer.setInt(1,livre.getId());
			csRestituer.execute();
		} catch (SQLException e) {
			throw new AppliException(e.getErrorCode());
		}
	}

	
	
	/**
	 * @param livre, un livre dans la base
	 * @param personne, une personne dans la base
	 * @throws AppliException si un des paramètres n'est pas défini
	 * @throws AppliException si la réservation n'est pas possible : le livre est déjà réservé par une autre personne, 
	 * ou il n'est pas emprunté, ou il est déjà  emprunté par cette personne, 
	 * ou la personne a déjà  3 réservations
	 */
	
	 
	public void reserver (Livre livre, Personne personne) throws AppliException {
		//A completer
		if(livre == null || personne == null){
			throw new AppliException(20111);
		}
		if(livre.getEmprunte()==null ){
			throw new AppliException(20116);
		}
		System.out.println(livre.getReserve());
		if(livre.getReserve() != null){
			throw new AppliException(20115);
		}
		try {
			ResultSet nb_reservation = stmt.executeQuery("select count(*) as nb from tp_livre where id_reserve = "+personne.getId());
			if(nb_reservation.next()){
				if(nb_reservation.getInt("nb")>3){
					System.out.println("Réservation > à 3");
					throw new AppliException(20114);
				}
			}
			stmt.executeUpdate("update tp_livre set id_reserve = "+personne.getId()+" where id = "+livre.getId());
			livre.setReserve(personne);
		} catch (SQLException e) {
			throw new AppliException(e.getErrorCode());
		}
	}
}
