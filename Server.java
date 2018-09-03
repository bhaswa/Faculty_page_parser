import java.io.IOException;
import java.sql.*;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class Server extends HttpServlet
{
    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        try
        {
            response.setContentType("text/html;charset=UTF-8");
            PrintWriter out=response.getWriter();
          
            System.out.println(request);
            String res= request.getParameter("responsibility");
            String awards= request.getParameter("awards");
            String publications= request.getParameter("publications");
            String phd=request.getParameter("phd");
            String max=request.getParameter("max");
            String year=request.getParameter("year");
            String query=request.getParameter("query");
            ResultSet rs;
           // System.out.println("Selected "+res+" , "+awards+" , "+publications+","+phd);
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/mydb", "root", "heer");
            Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            if (!query.equals(""))
            {
                 rs=stmt.executeQuery(query+"");
                  while(rs.next())
                    {
                        ResultSetMetaData rsmd = rs.getMetaData();
                        String name=rs.getString("fac_name");
                        int columnsNumber = rsmd.getColumnCount();
                        StringBuffer data =new StringBuffer("");
                        StringBuffer data1 =new StringBuffer("");
                        int i;
                        if(columnsNumber!=0)
                        {
                            
                             for(i=1;i<=columnsNumber;i++)
                                {
                                    data1=new StringBuffer(rsmd.getColumnName(i));
                                    data=new StringBuffer(rs.getString(i));
                                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                                    "transitional//en\">\n";

                                    out.println(docType + "<html>\n" +
                                    "<head><title>" + "Response"+ "</title></head>\n" +
                                    "<body bgcolor=\"#f0f0f0\">\n" +
                                    "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n"
                                    +data1.toString().toUpperCase()+"</b></h2>"+
                                       "<p>"+data+"</p>"+     
                                    "</body></html>");
                                } 
                        }
                        else
                        {
                            response.sendRedirect("userhome.html");
                        }
                    }  
            }
            if(!res.equals("Select Responsibility"))
            {
                rs = stmt.executeQuery("select * from Fac_Details where responsibility='"+res+"'");
                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                    "transitional//en\">\n";

                    out.println(docType + "<html>\n" +
                    "<head><title>" + "Response"+ "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                       "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n" +
                       "<h2>"+name+" has responsibilty "+res+"</h2>"+
                    "</body></html>");
                }
            }
            if(!awards.equals("Select Awards"))
            {
                rs = stmt.executeQuery("select fac_name from awards where award_name='"+awards+"'");
                String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                            "transitional//en\">\n"
                                    +"<html><head><title>RESPONSE</title></head><body>";

                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    out.println(docType + 
                       "<h2> "+name+" got "+awards+"</h2>"+
                    "</body></html>");
                }
            }
            if(!publications.equals("Select Publication"))
            {
                rs = stmt.executeQuery("select fac_name from publication where paper_name='"+publications+"'");
                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                    "transitional//en\">\n";

                    out.println(docType + "<html>\n" +
                    "<head><title>" + "Response"+ "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                       "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n" +
                       "<h2> "+name+" published "+publications+"</h2>"+
                    "</body></html>");
                }
            }
            if(!year.equals("Select Year"))
            {
                rs = stmt.executeQuery("select fac_name ,count(paper_name),year from publication group by year having year=\""+year+"\";");
                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    String count=rs.getString("count(paper_name)");
                    
                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                    "transitional//en\">\n";

                    out.println(docType + "<html>\n" +
                    "<head><title>" + "Response"+ "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                       "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n" +
                       "<h2>Max Paper in the year "+year+" is by "+name+" and count is "+count+" </h2>"+
                    "</body></html>");
                }
                
            }
            
            if(max.equals("YES"))
            {
                rs = stmt.executeQuery("select fac_name ,count(project_name) from projects group by fac_name order by count(project_name) desc limit 1;");
                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    String count=rs.getString("count(project_name)");
                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                    "transitional//en\">\n";

                    out.println(docType + "<html>\n" +
                    "<head><title>" + "Response"+ "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                       "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n" +
                       "<h2>"+name+" Have Maximum Current Projects and count is "+count+"</h2>"+
                    "</body></html>");
                }
                
            }
            if(phd.equals("YES"))
            {
                rs = stmt.executeQuery("select fac_name ,count(student_name) from phdstudents group by fac_name order by count(student_name) desc limit 1;");
                while(rs.next())
                {
                    String name=rs.getString("fac_name");
                    String count=rs.getString("count(student_name)");
                    String docType = "<!doctype html public \"-//w3c//dtd html 4.0 " +
                    "transitional//en\">\n";

                    out.println(docType + "<html>\n" +
                    "<head><title>" + "Response"+ "</title></head>\n" +
                    "<body bgcolor=\"#f0f0f0\">\n" +
                       "<h1 align=\"center\">" + "RESPONSE" + "</h1>\n" +
                       "<h2>"+name+" Have Maximum Ph.D Students And Count is "+count+"</h2>"+
                    "</body></html>");
                }
                
            }
            else
            {
                response.sendRedirect("userhome.html");
            }
        } 
        catch (Exception ex)
        {
            ex.printStackTrace();
        }
    }
}
