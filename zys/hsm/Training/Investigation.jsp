<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      培训管理接口
     *      培训调查
     *      zys
     *      2021329
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行培训调查操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    RecordSet rs1 = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    JSONArray jsonArray1 = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    //String nodeid = request.getParameter("nodeid");//节点id
    String sql="";
    String sql1="";
    try {
        sql= "select * from uf_jspjxmcs";
        sql1= "select * from uf_pxxmpjxmcs";
        boolean a =rs.execute(sql);
        new BaseBean().writeLog(">>>>>>>>>>>>>>执行1<<<<<<<<<"+a);
        while (rs.next()){
            new BaseBean().writeLog(">>>>>>>>>>>>>>执行1<<<<<<<<<");
             JSONObject Json = new JSONObject();
             String pxspjxm= rs.getString("pxspjxm");
             String sm = rs.getString("sm");
             Json.put("pxspjxm",pxspjxm);
             Json.put("sm",sm);
             jsonArray.add(Json);
        }
        boolean b =rs1.execute(sql1);
        new BaseBean().writeLog(">>>>>>>>>>>>>>执行2<<<<<<<<<"+b);

        while (rs1.next()){

            JSONObject Json1 = new JSONObject();
            String pxxmpjxm= rs1.getString("pxxmpjxm");
            String sm1 = rs1.getString("sm");
            Json1.put("pxxmpjxm",pxxmpjxm);
            Json1.put("sm",sm1);
            jsonArray1.add(Json1);
        }
        new BaseBean().writeLog(">>>>>>>>>>>>>>执行3<<<<<<<<<");
        json.put("mapList", jsonArray.toString());
        json.put("mapList1", jsonArray1.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>