package ihm;

import bdd.AppliException;

/**
 * Listener qui réagit au bouton "emprunter"
 *
 */
public class ListenerEmprunter implements java.awt.event.ActionListener{
	private final ihm.PanelEmprunt laVue ;

	/**
	 * @param laVue le panel qui contient les 2 listes (livres et personnes)
	 */
	public ListenerEmprunter (ihm.PanelEmprunt laVue) {
		this.laVue = laVue ;
	}

	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed (java.awt.event.ActionEvent e) {
		bdd.Livre livre = laVue.livreSelectionne() ;
		bdd.Personne personne = laVue.personneSelectionnee() ;
		if (livre == null) {
			laVue.setStatut ("Il faut sélectionner un livre") ;
		} else if (personne == null) {
			laVue.setStatut ("Il faut sélectionner une personne") ;
		} else {
			try {
				laVue.laBase().getManagerBiblio().emprunter (livre, personne) ;
			} catch (AppliException excp) {
				laVue.setStatut(excp.getMessage ()) ;
				return ;
			}
			laVue.rafraichir ("OK") ;
		}
	}


}
