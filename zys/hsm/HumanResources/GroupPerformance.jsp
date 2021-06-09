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
     *      集团绩效
     *
     *      zys
     *      20210331
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行集团绩效操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    String workflowid = request.getParameter("workflowid");
    String lx = request.getParameter("lx");//类型 0工资奖金，1绩效
    String yf = request.getParameter("yf");//
    String nf = request.getParameter("nf");//
    String sql="";
    try {
        new BaseBean().writeLog(">>>>>>>>>>>>>>类型<<<<<<<<<"+lx);
        if(lx.equals("0")){
            sql ="SELECT * FROM uf_jtgzxx where nf="+nf+" and yf="+yf ;//
        }else if (lx.equals("1")){
            sql ="SELECT * FROM uf_jxjcxx where nf="+nf+" and yf="+yf ;
        }
        rs.execute(sql);
        while (rs.next()){
            JSONObject Json = new JSONObject();
            String id= rs.getString("id");//人员id
            Json.put("id",id);
            Json.put("lx",lx);
            jsonArray.add(Json);
        }
        json.put("mapList",jsonArray.toString());
    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());


%>