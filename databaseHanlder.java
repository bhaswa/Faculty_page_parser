import java.io.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.*;

class databaseHandler
{
    public static void main(String[] args) throws Exception
    {
        InputStreamReader ins= new InputStreamReader(System.in);
        BufferedReader br= new BufferedReader(ins);
        Class.forName("com.mysql.jdbc.Driver");
           System.out.println("Driver Loading done");

           Connection conn = 
           DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/mydb","root","heer");
           System.out.println("Connection Created");

           Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
           System.out.println("Statement Created");
           ResultSet rs;
           
           String csvFile = "C:\\Users\\sony\\.netbeans-derby\\Desktop\\Assignment3\\out3.csv";
           String line = "";
           String cvsSplitBy = "\t";
           String query;
           
           query = "drop table if exists Publication";
           stmt.executeUpdate(query);
           query = "drop table if exists Projects;";
           stmt.executeUpdate(query);
           query = "drop table if exists Awards;";
           stmt.executeUpdate(query);
           query = "drop table if exists PhdStudents;";
           stmt.executeUpdate(query);
           query = "drop table if exists Fac_Details;";
           stmt.executeUpdate(query);
           
           query="CREATE TABLE Fac_Details(fac_name varchar(100) NOT NULL primary key,designation varchar(100) NOT NULL,responsibility varchar(100),email varchar(100),contact varchar(20),website varchar(80),research varchar(3000));";
           stmt.executeUpdate(query);
           query="CREATE TABLE Publication(fac_name varchar(100) ,paper_name varchar(1000) ,authors varchar(1000),publishers varchar(1000),year VARCHAR(10),foreign key fk_name(fac_name) references Fac_Details(fac_name) on delete cascade on update cascade)";
           stmt.executeUpdate(query);
           query="CREATE TABLE Projects(fac_name varchar(100) ,project_name varchar(1000) NOT NULL ,sponseredby varchar(1000),foreign key fk_name(fac_name) references Fac_Details(fac_name) on delete cascade on update cascade);";
           stmt.executeUpdate(query);
           query="CREATE TABLE Awards(fac_name varchar(100),award_name varchar(1000) NOT NULL,year varchar(5),foreign key fk_name(fac_name) references Fac_Details(fac_name) on delete cascade on update cascade);";
           stmt.executeUpdate(query);
           query="CREATE TABLE PhdStudents(fac_name varchar(100),stream varchar(10),student_name varchar(1000) NOT NULL ,area varchar(250),foreign key fk_name(fac_name) references Fac_Details(fac_name) on delete cascade on update cascade);";
           stmt.executeUpdate(query);
           String name="satinder";
           try 
           {
            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) 
            {
                String[] records= line.split("\t");
                System.out.println(records.length+"");
                query="INSERT INTO Fac_Details (fac_name,designation,responsibility,email,contact,website,research) VALUES (\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\",\""+records[3]+"\",\""+records[4]+"\",\""+records[5]+"\",\""+records[6]+"\")";
                System.out.println(query);        
                stmt.executeUpdate(query);
            }
            
            csvFile = "C:\\Users\\sony\\.netbeans-derby\\Desktop\\Assignment3\\publications_data.csv";
            line = "";
            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) 
            {
                String[] records= line.split(cvsSplitBy+"");
                //System.out.println(records[4]+"");
                query="insert into Publication values(\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\",\""+records[3]+"\",\""+records[4]+"\")";
                System.out.println(query);         
                stmt.executeUpdate(query);
            }
            
            csvFile = "C:\\Users\\sony\\.netbeans-derby\\Desktop\\Assignment3\\awards_data.csv";
            line = "";
            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) 
            {
                String[] records= line.split(cvsSplitBy);
                System.out.println(""+records.length);
                if(records.length==3)
                    query="insert into Awards values(\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\")";
                else
                    query="insert into Awards values(\""+records[0]+"\",\""+records[1]+"\",\"\")";
                System.out.println(query);         
                stmt.executeUpdate(query);
            }
            
            csvFile = "C:\\Users\\sony\\.netbeans-derby\\Desktop\\Assignment3\\project_data.csv";
            line = "";
            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) 
            {
                String[] records= line.split(cvsSplitBy);
                query="insert into Projects values(\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\")";
                System.out.println(query);         
                stmt.executeUpdate(query);
            }
            
            csvFile = "C:\\Users\\sony\\.netbeans-derby\\Desktop\\Assignment3\\phdms_data.csv";
            line = "";
            br = new BufferedReader(new FileReader(csvFile));
            while ((line = br.readLine()) != null) 
            {
                String[] records= line.split(cvsSplitBy);
                if(records.length==4)
                query="insert into PhdStudents values(\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\",\""+records[3]+"\")";
                if(records.length==3)
                query="insert into PhdStudents values(\""+records[0]+"\",\""+records[1]+"\",\""+records[2]+"\",\"\")";
                System.out.println(query);         
                stmt.executeUpdate(query);
            }
        }
        catch (FileNotFoundException e) 
        {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}