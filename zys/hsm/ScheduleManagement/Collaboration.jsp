<%@ page import="weaver.conn.RecordSet" %>
<%@ page import="com.weaver.general.BaseBean" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="weaver.hrm.User" %>
<%@ page import="weaver.hrm.HrmUserVarify" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<%
    /**
     *      RC02协作事项接口
     *      zys
     *      20210415
     */
    new BaseBean().writeLog(">>>>>>>>>>>>>>开始协作事项流程操作<<<<<<<<<");
    RecordSet rs = new RecordSet();
    JSONObject json = new JSONObject();
    JSONArray jsonArray = new JSONArray();
    User users1 = HrmUserVarify.getUser(request, response);
    //String workflowid = request.getParameter("workflowid");

    String zygzsj = request.getParameter("zygzsj");//占用工作时间
    String kssj = zygzsj.substring(0,zygzsj.indexOf(" "));
    String zygzsjjs = request.getParameter("zygzsjjs");//占用工作时间（结束）
    String jssj =zygzsjjs.substring(0,zygzsjjs.indexOf(" "));
    String xzr = request.getParameter("xzr");//协作人
    String sql="";

    try {
        sql="update uf_yhtxx set tsrwztdet =1 where rq BETWEEN '"+kssj+"' and '"+jssj+"' and yhyxm in ("+xzr+")";
        new BaseBean().writeLog(">>>>>>>>>>>>>>开始执行更新操作<<<<<<<<<"+sql);
       boolean a = rs.execute(sql);
        if (a){
            json.put("code","200");
            json.put("msg","更新成功");
        }else {
            json.put("code","203");
            json.put("msg","程序出错！");
        }

    } catch (Exception e) {
        e.printStackTrace();
    }
    out.clear();
    out.println(json.toString());

%>