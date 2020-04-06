package bdd;

/**
 * Un objet Livre represente 1 ligne de la table qui contient les livres dans la base de la bibliothèque
 * et les objets associés : personne qui a emprunté et personne qui a réservé
 *
 */
public class Livre {

	private final int id ;
	private final String titre;
	private Personne emprunte, reserve ;

	/**
	 * @param id identifiant du livre
	 * @param titre titre du livre
	 * construit un livre qui n'est ni emprunté ni réservé
	 */
	public Livre (int id, String titre) {
		this.id = id ;
		this.titre = titre ;
		this.emprunte = null ;
		this.reserve = null ;
	}

	/**
	 * @return l'identifiant du livre
	 */
	public int getId(){return id ;}
	
	/**
	 * @return le titre du livre
	 */
	public String getTitre() {return titre;}

	/* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	
	
	public String toString() {
		return
				getTitre() +
				" (" + (emprunte == null ? "" : emprunte.getNom()) + ")" +
				" (" + (reserve == null ? ""  : reserve.getNom())  + ")" ;
	}

	public Personne getEmprunte() {
		return emprunte;
	}

	public void setEmprunte(Personne emprunte) {
		this.emprunte = emprunte;
	}

	public Personne getReserve() {
		return reserve;
	}

	public void setReserve(Personne reserve) {
		this.reserve = reserve;
	}
}
