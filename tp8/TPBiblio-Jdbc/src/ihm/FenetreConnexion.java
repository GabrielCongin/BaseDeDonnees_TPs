package ihm;

import javax.swing.*;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.sql.SQLException;

import bdd.AppliException;
import bdd.BaseBiblio;

/**
 * Une fenetre de connexion a la base de données : on saisit le login et le mot de passe
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class FenetreConnexion extends JDialog implements ActionListener{
	// réagit au bouton "ok" 

	private JTextField login = new JTextField(20);
	private JPasswordField pw = new JPasswordField(20);
	private JButton ok = new JButton("OK");
	private JLabel message = new JLabel("");
	private BaseBiblio b;
	private FenetrePrincipale fePr ;

	/**
	 * @param fp la fenetre principale qui a entrainé la connexion
	 * @param b la base Ã  laquelle il faut se connecter
	 * ouvre une fenêtre de connexion 
	 */
	public FenetreConnexion(FenetrePrincipale fp, BaseBiblio b) {
		this.b = b ;
		this.fePr = fp ;
		JPanel lesChamps = new JPanel(new GridLayout(2,2)) ;
		lesChamps.add(new JLabel("Nom :"));
		lesChamps.add(login);
		lesChamps.add(new JLabel("Mot de Passe :"));
		lesChamps.add(pw);
		this.setLayout(new BorderLayout());
		this.add(lesChamps,BorderLayout.NORTH);
		this.add(ok,BorderLayout.CENTER);
		this.add(message,BorderLayout.SOUTH);
		ok.addActionListener(this);
		this.pack();
		this.setVisible(true);
	}

	/* (non-Javadoc)
	 * @see java.awt.event.ActionListener#actionPerformed(java.awt.event.ActionEvent)
	 */
	public void actionPerformed(ActionEvent e) {
		try{
			this.b.seConnecter(this.login.getText(), new String(this.pw.getPassword()));
			this.fePr.OkConnexion();
			this.dispose();
		}catch(AppliException sqle){
			this.message.setText("erreur login ou initialisation : " + sqle.getMessage());
		}
	}

}
