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
     *      培训组织
     *      zys
     *      2021329
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行培训组织操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String nodeid = request.getParameter("nodeid");//节点id
    String sql="";
    try {
        if(nodeid.equals("2001")){
            sql= "select * from formtable_main_727 ";
        }else {
            sql= "select count(*) as count from formtable_main_732_dt2 where sfqq=2 ";
        }
    rs.execute(sql);
    while (rs.next()){
        JSONObject Json = new JSONObject();
        if(nodeid.equals("2001")){
            String pxdx= rs.getString("pxdx");//培训对象
            String khfs = rs.getString("khfs");//考核方式
            Json.put("pxdx",pxdx);
            Json.put("khfs",khfs);
        }else {
            String sjcyrs=rs.getString("count");
            Json.put("sjcyrs",sjcyrs);
        }
        jsonArray.add(Json);
    }
        json.put("mapList", jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>