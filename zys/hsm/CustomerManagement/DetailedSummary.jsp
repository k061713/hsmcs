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
     *      客户管理接口
     *      KF02 抽检服务申请流程
     *      zys
     *      20210520
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行明细表2汇总到明细表12操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");

    String sql="";
    try {
        sql ="SELECT * FROM uf_khdjpgb";
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            String sjid= rs.getString("id");//人员id
            Json.put("sjid",sjid);
            jsonArray.add(Json);
        }
        json.put("mapList",jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>