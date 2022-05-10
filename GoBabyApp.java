import java.util.* ;
import java.util.Scanner;
import java.sql.* ;
import java.sql.Date;
import java.text.SimpleDateFormat;

public class GoBabyApp {

	static ArrayList <Integer> option;

	static ArrayList <String> nameList;

	static ArrayList <String> hcardIDList;

	static ArrayList <Integer> appIDList;


	public static void main(String[] args) throws SQLException{
		// TODO Auto-generated method stub

		// Unique table names.  Either the user supplies a unique identifier as a command line argument, or the program makes one up.
		String tableName = "";
		int sqlCode=0;      // Variable to hold SQLCODE
		String sqlState="00000";  // Variable to hold SQLSTATE

		if ( args.length > 0 )
			tableName += args [ 0 ] ;
		else
			tableName += "exampletbl";

		// Register the driver.  You must register the driver before you can use it.
		try { DriverManager.registerDriver ( new com.ibm.db2.jcc.DB2Driver() ) ; }
		catch (Exception cnfe){ System.out.println("Class not found"); }

		// This is the url you must use for DB2.
		//Note: This url may not valid now ! Check for the correct year and semester and server name.
		String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";

		//REMEMBER to remove your user id and password before submitting your code!!
		String your_userid = "";
		String your_password = "";
		//AS AN ALTERNATIVE, you can just set your password in the shell environment in the Unix (as shown below) and read it from there.
		//$  export SOCSPASSWD=yoursocspasswd 

		if(your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null)
		{
			System.err.println("Error!! do not have a password to connect to the database!");
			System.exit(1);
		}
		if(your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null)
		{
			System.err.println("Error!! do not have a password to connect to the database!");
			System.exit(1);
		}

		Connection con = DriverManager.getConnection (url,your_userid,your_password) ;
		Statement statement = con.createStatement ( ) ;

		//-------------------------------------------------------------------------------------

		int var = 1;
		Scanner scanner = new Scanner(System.in);


		while( var != 0) {

			//-------------------------------------------------------------------------------------

			System.out.println("Please enter your practitioner id [E] to exit:");
			String pID = scanner.nextLine();

			var = checkCloseApp(pID, scanner, con);
			if (var == 0) break;

			String name = getMidwife(pID, statement);

			if (name == null) {
				System.out.println("Midwife does not exist");

			}
			//-------------------------------------------------------------------------------------

			if (name != null) {
				int var2 = 2;

				while(var2 != 0) {

					System.out.println("Please enter the date (YYYY-MM-DD) for appointment list [E] to exit:");
					String date = scanner.nextLine();

					var = checkCloseApp(date, scanner, con);
					var2 = var;
					if (var == 0) break;

					String hcardID = getAppointments(pID, date, statement);

					//-------------------------------------------------------------------------------------

					if (hcardID != null) {

						int var3 = 3;

						while(var3 != 0) {

							System.out.println("Enter the appointment number that you would like to work on.");
							System.out.println("[E] to exit [D] to go back to another date :");
							String option = scanner.nextLine();

							var = checkCloseApp(option, scanner, con);
							var3 = var;
							var2 = var; 
							if (var == 0) break;

							if ( option.equals("D") || (option.equals("d")) )break;

							else {

								int var4 = 4;
								while (var4 != 0) {

									System.out.println( "For "+ nameList.get(Integer.parseInt(option)) +" "+ hcardIDList.get(Integer.parseInt(option)) );
									System.out.println("1. Review notes");
									System.out.println("2. Review tests");
									System.out.println("3. Add a note");
									System.out.println("4. Prescribe a test");
									System.out.println("5. Go back to the appointments.");
									System.out.println();
									System.out.println("Enter your choice: ");
									int op = scanner.nextInt(); 
									scanner.nextLine();

									if (op == 1) {
										getNotes(hcardIDList.get(Integer.parseInt(option)), statement);
									}

									else if (op == 2) {
										getReviewTests(hcardIDList.get(Integer.parseInt(option)), statement);
									}

									else if (op == 3) {
										System.out.println("Please type your observation:");
										String observation = scanner.nextLine();
										addNote(observation, statement, option, date);
									}

									else if (op == 4) {
										System.out.println("Please enter the type of test");
										String type = scanner.nextLine();
										prescribeTest(type, statement, option, hcardIDList.get(Integer.parseInt(option)));
									}

									else if (op == 5) {
										hcardID = getAppointments(pID, date, statement);
										break;
									}
								}	
							}	
						}
					}	
				}	
			}
		}
		statement.close ( ) ;
		con.close ( ) ;
	}


