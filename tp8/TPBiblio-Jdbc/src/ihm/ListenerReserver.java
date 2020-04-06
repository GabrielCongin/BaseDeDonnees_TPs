package ihm;

import bdd.AppliException;

/**
 * Objet qui réagit au bouton "réserver"
 *
 */
public class ListenerReserver implements java.awt.event.ActionListener{

	private final ihm.PanelEmprunt vue ;

	/**
	 * @param vue le panel qui contient les 2 listes (livres et personnes)
	 */
	public ListenerReserver(ihm.PanelEmprunt vue) {
		this.vue = vue ;
	}

	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	@Override
	public void actionPerformed (java.awt.event.ActionEvent e) {
		bdd.Livre livre = vue.livreSelectionne() ;
		bdd.Personne personne = vue.personneSelectionnee() ;
		if (livre == null) {
			vue.setStatut("Il faut sélectionner un livre") ;
		} else if (personne == null) {
			vue.setStatut("Il faut sélectionner une personne") ;
		} else {
			try {
				vue.laBase().getManagerBiblio().reserver(livre, personne) ;
			} catch (AppliException excp) {
				vue.setStatut(excp.getMessage ()) ;
				return ;
			}
			vue.rafraichir ("OK") ;
		}
	}
}
