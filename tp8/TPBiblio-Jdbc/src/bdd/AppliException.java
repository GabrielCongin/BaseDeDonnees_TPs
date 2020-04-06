package bdd;

@SuppressWarnings("serial")
public class AppliException extends Exception {
	
	String messageLocal;

	public AppliException() {
		// TODO Auto-generated constructor stub
	}
	
	//nouveau constructeur qui prend en paramètre un code erreur Oracle
	// et le traduit en message d'erreur
	// codes erreur du paquetage stocké 
	public AppliException (int codeErreur) {
		if (codeErreur == 20111) 
			messageLocal = "ERREUR :  Parametres non définis";
		else if (codeErreur == 20112)
			messageLocal = " ERREUR : Livre inconnu ";
		else if (codeErreur== 20113) 
			messageLocal = "ERREUR :  personne inconnue";
		else if ( codeErreur == 20114) 
			messageLocal = " ERREUR : Quota maximal de livres empruntés atteint";
		else if (codeErreur== 20115)
			messageLocal = "ERREUR : Livre non disponible";
		else if (codeErreur == 20116) 
			messageLocal = "ERREUR : Ce livre n'est pas emprunté";
		else messageLocal = "ERREUR : erreurOracle " + codeErreur;
			
	}

	public AppliException(String arg0) {
		super(arg0);
		// TODO Auto-generated constructor stub
	}

	public AppliException(Throwable arg0) {
		super(arg0);
		// TODO Auto-generated constructor stub
	}

	public AppliException(String arg0, Throwable arg1) {
		super(arg0, arg1);
		// TODO Auto-generated constructor stub
	}

	public AppliException(String arg0, Throwable arg1, boolean arg2,
			boolean arg3) {
		super(arg0, arg1, arg2, arg3);
		// TODO Auto-generated constructor stub
	}
	
	public String getMessage() {
		if (messageLocal==null) 
			return super.getMessage();
		else return messageLocal;
	}

}