	///////////////////////
	////////HELPERS////////
	///////////////////////

	public static int checkCloseApp(String input, Scanner scanner, Connection con) {
		int var = 1;
		if (input.equals("E") || input.equals("e")) {
			System.out.println("Exiting Application");
			scanner.close();
			var = 0;

		}
		return var;
	}

	public static String getMidwife(String pID, Statement stmt) {

		int pid = 0;
		String name = null;

		try {

			String querySQL = "SELECT pid, midwife_name from MIDWIFE  WHERE pID ="+pID;
			ResultSet rs = stmt.executeQuery ( querySQL );

			while ( rs.next ( ) ){

				pid = rs.getInt ("pID") ;
				name = rs.getString ("midwife_name");
				System.out.println ("id:  " + pid + " name:  " + name);
				//System.out.println ("name:  " + name);
			}

		}

		catch (SQLException e) {
			System.out.println(e);
		}

		return name;

	}

	public static String getAppointments(String pID, String date, Statement stmt) {
		ResultSet rs = null;
		int appID = 0;
		Time time = null;
		String isPM = null;
		String name = null;
		String hcardID = null;
		int cnt = 1;

		option = new ArrayList<Integer>();
		nameList = new ArrayList<String>();
		hcardIDList = new ArrayList<String>();
		appIDList = new ArrayList<Integer>();
		option.add(-1);
		nameList.add("none");
		hcardIDList.add("none");
		appIDList.add(-1);


		try {

			String querySQL = "WITH t1 (appID,time,pid,pregID) AS (SELECT appointmentID,a_time, PID, pregID FROM Appointment where pid =" +pID+ " AND a_date =" + "\'" +date+"\'" + ")";
			querySQL += " SELECT appID,time,CASE WHEN isPrimaryMidwife = 1 THEN 'P' ELSE 'B' END AS isPM,mother.name, mother.hcardID";
			querySQL += " FROM t1 JOIN Pregnancy_Midwife_Assistance as pma ON t1.pregID = pma.pregID";
			querySQL += " JOIN Couple_Pregnancy as cp ON t1.pregID = cp.pregID";
			querySQL += " JOIN couple on couple.coupleID = cp.coupleID";
			querySQL += " JOIN mother on mother.hcardID = couple.hcardID";
			querySQL += " ORDER BY time";
			//System.out.println(querySQL);
			rs = stmt.executeQuery(querySQL);

			while ( rs.next ( ) ){

				time = rs.getTime("time");
				isPM = rs.getNString("isPM");
				name = rs.getNString("name");
				hcardID = rs.getNString("hcardID");
				appID = rs.getInt("appID");

				System.out.println ("" +cnt+": "+ time + " " + isPM + " " + name + " " + hcardID);
				option.add(cnt);
				nameList.add(name);
				hcardIDList.add(hcardID);
				appIDList.add(appID);
				cnt++;

			}

			if (time == null) {
				System.out.println("There are no appointments for this date");
			}
		}

		catch (SQLException e) {
			System.out.println(e);
		}

		//		System.out.println(option);
		//		System.out.println(name_plus_hcardID);
		return hcardID; 
	}

	public static void getNotes(String hcardID, Statement stmt) {
		ResultSet rs = null;
		Time time = null;
		Date date = null;
		String text = null;
		try {
			String querySQL = "select note_date,note_time,text from mother JOIn couple on mother.hcardID = couple.hcardID JOIN couple_pregnancy as cp on cp.coupleID = couple.coupleID";
			querySQL += " join appointment on appointment.pregID = cp.pregID join NOTES on notes.appointmentID = appointment.appointmentID where mother.hcardID =" + "\'" +hcardID+"\'";
			querySQL += " ORDER BY note_date DESC,note_time DESC";
			rs = stmt.executeQuery(querySQL);

			while ( rs.next ( ) ){

				date = rs.getDate("note_date");
				time = rs.getTime("note_time");
				text = rs.getString("text");


				System.out.println ("" +date+" "+ time + " " + text );


			}
		}

		catch (SQLException e) {
			System.out.println(e);
		}
	}

