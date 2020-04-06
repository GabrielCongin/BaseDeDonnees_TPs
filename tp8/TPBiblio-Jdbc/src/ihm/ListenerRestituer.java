package ihm;

import bdd.AppliException;

/**
 * Listener qui réagit au bouton "restituer"
 *
 */
public class ListenerRestituer implements java.awt.event.ActionListener{

	private final ihm.PanelEmprunt vue ;

	/**
	 * @param vue le panel qui contient les 2 listes (livres et personnes)
	 */
	public ListenerRestituer(ihm.PanelEmprunt vue) {
		this.vue = vue ;
	}

	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	@Override
	public void actionPerformed (java.awt.event.ActionEvent e) {
		bdd.Livre livre = vue.livreSelectionne () ;
		if (livre == null) {
			vue.setStatut ("Il faut sélectionner un livre") ;
		} else {
			try {
				vue.laBase().getManagerBiblio().restituer(livre) ;
			} catch (AppliException excp) {
				vue.setStatut(excp.getMessage ()) ;
				return ;
			}
			vue.rafraichir ("OK") ;
		}
	}
}
