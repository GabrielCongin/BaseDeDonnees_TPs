package metadonnee;

import java.io.Console;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DataBase {
	
	private java.sql.Connection connect;
	private java.sql.DatabaseMetaData metadata;
	
	public DataBase(String login, String password){
		seConnecter(login,password);
	}
	
	public void seConnecter(String login, String password){
		try {
			connect = DriverManager.getConnection("jdbc:oracle:thin:@oracle.fil.univ-lille1.fr:1521:filora",login, password);
			metadata = connect.getMetaData();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void seDeconnecter() {
		try {
			connect.close();
			System.out.println("\ndisconnected");
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void listeTables() throws SQLException {
		String table[] = { "TABLE" , "VIEW" , "SYNONYM" };
		ResultSet rs = metadata.getTables(null, "CONGIN", "%", table);
		//ResultSet rs2 = metadata.getSchemas();
		while(rs.next()) {
            System.out.println(rs.getString("TABLE_NAME")+" : "+rs.getString("TABLE_SCHEM"));
        }
		ResultSet rs3 = metadata.getProcedures(null, "CONGIN", "%");
        while(rs3.next()){
        	System.out.println("       "+rs3.getString("PROCEDURE_NAME"));
        }
	}
	
	public void desc(String table_name) throws SQLException{
		//String table[] = {" TABLE" };
		//ResultSet rs = metadata.getTables(null, "CONGIN", table_name , table);
		ResultSet rs = metadata.getColumns(null, "CONGIN", table_name, "%");
		ResultSet pk = metadata.getPrimaryKeys(null, "CONGIN", table_name);
		ResultSet fk = metadata.getImportedKeys(null, "CONGIN", table_name);
		ArrayList<String> pks = new ArrayList<>();
		while(pk.next()){
			pks.add(pk.getString("COLUMN_NAME"));
		}
		
		while(rs.next()){
			System.out.print(rs.getString("COLUMN_NAME")+" "+rs.getString("TYPE_NAME")+" "+rs.getString("COLUMN_SIZE")+" ");
			if(rs.getString("IS_NULLABLE")=="YES"){
				System.out.print("NULL");
			}else{
				System.out.print("NOT NULL");
			}
			if(pks.contains(rs.getString("COLUMN_NAME"))){
				System.out.println(" PK ");
			}else{
				System.out.println();
			}
		}
		while(fk.next()){
			System.out.println(fk.getString("FK_NAME")+" : "+fk.getString("FKCOLUMN_NAME")+"->"+fk.getString("PKTABLE_NAME")+"."+fk.getString("FKCOLUMN_NAME"));
		}
	}
	
	
	public static void main(String[] args) throws SQLException {
		Console console = System.console();
		char[] tmp = console.readPassword("[Mot de passe]: ");
		String password = new String(tmp);
		DataBase base = new DataBase("congin",password);
		//base.listeTables();
		base.desc("TD2_SEANCE");
		base.seDeconnecter();
	}

}