	public static void getReviewTests(String hcardID, Statement stmt) {
		ResultSet rs = null;
		String test_type = null;
		Date date = null;
		String test_result = null;

		try {
			String querySQL = "SELECT prescribed_date,test_type, CASE WHEN test_result IS NULL THEN 'PENDING' ELSE test_result END AS test_result FROM medical_test";
			querySQL += " JOIN couple_pregnancy AS cp on cp.pregID = medical_test.pregID";
			querySQL += " JOIN couple on couple.coupleID = cp.coupleID JOIN mother on mother.hcardID = couple.hcardID where mother.hcardID =" + "\'" +hcardID+"\'";
			querySQL += " ORDER BY prescribed_date DESC";
			rs = stmt.executeQuery(querySQL);

			while ( rs.next ( ) ){

				date = rs.getDate("prescribed_date");
				test_type = rs.getString("test_type");
				test_result = rs.getString("test_result");


				System.out.println ("" +date+" ["+ test_type + "] " + test_result );


			}
		}

		catch (SQLException e) {
			System.out.println(e);
		}
	}

	public static void addNote(String notetxt, Statement stmt, String option, String date) {
		ResultSet rs = null;
		int noteID = 0;
		/**************************************/
		long millis = System.currentTimeMillis();  
		//Date d = new Date(millis);  //date YYYY-MM-DD
		//System.out.println(d); 
		/**************************************/
		Timestamp timestamp = new Timestamp(System.currentTimeMillis());
		SimpleDateFormat sdf3 = new SimpleDateFormat("HH:mm:ss");
		String time = sdf3.format(timestamp); // HH:mm:ss
		//System.out.println(time);//time
		/**************************************/
		//System.out.println("AppointmentID is: "+ appIDList.get((Integer.parseInt(option))) );
		int appID = appIDList.get((Integer.parseInt(option)));
		/**************************************/


		try {
			String querySQL = "select MAX(noteID) from notes";
			rs = stmt.executeQuery(querySQL);

			while ( rs.next ( ) ){
				noteID = rs.getInt(1);
				//System.out.println ("MAX ID = "+noteID );	
			}
			++noteID;

			//System.out.println("INSERT INTO NOTES (noteID,note_date,note_time,appointmentID,text) values ("+ noteID+ "," + "\'"+d+ "\'," + "\'"+time+ "\'," + "\'"+appID+ "\'," +"\'"+notetxt+"\')");
			String insertSQL = "INSERT INTO NOTES (noteID,note_date,note_time,appointmentID,text) values ("+ noteID+ "," + "\'"+date+ "\'," + "\'"+time+ "\'," + "\'"+appID+ "\'," +"\'"+notetxt+"\')";
			stmt.executeUpdate(insertSQL);
			System.out.println("Inserted successfully");
		}
		catch (SQLException e) {
			System.out.println(e);
		}

	}

	public static void prescribeTest(String type, Statement stmt, String option, String hcardID) {
		ResultSet rs = null;
		ResultSet rs2 = null;
		int pregID = 0;
		int testID = 0;
		long millis = System.currentTimeMillis();  
		Date d = new Date(millis);  //date YYYY-MM-DD
		Date p_date = d;
		Date s_date = d;

		try {
			String querySQL = "select cp.pregID from couple join couple_pregnancy as cp on couple.coupleID = cp.coupleID where hcardid =" + "\'" +hcardID+"\'";
			rs = stmt.executeQuery(querySQL);
			while ( rs.next ( ) ){
				pregID = rs.getInt("pregID");
			}

			String query2SQL = "select MAX(testID) from medical_test";
			rs2 = stmt.executeQuery(query2SQL);
			while ( rs2.next ( ) ){
				testID = rs2.getInt(1);
			}
			++testID;

			//System.out.println("INSERT INTO MEDICAL_TEST(testID,prescribed_date,sample_taken_date,performed_labwork_date,test_sample,test_type,test_result,technicianID,technicianName,technicianPhonenum,pregID) values");
			//System.out.println("("+testID+","+ "\'" +p_date+"\',"+ "\'" +s_date+"\'"+ ",NULL,NULL,"+ "\'" +type+"\'"+",NULL,NULL,NULL,NULL,"+pregID+")");

			String insertSQL = "INSERT INTO MEDICAL_TEST(testID,prescribed_date,sample_taken_date,performed_labwork_date,test_sample,test_type,test_result,technicianID,technicianName,technicianPhonenum,pregID) values";
			insertSQL += "("+testID+","+ "\'" +p_date+"\',"+ "\'" +s_date+"\'"+ ",NULL,NULL,"+ "\'" +type+"\'"+",NULL,NULL,NULL,NULL,"+pregID+")";
			stmt.executeUpdate(insertSQL);
			System.out.println("Inserted successfully");
		}

		catch (SQLException e) {
			System.out.println(e);
		}
	}


}
