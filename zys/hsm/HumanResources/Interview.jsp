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
     *      人资管理接口
     *      面试流程
     *      zys
     *      20210330
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行面试流程操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String sql="";
    try {
        sql ="select * from uf_mspfxz";
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            String pjxm= rs.getString("pjxm");//评价项目
            String pf= rs.getString("pf");//评分
            String pjys1= rs.getString("pjys1");//评价要素
            String ckbz= rs.getString("ckbz");//参考标准
            Json.put("pjxm",pjxm);
            Json.put("pf",pf);
            Json.put("pjys1",pjys1);
            Json.put("ckbz",ckbz);
            jsonArray.add(Json);
        }
        json.put("mapList",jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>