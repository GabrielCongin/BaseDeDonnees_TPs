package tp;

import java.io.Console;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Scanner;

public class TpJdbc {
	
	private java.sql.Connection connect;
	private java.sql.PreparedStatement pstat;
	private java.sql.CallableStatement insertion;
	
	public TpJdbc(String login, String password){
		seConnecter(login,password);
	}
	
	public void seConnecter(String login, String password){
		try {
			connect = DriverManager.getConnection("jdbc:oracle:thin:@oracle.fil.univ-lille1.fr:1521:filora",login, password);
			this.pstat = connect.prepareStatement("select * from CARON.TABLE_TEST where texte like ?");
			insertion = connect.prepareCall("{? = call CARON.inserer_ligne(?)}");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void seDeconnecter() {
		try {
			connect.close();
			System.out.println("disconnected");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void lireTableTest(){
		try {
			PreparedStatement pstat = connect.prepareStatement("select * from CARON.TABLE_TEST");
			ResultSet rs = pstat.executeQuery();
			while(rs.next()){
				System.out.println(rs.getInt("id")+" "+rs.getString("texte"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void lireTableTestAmeliore(String s){
		try {
			this.pstat.setString(1,"%"+s+"%");
			ResultSet rs = pstat.executeQuery();
			while(rs.next()){
				System.out.println(rs.getInt("id")+" "+rs.getString("texte"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void insererLigne(String s){
		try {
			insertion.setString(2, s);
			insertion.registerOutParameter(1, java.sql.Types.INTEGER);
			insertion.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}
	
	public static void main(String[] args) {
		Console console = System.console();
		char[] tmp = console.readPassword("[Mot de passe]: ");
		String password = new String(tmp);
		TpJdbc jdbc = new TpJdbc("congin",password);
		jdbc.insererLigne("coucou");
		jdbc.lireTableTest();
		//jdbc.lireTableTestAmeliore("mdr");
		jdbc.seDeconnecter();
	}

}
