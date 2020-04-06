package adaptateurs;

import bdd.AppliException;


/**
 * Un objet DonneesList est une liste d'objets de type Element
 * DonneesList est la superclasse des classes qui vont servir Ã  définir des JList attachées à des données
 */
@SuppressWarnings("serial")
public abstract class DonneesList<Element> extends javax.swing.AbstractListModel<Element> {
	protected final java.util.ArrayList<Element> lesDonnees = new java.util.ArrayList<Element> () ;
	

	/**
	 * Constructeur
	 */
	protected DonneesList () {
		super();
	}

	/* (non-Javadoc)
	 * @see javax.swing.ListModel#getSize()
	 */
	public final int getSize () {
		return lesDonnees.size () ;
	}

	/* (non-Javadoc)
	 * @see javax.swing.ListModel#getElementAt(int)
	 */
	public final Element getElementAt(int index) {
		return lesDonnees.get(index) ;
	}

	/**
	 * @param e élément à ajouter à la liste
	 * permet d'ajouter un élément à la liste de données
	 */
	protected final void ajouter(Element e) {
		lesDonnees.add(e) ;
	}


	/*
	 *  @throws AppliException
	 * a developper pour chaque type d'element : rÃ©cupere les Ã©lÃ©ments Ã  la source
	 * et les stocker dans lesdonnees
	 */
	protected abstract void ajouterTous() throws AppliException ; 

	/**
	 * @throws AppliException
	 * refabrique la liste d'Element à partir de la source
	 */
	public final void recharger () throws AppliException {
		final int AncienneTaille = getSize() ;
		lesDonnees.clear() ;
		
		// ajouter toutes les données dans la liste
		this.ajouterTous () ;
		
		if (AncienneTaille != 0) {
			fireIntervalRemoved(this, 0, AncienneTaille - 1) ;
		}
		if (lesDonnees.size() != 0) {
			fireContentsChanged(this, 0, lesDonnees.size() - 1) ;
		}
	}
}