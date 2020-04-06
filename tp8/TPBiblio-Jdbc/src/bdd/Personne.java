package bdd;

/**
 * objet qui représente un usager : correspond souvent à  1 ligne de la table contenant les personnes
 *
 */
public class Personne { 
	private final int id ;
	private final String nom, prenom ;


	/**
	 * @param id un identifiant de personne
	 * @param nom un nom de personne
	 * crée la personne d'identifiant id et de nom nom
	 */
	public Personne(int id, String nom, String prenom) {
		this.id = id ;
		this.nom = nom ;
		this.prenom=prenom;
		
	}

	/**
	 * @return l'identifiant de la personne
	 */
	public int getId()   { return id ;}
	
	/**
	 * @return le nom de la personne
	 */
	public String getNom()   { return nom ;}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	
	public String toString() { return getNom () + " " + getPrenom(); }

	public String getPrenom() {
		return prenom;
	}

}
