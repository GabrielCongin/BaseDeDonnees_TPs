package ihm;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.border.Border;

import java.awt.BorderLayout;


import bdd.BaseBiblio;

/**
 * Fenetre principale, qui permet de se connecter ou de se deconnecter 
 * et qui, quand on est connecté, permet d'emprunter, restituer, réserver des livres.
 *
 */
@SuppressWarnings("serial")
public class FenetrePrincipale extends JFrame{

	private BaseBiblio laBase = new BaseBiblio() ;
	private JButton connexionDeconnexion = new JButton("Se connecter") ;
	private JLabel message = new JLabel("déconnecté");
	private ListenerConnexionDeconnexion lcd = new ListenerConnexionDeconnexion(this,laBase) ;
	private PanelEmprunt empruntReservation ;

	/**
	 * Constructeur de la fenetre principale
	 */
	public FenetrePrincipale() {
		super("Bibliotheque");
		
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.connexionDeconnexion.addActionListener (lcd) ;
		
		Border empty = BorderFactory.createEmptyBorder(10,10,10,10);
		connexionDeconnexion.setBorder(empty);
		this.add(this.connexionDeconnexion, BorderLayout.NORTH) ;
		this.add(this.message,BorderLayout.SOUTH);
		this.pack();
		this.setVisible(true);
	}

	/**
	 * méthode qui indique que l'on est connecté
	 * et qui ajoute la gestion des emprunts/réservations dans la fenetre
	 */
	public void OkConnexion(){
		this.connexionDeconnexion.setText("Se déconnecter");
		this.message.setText("connecté");
		this.empruntReservation = new PanelEmprunt(laBase);
		this.add(this.empruntReservation,BorderLayout.CENTER);
		this.pack();
		this.setVisible(true);
	}

	/**
	 * methode qui indique que l'on est déconnecté
	 * et qui retire la partie "gestion des emprunts/reservations" de la fenetre
	 */
	public void OkDeconnexion(){
		this.connexionDeconnexion.setText("Se connecter");
		this.message.setText("déconnecté");
		this.remove(this.empruntReservation);
		this.pack();
		this.setVisible(true);
	}

	
	/**
	 * @param msg un message (souvent un message d'erreur)
	 * méthode qui permet de donner une valeur au champs textuel affiché en haut de la fenetre
	 */
	public void setMessage(String msg){
		this.message.setText(msg);
	}

	/**
	 * @param args
	 * ouverture de la fenêtre principale de l'application
	 */
	@SuppressWarnings("unused")
	public static void main(String[] args) {
		FenetrePrincipale fen = new FenetrePrincipale();
		
	}

}
