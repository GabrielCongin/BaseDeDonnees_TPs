package ihm;

import javax.swing.*;
import javax.swing.border.Border;

import adaptateurs.LivresList;
import adaptateurs.PersonnesList;
import bdd.*;

/**
 * Panel de gestion des emprunts
 * Permet d'afficher la liste des personnes, la liste des livres, et de réserver/emprunter/restituer
 *
 */
@SuppressWarnings("serial")
public class PanelEmprunt extends JPanel {

	private JList<Personne> listePersonnes;
	private JList<Livre> listeLivres ;
	private JLabel statut = new JLabel() ;
	private BaseBiblio b ;
	
	//les modeles de donnÃ©es
	adaptateurs.LivresList modeleLivre;
	adaptateurs.PersonnesList modelePersonne;
	

	/**
	 * @param b la base de données Bibliothèque
	 * crée le panel avec tous ses composants initialisés
	 */
	public PanelEmprunt (BaseBiblio b) 
	{
		super (new java.awt.BorderLayout()) ;
		
		//liaison aux services et remplissage des listes de livres/personnes
		this.b = b ;
		this.initListes();
		
		//composants graphiques
		
		Border empty = BorderFactory.createEmptyBorder(10,10,10,10);
		
		statut.setBorder(empty);		
		add (statut, java.awt.BorderLayout.NORTH) ;
		JScrollPane listP = new javax.swing.JScrollPane (listePersonnes);
		listP.setBorder(empty);
		add (listP, java.awt.BorderLayout.WEST) ;
		JScrollPane listE = new JScrollPane (listeLivres);
		listE.setBorder(empty);
		add (listE,java.awt.BorderLayout.CENTER) ;
		JPanel boutons= this.boiteAboutons();
		boutons.setBorder(empty);
		add (boutons, java.awt.BorderLayout.SOUTH) ;
		
	}

	/**
	 * initialise les listes (livres et personnes)
	 */
	private void initListes() {
		
		try {
			modeleLivre= new LivresList();
			modeleLivre.setManagerLivre(b.getManagerLivre());
			modeleLivre.recharger();
			
			modelePersonne = new PersonnesList();
			modelePersonne.setManagerPersonne(b.getManagerPersonne());
			modelePersonne.recharger();
			
			this.listePersonnes = new javax.swing.JList<Personne>(modelePersonne) ;
			this.listePersonnes.setSelectionMode
			(javax.swing.ListSelectionModel.SINGLE_SELECTION) ;

			this.listeLivres = new javax.swing.JList<Livre>(modeleLivre) ;
			this.listeLivres.setSelectionMode
			(javax.swing.ListSelectionModel.SINGLE_SELECTION) ;

			rafraichir ("connexion réussie") ;
		} catch (AppliException e) {
			statut.setText ("Erreur au rechargement des données: " + e.getMessage ()) ;
			e.printStackTrace();
		}
	}

	/**
	 * @return la boite avec les 3 boutons emprunter/restituer/rÃ©server
	 */
	private javax.swing.JPanel boiteAboutons() {
		final javax.swing.JButton 
		  emprunter = new javax.swing.JButton("Emprunter"),
		  reserver  = new javax.swing.JButton("Réserver"),
		  restituer = new javax.swing.JButton("Restituer") ;
		javax.swing.JPanel boiteAboutons = new javax.swing.JPanel () ;
		// en FlowLayout par dÃ©faut
		boiteAboutons.add (emprunter) ;
		boiteAboutons.add (reserver) ;
		boiteAboutons.add (restituer) ;
		emprunter.addActionListener(new ihm.ListenerEmprunter(this)) ;
		reserver.addActionListener(new ihm.ListenerReserver(this)) ;
		restituer.addActionListener(new ihm.ListenerRestituer(this)) ;
		return boiteAboutons ;
	}

	/**
	 * @return le livre sélectionné parmi tous ceux de la liste
	 */
	public bdd.Livre livreSelectionne() {
		return (bdd.Livre) listeLivres.getSelectedValue() ;
	}

	/**
	 * @return la personne sélectionnée parmi toutes celles de la liste
	 */
	public bdd.Personne personneSelectionnee() {
		return (bdd.Personne) listePersonnes.getSelectedValue() ;
	}

	/**
	 * @return l'objet qui gère la base de données Bibliothèque
	 */
	public bdd.BaseBiblio laBase(){
		return this.b ;
	}

	/**
	 * @param message message a  afficher dans la fenetre
	 * Rafraichit les listes de livres et de personnes 
	 */
	public void rafraichir (String message) { 
		this.setStatut(message) ;
		try{
			listePersonnes.clearSelection () ;
			listeLivres.clearSelection () ;
			//b.recharger () ;
			modeleLivre.recharger();
			modelePersonne.recharger();
		} catch (Exception exc) {
			statut.setText ("Erreur au rechargement des données: " + exc.getMessage ()) ;
			exc.printStackTrace () ;
		}
	}

	/**
	 * @param string message à afficher dans la fenêtre
	 * Affiche un nouveau message dans la fenêtre de gestion des emprunts/réservations/restitutions
	 */
	public void setStatut(String string) {
		this.statut.setText(string)  ;
	}

}
