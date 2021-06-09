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
     *      部门绩效
     *      根据人员能力表中 “是否验货员”字段，选项为“是”的情况下，列出所有人员id
     *      zys
     *      20210331
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行部门绩效操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String ssjg = request.getParameter("ssjg");//机构
    String ssbm = request.getParameter("ssbm");//部门
    String sql="";
    try {
        sql ="select id from hrmresource h where subcompanyid1="+ssjg+" and departmentid in'"+ssbm+"' and h.id not in (select rymc from uf_ryda where sfyhy=0)";
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            String id= rs.getString("id");//人员id
            Json.put("id",Integer.valueOf(id));
            jsonArray.add(Json);
        }
        json.put("mapList",jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>